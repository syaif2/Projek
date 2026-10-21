# Rencana pengujian

## Perintah

```powershell
flutter analyze
flutter test
flutter build apk --debug
```

## Cakupan unit

- `PhysicsCalculations`: I=Q/t, V=IR, R/ρ untuk diameter, rangkaian seri/paralel, solver Kirchhoff dengan contoh buku, daya dan energi.
- `LearningRules`: persentase progres, gerbang enam evaluasi, status asesmen ketika ambang kosong.
- `InputValidators`: data login/daftar/edit profil dan angka ukur.
- Penilaian asesmen 10 soal, persentase, dan status tertunda/ambang terkonfigurasi.

## Cakupan widget

Login/validasi, dashboard dan progres, daftar enam materi, tiap Mini Lab dengan instruksi/tujuan/kesimpulan dan kontrol topikal, evaluasi submateri beserta feedback, asesmen scroll 10 soal dan tombol kirim, serta profil tanpa password.

## Pemeriksaan integrasi manual pada Android

1. Buat akun, tutup aplikasi, buka lagi, dan login.
2. Buat akun kedua dan pastikan progres kedua akun terpisah.
3. Submit evaluasi, tutup/buka aplikasi, pastikan status tetap tersimpan.
4. Pastikan asesmen terkunci sampai keenam evaluasi terkirim.
5. Isi kurang dari 10 soal dan pastikan Kirim nonaktif; isi lengkap dan batalkan dialog; kirim kemudian lihat hasil.
6. Periksa Mini Lab pada ponsel portrait dan layar lebih lebar; tantangan tidak mengubah progres.
7. Aktifkan mode pesawat setelah instalasi dan buka semua materi, bantuan, dan simulasi.
8. Verifikasi database mempertahankan seed dan data pengguna setelah cold restart.

## Status eksekusi

File unit dan widget tests telah dibuat. Eksekusi Flutter analyzer, Flutter tests, uji persistensi perangkat, serta build APK belum dijalankan karena Flutter/Dart CLI tidak tersedia di lingkungan pembuatan. Android SDK terpasang (platform `android-37.0`, build-tools `36.0.0`, `adb`), tetapi `adb` tidak ada di PATH. Android Studio menyertakan JBR 25; JDK 17 yang disyaratkan proyek belum tersedia pada PATH dan kompatibilitas JBR tersebut belum diverifikasi. Hasil tes tidak diklaim lulus.
