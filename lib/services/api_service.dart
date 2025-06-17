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
    final url = Uri.parse(
      'http://192.168.0.100:3000/usuarios/completar-perfil',
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

    return response.statusCode == 201;
  }
}
