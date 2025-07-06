import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import './confirm_password_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";

  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Olvidé mi contraseña")),
      body: const SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 16),
                Text(
                  "Olvidé mi contraseña",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Por favor, ingresa tu correo electrónico y te enviaremos\nun enlace para recuperar tu cuenta",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                ForgotPassForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? message;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "Correo"),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) {
              email = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Por favor, ingresa tu correo electrónico";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          if (message != null)
            Text(message!, style: TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                bool enviado = await AuthService.solicitarRecuperacion(email!);
                if (enviado) {
                  // Navegar a ConfirmPasswordScreen con el email
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ConfirmPasswordScreen(email: email!),
                    ),
                  );
                } else {
                  setState(() {
                    message = "No se pudo enviar el correo.";
                  });
                }
              }
            },
            child: const Text("Continuar"),
          ),
        ],
      ),
    );
  }
}
