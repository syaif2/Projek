# Changelog

## 2026-10-11 — Fondasi Flutter Android VORTEKS

- Membuat proyek Flutter/Dart baru bernama `vorteks` dan konfigurasi aplikasi Android native.
- Menambahkan Gradle Wrapper Android untuk target Gradle 8.11.1.
- Menambahkan tema Material 3, logo VORTEKS lokal, onboarding, auth lokal, dashboard, materi, Mini Lab, evaluasi, asesmen, profil, edit profil, dan bantuan.
- Menambahkan SQLite untuk akun, konten, pertanyaan, jawaban, progres, percobaan, dan hasil asesmen; seed statis menambah atau memperbarui konten dengan ID stabil tanpa menghapus progres.
- Menambahkan PBKDF2-HMAC-SHA256 salted untuk password lokal dan dokumentasi keterbatasannya.
- Memetakan materi serta enam eksperimen Mini Lab ke halaman Bab 2 buku Fisika.
- Menambahkan unit/widget tests dan dokumen produk, arsitektur, UI/UX, model data, offline, pengujian, rencana, sumber, dan pertanyaan terbuka.
- Mengarsipkan scaffold React/PWA yang dibuat sebelumnya di `outputs/VORTEKS-react-legacy`; `outputs/VORTEKS` sekarang proyek Flutter.
- Flutter/Dart CLI tidak tersedia saat pembuatan. Android SDK (platform `android-37.0`, build-tools `36.0.0`, dan `adb`) terpasang tetapi `adb` tidak ada di PATH; JBR 25 tersedia dalam Android Studio, tetapi JDK 17 belum disiapkan pada PATH. Analyzer, test, APK, lockfile, dan QA perangkat belum terverifikasi.
- Memisahkan deskripsi aktivitas dari tujuan eksperimen di model konten, memakai kesimpulan seed pada Mini Lab, dan membuat tantangan Daya menilai prediksi siswa berdasarkan P = V²/R.
- Menambahkan cakupan widget test untuk enam Mini Lab topikal dan tantangan Daya.
