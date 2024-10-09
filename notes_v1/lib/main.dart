import 'package:flutter/material.dart';
import 'package:notes_v1/home.dart';
import 'package:notes_v1/provider.dart';
import 'package:notes_v1/signin.dart';
import 'package:notes_v1/Notes.dart';
import 'package:notes_v1/Register.dart';
import 'package:notes_v1/search.dart';
import 'package:notes_v1/settings.dart';
import 'package:provider/provider.dart';
import 'package:notes_v1/editor.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CustomProvider())],
      child: const MainApp()
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Home(),
      routes: {
        "/signin": (context) => const SignIn(),
        "/register": (context) => const Register(),
        "/notes": (context) => const NotesHome(),
        "/search": (context) => const Search(),
        "/settings": (context) => const Settings(),
        "/editor": (context) => Editor(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}



// runApp(MultiProvider(
//     providers: [ChangeNotifierProvider(create: (_) => CustomProvider())],
//     child: const MyApp(),
//   ));
