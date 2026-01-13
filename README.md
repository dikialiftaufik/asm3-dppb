# Dokumentasi Tugas Besar

**Nama Proyek:** The Komar's
* 607012400005 - Diki Alif Taufik
* 607012400032 - Ega Fiandra Pratama
* 607012400093 - Ahmad Zufar Fathoni

---

## 🛠 Tech Stack & Dependencies

Aplikasi ini dibangun menggunakan teknologi dan *package* berikut:

* **Framework:** Flutter (SDK ^3.9.2)
* **Networking:** `http` (^1.2.0) - Untuk komunikasi dengan REST API.
* **Local Storage:** `shared_preferences` (^2.2.2) - Untuk menyimpan token autentikasi sesi pengguna.
* **Media:** `image_picker` (^1.0.7) - Untuk mengambil foto dari galeri.
* **Formatting:** `intl` (^0.19.0) - Untuk format tanggal.
* **UI/Assets:** `google_fonts`, `flutter_svg`.

---

## 🚀 Rincian fitur yang telah dikerjakan oleh **Diki Alif Taufik**:

### 1. Fitur Autentikasi (Authentication)

Modul ini menangani keamanan akses pengguna mulai dari masuk hingga pemulihan akun.

#### a. Login
* **Deskripsi:** Memungkinkan pengguna masuk menggunakan email dan password.
* **Implementasi UI:** * Form input dengan validasi.
    * **Alert Dialog:** Menampilkan pesan "Login Gagal" jika kredensial salah.
* **Logika & Navigasi:**
    * **Replacement Navigation:** Menggunakan `pushReplacement` saat login sukses agar pengguna tidak bisa kembali ke halaman login dengan tombol *back*.
    * **Penyimpanan Token:** Token akses disimpan lokal menggunakan `SharedPreferences`.
* **Integrasi API:**
    * **Method:** `POST`
    * **Endpoint:** `/login`

#### b. Register
* **Deskripsi:** Pendaftaran akun baru untuk pengguna.
* **Implementasi UI:**
    * Menggunakan `TextFormField` dengan validator (memastikan password dan konfirmasi password cocok).
    * Dialog sukses dengan tombol pintas menuju halaman Login.
* **Integrasi API:**
    * **Method:** `POST`
    * **Endpoint:** `/register`
    * **Data:** Mengirim `name`, `email`, `password`, `password_confirmation`, dan `role` (default: 'pembeli').

#### c. Forgot Password & Reset Password
* **Deskripsi:** Alur pemulihan akun jika pengguna lupa kata sandi.
* **Highlight Fitur:**
    * **Auto-Copy Token:** Pada halaman *Forgot Password*, sistem menampilkan token dalam *Custom Alert Dialog* yang otomatis menyalin token ke *clipboard* pengguna.
    * **Clear Stack Navigation:** Setelah *Reset Password* berhasil, navigasi menghapus riwayat halaman (`pushAndRemoveUntil`) untuk memaksa login ulang.
* **Integrasi API:**
    * **Forgot:** `POST` ke `/forgot-password`.
    * **Reset:** `POST` ke `/reset-password` (mengirim token validasi).

---

### 2. Manajemen Profil Pengguna

#### a. Lihat Profil (My Profile)
* **Deskripsi:** Menampilkan informasi detail pengguna yang sedang login.
* **Implementasi UI:**
    * **Stack Layout:** Digunakan untuk memposisikan foto profil menumpuk di atas elemen *background* secara estetis.
* **Integrasi API:**
    * **Method:** `GET`
    * **Endpoint:** `/user` (Menggunakan Header `Authorization: Bearer <token>`).

#### b. Edit Profil
* **Deskripsi:** Memperbarui data diri (Nama, Email) dan Foto Profil.
* **Implementasi Teknis:**
    * **Multipart Request:** Menggunakan `http.MultipartRequest` karena pengiriman data bersifat campuran antara teks (nama, email) dan file biner (foto).
    * **Image Picker:** Integrasi widget untuk memilih foto dari galeri perangkat.
* **Integrasi API:**
    * **Method:** `POST` (Multipart)
    * **Endpoint:** `/user/update`

#### c. Logout
* **Deskripsi:** Keluar dari aplikasi dan menghapus sesi.
* **Logika:** Menghapus data token dari `SharedPreferences` dan memanggil endpoint logout di server.

---

### 3. Fitur Pendukung

#### a. Notifikasi (Notifications)
* **Deskripsi:** Menampilkan daftar informasi terkini dari restoran (promo, jadwal, dll).
* **Implementasi UI:**
    * **ListView.separated:** Digunakan untuk merender daftar notifikasi secara dinamis dengan garis pemisah.
    * **State Management:** Menangani tampilan *Empty State* (saat data kosong) vs tampilan data tersedia.
