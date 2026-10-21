# PRD — VORTEKS

## Tujuan produk

Membantu siswa SMA kelas XII memahami Listrik Arus Searah lewat unit microlearning, visualisasi, eksperimen interaktif, evaluasi per topik, dan asesmen akhir yang dapat dipakai tanpa internet.

## Masalah dan pengguna

Materi rangkaian sering terasa abstrak ketika siswa hanya membaca persamaan, sementara akses ke praktikum terbatas. Pengguna utama adalah siswa SMA; aplikasi juga dapat mendukung guru sebagai media belajar.

## Ruang lingkup

Termasuk akun lokal, dashboard, enam materi, visualisasi, enam Mini Lab berbeda, evaluasi submateri, asesmen akhir 10 soal, hasil, profil/edit, bantuan, dan data lokal. Tidak termasuk backend, sinkronisasi antargawai, akun server, analitik daring, atau pengambilan materi dari internet.

## Kebutuhan fungsional

1. Pengguna dapat membuat akun dengan nama lengkap, kelas, nama pengguna, dan kata sandi; registrasi langsung membuka dashboard.
2. Pengguna dapat login/logout dan mengedit profil. Kata sandi tidak pernah ditampilkan pada profil.
3. Dashboard menampilkan sapaan, materi terakhir, progres dari data lokal, status materi, dan status asesmen.
4. Materi terdiri dari Arus Listrik; Hambatan Ohmik dan Non-Ohmik; Hambatan Jenis; Rangkaian Listrik; Rangkaian Majemuk; serta Daya Listrik.
5. Setiap materi menampilkan konteks, tujuan, uraian, rumus relevan, visualisasi, akses Mini Lab, evaluasi spesifik, feedback, dan navigasi.
6. Mini Lab menyediakan petunjuk, tujuan, variabel, hasil, kesimpulan, serta tantangan opsional. Tantangan tidak mengubah progres maupun kelulusan.
7. Evaluasi submateri ada di bawah halaman materi. Pengiriman menyimpan jawaban dan skor.
8. Asesmen akhir memuat 10 soal pilihan ganda dalam satu halaman scroll; tombol Kirim nonaktif sebelum semua jawaban dipilih dan menampilkan dialog konfirmasi.
9. Asesmen terkunci sampai keenam evaluasi submateri terkirim.
10. Hasil asesmen disimpan beserta skor. Status Lulus/Belum Lulus baru ditentukan jika ambang kelulusan telah disetujui.
11. Bantuan dan semua data inti tersedia lokal.

## Kebutuhan nonfungsional

- Android native berbasis Flutter/Dart dan Material 3; layout utama mengutamakan ponsel serta tetap terbaca pada layar lebar.
- Fitur inti berjalan tanpa koneksi internet setelah aplikasi dipasang.
- Penyimpanan SQLite terstruktur, dengan foreign key per akun dan repository terpisah dari UI.
- Seed konten idempotent, tidak menggandakan baris, serta tidak menghapus progres.
- Password memakai derivasi kriptografis lokal; batas keamanan lokal dijelaskan kepada pengguna.
- Logika rumus, penilaian, progres, dan validasi terpisah dari widget.

## User stories dan penerimaan

- Sebagai siswa, saya dapat belajar satu topik singkat dan kembali kapan saja. **Penerimaan:** enam topik tersedia, sumber buku dicatat, dan tiap evaluasi berbeda.
- Sebagai siswa, saya dapat mencoba Mini Lab tanpa takut memengaruhi nilai. **Penerimaan:** setiap topik punya jenis eksperimen berbeda; keluar/ulang tidak menambah progres.
- Sebagai siswa, saya ingin melihat progres akun saya. **Penerimaan:** progres dihitung dari status SQLite akun aktif, tidak dari angka contoh statis.
- Sebagai siswa, saya dapat mengerjakan asesmen sesudah semua materi. **Penerimaan:** asesmen berisi sepuluh soal, terkunci sebelum keenam evaluasi selesai, dan hanya dapat dikirim lengkap.
- Sebagai siswa, data saya tetap ada saat aplikasi dibuka lagi. **Penerimaan:** akun, jawaban, progres, dan hasil asesmen tersimpan lokal.

## Batasan dan aturan sementara

Sumber isi adalah Bab 2 “Arus Searah” pada buku Fisika kelas XII, halaman cetak 25–41. Penyelesaian materi sementara berarti evaluasi submateri telah dikirim, tanpa ambang skor. Ambang kelulusan asesmen belum ditentukan dan tidak diterka dari contoh progres 70% pada desain. Detail parameter simulasi dan pertanyaan pedagogis ada di `OPEN_QUESTIONS.md`.
