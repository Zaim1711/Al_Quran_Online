# 📖 Al-Quran Digital (Al-Quran Online)

Aplikasi **Al-Quran Digital** modern yang dikembangkan menggunakan **Flutter**. Dirancang untuk memberikan pengalaman membaca, mempelajari, dan mendengarkan Al-Quran dengan **antarmuka pengguna (UI) yang bersih, intuitif, dan kaya fitur.**

---

## ✨ Fitur Utama

Aplikasi ini dilengkapi dengan serangkaian fitur esensial untuk mendukung kegiatan membaca dan memahami Al-Quran:

* **Bacaan Arab Jelas:** Menampilkan teks Al-Quran dalam huruf Arab yang mudah dibaca, dioptimalkan dengan *font* khusus (**Amiri**).
* **Terjemahan Indonesia:** Menampilkan terjemahan resmi **Bahasa Indonesia** tepat di bawah setiap ayat.
* **Transliterasi (Latin):** Opsi untuk menampilkan bacaan Latin guna membantu pengguna dalam pengucapan yang benar.
* **Tafsir Singkat:** Menyediakan **Tafsir ringkas per ayat** untuk pemahaman cepat konteks dan makna.
* **Murottal Audio:** Pemutaran audio (**Murottal**) per ayat menggunakan *library* `just_audio`, memungkinkan pengguna mendengarkan bacaan dari Qari terkemuka.
* **Dukungan Tema (Dark/Light):** Kompatibel penuh dengan **Mode Terang** (*Light Mode*) dan **Mode Gelap** (*Dark Mode*), yang dapat mengikuti preferensi sistem pengguna.

---

## 💻 Teknologi yang Digunakan

| Kategori | Teknologi/Pustaka | Deskripsi Singkat |
| :--- | :--- | :--- |
| **Framework** | **Flutter** | Digunakan untuk membangun aplikasi *cross-platform* (Android, iOS, Web, dsb.) dengan satu *codebase*. |
| **State Management** | **GetX** | Digunakan untuk manajemen *state* yang efisien, injeksi dependensi, dan navigasi yang cepat. |
| **Audio Playback** | `just_audio` | Pustaka untuk pemutaran audio Murottal yang fleksibel dan stabil. |
| **Font** | `google_fonts` | Menggunakan **Amiri** (untuk Arab) dan **Inter** (untuk UI). |

---

## 🚀 Instalasi dan Jalankan Proyek

Ikuti langkah-langkah di bawah ini untuk menjalankan proyek ini di mesin lokal Anda.

### Prasyarat

* **Flutter SDK** terinstal (versi **3.x.x** atau lebih baru).
* **Dart SDK**.
* Editor pilihan (VS Code atau Android Studio).

### Langkah-Langkah

1.  **Clone Repositori:**
    ```bash
    git clone (https://github.com/Zaim1711/Al_Quran_Online.git)
    cd Al_Quran_Online
    ```

2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Jalankan Aplikasi:**
    Pastikan *emulator* atau perangkat fisik sudah terhubung dan aktif.
    ```bash
    flutter run
    ```
    > **Catatan Penting:** Karena aplikasi ini menggunakan `just_audio` (untuk Murottal), disarankan untuk menjalankan **build penuh** (`flutter run`) daripada hanya *Hot Restart* setelah instalasi pertama untuk memastikan semua *plugin* terkompilasi dengan benar.

---

## 🚧 Struktur Data (API Kemenag)

Aplikasi ini saat ini menggunakan **Data (Kemenag)** untuk daftar Surah dan Ayat.

* Data Surah dan Ayat dimuat dari *method* `fetchMockSurahs` di `QuranController`.

---

## 📸 Tampilan Aplikasi (Screenshots)

| Halaman Daftar Surah | Halaman Detail Ayat | Bottom Sheet Pengaturan |
| :---: | :---: | :---: |
| ![]) | ![]) | ![]) |
