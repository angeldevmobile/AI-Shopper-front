import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart'; // Importa material.dart para el diálogo

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  BuildContext? context;

  AuthService({this.context});

  // Registrar usuario con correo y contraseña
  Future<UserCredential?> registerUser(String email, String password) async {
    try {
      print(
        "Se llamó al método registerUser con correo electrónico: $email, contraseña: $password",
      );
      print("Intentando crear usuario en Firebase...");
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("createUserWithEmailAndPassword completado");
      print("Credencial: $credential");

      return credential;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException al registrar usuario: ${e.code}');
      if (e.code == 'email-already-in-use') {
        print('El correo electrónico ya está en uso');
      }
      return null;
    } catch (e) {
      print('Error general al registrar usuario: $e');
      return null;
    }
  }

  // Iniciar sesión con Google
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        return {
          'email': user.email,
          'name': user.displayName ?? user.email!.split('@')[0],
          'uid': user.uid,
        };
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print("Error al registrar con Google: ${e.code}");
      return null;
    } catch (e) {
      print("Error general al registrar con Google: $e");
      return null;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse('http://192.168.0.109:3000/usuarios/login'); // <-- Cambia aquí a "usuarios"
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': email, 'contrasena': password}),
      );
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return true;
        }
        print('Mensaje backend: ${data['message']}');
        return false;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static Future<bool> solicitarRecuperacion(String correo) async {
    final url = Uri.parse('http://192.168.0.109:3000/usuarios/forgot-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo}),
    );
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
    return response.statusCode == 200;
  }

  static Future<bool> resetearContrasena(String correo, String otp, String nuevaContrasena) async {
    try {
      final url = Uri.parse('http://192.168.0.109:3000/usuarios/resetear-contrasena'); // <-- Cambia aquí a "resetear-contrasena"
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': correo, 'otp': otp, 'nuevaContrasena': nuevaContrasena}),
      );
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return true;
        }
        print('Mensaje backend: ${data['message']}');
        return false;
      }
      return false;
    } catch (e) {
      print('Error al resetear contraseña: $e');
      return false;
    }
  }
}
