# 🚀 Quick Reference Guide - Todo FCM

**Last Updated:** 26 Juni 2026

---

## ⚡ Command Cheat Sheet

### Jalankan Aplikasi
```bash
# Normal run
flutter run

# Verbose (untuk debugging)
flutter run -v

# Clean build
flutter clean && flutter pub get && flutter run

# Run di device spesifik
flutter devices              # Lihat devices
flutter run -d <device-id>  # Run di device
```

### Build & Release
```bash
# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# List build outputs
flutter build --info
```

### Firebase Setup
```bash
# Configure Firebase
flutterfire configure --project=todo_fcm

# Check Firebase status
firebase projects:list
```

---

## 🔍 FCM Token di Terminal

**Terminal menampilkan:**
```
✓ FCM Token: dev_token_1234567890
```

Atau jika berhasil terhubung Firebase:
```
✓ FCM Token: eJ3aPmQ1RT-u8YXbVHbZdp:APA91b...
```

---

## 🧪 Testing Notifikasi

### 1. Get FCM Token
- Lihat di terminal saat app start
- Atau lihat di card "FCM Status" di app

### 2. Send Test Message (Firebase Console)
```
Firebase Console → Cloud Messaging → New campaign
↓
Title: "Test"
Body: "Pesan test"
Target: Select by Device → Paste FCM Token
↓
Send
```

### 3. Lihat Hasil
- App buka → Snackbar muncul
- App tutup → Notification di system tray

---

## 🐛 Common Issues & Quick Fix

| Issue | Fix |
|-------|-----|
| `Firebase Installations Service unavailable` | Gunakan physical device atau emulator dgn Google APIs |
| `FCM Token tidak muncul` | Jalankan `flutter clean && flutter run` |
| `DevFS connection dropped` | `adb disconnect` → reconnect |
| `Build error` | `flutter pub get` → `flutter clean` → run |
| `Permission denied` | Tap OK saat permission popup |

---

## 📊 File Penting

| File | Fungsi |
|------|--------|
| `lib/main.dart` | Main code & UI |
| `lib/firebase_options.dart` | Firebase config (auto-generated) |
| `android/app/google-services.json` | Firebase service account |
| `pubspec.yaml` | Dependencies |
| `DOKUMENTASI.md` | Full documentation |

---

## 🎯 Code Snippets

### Get FCM Token (di Code)
```dart
final messaging = FirebaseMessaging.instance;
String? token = await messaging.getToken();
debugPrint('Token: $token');
```

### Send Notification (dari Backend)
```bash
curl -X POST https://fcm.googleapis.com/v1/projects/your-project/messages:send \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "token": "DEVICE_FCM_TOKEN",
      "notification": {
        "title": "Hello",
        "body": "Test message"
      }
    }
  }'
```

### Add Task (di UI)
```dart
context.read<TodoProvider>().addTask('New Task');
```

---

## 📱 UI Flow

```
Splash (2s)
    ↓
TodoHomePage
    ├─ AppBar
    │  └─ Delete Button
    ├─ TextField (Add Task)
    ├─ ListView (Tasks)
    └─ Card (FCM Status)
```

---

## 🔗 Important Links

- 📖 [Full Documentation](DOKUMENTASI.md)
- 🔗 [Flutter Docs](https://docs.flutter.dev/)
- 🔥 [Firebase Console](https://console.firebase.google.com/)
- 📦 [Pub.dev Packages](https://pub.dev/)

---

## ✅ Checklist Before Submission

- [ ] App runs without crashes
- [ ] FCM Token displays in terminal
- [ ] Can add/delete tasks
- [ ] Notifications work on physical device
- [ ] No compilation errors
- [ ] Documentation complete
- [ ] Code formatted (`dart format lib/`)

---

## 🎓 Key Learnings

1. **Firebase Integration** - Init, config, messaging setup
2. **State Management** - Provider pattern for clean code
3. **Async Programming** - Futures, async/await
4. **Error Handling** - Try-catch, fallback mechanisms
5. **Mobile UI** - Material Design 3, responsive layouts
6. **Push Notifications** - Foreground/background handling

---

## 📞 Debugging Tips

### Enable Verbose Logging
```bash
flutter run -v 2>&1 | tee debug.log
```

### Check Device Connection
```bash
adb devices
adb logcat | grep flutter
```

### Force Garbage Collection
```bash
adb shell am send-trim-memory <PID> 80
```

### Check Permissions
```bash
adb shell pm list permissions -u | grep todo_fcm
```

---

**Need Help?** Check [DOKUMENTASI.md](DOKUMENTASI.md#-troubleshooting) for detailed guide.
