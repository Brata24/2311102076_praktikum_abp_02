# Flutter Application 1

A Flutter project for a practical assignment on camera access, gallery selection, and local notifications.

## Ringkasan

Aplikasi ini memungkinkan pengguna untuk:

- mengambil foto menggunakan kamera perangkat,
- memilih foto dari galeri perangkat,
- menampilkan notifikasi lokal setelah foto berhasil diambil atau dipilih.

Teknologi utama:

- Flutter
- image_picker
- flutter_local_notifications
- permission_handler

## Fitur Utama

1. Ambil foto dari kamera.
2. Pilih foto dari galeri.
3. Tampilkan preview foto di layar.
4. Menampilkan notifikasi lokal setelah foto berhasil diambil atau dipilih.
5. Permintaan izin runtime untuk kamera dan notifikasi.

## Struktur Proyek

- `lib/main.dart`
  - sumber utama aplikasi.
  - berisi UI, logika pemilihan gambar, permission handling, dan notifikasi.
- `android/app/src/main/AndroidManifest.xml`
  - deklarasi izin runtime untuk kamera dan notifikasi.
- `pubspec.yaml`
  - daftar dependency dan konfigurasi Flutter.

## Dependency

Minimal dependency yang digunakan:

- `flutter`
- `cupertino_icons: ^1.0.8`
- `image_picker: ^0.8.7+5`
- `flutter_local_notifications: ^22.0.1`
- `permission_handler: ^12.0.3`

## Persyaratan

- Flutter SDK
- Android SDK
- Perangkat Android atau emulator dengan kamera
- Developer mode aktif pada Windows untuk plugin symlink

## Izin Android

Tambahkan permissions berikut di `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

Runtime permission yang diminta:

- `Permission.camera`
- `Permission.notification`

## Cara Menjalankan

1. Buka terminal di folder proyek.
2. Jalankan:

```bash
flutter pub get
flutter run
```

Jika menggunakan Windows dan muncul pesan "Building with plugins requires symlink support", aktifkan Developer Mode di Settings.

## Alur Aplikasi

1. `main()` memanggil `WidgetsFlutterBinding.ensureInitialized()` dan `_initNotifications()`.
2. `_initNotifications()` meminta izin notifikasi dan inisialisasi plugin notifikasi.
3. UI utama menampilkan tombol `Kamera` dan `Galeri`.
4. Ketika tombol kamera ditekan:
   - izin kamera diminta,
   - jika diberi izin, kamera dibuka,
   - foto ditampilkan di preview,
   - notifikasi ditampilkan.
5. Ketika tombol galeri ditekan:
   - galeri dibuka,
   - foto dipilih dan ditampilkan,
   - notifikasi berhasil dipilih ditampilkan.

## Catatan

- `flutter_local_notifications` membutuhkan dukungan Android core library desugaring di Android Gradle.
- Untuk ADB wireless atau perangkat Xiaomi, pastikan opsi developer dan izin install diaktifkan.

## Saran Perbaikan

- tambah dukungan iOS untuk notifikasi lebih lengkap,
- tambahkan kemampuan menghapus atau menyimpan foto,
- gunakan state management untuk memperjelas logika.

---

Dokumentasi ini dibuat berdasarkan implementasi saat ini di `lib/main.dart`, `pubspec.yaml`, dan konfigurasi Android manifest.
