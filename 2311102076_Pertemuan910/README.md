# 📱 Todo FCM - Flutter Application

> Aplikasi Todo List dengan Firebase Cloud Messaging Integration

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/flutter-3.11.5%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## 🎯 Tentang Proyek

**Todo FCM** adalah aplikasi Flutter yang menggabungkan:
- ✅ **Todo List Management** - Kelola daftar tugas dengan mudah
- 📬 **Firebase Cloud Messaging (FCM)** - Terima notifikasi push real-time
- 🎨 **Material Design 3** - UI modern dan responsif
- 🏗️ **Provider Pattern** - State management yang clean

**Mata Kuliah:** Praktikum ABP (Pertemuan 9-10)  
**NIM:** 2311102076

---

## ⭐ Fitur

- 🆕 Tambah tugas baru dengan TextField
- 📋 Lihat semua tugas dalam ListView yang rapi
- 🗑️ Hapus semua tugas sekaligus
- 🔔 Terima notifikasi push FCM real-time
- 📱 Handle notifikasi saat app foreground/background
- 🎨 Material Design 3 UI
- ⚡ Fallback token untuk development mode

---

## 🚀 Quick Start

### Prerequisites
```
- Flutter SDK 3.11.5 atau lebih baru
- Dart SDK 3.11.5 atau lebih baru
- Android SDK 21+ (untuk Android)
- Firebase Account
```

### Installation

1. **Clone dan masuk folder:**
```bash
cd "C:\Smester6\Praktikum ABP\push\2311102076_Pertemuan910"
```

2. **Install dependencies:**
```bash
flutter clean
flutter pub get
```

3. **Jalankan aplikasi:**
```bash
flutter run
```

---

## 📖 Dokumentasi Lengkap

Untuk dokumentasi lengkap, baca file [DOKUMENTASI.md](DOKUMENTASI.md) yang berisi:
- 📋 Deskripsi lengkap proyek
- 🛠️ Setup Firebase step-by-step
- 💻 Penjelasan kode detail
- 🐛 Troubleshooting guide
- 📊 Skenario testing

---

## 📁 Struktur Project

```
lib/
├── main.dart              # Main app & state management
└── firebase_options.dart  # Firebase configuration

android/
├── app/
│   └── google-services.json  # Firebase service file
└── build.gradle.kts         # Android build config

pubspec.yaml          # Dependencies
firebase.json         # Firebase config
DOKUMENTASI.md        # Full documentation
```

---

## 🔧 Tech Stack

| Technology | Version | Purpose |
|-----------|---------|---------|
| Flutter | 3.11.5+ | UI Framework |
| Firebase Core | 3.12.0 | Firebase Init |
| Firebase Messaging | 15.0.0 | Push Notifications |
| Provider | 6.1.5+1 | State Management |

---

## 📸 Demo

### Foreground Notification
```
User di app → Terima pesan → Snackbar muncul
```

### Background Notification  
```
App ditutup → Terima pesan → Notification di system tray
```

### Todo List
```
Input task → Click add → Task muncul di list → Delete all
```

---

## 🐛 Troubleshooting

### FCM Token Tidak Muncul?
**Solusi:**
```bash
flutter clean
flutter run -v
```

### Firebase Connection Error?
- Emulator tanpa internet → Gunakan development token (auto)
- Physical device → Pastikan ada Google Play Services

Lihat [DOKUMENTASI.md](DOKUMENTASI.md#-troubleshooting) untuk detail lengkap.

---

## 📝 Development

### Build APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Run dengan Verbose
```bash
flutter run -v
```

### Hot Reload
```
Tekan 'r' di terminal saat running
```

---

## 💡 Best Practices yang Diterapkan

✅ Error handling dengan try-catch  
✅ Fallback mechanism untuk emulator  
✅ State management dengan Provider  
✅ Proper async/await handling  
✅ Memory management & disposal  
✅ Material Design 3 UI  

---

## 🎓 Pembelajaran

Aplikasi ini mendemonstrasikan:
- Firebase initialization di Flutter
- Push notification handling (foreground/background)
- State management dengan Provider
- Material Design 3 implementation
- Async programming dengan Dart

---

## 📄 License

MIT License - Gratis untuk keperluan akademik

---

## 👨‍💻 Author

**NIM:** 2311102076  
**Status:** ✅ Production Ready  
**Last Update:** 26 Juni 2026

---

## 🔗 Resources

- [Flutter Docs](https://docs.flutter.dev/)
- [Firebase Messaging Docs](https://firebase.google.com/docs/cloud-messaging)
- [Provider Package](https://pub.dev/packages/provider)

---

**Untuk dokumentasi lengkap, buka [DOKUMENTASI.md](DOKUMENTASI.md)**

