class InputValidators {
  const InputValidators._();

  static String? requiredText(String? value, {String label = 'Bagian ini'}) {
    if (value == null || value.trim().isEmpty) return '$label wajib diisi.';
    return null;
  }

  static String? username(String? value) {
    final required = requiredText(value, label: 'Nama pengguna');
    if (required != null) return required;
    final normalized = value!.trim();
    if (normalized.length < 3) return 'Nama pengguna minimal 3 karakter.';
    if (!RegExp(r'^[a-zA-Z0-9_.-]+$').hasMatch(normalized)) {
      return 'Gunakan huruf, angka, titik, garis bawah, atau tanda hubung.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Kata sandi wajib diisi.';
    if (value.length < 6) return 'Kata sandi minimal 6 karakter.';
    return null;
  }

  static String? className(String? value) =>
      requiredText(value, label: 'Kelas');

  static String? fullName(String? value) =>
      requiredText(value, label: 'Nama lengkap');

  static String? positiveNumber(String? value) {
    final parsed = double.tryParse((value ?? '').replaceAll(',', '.'));
    if (parsed == null || !parsed.isFinite || parsed <= 0) {
      return 'Masukkan angka lebih besar dari 0.';
    }
    return null;
  }
}
