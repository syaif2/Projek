import 'package:flutter/material.dart';

import '../../shared/widgets/vorteks_widgets.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key, this.showScaffold = true});
  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    final content = ListView(padding: const EdgeInsets.all(18), children: const [
      SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionTitle('Petunjuk penggunaan aplikasi', icon: Icons.menu_book_outlined),
        SizedBox(height: 10),
        _StepText('1. Login atau daftar akun'),
        _StepText('2. Pilih Materi di menu bawah'),
        _StepText('3. Buka submateri, baca sampai habis'),
        _StepText('4. Kerjakan Asesmen setelah semua submateri selesai.'),
      ])),
      SizedBox(height: 12),
      SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionTitle('Cara menggunakan Mini Lab', icon: Icons.science_outlined),
        SizedBox(height: 10),
        Text('Geser slider Tegangan dan Hambatan, perhatikan nilai Arus berubah otomatis. Selesaikan Tantangan dengan mengatur nilai sampai sesuai target yang diminta.'),
      ])),
      SizedBox(height: 12),
      SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionTitle('Informasi navigasi', icon: Icons.touch_app_outlined),
        SizedBox(height: 10),
        Text('Tap ikon di bawah layar untuk pindah ke Beranda, Materi, Asesmen, atau Bantuan. Tap panah kembali di pojok kiri atas untuk keluar dari halaman yang sedang dibuka.'),
      ])),
    ]);
    if (!showScaffold) return SafeArea(top: false, child: content);
    return Scaffold(appBar: AppBar(title: const Text('BANTUAN')), body: content);
  }
}

class _StepText extends StatelessWidget {
  const _StepText(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 7), child: Text(text, style: const TextStyle(height: 1.4)));
}
