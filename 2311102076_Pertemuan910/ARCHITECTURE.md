# 🏗️ Architecture & Design Document - Todo FCM

**Project:** Todo FCM  
**Date:** 26 Juni 2026  
**Status:** ✅ Complete

---

## 📋 Daftar Isi

1. [Architecture Overview](#architecture-overview)
2. [State Management](#state-management)
3. [Firebase Integration](#firebase-integration)
4. [UI Architecture](#ui-architecture)
5. [Data Flow](#data-flow)
6. [Design Patterns](#design-patterns)
7. [Performance Considerations](#performance-considerations)

---

## 🏛️ Architecture Overview

### Layered Architecture

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│    (UI - Widgets & Screens)         │
├─────────────────────────────────────┤
│     Business Logic Layer            │
│  (State Management - Provider)      │
├─────────────────────────────────────┤
│      Services Layer                 │
│   (Firebase - FCM, Auth)            │
├─────────────────────────────────────┤
│        Platform Layer               │
│  (Android, iOS, Web, etc)           │
└─────────────────────────────────────┘
```

### Project Structure

```
lib/
├── main.dart
│   ├── _firebaseMessagingBackgroundHandler()  [Services]
│   ├── main()                                  [Initialization]
│   ├── TodoProvider (ChangeNotifier)          [Business Logic]
│   ├── MyApp                                   [Presentation]
│   ├── TodoHomePage                           [Presentation]
│   └── _TodoHomePageState                     [Presentation + Logic]
└── firebase_options.dart                      [Configuration]
```

---

## 🔄 State Management

### Provider Pattern Implementation

```dart
class TodoProvider extends ChangeNotifier {
  final List<String> _tasks = [];

  List<String> get tasks => List.unmodifiable(_tasks);
  bool get hasTasks => _tasks.isNotEmpty;

  void addTask(String title) {
    _tasks.add(title.trim());
    notifyListeners();  // ← Trigger rebuild
  }

  void clearTasks() {
    _tasks.clear();
    notifyListeners();
  }
}
```

### State Flow Diagram

```
User Input
    ↓
_addTask(context)
    ↓
context.read<TodoProvider>().addTask()
    ↓
Provider notifies listeners
    ↓
context.watch<TodoProvider>() rebuilds
    ↓
ListView updates
```

### Benefits

✅ **Separation of Concerns** - Logic terpisah dari UI  
✅ **Testability** - Provider dapat di-test independently  
✅ **Reusability** - Provider dapat digunakan di multiple screens  
✅ **Performance** - Selective rebuilds (watch vs read)  

---

## 🔥 Firebase Integration

### Initialization Flow

```
main()
  ├─ WidgetsFlutterBinding.ensureInitialized()
  ├─ Firebase.initializeApp(
  │   options: DefaultFirebaseOptions.currentPlatform
  │  )
  ├─ FirebaseMessaging.onBackgroundMessage(
  │   _firebaseMessagingBackgroundHandler
  │  )
  └─ runApp()
```

### FCM Setup Flow

```
initState()
  └─ _configureFcm()
     ├─ RequestPermission()
     │  ├─ alert
     │  ├─ badge
     │  ├─ sound
     │  └─ provisional
     │
     ├─ getToken()
     │  ├─ Try: Get real token from Firebase
     │  └─ Catch: Use development token
     │
     ├─ Listen onMessage (Foreground)
     │  └─ Show Snackbar
     │
     └─ Listen onMessageOpenedApp
        └─ Handle tap on notification
```

### FCM Message Routing

```
Firebase Cloud Messaging
         │
         ├─ App Foreground
         │  └─ onMessage listener
         │     └─ Show Snackbar
         │
         ├─ App Background
         │  └─ onBackgroundMessage
         │     └─ Log (background handler)
         │
         └─ App Closed
            └─ System notification
               └─ onMessageOpenedApp (when tapped)
```

### Error Handling Strategy

```
try {
  _fcmToken = await messaging.getToken();
  // Success
} catch (e) {
  // Fallback for development/emulator
  _fcmToken = 'dev_token_${DateTime.now().millisecondsSinceEpoch}';
  
  // Still show UI, don't crash
}
```

---

## 🎨 UI Architecture

### Widget Hierarchy

```
MyApp (StatelessWidget)
  └─ MaterialApp
     └─ home: TodoHomePage
        └─ TodoHomePage (StatefulWidget)
           └─ _TodoHomePageState
              ├─ Scaffold
              │  ├─ AppBar
              │  │  ├─ title: "Todo List dengan FCM"
              │  │  └─ actions: DeleteButton
              │  │
              │  └─ body: Column
              │     ├─ TextField (Add task)
              │     ├─ Expanded > ListView (Tasks)
              │     └─ Card (FCM Status)
              │
              └─ Provider Consumer
                 └─ context.watch<TodoProvider>()
```

### State Variables

```dart
class _TodoHomePageState extends State<TodoHomePage> {
  // Controllers
  final TextEditingController _taskController;
  
  // FCM State
  String? _fcmToken;                    // FCM Token value
  String? _notificationText;            // Last notification
  bool _permissionGranted;              // Permission status
  
  // UI Updates
  setState(() { ... });                 // Trigger rebuild
}
```

---

## 📊 Data Flow

### Adding a Task

```
┌─────────────────────────────────────────┐
│   User taps ADD button or presses ENTER │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│   _addTask(context) called              │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│   context.read<TodoProvider>()          │
│   .addTask(_taskController.text)        │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│   TodoProvider.addTask() → push to list │
│   notifyListeners() → trigger rebuild   │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│   context.watch<TodoProvider>() updates │
│   ListView rebuilds with new task       │
│   TextField cleared                     │
└─────────────────────────────────────────┘
```

### Receiving FCM Notification

```
Firebase Cloud Messaging Server
           │
           ▼ (Message sent to device)
┌─────────────────────────────────┐
│  Device receives message        │
└─────────────┬───────────────────┘
              │
         ┌────┴────┐
         ▼         ▼
    FOREGROUND  BACKGROUND
         │         │
         ▼         ▼
    onMessage  onBackgroundMessage
    (handler)  (handler)
         │         │
         ▼         ▼
    setState()  Log only
    Show UI     Show notification
    Snackbar    in tray
```

---

## 🎯 Design Patterns

### 1. Provider Pattern (State Management)
```dart
ChangeNotifierProvider(
  create: (_) => TodoProvider(),
  child: MyApp()
)
```
**Purpose:** Centralized state management with auto-rebuild

### 2. Singleton Pattern (Firebase)
```dart
final messaging = FirebaseMessaging.instance;
// Same instance everywhere
```
**Purpose:** Single instance for entire app

### 3. Strategy Pattern (Error Handling)
```dart
try {
  // Strategy 1: Get real token
  _fcmToken = await messaging.getToken();
} catch (e) {
  // Strategy 2: Fallback to dev token
  _fcmToken = 'dev_token_...';
}
```
**Purpose:** Multiple strategies for error handling

### 4. Observer Pattern (FCM Listeners)
```dart
FirebaseMessaging.onMessage.listen((message) {
  // Observe and react to messages
});
```
**Purpose:** React to events without tight coupling

### 5. Model-View-ViewModel (MVVM) Pattern
```
TodoProvider (ViewModel)
    ↓
  State
    ↓
UI (view)
```
**Purpose:** Clear separation between business logic and UI

---

## ⚡ Performance Considerations

### 1. Memory Management
```dart
@override
void dispose() {
  _taskController.dispose();
  super.dispose();
}
```
**Best Practice:** Always dispose controllers

### 2. Efficient Rebuilds
```dart
// Use read() - doesn't trigger rebuild
final provider = context.read<TodoProvider>();

// Use watch() - only when you need UI update
final tasks = context.watch<TodoProvider>().tasks;
```

### 3. Unmodifiable List (Immutability)
```dart
List<String> get tasks => List.unmodifiable(_tasks);
```
**Benefit:** Prevents accidental mutations

### 4. Lazy Loading (Future Implementation)
```dart
// Current: All tasks loaded in memory
// Future: Load tasks on demand from database
```

### 5. Optimize Build Method
```dart
// ✅ Good - Extracted to separate method
if (provider.hasTasks) 
  IconButton(icon: const Icon(Icons.delete_forever), ...)

// ❌ Bad - Rebuilding expensive widget
for (int i = 0; i < provider.tasks.length; i++)
  Text(provider.tasks[i]);
```

### Skipped Frames Issue

```
I/Choreographer: Skipped 68 frames! 
```

**Cause:** Heavy work on main thread  
**Solutions:**
1. Use `compute()` for heavy calculations
2. Optimize ListView with `shrinkWrap: true`
3. Use `itemExtent` for fixed-height items
4. Profile dengan DevTools

---

## 🔒 Security Considerations

### 1. FCM Token Security
```
⚠️ Never hardcode tokens
⚠️ Store tokens securely if persisting
✅ Use secure storage for production
```

### 2. Firebase Rules
```
Future: Implement Firestore security rules
if request.auth != null {
  allow read, write: if true;
}
```

### 3. Permissions
```dart
final settings = await messaging.requestPermission(
  // Only request necessary permissions
);
```

---

## 📈 Scalability Plan

### Phase 1 (Current)
- ✅ Basic todo list
- ✅ FCM integration
- ✅ Local state management

### Phase 2 (Future)
- 📌 Database (Firestore/SQLite)
- 📌 User authentication
- 📌 Cloud sync
- 📌 Multiple lists/categories

### Phase 3 (Advanced)
- 📌 Real-time collaboration
- 📌 Offline support
- 📌 Advanced notifications
- 📌 Analytics

---

## 🧪 Testing Strategy

### Unit Tests
```dart
test('TodoProvider adds task correctly', () {
  final provider = TodoProvider();
  provider.addTask('Test task');
  expect(provider.tasks.length, equals(1));
});
```

### Widget Tests
```dart
testWidgets('Add button adds task', (tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.enterText(find.byType(TextField), 'New task');
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  expect(find.text('New task'), findsOneWidget);
});
```

### Integration Tests
```dart
// Test entire flow: add -> notification -> delete
```

---

## 📚 Design Principles Applied

| Principle | Implementation |
|-----------|-----------------|
| **DRY** | TodoProvider manages all task logic |
| **SOLID** | Single Responsibility per class |
| **KISS** | Simple, readable code structure |
| **YAGNI** | No unnecessary features |
| **Clean Code** | Clear naming, comments |

---

## 🎓 Learning Outcomes

1. **Architecture Design** - Layered architecture pattern
2. **State Management** - Provider pattern best practices
3. **Firebase Integration** - Cloud messaging setup
4. **Error Handling** - Graceful degradation with fallbacks
5. **Performance** - Efficient rebuilds and memory management
6. **Scalability** - Designed for future expansion

---

**Document Version:** 1.0  
**Last Updated:** 26 Juni 2026  
**Reviewed:** ✅
