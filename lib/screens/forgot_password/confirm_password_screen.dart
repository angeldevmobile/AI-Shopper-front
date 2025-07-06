import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../screens/login_success/login_success_screen.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  final String email;
  const ConfirmPasswordScreen({super.key, required this.email});

  @override
  State<ConfirmPasswordScreen> createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String? nuevaContrasena;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar Contraseña"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Confirmar Contraseña",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Por favor, ingresa tu nueva contraseña",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Nueva Contraseña",
                        hintText: "Ingresa tu contraseña",
                        suffixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      obscureText: true,
                      onSaved: (value) => nuevaContrasena = value,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Por favor, ingresa tu nueva contraseña"
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 24.0,
                        ), // Aumentado a 24.0
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(
                      height: 16,
                    ), // Espacio adicional antes del botón
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          bool success = await AuthService.login(
                            widget.email,
                            nuevaContrasena!,
                          );
                          if (success) {
                            Navigator.pushNamed(
                              context,
                              LoginSuccessScreen
                                  .routeName, // Navega a LoginSuccessScreen
                            );
                          } else {
                            setState(() {
                              errorMessage =
                                  "Contraseña incorrecta, por favor intenta de nuevo.";
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Continuar",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Navegar a la pantalla de registro (ajusta la ruta)
                  // Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  "¿No tienes una cuenta? Regístrate aquí",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
