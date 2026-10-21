import 'package:flutter/material.dart';

import '../../app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/input_validators.dart';
import '../../shared/widgets/vorteks_widgets.dart';
import '../dashboard/dashboard_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.controller, this.onSuccess});
  final AppController? controller;
  final VoidCallback? onSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || widget.controller == null) return;
    setState(() { _busy = true; _error = null; });
    try {
      await widget.controller!.login(username: _username.text, password: _password.text);
      if (!mounted) return;
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => DashboardShell(controller: widget.controller!)),
          (route) => false,
        );
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(leading: const BrandBackButton()),
        body: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: ListView(padding: const EdgeInsets.all(22), children: [
            const Center(child: BrandLogo(size: 190)),
            const SizedBox(height: 22),
            Form(key: _formKey, child: Column(children: [
              TextFormField(controller: _username, decoration: const InputDecoration(labelText: 'Nama Pengguna', prefixIcon: Icon(Icons.person, color: AppColors.navy)), validator: InputValidators.username, textInputAction: TextInputAction.next),
              const SizedBox(height: 16),
              TextFormField(controller: _password, decoration: InputDecoration(labelText: 'Kata Sandi', prefixIcon: const Icon(Icons.lock, color: AppColors.navy), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.navy), onPressed: () => setState(() => _obscure = !_obscure))), validator: (value) => InputValidators.requiredText(value, label: 'Kata sandi'), obscureText: _obscure, onFieldSubmitted: (_) => _submit()),
              if (_error != null) ...[const SizedBox(height: 12), Text(_error!, key: const Key('login-error'), style: const TextStyle(color: Colors.red))],
              const SizedBox(height: 22),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.maybePop(context), child: const Text('KEMBALI'))),
                const SizedBox(width: 12),
                Expanded(child: FilledButton(onPressed: _busy ? null : _submit, child: _busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('LOGIN'))),
              ]),
            ])),
            const SizedBox(height: 18),
            TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (_) => RegisterScreen(controller: widget.controller, onSuccess: widget.onSuccess))), child: const Text('Belum ada akun? Daftar di sini')),
          ]),
        )),
      );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.controller, this.onSuccess});
  final AppController? controller;
  final VoidCallback? onSuccess;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  String _className = '';
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _fullName.dispose(); _username.dispose(); _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || widget.controller == null) return;
    setState(() { _busy = true; _error = null; });
    try {
      await widget.controller!.register(
        fullName: _fullName.text,
        className: _className,
        username: _username.text,
        password: _password.text,
      );
      if (!mounted) return;
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => DashboardShell(controller: widget.controller!)),
          (route) => false,
        );
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(leading: const BrandBackButton(), title: const Text('DAFTAR')),
        body: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(22), children: [
            const Center(child: BrandLogo(size: 150)),
            const SizedBox(height: 14),
            TextFormField(controller: _fullName, decoration: const InputDecoration(labelText: 'Nama Lengkap', prefixIcon: Icon(Icons.person, color: AppColors.navy)), validator: InputValidators.fullName, textInputAction: TextInputAction.next),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _className.isEmpty ? null : _className,
              decoration: const InputDecoration(labelText: 'Kelas', prefixIcon: Icon(Icons.groups, color: AppColors.navy)),
              items: [for (final option in ClassOptions.values) DropdownMenuItem(value: option, child: Text(option))],
              onChanged: (value) => setState(() => _className = value ?? ''),
              validator: InputValidators.className,
            ),
            const SizedBox(height: 12),
            TextFormField(controller: _username, decoration: const InputDecoration(labelText: 'Nama Pengguna', prefixIcon: Icon(Icons.person_outline, color: AppColors.navy)), validator: InputValidators.username, textInputAction: TextInputAction.next),
            const SizedBox(height: 12),
            TextFormField(controller: _password, decoration: InputDecoration(labelText: 'Kata Sandi', prefixIcon: const Icon(Icons.lock, color: AppColors.navy), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.navy), onPressed: () => setState(() => _obscure = !_obscure))), validator: InputValidators.password, obscureText: _obscure, textInputAction: TextInputAction.done, onFieldSubmitted: (_) => _submit()),
            if (_error != null) ...[const SizedBox(height: 12), Text(_error!, style: const TextStyle(color: Colors.red))],
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.maybePop(context), child: const Text('KEMBALI'))),
              const SizedBox(width: 12),
              Expanded(child: FilledButton(onPressed: _busy ? null : _submit, child: _busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('DAFTAR'))),
            ]),
            const SizedBox(height: 12),
            TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (_) => LoginScreen(controller: widget.controller, onSuccess: widget.onSuccess))), child: const Text('Sudah punya akun? Login di sini')),
          ])),
        )),
      );
}
