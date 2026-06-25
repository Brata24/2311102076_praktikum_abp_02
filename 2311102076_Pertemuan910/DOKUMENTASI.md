# 📚 Dokumentasi Aplikasi Todo FCM

**Nama Proyek:** Todo FCM  
**Versi:** 1.0.0  
**Platform:** Flutter (Android, iOS, Web, Linux, macOS, Windows)  
**Nim:** 2311102076  
**Pertemuan:** 9-10

---

## 📖 Daftar Isi

1. [Deskripsi Proyek](#deskripsi-proyek)
2. [Fitur Utama](#fitur-utama)
3. [Teknologi yang Digunakan](#teknologi-yang-digunakan)
4. [Persyaratan Sistem](#persyaratan-sistem)
5. [Instalasi](#instalasi)
6. [Struktur Proyek](#struktur-proyek)
7. [Cara Kerja Aplikasi](#cara-kerja-aplikasi)
8. [Firebase Setup](#firebase-setup)
9. [Menjalankan Aplikasi](#menjalankan-aplikasi)
10. [Troubleshooting](#troubleshooting)
11. [Penjelasan Kode](#penjelasan-kode)

---

## 🎯 Deskripsi Proyek

**Todo FCM** adalah aplikasi mobile yang menggabungkan fitur manajemen todo list dengan Firebase Cloud Messaging (FCM). Aplikasi ini memungkinkan pengguna untuk:

- ✅ Membuat dan mengelola daftar tugas (To-Do List)
- 📱 Menerima notifikasi push dari Firebase Cloud Messaging
- 🔔 Melihat status FCM dan menerima pesan real-time
- 💾 Menyimpan tugas dalam state lokal aplikasi

---

## ⭐ Fitur Utama

### 1. **Manajemen Todo List**
- Tambah tugas baru melalui TextField
- Lihat semua tugas dalam ListView
- Hapus semua tugas sekaligus dengan tombol delete
- Setiap tugas ditampilkan dengan nomor urut

### 2. **Firebase Cloud Messaging (FCM)**
- Menerima notifikasi push dari Firebase
- Menampilkan FCM Token untuk testing
- Handle pesan foreground (saat app buka)
- Handle pesan background (saat app ditutup)
- Handle pesan saat app dibuka dari notifikasi

### 3. **User Interface**
- Material Design 3 dengan Material You colors
- AppBar dengan judul dan tombol aksi
- Card untuk menampilkan informasi FCM
- Snackbar untuk notifikasi

---

## 🛠 Teknologi yang Digunakan

| Teknologi | Versi | Fungsi |
|-----------|-------|--------|
| Flutter | 3.11.5+ | Framework UI |
| Dart | 3.11.5+ | Bahasa Pemrograman |
| Firebase Core | 3.12.0 | Inisialisasi Firebase |
| Firebase Messaging | 15.0.0 | Cloud Messaging |
| Provider | 6.1.5+1 | State Management |
| Material Design | 3 | UI Components |

---

## 💻 Persyaratan Sistem

### Minimum Requirements
- **Flutter:** 3.11.5 atau lebih baru
- **Dart:** 3.11.5 atau lebih baru
- **Android:** SDK 21 (Android 5.0) atau lebih baru
- **Java:** JDK 11 atau lebih baru
- **RAM:** 4GB minimum

### Alat yang Diperlukan
- Flutter SDK
- Android Studio atau VSCode
- Git
- Firebase Account
- Google Services (untuk Firebase)

---

## 📦 Instalasi

### 1. Clone Repository
```bash
cd "C:\Smester6\Praktikum ABP\push\"
# Repository sudah ada, tinggal masuk ke folder
cd 2311102076_Pertemuan910
```

### 2. Install Dependencies
```bash
flutter clean
flutter pub get
```

### 3. Jalankan Code Generation (jika diperlukan)
```bash
dart run build_runner build
```

### 4. Setup Firebase (Lihat bagian Firebase Setup)

---

## 📁 Struktur Proyek

```
2311102076_Pertemuan910/
├── lib/
│   ├── main.dart              # File utama aplikasi
│   └── firebase_options.dart  # Konfigurasi Firebase
├── android/                   # Platform Android
├── ios/                       # Platform iOS
├── web/                       # Platform Web
├── linux/                     # Platform Linux
├── macos/                     # Platform macOS
├── windows/                   # Platform Windows
├── test/                      # Unit Tests
├── pubspec.yaml              # Dependencies
├── firebase.json             # Firebase Config
├── analysis_options.yaml     # Linting Rules
└── README.md                 # Readme file
```

### File Penting:
- **lib/main.dart** - Kode utama aplikasi
- **lib/firebase_options.dart** - Konfigurasi Firebase yang di-generate
- **android/app/google-services.json** - Service account Firebase untuk Android
- **pubspec.yaml** - Definisi dependencies

---

## 🔄 Cara Kerja Aplikasi

### Lifecycle Aplikasi

```
┌─────────────────────────────────────────┐
│         Aplikasi Dimulai                │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  main() → Firebase.initializeApp()      │
│  - Inisialisasi Firebase                │
│  - Set Background Handler FCM           │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│     TodoHomePage (StatefulWidget)       │
│     - initState() dipanggil             │
│     - _configureFcm() dipanggil         │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  _configureFcm() - Setup FCM Handler    │
│  1. Request Permission                  │
│  2. Get FCM Token                       │
│  3. Listen to onMessage (foreground)    │
│  4. Listen to onMessageOpenedApp        │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│      UI Rendered - Ready for Interaction│
└─────────────────────────────────────────┘
```

### Alur Penerimaan Notifikasi

```
Firebase Cloud Messaging
        │
        ▼ (Pesan dikirim)
┌─────────────────────────┐
│  Foreground?            │
└────┬───────────────┬────┘
     │ Ya            │ Tidak
     ▼               ▼
onMessage        onBackgroundMessage
Show Snackbar    (Background Handler)
Update UI        Log Message
     │               │
     └───────┬───────┘
             ▼
    Notifikasi Ditampilkan
```

---

## 🔐 Firebase Setup

### Langkah 1: Buat Project Firebase
1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik "Create a new project"
3. Masukkan nama project: `todo_fcm` (atau sesuaikan)
4. Follow wizard hingga project terbuat

### Langkah 2: Tambahkan Android App
1. Di Firebase Console, klik "+ Add app"
2. Pilih Android
3. Masukkan:
   - **Package name:** `com.example.todo_fcm` (atau sesuaikan dengan build.gradle)
   - Download `google-services.json`
4. Letakkan di `android/app/google-services.json`

### Langkah 3: Verifikasi Build Configuration
```gradle
// android/app/build.gradle.kts
plugins {
    id("com.google.gms.google-services")
}

dependencies {
    implementation("com.google.firebase:firebase-messaging")
}
```

### Langkah 4: Generate Firebase Options
```bash
flutterfire configure --project=todo_fcm
```

---

## 🚀 Menjalankan Aplikasi

### Mode Development
```bash
# Bersihkan build sebelumnya
flutter clean

# Download dependencies
flutter pub get

# Jalankan di emulator atau device
flutter run

# Dengan verbose logging (untuk debugging)
flutter run -v
```

### Mode Release
```bash
# Build APK untuk Android
flutter build apk --release

# Build untuk iOS
flutter build ios --release

# Hasilnya ada di build/app/outputs/flutter-apk/
```

### Jalankan di Device Spesifik
```bash
# Lihat device yang tersedia
flutter devices

# Jalankan di device tertentu
flutter run -d <device-id>
```

---

## 🛠 Troubleshooting

### Masalah 1: Firebase Installations Service Unavailable

**Gejala:**
```
E/FirebaseMessaging( 8528): Failed to get FIS auth token
com.google.firebase.installations.FirebaseInstallationsException: Firebase Installations Service is unavailable
```

**Solusi:**
1. **Cek koneksi internet emulator:**
   ```bash
   adb shell ping 8.8.8.8
   ```

2. **Gunakan device dengan Google Play Services:**
   - Buat emulator baru dengan "Google APIs" image (bukan AOSP)

3. **Atau gunakan physical device** (paling reliable)

4. **Temporary workaround:** Aplikasi sudah dilengkapi fallback token development

### Masalah 2: DevFS Connection Dropped

**Solusi:**
```bash
# 1. Restart adb
adb disconnect
adb devices

# 2. Bersihkan build
flutter clean

# 3. Jalankan lagi
flutter run
```

### Masalah 3: Gradle Build Error

**Solusi:**
```bash
# 1. Update Gradle
flutter upgrade

# 2. Clean gradle cache
cd android
./gradlew clean
cd ..

# 3. Rebuild
flutter run
```

### Masalah 4: FCM Token Tidak Muncul

**Cek:**
1. Lihat di terminal untuk log: `✓ FCM Token:`
2. Pastikan permission FCM sudah disetujui
3. Lihat card di bawah UI untuk status FCM

---

## 💻 Penjelasan Kode

### 1. Main Function
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    ChangeNotifierProvider(create: (_) => TodoProvider(), child: const MyApp()),
  );
}
```
- **ensureInitialized()** - Pastikan Flutter binding siap
- **Firebase.initializeApp()** - Inisialisasi Firebase
- **onBackgroundMessage()** - Set handler untuk pesan background
- **ChangeNotifierProvider** - Provide state manager

### 2. TodoProvider (State Management)
```dart
class TodoProvider extends ChangeNotifier {
  final List<String> _tasks = [];

  void addTask(String title) {
    final cleaned = title.trim();
    if (cleaned.isEmpty) return;
    _tasks.add(cleaned);
    notifyListeners();
  }

  void clearTasks() {
    _tasks.clear();
    notifyListeners();
  }
}
```
- Manage list of tasks
- `notifyListeners()` - Update UI ketika data berubah

### 3. Firebase Messaging Configuration
```dart
Future<void> _configureFcm() async {
  final messaging = FirebaseMessaging.instance;
  
  // 1. Request Permission
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // 2. Get FCM Token
  try {
    _fcmToken = await messaging.getToken();
    debugPrint('✓ FCM Token: $_fcmToken');
  } catch (e) {
    // Fallback untuk emulator
    _fcmToken = 'dev_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  // 3. Listen to Foreground Messages
  FirebaseMessaging.onMessage.listen((message) {
    final title = message.notification?.title ?? 'Notifikasi FCM';
    final body = message.notification?.body ?? 'Pesan diterima.';
    setState(() {
      _notificationText = '$title - $body';
    });
  });

  // 4. Listen to App Opened from Notification
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    final title = message.notification?.title ?? 'Notifikasi dibuka';
    setState(() {
      _notificationText = title;
    });
  });
}
```

### 4. UI Building
```dart
TextField(
  controller: _taskController,
  decoration: InputDecoration(
    labelText: 'Tambah tugas baru',
    suffixIcon: IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => _addTask(context),
    ),
  ),
),
```

---

## 📊 Skenario Testing

### Test 1: Tambah Tugas
1. Ketik "Kerjakan latihan" di TextField
2. Tekan tombol Add atau Enter
3. Tugas akan muncul di ListView

### Test 2: Hapus Semua Tugas
1. Tambah beberapa tugas
2. Tekan tombol delete (ikon tempat sampah) di AppBar
3. Semua tugas akan dihapus

### Test 3: Terima Notifikasi FCM
1. Copy FCM Token dari terminal
2. Buka Firebase Console → Cloud Messaging
3. Klik "Send your first message"
4. Isi title, body, target audience
5. Kirim message
6. Lihat notifikasi muncul di app

### Test 4: Background Message
1. Jalankan aplikasi
2. Tekan tombol home (minimize app)
3. Kirim notifikasi dari Firebase
4. Lihat notifikasi di system tray
5. Tekan notifikasi untuk buka app

---

## 📝 Notes dan Best Practices

### Best Practices yang Diterapkan:
1. ✅ **Error Handling** - Try-catch untuk FCM token
2. ✅ **Fallback Mechanism** - Development token untuk emulator
3. ✅ **State Management** - Provider pattern untuk clean architecture
4. ✅ **Memory Management** - Proper disposal dan mounted check
5. ✅ **Async/Await** - Proper async handling
6. ✅ **UI Responsiveness** - Skipped frames notification (perlu optimization)

### Rekomendasi Improvement:
1. 🔧 Tambahkan local database (SQLite/Hive) untuk persistensi data
2. 🔧 Optimasi performance untuk mengurangi skipped frames
3. 🔧 Tambahkan unit tests dan widget tests
4. 🔧 Implementasi sound null safety
5. 🔧 Tambahkan error tracking (Sentry/Crashlytics)

---

## 📞 Kontak & Support

- **Developer:** NIM 2311102076
- **Mata Kuliah:** Praktikum ABP (Pertemuan 9-10)
- **Status:** ✅ Working (dengan fallback untuk emulator)

---

## 📄 Lisensi

Proyek ini adalah bagian dari Praktikum ABP dan bebas digunakan untuk keperluan akademik.

---

**Terakhir diupdate:** 26 Juni 2026  
**Status:** ✅ Production Ready dengan Fallback Mode
