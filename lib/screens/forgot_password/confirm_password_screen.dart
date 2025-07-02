import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  final String email;
  const ConfirmPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ConfirmPasswordScreen> createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String? otp;
  String? nuevaContrasena;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "OTP"),
                onSaved: (value) => otp = value,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter the OTP" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "New Password"),
                obscureText: true,
                onSaved: (value) => nuevaContrasena = value,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter new password" : null,
              ),
              const SizedBox(height: 16),
              if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    bool success = await AuthService.resetearContrasena(
                      widget.email,
                      otp!,
                      nuevaContrasena!,
                    );
                    if (success) {
                      Navigator.pop(context); // O navega a login/success
                    } else {
                      setState(() {
                        errorMessage = "OTP or password invalid";
                      });
                    }
                  }
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}