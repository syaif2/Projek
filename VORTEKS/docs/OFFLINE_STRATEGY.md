# Strategi offline

- Android manifest tidak meminta permission INTERNET.
- Konten enam modul, pertanyaan, feedback, bantuan, tema, logo, serta visualisasi dibuat/disimpan di paket aplikasi.
- SQLite menyimpan akun, jawaban, progres, percobaan asesmen, hasil, dan salinan seed konten. `shared_preferences` hanya menyimpan id sesi dan materi terakhir per akun.
- Operasi database tidak memanggil API atau server. Fitur belajar, Mini Lab, evaluasi, dan asesmen menghitung hasil pada perangkat.
- Seed dijalankan dalam transaksi saat database dibuka: konten statis dengan ID stabil ditambahkan atau diperbarui, tanpa menghapus data akun/progres.
- Pengguna dapat memakai semua fungsi inti tanpa jaringan setelah aplikasi terpasang. Mendapatkan dependency/build Flutter untuk pengembang dilakukan sebelum pemasangan, bukan pada runtime aplikasi.

## Batas keamanan data lokal

Password di-derive dengan PBKDF2-HMAC-SHA256, salt acak 16 byte per akun, output 256 bit, dan 210.000 iterasi. `cryptography_flutter` menyediakan implementasi native Android. Hash dan salt tersimpan di SQLite, bukan password. Akun tidak tersinkron, database berada pada sandbox aplikasi, dan mekanisme lokal tidak memberi perlindungan server dari pengguna perangkat yang memiliki akses penuh.
