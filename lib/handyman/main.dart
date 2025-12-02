import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/requests_page.dart';
import 'pages/profile_page.dart';
import 'handyman_bloc.dart';
import 'repositories/firestore_repository.dart';
import 'repositories/handyman_repository.dart';

void main() {
  runApp(const MyApp());
}

/// Root app for the Handyman module (UI-only demo)
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late HandymanBloc bloc;
  late HandymanRepository _repo;
  bool _usingFirestore = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // start with in-memory repo so UI can show immediately
    _repo = InMemoryHandymanRepository();
    bloc = HandymanBloc(repository: _repo);
    bloc.initializeSampleData();

    // try to initialize Firebase and switch to Firestore repository when available
    _initFirebase();
  }

  void _initFirebase() async {
    try {
      await Firebase.initializeApp();
      final fsRepo = FirestoreHandymanRepository();
      // switch to Firestore-backed repo
      final old = bloc;
      setState(() {
        _repo = fsRepo;
        bloc = HandymanBloc(repository: _repo);
        _usingFirestore = true;
      });
      // cleanup old
      old.dispose();
    } catch (e) {
      // ignore - keep in-memory repo
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Handyman Module',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      ),
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            RequestsPage(bloc: bloc),
            ProfilePage(bloc: bloc),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[600],
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.note_alt_outlined),
              label: 'Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
