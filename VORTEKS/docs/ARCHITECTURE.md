# Arsitektur

## Teknologi dan batas sistem

Aplikasi Android native memakai Flutter/Dart dan Material 3. Tidak ada backend, API, atau permission internet. Struktur source memisahkan tema/aturan, repository/database, seed/model, dan fitur layar.

## Lapisan

- `core/theme`, `constants`, dan `utils`: design tokens, aturan progres/kelulusan, validator, dan rumus Fisika murni.
- `core/database`: pembukaan SQLite, schema version 1, foreign key, dan seed statis idempotent.
- `data/models`: model konten, pengguna, progres, pertanyaan, dan hasil.
- `data/seed`: enam modul, evaluasi topik, dan bank asesmen sepuluh soal.
- `data/repositories`: semua akses query/mutasi SQLite yang dipakai fitur.
- `data/services`: PBKDF2 password lokal.
- `features`: onboarding/auth, dashboard, belajar, Mini Lab, asesmen, profil, dan bantuan.
- `shared/widgets`: logo, kartu, visualisasi rangkaian, grafik, dan kontrol berulang.

## State dan navigasi

`AppController` menjadi `ChangeNotifier` untuk akun aktif, konten, progres, materi terakhir, hasil asesmen, autentikasi, dan operasi repository. `main.dart` membuka database serta preferensi lebih dahulu. Pengguna tanpa sesi melihat Splash → Intro → pilihan Login/Daftar. Pengguna terautentikasi melihat shell dengan tab Beranda, Materi, Asesmen, dan Bantuan. Profil tersedia dari ikon di AppBar; halaman submateri dan Mini Lab didorong sebagai route. Logout memerlukan dialog konfirmasi.

```text
Intro → Login/Daftar → Dashboard
                         ├─ Materi → Submateri → Mini Lab (opsional)
                         │                    └→ Evaluasi → Simpan progres
                         ├─ Asesmen (terkunci sampai enam evaluasi selesai)
                         │      └→ 10 soal scroll → Konfirmasi → Hasil
                         ├─ Bantuan
                         └─ Profil → Edit / Konfirmasi logout
```

## Data flow pembelajaran

UI memanggil `AppController`; controller memakai `VorteksRepository`; repository memakai `AppDatabase`. Seed pelajaran dan pertanyaan menggunakan kunci stabil. Saat database dibuka, transaksi menyisipkan baris seed yang belum ada lalu memperbarui konten seed dengan ID tersebut; progres dan jawaban pengguna tidak disentuh. Jawaban/progres memiliki foreign key ke pengguna dan materi. Operasi evaluasi dan pengiriman asesmen berjalan dalam transaksi. Perhitungan tidak query database dari widget.

Dashboard menghitung progres sebagai jumlah evaluasi yang terkirim dibagi enam. Aturan ini dipusatkan pada `LearningRules`. `assessmentPassPercent` bernilai `null` sampai pengajar menyetujui ambang; hasil tetap menyimpan jumlah benar dan persentase.

## Logika eksperimen

`PhysicsCalculations` memuat I=Q/t, V=IR, geometri luas penampang lingkaran, R/ρ, rangkaian seri/paralel, model lampu ideal, solver dua-loop untuk contoh mobil buku, daya, energi, dan penilaian pilihan ganda. Tidak ada rumus simulasi di dalam widget. Dataset LED/resistor tidak dibuat-buat; pengguna memasukkan data V–I hasil pengamatan.

## Kegagalan lokal

Kesalahan autentikasi ditampilkan pada layar terkait. Gagal membuka SQLite menampilkan halaman startup yang menyatakan penyimpanan lokal tidak dapat dibuka. Repository tidak menghapus database atau progres saat seed konten dijalankan.
