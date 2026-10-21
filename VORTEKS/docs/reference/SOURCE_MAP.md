# Pemetaan sumber konten dan Mini Lab

Sumber primer yang diperiksa: `Fisika_BS_KLS_XII.pdf`, Bab 2 “Arus Searah”. Nomor halaman berikut adalah nomor cetak di buku. Gambar rangkaian/grafik yang melekat pada halaman 25–41 juga ditinjau pada render PDF.

| Submateri / halaman buku | Tujuan dan konsep/rumus | Aktivitas Mini Lab | Variabel dan keluaran | Kaitan dengan sumber |
|---|---|---|---|---|
| Arus Listrik, hlm. 25–26 | Arus adalah muatan per waktu; arah arus konvensional berlawanan dengan gerak elektron. `I=Q/t`, `I=ne/t`, `e=1,6×10⁻¹⁹ C`. | Ubah muatan dan waktu secara terpisah; lihat rangkaian tertutup dan arus yang dihitung. | Q (C), t (s); hasil I (A), dengan skenario awal Q=5 C dan t=10 s. Rentang kontrol draf. | Langsung mengamati definisi arus dan contoh satuan yang dibahas pada hlm. 25–26. Tantangan target 0,20 A berasal dari rancangan UI, bukan target buku. |
| Hambatan Ohmik dan Non-Ohmik, hlm. 27–30 | `V=IR`; resistor ohmik memiliki rasio V/I tetap dan grafik V–I linear. LED/lampu filamen dipakai untuk membandingkan karakteristik non-linear. | Catat pasangan V–I untuk resistor dan LED; tampilkan dua grafik dari data siswa. Tidak ada data komponen hasil rekaan. | Pilihan komponen, V (V), I (A); titik dan tabel pengamatan. Aktivitas buku meminta sekurangnya empat tegangan berbeda pada tiap komponen. | Mengikuti Aktivitas 2.1, urutan pengukuran, dan grafik pada hlm. 28–30. Data eksperimen tidak disediakan buku sehingga dimasukkan manual. |
| Hambatan Jenis, hlm. 31–32 | `R=ρℓ/A`; pengaruh bahan, panjang, luas penampang, dan suhu. Untuk lingkaran, `A=π(d/2)²`. | Pilih diameter kawat nikrom dengan panjang 60 cm tetap; bandingkan `R/ρ=ℓ/A`. | Diameter 0,1; 0,5; 1 mm, panjang 60 cm; hasil A, R/ρ (m⁻¹), dan rasio relatif. | Panjang dan diameter berasal dari Aktivitas 2.2 hlm. 31. Karena nilai ρ numerik tidak dicantumkan, hasil tidak diklaim sebagai ohm. Rumus geometri lingkaran adalah hubungan luas penampang kawat bundar. |
| Rangkaian Listrik, hlm. 33–35 | Seri: arus sama, tegangan dijumlah, `Rₛ=ΣR`. Paralel: tegangan cabang sama, arus dijumlah, `1/Rₚ=Σ(1/R)`. | Pilih seri/paralel untuk skenario lima lampu 2,1 V dengan sumber 9 V. | Topologi, jumlah 1–5 lampu; tegangan model per lampu. Model draf menganggap beban identik dan sumber ideal. | Rumus dari hlm. 34; skenario lampu dari Aktivitas 2.4 hlm. 35. Perlu validasi model ideal terhadap tujuan eksperimen.
| Rangkaian Majemuk, hlm. 35–39 | Hukum I Kirchhoff `ΣI masuk=ΣI keluar`; hukum loop `Σ ε=ΣIR`; tanda arus memuat informasi arah relatif. | Solver dua-loop memakai contoh alternator/aki/lampu mobil. | ε alternator 14 V, r=0,1 Ω; ε aki 12 V, r=0,01 Ω; R lampu awal 1,20 Ω. R lampu dapat diubah dalam rentang draf; hasil I alternator, I aki, I lampu. | Nilai contoh dan persamaan pada hlm. 37–39. Hasil untuk R=1,20 Ω mendekati 19,1 A; −9 A; 10,1 A sesuai pembulatan buku. Aktivitas 2.5 hlm. 35 memakai tiga resistor dan dua baterai; Mini Lab memilih contoh mobil pada bab yang sama dan perbedaan ini dicatat.
| Daya Listrik, hlm. 39–41 | `E=qV`, `P=E/t`, `P=VI=V²/R=I²R`; energi rumah tangga dalam kWh. | Atur V, R, dan lama penggunaan; bandingkan arus, daya, dan energi. | V (V), R (Ω), waktu (jam); hasil I (A), P (W), energi (kWh). Rentang draf; tarif tidak ditetapkan. | Menerapkan rumus dan aktivitas analisis konsumsi daya pada hlm. 40–41 tanpa mengarang tarif.

## Dokumen desain dan alur

- `Visualisasi Otomatis Rangkaian Terintegrasi Eksperimen ListriK.pdf` (23 layar): rujukan logo/warna, auth, dashboard, enam materi, materi contoh, Mini Lab awal, asesmen, profil, edit, dan bantuan. Halaman pengantar asesmen menyebut 50 soal, sedangkan layar lain menyebut 10; arahan terbaru pengguna menetapkan 10.
- `Ahmad Syaifulloh_005.pdf`: storyboard dan flowchart; layar storyboard pada hlm. 4–7, flowchart pada hlm. 8. Dokumen menyebut storyboard sebagai draf untuk dikonsultasikan.
- `FLOWCHART VORTESK.drawio.png`: alur mulai, auth, dashboard, materi/evaluasi, asesmen, profil, bantuan, dan logout.
- `VORTEKS (2).png`: logo aplikasi yang dipakai sebagai aset lokal.
- `Tugas Judul mobile Learning.pdf`, hlm. 1–2: nama, strategi microlearning, topik, dan pengguna sasaran.

PDF sumber tidak disalin ke proyek; path sumber asli pada mesin pemilik tercatat di atas dan di README/source record.
