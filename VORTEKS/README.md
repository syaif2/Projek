# VORTEKS

VORTEKS adalah aplikasi Android mobile learning offline untuk materi Fisika Listrik Arus Searah. Aplikasi dibuat dengan Flutter dan Dart, memakai Material 3, SQLite lokal, dan aset lokal.

## Persyaratan

- Flutter stable 3.47 atau lebih baru dengan Dart 3.12 atau lebih baru.
- Android SDK dan Android build tools yang sesuai dengan versi Flutter.
- JDK 17.
- Perangkat Android atau emulator untuk menjalankan aplikasi.

## Menjalankan

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

Untuk menghasilkan APK debug:

```powershell
flutter build apk --debug
```

APK debug akan berada di `build/app/outputs/flutter-apk/app-debug.apk` setelah build berhasil.

## Fitur

- Intro, login, dan registrasi akun lokal.
- Enam materi yang dipetakan ke buku Fisika kelas XII.
- Enam Mini Lab yang menggunakan aktivitas dan variabel berbeda.
- Evaluasi khusus pada bagian bawah setiap materi.
- Asesmen akhir 10 soal yang terbuka setelah enam evaluasi dikirim.
- Profil, edit profil, progres, hasil asesmen, bantuan, dan konfirmasi logout.
- SQLite untuk akun, materi, soal, jawaban, progres, percobaan asesmen, dan hasil.

## Penyimpanan dan keamanan

Tidak ada izin internet pada manifest Android. Isi pembelajaran dan bank soal disertakan lokal. Akun dan progres hanya berada pada perangkat. Kata sandi tidak disimpan mentah: aplikasi memakai PBKDF2-HMAC-SHA256 dengan salt acak per akun. Autentikasi lokal tidak setara dengan autentikasi server; orang yang menguasai perangkat dapat mengakses atau mengubah data aplikasinya.

Database diinisialisasi dengan transaksi seed idempotent: konten statis ditambahkan atau diperbarui dengan ID stabil. Seed tidak menghapus progres pengguna saat aplikasi dibuka kembali. `shared_preferences` hanya menyimpan id sesi lokal dan materi terakhir per akun.

## Struktur utama

```text
android/       Konfigurasi aplikasi Android dan Gradle
assets/        Logo VORTEKS lokal
docs/          PRD, arsitektur, UI/UX, data, offline, pengujian, dan sumber
lib/core/      Tema, aturan progres, SQLite, validasi, dan perhitungan
lib/data/      Model, repository, layanan, dan seed konten
lib/features/  Intro, autentikasi, dashboard, belajar, Mini Lab, asesmen, profil, bantuan
test/          Uji unit dan widget
```

## Status toolchain

Source Android, Gradle Wrapper, dan konfigurasi build telah disiapkan. Flutter/Dart CLI tidak tersedia pada mesin pembuatan proyek ini. Android SDK terpasang dengan platform `android-37.0`, build-tools `36.0.0`, dan `adb`, tetapi `adb` tidak ada di PATH. Android Studio menyertakan JBR 25; JDK 17 yang disyaratkan proyek belum tersedia pada PATH dan kompatibilitas JBR tersebut belum diverifikasi. Karena itu `flutter pub get`, `flutter analyze`, `flutter test`, dan `flutter build apk --debug` belum dapat dijalankan, APK belum dihasilkan, dan `pubspec.lock` belum dibuat oleh Pub. Jalankan perintah di atas pada mesin yang memiliki Flutter/Dart dan JDK kompatibel sebelum penggunaan Android.

Rincian keputusan pedagogis serta batas yang masih perlu persetujuan pengajar terdapat di [docs/OPEN_QUESTIONS.md](docs/OPEN_QUESTIONS.md). Pemetaan materi ke halaman buku berada di [docs/reference/SOURCE_MAP.md](docs/reference/SOURCE_MAP.md).
