import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../services/api_service.dart'; // Import ApiService
import 'package:ai_shopper_online/screens/sign_in/sign_in_screen.dart'; // Import SignInScreen

class OtpForm extends StatefulWidget {
  final String correo; // Solo correo como parámetro

  const OtpForm({super.key, required this.correo});

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  String? otp;

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 60,
                child: TextFormField(
                  autofocus: true,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode);
                    if (value.length == 1) {
                      otp = value;
                    }
                  },
                  maxLength: 1,
                ),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin3FocusNode);
                    if (value.length == 1) {
                      otp = (otp ?? '') + value;
                    }
                  },
                  maxLength: 1,
                ),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin4FocusNode);
                    if (value.length == 1) {
                      otp = (otp ?? '') + value;
                    }
                  },
                  maxLength: 1,
                ),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin4FocusNode!.unfocus();
                      otp = (otp ?? '') + value;
                      print("OTP: $otp");
                      if (otp!.length == 4) {
                        FocusScope.of(context).unfocus();
                      }
                    }
                  },
                  maxLength: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          ElevatedButton(
            onPressed: () async {
              if (otp != null && otp!.length == 4) {
                final isVerified = await ApiService.verifyOTP(
                  correo: widget.correo,
                  otp: otp!,
                );

                if (isVerified) {
                  print('OTP Verificado con éxito');
                  Navigator.pushNamed(context, SignInScreen.routeName);
                } else {
                  print('OTP Inválido');
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('OTP Inválido')));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Por favor, ingresa un OTP válido de 4 dígitos',
                    ),
                  ),
                );
              }
            },
            child: const Text("Continuar"),
          ),
        ],
      ),
    );
  }
}
