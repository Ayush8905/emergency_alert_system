import 'package:alert_system/Screen/Splash_Screen/splash_screen.dart';
import 'package:alert_system/Screen/map_screen/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:alert_system/Screen/auth_screen/login_screen/login_screen.dart';
import 'package:alert_system/Screen/auth_screen/register_screen/register_page.dart';
import 'package:alert_system/firebase_options.dart';
import 'package:alert_system/Screen/map_screen/map_screen.dart';
import 'Screen/home_screen/home_page.dart';

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
        '/mapscreen':(context)=> const MapScreen(),
      },
    );
  }
}





