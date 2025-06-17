import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_shopper_online/services/auth_service.dart';
import '../../../services/api_service.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../otp/otp_screen.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({Key? key}) : super(key: key);

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final correo = args?['correo'] ?? '';
    final contrasena = args?['contrasena'] ?? '';

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) removeError(error: kNamelNullError);
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Nombre",
              hintText: "Ingresa tu nombre",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onSaved: (newValue) => lastName = newValue,
            decoration: const InputDecoration(
              labelText: "Apellido",
              hintText: "Ingresa tu apellido",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => phoneNumber = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) removeError(error: kPhoneNumberNullError);
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Número de Teléfono",
              hintText: "Ingresa tu número de teléfono",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) removeError(error: kAddressNullError);
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kAddressNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Dirección",
              hintText: "Ingresa tu dirección",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(
                svgIcon: "assets/icons/Location point.svg",
              ),
            ),
          ),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                print('Correo (CompleteProfileForm): $correo');
                print('Contraseña (CompleteProfileForm): $contrasena');
                print('Nombre: $firstName');
                print('Apellido: $lastName');
                print('Teléfono: $phoneNumber');
                print('Dirección: $address');

                try {
                  print("Llamando a AuthService.registerUser...");
                  final authService = AuthService();
                  final userCredential = await authService.registerUser(
                    correo!,
                    contrasena!,
                  );

                  if (userCredential != null && userCredential.user != null) {
                    print(
                      "Usuario de Firebase creado con éxito: ${userCredential.user!.uid}",
                    );

                    print("Llamando a ApiService.registrarUsuarioCompleto...");
                    bool exito = await ApiService.registrarUsuarioCompleto(
                      correo: correo,
                      contrasena: contrasena,
                      nombres: firstName ?? '',
                      apellidos: lastName ?? '',
                      direccion: address ?? '',
                      telefono: phoneNumber ?? '',
                      rolId: 1, // Ajusta el rol según corresponda
                    );

                    if (exito) {
                      print('Registro exitoso');
                      Navigator.pushNamed(context, OtpScreen.routeName);
                    } else {
                      print('Error al registrar usuario');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al registrar usuario'),
                        ),
                      );
                    }
                  } else {
                    print('Error al registrar usuario en Firebase');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al registrar usuario en Firebase'),
                      ),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  print('FirebaseAuthException: ${e.code}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.message}')),
                  );
                } catch (e) {
                  print('Error de conexión: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error de conexión')),
                  );
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