* **Integrasi API:**
    * **Method:** `GET`
    * **Endpoint:** `/notifications`

#### b. Feedback (Kirim Masukan)
* **Deskripsi:** Pengguna dapat mengirimkan kritik/saran beserta bukti foto.
* **Implementasi UI:**
    * **DropdownButton:** Untuk memilih kategori masukan.
    * **Text Area:** Input multiline untuk pesan panjang.
* **Integrasi API:**
    * **Method:** `POST` (Multipart)
    * **Endpoint:** `/feedback`
    * **Parameter:** `kategori_masukan`, `pesan_masukan`, dan file `bukti_foto`.

---

## 🚀 Rincian fitur yang telah dikerjakan oleh **Ega Fiandra Pratama**:

### 1. Halaman Utama (Home Screen)

* **Deskripsi:** Halaman utama aplikasi yang menampilkan navigasi ke berbagai fitur utama seperti katalog menu, notifikasi, dan profil.
* **Implementasi UI:**
    * **AppBar:** Dengan judul "The Komars" dan ikon untuk katalog menu serta notifikasi.
    * **Body:** Konten utama dengan tombol navigasi ke fitur-fitur seperti reservasi, menu, dan feedback.
* **Logika & Navigasi:**
    * Menggunakan `Navigator.push` untuk berpindah ke halaman lain seperti `MenuCatalogScreen` dan `NotificationScreen`.
* **Integrasi API:**
    * Menggunakan `ApiServiceEga.getMenu()` untuk mengambil data menu jika diperlukan di masa depan.

### 2. Layar Utama (Main Screen)

* **Deskripsi:** Layar utama dengan navigasi bottom navigation bar untuk mengakses berbagai halaman aplikasi.
* **Implementasi UI:**
    * **BottomNavigationBar:** Dengan 5 item: Menu, Reservasi Berlangsung, Home, Riwayat Reservasi, Feedback.
    * **IndexedStack:** Untuk menampilkan halaman sesuai indeks yang dipilih.
* **Logika & Navigasi:**
    * Menggunakan `setState` untuk mengubah `_selectedIndex` dan menampilkan halaman yang sesuai.
    * Halaman-halaman yang ditampilkan: `MenuScreen`, `MyReservationScreen` (untuk berlangsung dan riwayat), `HomeScreen`, `FeedbackScreen`.

### 3. Reservasi Saya (My Reservation Screen)

* **Deskripsi:** Menampilkan daftar reservasi pengguna yang sedang berlangsung dan riwayat reservasi.
* **Implementasi UI:**
    * **TabBar:** Dengan dua tab: "Berlangsung" dan "Riwayat".
    * **TabBarView:** Menampilkan `_ReservationList` untuk setiap status.
    * **ListView:** Untuk menampilkan daftar reservasi dengan detail seperti nama, tanggal, status.
* **Logika & Navigasi:**
    * Menggunakan `DefaultTabController` dengan `initialIndex` berdasarkan parameter.
    * Widget `_ReservationList` menangani tampilan daftar berdasarkan status ('active' atau 'history').
* **Integrasi API:**
    * Menggunakan `ApiServiceEga.getReservations()` untuk mengambil data reservasi dari server.

### 4. Status Pesanan (Order Status Screen)

* **Deskripsi:** Menampilkan status pesanan pengguna dengan detail lengkap seperti item, alamat pengiriman, metode pembayaran, dan total harga.
* **Implementasi UI:**
    * **ListView:** Untuk menampilkan daftar pesanan.
    * **Card:** Untuk setiap pesanan dengan informasi detail.
    * **Status Indicator:** Menggunakan warna dan ikon untuk menunjukkan status (pending, confirmed, completed, cancelled).
* **Logika & Navigasi:**
    * Menggunakan dummy data untuk demonstrasi, siap diintegrasikan dengan API.
* **Integrasi API:**
    * Menggunakan `ApiServiceEga.getOrders()` untuk mengambil data pesanan dari server.

### 5. Form Reservasi (Reservation Form Screen)

* **Deskripsi:** Formulir untuk membuat reservasi baru dengan input detail seperti nama, email, telepon, tanggal, waktu, jumlah orang, dan pesan tambahan.
* **Implementasi UI:**
    * **Form:** Dengan `TextFormField` untuk input teks dan `DropdownButton` untuk pilihan.
    * **DatePicker & TimePicker:** Untuk memilih tanggal dan waktu reservasi.
    * **ElevatedButton:** Untuk submit reservasi.
* **Logika & Navigasi:**
    * Validasi input sebelum submit.
    * Navigasi kembali ke halaman sebelumnya setelah berhasil.
* **Integrasi API:**
    * Menggunakan `ApiServiceEga.createReservation()` untuk mengirim data reservasi ke server.

---


## 🚀 Rincian fitur yang telah dikerjakan oleh **Ahmad Zufar Fathoni**:
