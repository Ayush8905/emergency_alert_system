import 'package:alert_system/UI/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:alert_system/UI/auth/login_screen.dart';
import 'package:alert_system/UI/register_page.dart';
import 'package:alert_system/firebase_options.dart';
import 'UI/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      debugShowCheckedModeBanner: false, // Disable the debug banner
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white, // Sets the background color for Scaffold
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple, // Sets the AppBar color
          foregroundColor: Colors.white, // Sets the text/icon color in AppBar
        ),
      ),
      initialRoute: '/', // Set the initial route to login page
      routes: {
        '/': (context) => const SplashScreen(),
        '/register': (context) => const RegisterPage(),
        '/login':(context)=>const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
