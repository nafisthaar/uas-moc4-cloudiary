# Cloudiary - Local NoSQL Mood Journal App

Proyek ini merupakan tugas akhir / UAS untuk mata kuliah **Mobile Computing (MoC4)**. **Cloudiary** adalah aplikasi mood jurnal lokal berbasis Android yang dibangun menggunakan Flutter dan memanfaatkan penyimpanan NoSQL lokal (Hive) demi performa yang cepat dan reaktif tanpa ketergantungan pada server.

---

## Pengembang
* **Nama:** Nafistha Awalya Rahma
* **NIM:** 24110300046
* **Mata Kuliah:** Mobile Computing (MoC4) 

---

## Struktur Repositori (`moc4/`)
Sesuai dengan instruksi pengumpulan, seluruh berkas proyek dibungkus di dalam folder `moc4` dengan pembagian struktur sebagai berikut:
* **`apk/`**: Berisi file mentah aplikasi siap instal (`cloudiary.apk`) untuk pengujian di perangkat Android.
* **`document/`**: Berisi laporan dokumentasi teknis (*Technical Documentation*) dalam format PDF.
* **`slide/`**: Berisi file presentasi pitch deck.
* **`lib/`**: Kode sumber (*source code*) utama pengembangan aplikasi Flutter.
* **`pubspec.yaml`**: Berkas konfigurasi dependensi pustaka dan manajemen aset aplikasi.

---

## Fitur Utama Aplikasi
1. **Onboarding Screen**: Pengenalan fitur aplikasi dengan UI minimalis menggunakan komponen slider.
2. **Local Data Loading**: Membaca riwayat catatan langsung dari memori internal secara instan saat aplikasi dibuka.
3. **Input Mood & Jurnal Interaktif**: Pencatatan jurnal yang dilengkapi dengan pemilihan *mood chips*, tag kata kunci, serta lampiran foto dari kamera atau galeri perangkat.
4. **Penyimpanan Instan**: Menggunakan database lokal Hive Box (`journals`) untuk manajemen data yang aman, cepat, dan luring (*offline*).
5. **UI Reaktif (Real-time)**: Sinkronisasi pembaruan tampilan layar utama secara otomatis menggunakan `ValueListenableBuilder` tanpa perlu memuat ulang keseluruhan halaman.

---

## Spesifikasi Teknologi
* **Framework Core:** Flutter SDK & Dart SDK
* **Database NoSQL Lokal:** `hive_flutter` (Bekerja langsung di dalam memori internal perangkat)
* **Integrasi Fitur Perangkat:** `image_picker` (Mengakses kamera asli dan galeri HP demi lampiran foto)
