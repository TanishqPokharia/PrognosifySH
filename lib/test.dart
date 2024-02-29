import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prognosify/firebase_options.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List _patientRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    // Initialize Firebase (Firestore)

    FirebaseFirestore.instance
        .collection('doctors')
        .doc('Ja0T7GXStYfFnWfjAPly')
        .snapshots()
        .listen((event) {
      // Option 1: Using null-conditional operator (recommended)
      setState(() {
        _patientRequests = event.data()?['patientRequests'];
      });

      // Option 2: Using null check (alternative)
      // if (event.data != null) {
      //   setState(() {
      //     _patientRequests = event.data?['patientRequests'] as String ?? "";
      //   });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Real-time Patient Requests'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Patient Requests:'),
              ..._patientRequests.map((e) {
                return Column(
                  children: [
                    Text(e['name']),
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}
