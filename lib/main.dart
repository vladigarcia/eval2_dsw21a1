import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eval2_dsw21a1/pages/Crear__dato.dart';
import 'package:eval2_dsw21a1/pages/scrum.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'base de datos',
      initialRoute: '/',
      routes: {
        '/Crear': (context) => const nuevodatos()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sistema datos aval2'),
    );
  }
}




