import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/Product.dart';

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
        'http://192.168.56.1:3000/usuarios/completar-perfil',
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
    final url = Uri.parse('http://192.168.56.1:3000/usuarios/verify-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo, 'otp': otp}),
    );
    return response.statusCode == 200;
  }

  static Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(
      Uri.parse('http://192.168.56.1:3000/productos'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }
}

class ProductService {
  static Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(
      Uri.parse('http://192.168.56.1:3000/productos'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  static Future<List<Product>> fetchPopularProducts() async {
    final response = await http.get(
      Uri.parse('http://192.168.56.1:3000/productos/popular'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos populares');
    }
  }

  static Future<List<Product>> fetchFiveProducts() async {
    final response = await http.get(
      Uri.parse('http://192.168.56.1:3000/productos/cinco'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar 5 productos');
    }
  }

  static Future<List<Product>> fetchMostDiscountedProducts() async {
    final response = await http.get(
      Uri.parse('http://192.168.56.1:3000/productos/descuento'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos con más descuento');
    }
  }

  static Future<List<String>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('http://192.168.56.1:3000/productos/categorias'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e['nombre'] as String).toList();
    } else {
      throw Exception('Error al cargar categorías');
    }
  }

  static Future<List<Product>> fetchProductsByCategories(
    List<String> categories,
  ) async {
    final response = await http.post(
      Uri.parse('http://192.168.56.1:3000/productos/por-categorias'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'categorias': categories}),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos por categorías');
    }
  }

  static Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse('http://192.168.56.1:3000/productos/buscar?q=$query'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al buscar productos');
    }
  }
}