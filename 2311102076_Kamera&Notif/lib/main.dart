// ============================================================
// TUGAS PRAKTIKUM - NOTIFIKASI & API PERANGKAT KERAS
// Fitur:
// 1. Ambil foto dari Kamera (Camera API via image_picker)
// 2. Pilih foto dari Galeri (image_picker)
// 3. Tampilkan notifikasi lokal setelah foto berhasil didapat
// ============================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

// Instance global untuk plugin notifikasi.
// Dibuat global agar bisa diakses dari mana saja tanpa perlu
// membuat instance baru tiap kali dipakai.
final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // Wajib dipanggil sebelum memakai plugin native (kamera, notifikasi, dll)
  // sebelum runApp(), supaya binding Flutter <-> platform sudah siap.
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi setting notifikasi untuk Android & iOS
  await _initNotifications();

  runApp(const MyApp());
}

// Fungsi untuk menyiapkan konfigurasi awal notifikasi lokal
Future<void> _initNotifications() async {
  // Pastikan permintaan notifikasi sudah diajukan sebelum inisialisasi.
  await _requestNotificationPermission();

  // Icon yang dipakai notifikasi di Android (pakai default icon app)
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Setting untuk iOS (minta izin alert, badge, sound)
  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await notificationsPlugin.initialize(
    settings: initSettings,
    onDidReceiveNotificationResponse: (response) {},
  );
}

Future<bool> _requestNotificationPermission() async {
  final status = await Permission.notification.request();
  if (!status.isGranted) {
    debugPrint('Izin notifikasi ditolak atau tidak diberikan: $status');
  }
  return status.isGranted;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Praktikum - Kamera & Notifikasi',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Menyimpan file foto yang sedang ditampilkan (hasil kamera/galeri)
  File? _selectedImage;

  // Instance ImagePicker, dipakai untuk membuka kamera & galeri
  final ImagePicker _picker = ImagePicker();

  // ----------------------------------------------------------
  // FUNGSI: Mengambil foto langsung dari kamera
  // ----------------------------------------------------------
  Future<void> _ambilFotoDariKamera() async {
    // Minta izin kamera dulu (penting untuk Android 13+ dan iOS)
    final cameraStatus = await Permission.camera.request();

    if (!cameraStatus.isGranted) {
      _tampilkanSnackbar('Izin kamera ditolak');
      return;
    }

    final notificationGranted = await _requestNotificationPermission();
    if (!notificationGranted) {
      _tampilkanSnackbar(
        'Izin notifikasi ditolak; notifikasi tidak akan ditampilkan.',
      );
    }

    try {
      // ImageSource.camera -> membuka aplikasi kamera HP langsung
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // kompresi supaya file tidak terlalu besar
      );

      if (foto != null) {
        setState(() {
          _selectedImage = File(foto.path);
        });

        // Setelah foto berhasil diambil -> tampilkan notifikasi
        await _tampilkanNotifikasi(
          judul: 'Foto Berhasil Diambil',
          isi: 'Foto dari kamera telah berhasil disimpan.',
        );
      }
    } catch (e) {
      _tampilkanSnackbar('Gagal mengambil foto: $e');
    }
  }

  // ----------------------------------------------------------
  // FUNGSI: Memilih foto dari galeri
  // ----------------------------------------------------------
  Future<void> _pilihFotoDariGaleri() async {
    try {
      // ImageSource.gallery -> membuka galeri/file foto di HP
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (foto != null) {
        setState(() {
          _selectedImage = File(foto.path);
        });

        // Setelah foto berhasil dipilih -> tampilkan notifikasi
        await _tampilkanNotifikasi(
          judul: 'Foto Berhasil Dipilih',
          isi: 'Foto dari galeri telah berhasil dipilih.',
        );
      }
    } catch (e) {
      _tampilkanSnackbar('Gagal memilih foto: $e');
    }
  }

  // ----------------------------------------------------------
  // FUNGSI: Menampilkan notifikasi lokal
  // ----------------------------------------------------------
  Future<void> _tampilkanNotifikasi({
    required String judul,
    required String isi,
  }) async {
    // Detail konfigurasi notifikasi khusus Android
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_foto', // id channel (harus unik per kategori notifikasi)
          'Notifikasi Foto', // nama channel yang terlihat di setting HP
          channelDescription: 'Notifikasi setelah foto diambil/dipilih',
          importance: Importance.high,
          priority: Priority.high,
        );

    // Detail konfigurasi notifikasi khusus iOS
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notifDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // show() -> menampilkan notifikasi
    // id 0 dipakai supaya notifikasi baru akan menimpa/replace yang lama
    await notificationsPlugin.show(
      id: 0,
      title: judul,
      body: isi,
      notificationDetails: notifDetails,
    );
  }

  void _tampilkanSnackbar(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambil Foto & Notifikasi'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ----------------------------------------------
              // AREA PREVIEW FOTO
              // ----------------------------------------------
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: _selectedImage == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Belum ada foto dipilih',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // ----------------------------------------------
              // TOMBOL AKSI (Kamera & Galeri)
              // ----------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _ambilFotoDariKamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Kamera'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pilihFotoDariGaleri,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galeri'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.indigo[400],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
