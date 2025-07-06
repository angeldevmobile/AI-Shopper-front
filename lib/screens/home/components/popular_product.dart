import 'package:flutter/material.dart';
import '../../../models/Product.dart';
import '../../../components/product_card.dart';
import '../../details/details_screen.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';
import '../../../services/api_service.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Productos Populares",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ProductsScreen(
                        fetchProducts: ProductService.fetchPopularProducts,
                        title: "Productos Populares",
                      ),
                ),
              );
            },
          ),
        ),
        FutureBuilder<List<Product>>(
          future: ProductService.fetchFiveProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final products = snapshot.data ?? [];
            if (products.isEmpty) {
              return const Center(child: Text('No hay productos populares'));
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...products.map(
                    (product) => Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ProductCard(
                        product: product,
                        onPress:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailsScreen(product: product),
                              ),
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
