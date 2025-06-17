import 'package:ai_shopper_online/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa firebase_core
import 'firebase_options.dart'; // Importa firebase_options.dart// Asegura la importación correcta de DefaultFirebaseOptions
import 'routes.dart';
import 'theme.dart';

void main() async {
  // Agrega async
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que Flutter esté inicializado
  await Firebase.initializeApp(
    // Inicializa Firebase
    options:
        DefaultFirebaseOptions
            .currentPlatform, // Usa las opciones específicas de la plataforma
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Shopper',
      theme: AppTheme.lightTheme(context),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
