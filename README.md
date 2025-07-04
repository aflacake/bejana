<p align="right">Bahasa: Indonesia</p>
<img src="https://raw.githubusercontent.com/aflacake/bejana/main/img/Logo%20Bejana%20ikon%20baru.png" width="150px" height="150px" alt="Logo Bejana" />

# 🏺 Bejana - Database dan Tampilan Dinamis
Bejana adalah database yang dinamis dan tidak membutuhkan skema atau tabel yang tetap seperti data relasional. Tanpa memperlakukan setup khusus pada awalnya. Batasan tidak ketat menyimpan data berbagai tipe seperti objek, _array_, _string_, dan angka. Bejana sendiri sudah satu paket untuk menampilkan datanya sendiri dari database yang Anda buat.

Terinspirasi dari kisah mukjizat Nabi Ilyas yang dapat membut bejana atau wadah jumlahya banyak, kumpulan wadah data _dictionary_. Bahasa Pemroraman yang memungkikan pemrosesan data dalam jumlah banyak disetiap "isian" dimulai dari blok `mulai` serta eksekusi kode diakhiri dengan `selesai`, bejana juga bahasa pemrograman interprener dan modular sederhana yang bertanggung jawab seutuhnya format.

Proses pengembangan ini juga beberapa dibuat generative oleh AI seperti pembuatan, debug, dan pembenahan kode.

# Mendukung
- [X] Variable dan value dalam jumlah banyak
- [x] Menyimpan data dalam jumlah yang banyak
- [x] Interegrasi dengan `.earl` yang mumpuni di dalam pengelolaan data luar
- [X] Kode dapat kirim ke penyimpanan data server
- [X] JSON File ekspor

# Instalasi
Buat file ekstensi dengan `.bjn` untuk mencari kode yang ingin di eksekusi dan menyintaksnya.

1. Arahkan ke folder bejana
   ```bash
   cd path/ke/folder/bejana
   ```
2. Tipe ketikan untuk tipe file khusus:
   ```bash
   ruby jalankan_bejana.rb NAMA_FILE.bjn
   ```
   atau bisa mode penuh, plugin, dan konfigurasi:
   > File plugin bawaan telah disediakan, Anda dapat menambahkan plugin lainnya dari luar dan itu boleh untuk dijalankan saja. Namun dalam menjalankan di file luar tidak memperbolehkan sebagai menyatakan bagian dari Bejana itu sendiri.
   ```bash
   ruby main.rb NAMA_FILE.bjn
   ```

Jangan lupa instal paket dari pihak ketiga untuk bahan Bejana:
- Menambahkan gem Sinatra untuk fitur API atau antarmuka eksternal agar bisa diakses dari luar misalnya dari frontend-web, aplikasi lain, dan cURL.
  ```bash
  gem install sinatra
  ```

## CLI
Dengan antarmuka CLI, memanggil fungsionalitas `Bejana` seperti:
- Menjalankan file `.bjn`.
- Menyimpan atau memuat data.
- Menampilkan variabel.
- Menjalankan langkah dari interpreter.

```bash
ruby bejana.rb jalankan NAMA_FILE.bjn
```

## Installer
### Linux dan MacOS
```bash
chmod +x installer.sh
./installer.sh
```
Setelah itu jalankan:
```bash
bejana bantuan
```

### Windows
1. Jalankan `installer.bat` dengan klik 2 kali atau lewat CMD.
2. Jalankan:
   ```bash
   %USERPROFILE%\.bejana\bejana.cmd bantuan
   ```
   > Untuk akses lebih mudah, secara manual Anda bisa tambahkan `%USERPROFILE%\.bejana` ke `PATH` sistem agar bisa dijalankan dengan hanya `bejana`.

## Font-end
Penggunaan luar seperti front-end, Anda bisa memasukkan plug-in yang sudah disediakan, bahwa plugin ini masih dalam proses pengerjakan lebih lanjut,
Plug-in: https://cdn.jsdelivr.net/gh/aflacake/bejana@main/bejana-skrip-modul.js.
   > Terkadang pembaruan kini sedang usang dan tidak relevan, sedang membutuhkan kontribusi dari Anda? tertarik? mulai fork sekarang.

# Berkontribusi
Membantu menyempurnakan aturan kode?\
Berikan kontribusi di isu atau _fork_ kode ini
