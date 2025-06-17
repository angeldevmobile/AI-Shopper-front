import 'package:flutter/material.dart';
import 'components/complete_profile_form.dart';
import '../../constants.dart'; // Importa las constantes

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  const Text("Completar Perfil", style: headingStyle),
                  const Text(
                    "Completa tus detalles o continua\ncon social media",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const CompleteProfileForm(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text(
                    "Al continuar, confirmas que estás de acuerdo\ncon nuestros Términos y Condiciones",
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
