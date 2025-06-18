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
}
