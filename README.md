# 📱 Android Connect — Pro ADB Dashboard

**Android Connect** adalah solusi manajemen koneksi Android (ADB) berbasis terminal (TUI) yang dirancang untuk pengguna macOS. Alat ini menyederhanakan proses mirroring, kontrol jarak jauh, dan manajemen perangkat melalui USB maupun WiFi secara otomatis dan persisten.

---

## ✨ Fitur Utama

- **Dasbor Konfigurasi Interaktif (TUI):** Kendalikan pengaturan `scrcpy` (Video, Audio, FPS, Codec) secara instan hanya dengan menekan satu tombol.
- **Koneksi Persisten (Stay-Alive):** Script akan terus berjalan dan mencoba menyambung kembali secara otomatis jika koneksi terputus.
- **Transisi USB ke WiFi Otomatis:** Deteksi cerdas saat kabel USB dicabut; script akan mencoba beralih ke koneksi WiFi secara otomatis menggunakan IP terakhir yang tercatat.
- **Deteksi Cerdas (Smart Discovery):** Menampilkan daftar perangkat yang online di jaringan WiFi yang sama meskipun kabel USB tidak dicolok.
- **Profil Mirroring Fleksibel:**
  - **Ghost Mode:** Mirroring suara tanpa jendela (cocok untuk mendengarkan audio background).
  - **Stealth Mode:** Mirroring video dengan layar HP fisik dalam keadaan mati.
  - **Performance/Gaming:** Pengaturan bitrate tinggi dan latensi rendah (60 FPS).
  - **Borderless Mode:** Tampilan jendela minimalis tanpa bingkai untuk macOS.
- **Manajemen Registry:** Nickname perangkat, alamat IP terakhir, dan riwayat serial disimpan secara lokal untuk kemudahan akses di kemudian hari.

---

## 🚀 Persyaratan Sistem

- **OS:** macOS (Direkomendasikan).
- **Alat Utama:**
  - [scrcpy](https://github.com/Genymobile/scrcpy) (`brew install scrcpy`)
  - [adb](https://developer.android.com/tools/adb) (`brew install android-platform-tools`)
- **Perangkat:** Android dengan fitur **USB Debugging** aktif.

---

## 🛠️ Instalasi & Penggunaan

### 1. Persiapan Direktori
Clone atau pindahkan semua file ke direktori kerja Anda (misal: `~/adb`).

### 2. Memberikan Izin Eksekusi
Buka terminal dan jalankan:
```bash
chmod +x ./android
```

### 3. Menjalankan Dasbor
Jalankan file entry point utama:
```bash
./android
```

---

## ⌨️ Pintasan Keyboard Dasbor

| Tombol | Fungsi | Keterangan |
| :--- | :--- | :--- |
| `1` | Layar HP Mati | Toggle on/off layar fisik HP saat mirroring |
| `2` | Tanpa Bingkai | Menghapus border jendela aplikasi di Mac |
| `6` | Mirror Video | Toggle tampilan visual mirroring |
| `7` | Mirror Audio | Toggle transmisi suara HP ke Mac |
| `9` | Bitrate | Siklus perubahan bitrate (4M, 8M, 16M, 32M) |
| `u` | UHID Smooth | Mode mouse/keyboard super responsif |
| `ENTER` | MULAI | Menjalankan koneksi mirroring scrcpy |
| `h` | Bantuan | Menunjukkan penjelasan detail fitur |
| `q` | Keluar | Menghentikan script dashbord |

---

## 📁 Struktur Proyek

- `android`: Entry point utama aplikasi.
- `config.sh`: Konfigurasi global (Path ADB, Bitrate default, Timeout).
- `lib/`: Pustaka core fungsi (Networking, Picker, Registry, Settings).
- `commands/`: Definisi perintah CLI (USB, WiFi, List, Rename, Forget).
- `.devices`: File registry database perangkat (Auto-generated).

---

## 👮 Disclaimer
Gunakan alat ini dengan bijak. Pastikan perangkat Android yang dihubungkan adalah milik Anda sendiri dan perhatikan keamanan pada jaringan publik saat menggunakan mode WiFi.

---
**Developed with care for Android Power Users.** 🦾
