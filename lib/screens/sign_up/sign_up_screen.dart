import 'package:ai_shopper_online/screens/otp/otp_screen.dart';
import 'package:ai_shopper_online/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:ai_shopper_online/services/auth_service.dart';
import '../../components/socal_card.dart';
import '../../constants.dart';
import 'components/sign_up_form.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
//import '../complete_profile/complete_profile_screen.dart'; // Import CompleteProfileScreen

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text("Registrar Cuenta", style: headingStyle),
                  const Text(
                    "Completa tus detalles o continua \ncon social media",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const SignUpForm(), // Este formulario es para el registro completo
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: "assets/icons/google-icon.svg",
                        press: () async {
                          final authService = AuthService(context: context);
                          final googleData =
                              await authService.signInWithGoogle();

                          if (googleData != null) {
                            print('Usuario de Google: ${googleData['email']}');

                            final idToken =
                                await FirebaseAuth.instance.currentUser!
                                    .getIdToken();
                            final url = Uri.parse(
                              'http://192.168.0.100:3000/usuarios/google-login',
                            );

                            final response = await http.post(
                              url,
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({'idToken': idToken}),
                            );

                            print('Status code: ${response.statusCode}');
                            print('Body: ${response.body}');
                            final data = jsonDecode(response.body);

                            if (response.statusCode == 200 &&
                                data['success'] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Inicio de sesión exitoso.'),
                                ),
                              );
                              Navigator.pushReplacementNamed(
                                context,
                                '/sign_in',
                              );
                            } else if (response.statusCode == 401 &&
                                data['message'] ==
                                    'Usuario no encontrado en la base de datos') {
                              final success =
                                  await ApiService.registrarUsuarioCompleto(
                                    correo: googleData['email']!,
                                    contrasena: 'google_auth',
                                    nombres: googleData['name']!,
                                    apellidos: '',
                                    direccion: '',
                                    telefono: '',
                                    rolId: 1,
                                  );

                              if (success) {
                                Navigator.pushNamed(
                                  context,
                                  OtpScreen.routeName,
                                  arguments: {'correo': googleData['email']},
                                );
                              }
                            } else if (response.statusCode == 403 ||
                                (data['message']?.contains('no verificado') ??
                                    false)) {
                              Navigator.pushNamed(
                                context,
                                OtpScreen.routeName,
                                arguments: {'correo': googleData['email']},
                              );
                            } else if (response.statusCode == 201 &&
                                data['success'] == true) {
                              Navigator.pushNamed(
                                context,
                                OtpScreen.routeName,
                                arguments: {'correo': googleData['email']},
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    data['message'] ??
                                        'Error al autenticar con Google.',
                                  ),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al autenticar con Google'),
                              ),
                            );
                          }
                        },
                      ),
                      SocalCard(
                        icon: "assets/icons/facebook-2.svg",
                        press: () {},
                      ),
                      SocalCard(icon: "assets/icons/twitter.svg", press: () {}),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Al continuar, confirmas que estás de acuerdo \ncon nuestros Términos y Condiciones',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
