# Model data SQLite

Database file lokal bernama `vorteks.db`, schema version 1. SQLite diatur dengan `PRAGMA foreign_keys = ON`. Tanggal disimpan sebagai ISO-8601 text.

| Tabel | Kolom utama | Kunci/relasi |
|---|---|---|
| `users` | `id`, `full_name`, `class_name`, `username`, `password_salt`, `password_hash`, `created_at` | PK `id`; `username` UNIQUE, case-insensitive |
| `lessons` | `id`, `sort_order`, `title`, `content_json`, `source_pages_json`, `lab_kind` | PK `id`; konten seed statis termasuk aktivitas, tujuan, petunjuk, dan kesimpulan Mini Lab dalam JSON |
| `questions` | `id`, `lesson_id`, `kind`, `prompt`, `options_json`, `correct_index`, `explanation`, `source_pages_json` | PK `id`; FK `lesson_id → lessons.id`, nullable untuk asesmen akhir |
| `lesson_progress` | `user_id`, `lesson_id`, `completed`, `evaluation_score`, `last_visited_at`, `updated_at` | PK komposit `(user_id, lesson_id)`; FK akun dan materi |
| `lesson_answers` | `user_id`, `lesson_id`, `question_id`, `selected_index`, `is_correct`, `updated_at` | PK `(user_id, question_id)`; FK akun, materi, pertanyaan |
| `assessment_attempts` | `id`, `user_id`, `correct_count`, `total_questions`, `percent`, `status`, `submitted_at` | PK `id`; FK akun |
| `assessment_answers` | `attempt_id`, `question_id`, `selected_index`, `is_correct` | PK `(attempt_id, question_id)`; FK percobaan dan pertanyaan |

## Relasi

```text
users 1──* lesson_progress *──1 lessons
users 1──* lesson_answers *──1 questions
users 1──* assessment_attempts 1──* assessment_answers *──1 questions
lessons 1──* questions (kind = lesson)
```

Seed enam materi dan 12 evaluasi submateri serta 10 soal asesmen memakai ID tetap. Saat database dibuka, transaksi melakukan `INSERT OR IGNORE` untuk baris yang belum ada lalu `UPDATE` untuk konten dengan ID yang sama; proses ini tidak menyentuh tabel progres, jawaban, atau percobaan. Semua jawaban pembelajaran memiliki `user_id`, sehingga progres antarakun tidak tercampur.

Skor evaluasi disimpan sebagai integer persentase. Asesmen menyimpan total benar, jumlah soal, persentase, status kebijakan, dan jawaban per soal. `status` dapat `pendingRule` ketika ambang lulus belum disetujui.
