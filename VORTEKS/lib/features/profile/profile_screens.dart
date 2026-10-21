import 'package:flutter/material.dart';

import '../../app_controller.dart';
import '../../core/constants/learning_rules.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/input_validators.dart';
import '../../data/models/content_models.dart';
import '../../shared/widgets/vorteks_widgets.dart';
import '../onboarding/onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.controller});
  final AppController controller;

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari VORTEKS?'),
        content: const Text('Sesi pada perangkat ini akan berakhir. Data belajar tetap tersimpan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Tidak')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await controller.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(builder: (_) => IntroFlow(controller: controller)), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final user = controller.currentUser;
        if (user == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final outcome = controller.latestAssessment;
        final statusLabel = outcome == null
            ? 'Belum Tersedia'
            : outcome.status == AssessmentStatus.pendingRule
                ? '${outcome.percent}%'
                : outcome.status == AssessmentStatus.passed ? 'Lulus' : 'Belum lulus';
        return Scaffold(
        appBar: AppBar(title: const Text('PROFIL')),
        body: PageBody(children: [
          // Header card: avatar + identity over the cyan circuit trace (p.20).
          Container(
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.navy, width: 1.4),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(children: [
              Positioned.fill(child: CustomPaint(painter: const CircuitPatternPainter(opacity: .75))),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(children: [
                  const CircleAvatar(radius: 34, backgroundColor: Colors.white, child: Icon(Icons.person, size: 42, color: AppColors.navy)),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.navy, fontSize: 19, height: 1.25)),
                    Text('@${user.username}', style: const TextStyle(color: AppColors.ink, height: 1.4, fontSize: 15)),
                    Text(user.className, style: const TextStyle(color: AppColors.ink, height: 1.4, fontSize: 15)),
                  ])),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionTitle('Progres Pembelajaran'),
            const SizedBox(height: 12),
            Text('${controller.progress.values.where((item) => item.completed).length} materi dipelajari',
                style: const TextStyle(fontSize: 16, height: 1.4)),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _StatusTile(
                icon: Icons.menu_book_outlined,
                caption: 'Status Materi',
                value: controller.progress.values.where((item) => item.completed).length >= LearningRules.totalLessons ? 'Selesai' : 'Belum Selesai',
              )),
              const SizedBox(width: 12),
              Expanded(child: _StatusTile(
                icon: Icons.fact_check_outlined,
                caption: 'Asesmen Akhir',
                value: statusLabel,
              )),
            ]),
          ])),
          const SizedBox(height: 18),
          FilledButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => EditProfileScreen(controller: controller))), child: const Text('EDIT PROFIL')),
          const SizedBox(height: 10),
          OutlinedButton.icon(onPressed: () => _logout(context), icon: const Icon(Icons.logout), label: const Text('LOGOUT')),
        ]),
        );
      },
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({required this.icon, required this.caption, required this.value});
  final IconData icon;
  final String caption;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.navy, width: 1.4),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 30, color: AppColors.navy),
          const SizedBox(height: 10),
          Text(caption, style: const TextStyle(color: AppColors.ink, fontSize: 13.5)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900, fontSize: 17)),
        ]),
      );
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullName;
  late String _className;
  late final TextEditingController _username;
  final _newPassword = TextEditingController();
  bool _busy = false;
  bool _obscure = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final profile = widget.controller.currentUser!;
    _fullName = TextEditingController(text: profile.fullName);
    _className = profile.className;
    _username = TextEditingController(text: profile.username);
  }

  @override
  void dispose() { _fullName.dispose(); _username.dispose(); _newPassword.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_newPassword.text.isNotEmpty && InputValidators.password(_newPassword.text) != null) {
      setState(() => _error = InputValidators.password(_newPassword.text));
      return;
    }
    setState(() { _busy = true; _error = null; });
    try {
      await widget.controller.updateProfile(
        fullName: _fullName.text,
        className: _className,
        username: _username.text,
        newPassword: _newPassword.text.isEmpty ? null : _newPassword.text,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(leading: const BrandBackButton(), title: const Text('EDIT PROFIL')),
        body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480), child: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(20), children: [
          const Center(child: CircleAvatar(radius: 44, backgroundColor: AppColors.paleBlue, child: Icon(Icons.person, size: 52, color: AppColors.navy))),
          const SizedBox(height: 20),
          TextFormField(controller: _fullName, decoration: const InputDecoration(labelText: 'Nama Lengkap', prefixIcon: Icon(Icons.person, color: AppColors.navy)), validator: InputValidators.fullName),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _className,
            decoration: const InputDecoration(labelText: 'Kelas', prefixIcon: Icon(Icons.groups, color: AppColors.navy)),
            items: [for (final option in ClassOptions.withCurrent(_className)) DropdownMenuItem(value: option, child: Text(option))],
            onChanged: (value) => setState(() => _className = value ?? _className),
            validator: InputValidators.className,
          ),
          const SizedBox(height: 12),
          TextFormField(controller: _username, decoration: const InputDecoration(labelText: 'Nama Pengguna', prefixIcon: Icon(Icons.person_outline, color: AppColors.navy)), validator: InputValidators.username),
          const SizedBox(height: 12),
          TextFormField(controller: _newPassword, decoration: InputDecoration(labelText: 'Kata Sandi', prefixIcon: const Icon(Icons.lock, color: AppColors.navy), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.navy), onPressed: () => setState(() => _obscure = !_obscure)), helperText: 'Kosongkan jika tidak ingin mengubah kata sandi.'), obscureText: _obscure),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(_error!, style: const TextStyle(color: Colors.red))),
          const SizedBox(height: 18),
          Row(children: [Expanded(child: OutlinedButton(onPressed: () => Navigator.maybePop(context), child: const Text('BATAL'))), const SizedBox(width: 12), Expanded(child: FilledButton(onPressed: _busy ? null : _save, child: _busy ? const CircularProgressIndicator() : const Text('SIMPAN')))]),
        ])))),
      );
}
