
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirebaseTestPage(),
    );
  }
}

class FirebaseTestPage extends StatefulWidget {
  const FirebaseTestPage({super.key});

  @override
  State<FirebaseTestPage> createState() => _FirebaseTestPageState();
}

class _FirebaseTestPageState extends State<FirebaseTestPage> {
  String _status = 'Waiting to test...';

  Future<void> _writeTestData() async {
    try {
      final ref = FirebaseDatabase.instance.ref('capstone_test');
      await ref.set({
        'project': 'capstone_logera',
        'status': 'Connected!',
        'timestamp': ServerValue.timestamp,
      });

      final snapshot = await ref.get();
      setState(() {
        _status = 'Success! Saved: ${snapshot.value}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capstone Logera - Firebase Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _writeTestData,
              child: const Text('Send Test Data to Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}