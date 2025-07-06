import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/otp_form.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";

  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final correo = args?['correo'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Verificación de OTP")),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text("Verificación de OTP", style: headingStyle),
                Text("Envio de codigo OTP a $correo"), // Mostrar el correo real
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "El código expirará en: ",
                      style: TextStyle(color: kPrimaryColor),
                    ),
                    TweenAnimationBuilder(
                      tween: Tween(
                        begin: 300.0,
                        end: 0.0,
                      ), // 5 minutes = 300 seconds
                      duration: const Duration(seconds: 300),
                      builder:
                          (_, dynamic value, child) => Text(
                            "00:${(value / 60).floor()}:${(value % 60).toInt().toString().padLeft(2, '0')}",
                            style: const TextStyle(color: kPrimaryColor),
                          ),
                    ),
                  ],
                ),
                OtpForm(correo: correo), // Pasar solo el correo
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // TODO: Implementar reenvío de OTP
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Funcionalidad de reenvío no implementada',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Reenviar OTP",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
