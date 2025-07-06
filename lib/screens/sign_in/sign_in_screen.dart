import 'package:flutter/material.dart';
import 'package:ai_shopper_online/services/auth_service.dart'; // Asegúrate de importar tu AuthService
import '../../components/no_account_text.dart';
import '../../components/socal_card.dart';
import 'components/sign_form.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar Sesión")),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Bienvenido de nuevo",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Inicia sesión con tu correo y contraseña\no continúa con redes sociales",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  const SignForm(),
                  const SizedBox(height: 30),
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
                            // Enviar ID token al backend para verificar
                            final idToken = await authService.getIdToken();
                            final url = Uri.parse(
                              'http://192.168.56.1:3000/usuarios/google-login',
                            );
                            final response = await http.post(
                              url,
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({'idToken': idToken}),
                            );

                            if (response.statusCode == 200) {
                              final data = jsonDecode(response.body);
                              if (data['success'] == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Inicio de sesión con Google exitoso!',
                                    ),
                                  ),
                                );
                                // Navega a la pantalla principal
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                ); // Ajusta la ruta
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${data['message']}'),
                                  ), // Sin const
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error en la conexión con el servidor.',
                                  ),
                                ), // Sin const
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Fallo al autenticar con Google.',
                                ),
                              ), // Sin const
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
                  const SizedBox(height: 20),
                  const NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
