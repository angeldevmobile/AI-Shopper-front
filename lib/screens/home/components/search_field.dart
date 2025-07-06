import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../services/api_service.dart';
import '../../details/details_screen.dart';
import '../../../models/Product.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  List<Map<String, dynamic>> _results = [];

  void _onChanged(String value) async {
    if (value.isEmpty) {
      setState(() => _results = []);
      return;
    }
    try {
      final results = await ProductService.searchProducts(value);
      setState(() => _results = results);
    } catch (_) {
      setState(() => _results = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: TextFormField(
            onChanged: _onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: kSecondaryColor.withOpacity(0.1),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              border: searchOutlineInputBorder,
              focusedBorder: searchOutlineInputBorder,
              enabledBorder: searchOutlineInputBorder,
              hintText: "Search product",
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        if (_results.isNotEmpty)
          Container(
            color: Colors.white,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _results.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _results[index];
                return ListTile(
                  leading: item['imagen'] != null
                      ? Image.network(item['imagen'], width: 40, height: 40, fit: BoxFit.cover)
                      : null,
                  title: Text(item['titulo'] ?? ''),
                  subtitle: Row(
                    children: [
                      Text('\$${item['precio']}'),
                      const SizedBox(width: 12),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        (double.tryParse(item['rating'].toString())?.toStringAsFixed(1) ?? ''),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  onTap: () async {
                    // Busca el producto completo por ID
                    try {
                      final productList = await ProductService.fetchAllProducts();
                      final product = productList.firstWhere(
                        (p) => p.id == item['id'],
                        orElse: () => Product(
                          id: item['id'],
                          titulo: item['titulo'] ?? '',
                          descripcion: '',
                          images: [item['imagen'] ?? ''],
                          rating: double.tryParse(item['rating'].toString()) ?? 0.0,
                          precio: double.tryParse(item['precio'].toString()) ?? 0.0,
                          thumbnail: item['imagen'] ?? '',
                          categoriaId: 0,
                          descuento: 0.0,
                          stock: 0,
                          marca: '',
                          sku: '',
                          peso: 0.0,
                          garantia: '',
                          envio: '',
                          estadoDisponibilidad: '',
                          politicaDevolucion: '',
                          cantidadMinima: 1,
                          reviews: [],
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(product: product),
                        ),
                      );
                    } catch (_) {}
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);