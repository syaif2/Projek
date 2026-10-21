# Pertanyaan terbuka

Pertanyaan berikut memerlukan konfirmasi pengajar/pemilik produk sebelum konten dan hasil asesmen dianggap final.

1. **Ambang kelulusan asesmen:** belum ada nilai yang disahkan. `LearningRules.assessmentPassPercent` tetap `null`; hasil hanya menampilkan skor dan “status menunggu kriteria”. Jangan memakai contoh progres 70% pada PDF desain sebagai batas lulus.
2. **Kriteria tuntas submateri:** implementasi teknis saat ini menandai materi selesai setelah evaluasi dikirim, tanpa syarat skor minimum. Apakah perlu nilai minimum atau jumlah percobaan tertentu?
3. **Makna persentase dashboard:** saat ini jumlah evaluasi selesai dibagi enam. Apakah desain 70% menunjukkan progres modul terakhir, progres semua konten, atau target lain?
4. **Jumlah soal asesmen:** PDF UI menyebut 50 pada pengantar desain (hlm. desain 15), tetapi layar lain menyebut 10. Instruksi terbaru menetapkan 10; konfirmasi jumlah final untuk produk.
5. **Parameter kontrol Mini Lab:** rentang berikut merupakan rancangan implementasi awal, bukan standar praktikum. Mohon sahkan atau ubah rentang, langkah, dan presisi.
   - Arus: Q 1–30 C, langkah 1 C; t 1–30 s, langkah 1 s; arus tampil 2 desimal.
   - Ohmik/LED: input V dan I manual dengan nilai positif; empat tegangan berbeda per komponen mengikuti Aktivitas 2.1. Perlu aturan pembulatan dan apakah nilai ukur boleh nol.
   - Hambatan jenis: panjang tetap 60 cm; diameter pilihan 0,1; 0,5; 1 mm sesuai Aktivitas 2.2. Nilai ρ/hasil ohm tidak ditampilkan karena angka ρ bahan tidak tercantum pada aktivitas.
   - Rangkaian lampu: 1–5 lampu, 9 V, tegangan nominal 2,1 V. Model menganggap lampu identik dan sumber ideal; perlu persetujuan asumsi/model.
   - Rangkaian majemuk: R lampu 0,6–2,4 Ω dengan langkah 0,1 Ω; nilai awal 1,2 Ω. Nilai alternator/aki/internal resistance mengikuti contoh buku.
   - Daya: V 1–24 V langkah 0,5 V; R 10–1.000 Ω langkah 10 Ω; waktu 0,5–8 jam langkah 0,5 jam. Tarif listrik tidak digunakan.
6. **Toleransi tantangan dan pembulatan:** saat ini target numerik dibandingkan dengan presisi floating-point dan angka tampilan dibulatkan per eksperimen. Apakah perlu toleransi tertentu untuk input siswa atau target eksperimen?
7. **Mini Lab Ohmik/LED:** buku meminta pengukuran resistor dan LED dengan minimal empat tegangan. Implementasi meminta siswa memasukkan data hasil ukur agar tidak mengarang kurva komponen. Apakah perangkat nyata digunakan, atau perlu model kualitatif terpisah yang disetujui?
8. **Mini Lab rangkaian majemuk:** eksperimen mengadaptasi contoh rangkaian mobil dua sumber pada hlm. 37–39, bukan menyalin diagram Aktivitas 2.5 secara persis. Konfirmasi apakah pilihan ini sesuai tujuan kelas.
9. **Storyboard/UI:** dokumen menyatakan storyboard masih draf yang perlu dikonsultasikan. Apakah perubahan visual dari PDF (khususnya struktur asesmen dan variasi enam Mini Lab) telah disetujui?
10. **Simpan data pengamatan Mini Lab:** pengamatan V–I saat ini hanya hidup selama halaman Mini Lab dibuka; progres, jawaban evaluasi, dan hasil asesmen tersimpan persisten. Apakah tabel pengamatan perlu disimpan di SQLite per akun?

Semua parameter draf diberi catatan langsung pada layar Mini Lab. Hasil tantangan Mini Lab tidak disimpan sebagai progres dan tidak memengaruhi asesmen.
