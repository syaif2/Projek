# Rencana implementasi dan status

| Tahap | Kriteria selesai | Status |
|---|---|---|
| 1. Audit sumber | UI, storyboard/flowchart, logo, dan halaman relevan buku diperiksa; konflik dicatat | Selesai |
| 2. Fondasi Flutter | Struktur `vorteks`, Android Gradle, tema Material 3, shell, aset lokal | Source selesai; belum diverifikasi dengan Flutter SDK |
| 3. Model dan penyimpanan | SQLite, seed idempotent, foreign keys, akun lokal, jawaban dan progres per pengguna | Source selesai; belum dijalankan pada perangkat |
| 4. Halaman | Intro, auth, dashboard, materi, Mini Lab, asesmen, profil, bantuan | Source selesai; belum ada visual QA Android |
| 5. Logika belajar | Enam Mini Lab topikal, evaluasi, gate asesmen, PBKDF2, hasil | Source selesai; parameter/kriteria tertentu menunggu persetujuan |
| 6. Kualitas | Unit/widget tests, analyzer, persistensi, build APK | Tes disediakan; eksekusi/build tertunda toolchain |
| 7. Dokumentasi | README, PRD, arsitektur, UI, data, offline, tes, open questions, changelog | Selesai |

Sesudah Flutter stable, Dart, JDK 17, Android SDK, dan build tools dipasang: jalankan `flutter pub get`, tinjau hasil resolver dan simpan `pubspec.lock`, lalu `flutter analyze`, `flutter test`, `flutter run`, tes mode pesawat, dan `flutter build apk --debug`.
