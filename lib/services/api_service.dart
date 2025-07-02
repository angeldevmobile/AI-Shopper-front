import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<bool> registrarUsuarioCompleto({
    required String correo,
    required String contrasena,
    required String nombres,
    required String apellidos,
    required String direccion,
    required String telefono,
    required int rolId,
  }) async {
    try {
      final url = Uri.parse(
        'http://192.168.0.109:3000/usuarios/completar-perfil',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': correo,
          'contrasena': contrasena,
          'nombres': nombres,
          'apellidos': apellidos,
          'direccion': direccion,
          'telefono': telefono,
          'rol_id': rolId,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during API call: $e');
      return false;
    }
  }

  static Future<bool> verifyOTP({
    required String correo,
    required String otp,
  }) async {
    final url = Uri.parse('http://192.168.0.109:3000/usuarios/verify-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo, 'otp': otp}),
    );
    return response.statusCode == 200;
  }
}
