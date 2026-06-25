import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message received: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    ChangeNotifierProvider(create: (_) => TodoProvider(), child: const MyApp()),
  );
}

class TodoProvider extends ChangeNotifier {
  final List<String> _tasks = [];

  List<String> get tasks => List.unmodifiable(_tasks);

  bool get hasTasks => _tasks.isNotEmpty;

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo FCM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final TextEditingController _taskController = TextEditingController();
  String? _fcmToken;
  String? _notificationText;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _configureFcm();
  }

  Future<void> _configureFcm() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
    );

    setState(() {
      _permissionGranted =
          settings.authorizationStatus != AuthorizationStatus.denied;
    });

    if (!_permissionGranted) {
      setState(() {
        _notificationText = 'Permission not granted';
      });
      return;
    }

    try {
      _fcmToken = await messaging.getToken();
      debugPrint('✓ FCM Token: $_fcmToken');
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
      // Fallback for emulator/development - generate a mock token
      _fcmToken = 'dev_token_${DateTime.now().millisecondsSinceEpoch}';
      debugPrint('✓ Using development token: $_fcmToken');
      setState(() {
        _notificationText = 'Using development token (Firebase unavailable)';
      });
    }
    setState(() {});

    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title ?? 'Notifikasi FCM';
      final body = message.notification?.body ?? 'Pesan diterima.';
      setState(() {
        _notificationText = '$title - $body';
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Notifikasi diterima: $title')));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final title = message.notification?.title ?? 'Notifikasi dibuka';
      setState(() {
        _notificationText = title;
      });
    });
  }

  void _addTask(BuildContext context) {
    final text = _taskController.text;
    if (text.trim().isEmpty) return;
    context.read<TodoProvider>().addTask(text);
    _taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List dengan FCM'),
        actions: [
          if (provider.hasTasks)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Hapus semua tugas',
              onPressed: provider.clearTasks,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Tambah tugas baru',
                hintText: 'Contoh: Kerjakan latihan provider',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addTask(context),
                ),
              ),
              onSubmitted: (_) => _addTask(context),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: provider.tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada tugas. Tambahkan tugas terlebih dahulu.',
                      ),
                    )
                  : ListView.separated(
                      itemCount: provider.tasks.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text(provider.tasks[index]),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status FCM',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Permission: ${_permissionGranted ? 'Diterima' : 'Ditolak'}',
                    ),
                    const SizedBox(height: 8),
                    Text('Token: ${_fcmToken ?? 'Menunggu token...'}'),
                    const SizedBox(height: 8),
                    Text(
                      'Notifikasi terakhir: ${_notificationText ?? 'Belum ada notifikasi diterima.'}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addTask(context),
        icon: const Icon(Icons.task_alt),
        label: const Text('Tambah tugas'),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}
