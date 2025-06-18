import 'package:ai_shopper_online/screens/otp/otp_screen.dart';
import 'package:ai_shopper_online/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:ai_shopper_online/services/auth_service.dart';
import '../../components/socal_card.dart';
import '../../constants.dart';
import 'components/sign_up_form.dart';
import '../complete_profile/complete_profile_screen.dart'; // Import CompleteProfileScreen

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
                            final success =
                                await ApiService.registrarUsuarioCompleto(
                                  correo: googleData['email']!,
                                  contrasena:
                                      'google_auth', // Marca temporal para Google
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
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Error al registrar con Google',
                                  ),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al registrar con Google'),
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
