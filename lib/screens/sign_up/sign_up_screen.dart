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
                  const SignUpForm(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: "assets/icons/google-icon.svg",
                        press: () async {
                          // Modifica la función press para que sea asíncrona
                          final authService = AuthService(context: context);
                          final userCredential =
                              await authService.signInWithGoogle();
                          if (userCredential != null) {
                            // Registro exitoso
                            print(
                              'Usuario de Google: ${userCredential.user?.displayName}',
                            );
                            // Navega a la siguiente pantalla para completar el perfil
                            Navigator.pushNamed(
                              context,
                              CompleteProfileScreen
                                  .routeName, // Navega a CompleteProfileScreen
                            );
                          } else {
                            // Error al registrar sesión
                            print('Error al registrar sesión con Google');
                            // Muestra un mensaje de error al usuario
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error al registrar sesión con Google',
                                ),
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
