class Review {
  final int id;
  final int idProducto;
  final double rating;
  final String comentario;
  final String fecha;
  final String nombreRevisor;
  final String emailRevisor;

  Review({
    required this.id,
    required this.idProducto,
    required this.rating,
    required this.comentario,
    required this.fecha,
    required this.nombreRevisor,
    required this.emailRevisor,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return Review(
      id: parseInt(json['id']),
      idProducto: parseInt(json['producto_id'] ?? json['id_producto']),
      rating: parseDouble(json['rating']),
      comentario: json['comentario'] ?? '',
      fecha: json['fecha'] ?? '',
      nombreRevisor: json['nombre_revisor'] ?? '',
      emailRevisor: json['email_revisor'] ?? '',
    );
  }
}

class Product {
  final int id;
  final String titulo;
  final String descripcion;
  final List<String> images;
  final double rating;
  final double precio;
  final String thumbnail;
  final int categoriaId;
  final double descuento;
  final int stock;
  final String marca;
  final String sku;
  final double peso;
  final String garantia;
  final String envio;
  final String estadoDisponibilidad;
  final String politicaDevolucion;
  final int cantidadMinima;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.images,
    required this.rating,
    required this.precio,
    required this.thumbnail,
    required this.categoriaId,
    required this.descuento,
    required this.stock,
    required this.marca,
    required this.sku,
    required this.peso,
    required this.garantia,
    required this.envio,
    required this.estadoDisponibilidad,
    required this.politicaDevolucion,
    required this.cantidadMinima,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> imagesList = [];
    if (json['images'] != null) {
      imagesList = List<String>.from(json['images']);
    }

    List<Review> reviewsList = [];
    if (json['reviews'] != null) {
      reviewsList = List<Map<String, dynamic>>.from(json['reviews'])
          .map((r) => Review.fromJson(r))
          .toList();
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return Product(
      id: parseInt(json['id']),
      titulo: json['titulo'] ?? json['title'] ?? '',
      descripcion: json['descripcion'] ?? json['description'] ?? '',
      images: imagesList,
      rating: parseDouble(json['rating']),
      precio: parseDouble(json['precio']),
      thumbnail: json['thumbnail'] ?? '',
      categoriaId: parseInt(json['categoria_id']),
      descuento: parseDouble(json['descuento']),
      stock: parseInt(json['stock']),
      marca: json['marca'] ?? '',
      sku: json['sku'] ?? '',
      peso: parseDouble(json['peso']),
      garantia: json['garantia'] ?? '',
      envio: json['envio'] ?? '',
      estadoDisponibilidad: json['estado_disponibilidad'] ?? '',
      politicaDevolucion: json['politica_devolucion'] ?? '',
      cantidadMinima: parseInt(json['cantidad_minima']),
      reviews: reviewsList,
    );
  }
}