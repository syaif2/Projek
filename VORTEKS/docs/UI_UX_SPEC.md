# Spesifikasi UI/UX

Rujukan visual utama adalah PDF desain VORTEKS 23 layar, logo yang disediakan, storyboard/flowchart, dan instruksi tambahan pengguna. Desain tetap mobile-first: header terang, tombol navy, aksen turquoise, bidang putih, ikon jelas, jarak tap lebar, serta navigasi bawah empat bagian.

## Identitas dan layout

- Logo asli disimpan di `assets/images/vorteks_logo.png` dan ditampilkan pada splash, intro, pilihan auth, login, dan daftar.
- Warna mengikuti logo/PDF: navy, turquoise/cyan, pale blue, latar abu terang, dan putih. Tipografi memakai Roboto bawaan Android agar tidak menambah unduhan font.
- Tema Material 3 dikustomisasi dengan tombol rounded, field berlabel, kartu tipis, dan ukuran tap minimal 44–48 dp.
- Materi memakai kisi responsif dengan ubin heksagon sesuai layar Materi pada desain.
- Panah kembali dipakai pada layar detail; navigasi bawah hanya muncul pada shell utama.

## Layar

1. **Splash dan Intro:** logo, identitas VORTEKS, kepanjangan nama, tombol Mulai.
2. **Pilihan autentikasi:** Daftar dan Login.
3. **Login:** nama pengguna/kata sandi, validasi, feedback gagal, kembali, tautan Daftar.
4. **Registrasi:** nama lengkap, kelas, nama pengguna, kata sandi; validasi dan masuk otomatis sesudah berhasil.
5. **Dashboard:** sapaan, materi terakhir, indikator dari progres nyata, Lanjutkan Belajar, kompetensi materi, status asesmen, navigasi bawah.
6. **Daftar Materi:** enam ubin heksagon, status penyelesaian.
7. **Submateri:** Konteks, Tujuan Pembelajaran, bagian materi dan rumus relevan, visualisasi topik, akses Mini Lab, evaluasi submateri di bagian bawah, kembali/lanjut, sumber halaman.
8. **Mini Lab:** judul eksperimen, deskripsi aktivitas, tujuan yang terpisah, petunjuk bernomor, area eksperimen, hasil pengamatan, kesimpulan dari seed topik, tantangan opsional, tombol kembali. Parameter yang belum disetujui diberi catatan draf.
9. **Pengantar asesmen:** cakupan enam topik, petunjuk, jumlah 10 soal, pengiriman dan status hasil.
10. **Asesmen:** satu halaman panjang yang dapat digulir, 10 kartu soal, jumlah belum dijawab, tombol Kirim nonaktif sampai semua terisi, dialog konfirmasi.
11. **Hasil:** jumlah benar/persentase, status Lulus/Belum Lulus hanya jika batas telah ditetapkan; jika belum, status menunggu kriteria.
12. **Profil:** nama, username, kelas, progres dan daftar status materi, status asesmen, Edit, Logout.
13. **Edit Profil:** nama lengkap, kelas, nama pengguna, kata sandi baru opsional, Batal, Simpan. Password tidak diprefill atau ditampilkan.
14. **Bantuan:** petunjuk aplikasi, pemakaian Mini Lab, navigasi, penyimpanan offline, batas autentikasi lokal.

## Perbedaan sumber dan adaptasi yang dicatat

- PDF UI/UX memuat layar pengantar asesmen “50 soal” pada halaman desain 15, tetapi layar soal 17 menunjukkan 10 soal. Instruksi terbaru pengguna menetapkan 10 soal; app mengikuti 10 dan konflik tetap dicatat.
- Contoh progres 70% pada desain tidak dipakai sebagai progres atau ambang lulus statis.
- Storyboard PDF menyatakan draf perlu dikonsultasikan sebelum final. Hal itu dicatat sebagai pertanyaan persetujuan desain.
- PDF desain menampilkan Mini Lab awal dengan tegangan/hambatan. Instruksi terbaru meminta eksperimen berbeda untuk enam topik; layar Mini Lab mengikuti pemetaan buku, bukan menggandakan kontrol itu.
