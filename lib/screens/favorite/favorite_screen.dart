import 'package:ai_shopper_online/components/product_card.dart';
import 'package:ai_shopper_online/models/Product.dart';
import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../details/details_screen.dart';

class FavoriteScreen extends StatelessWidget {

  static String routeName = "/favorite";
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text("Favoritos", style: Theme.of(context).textTheme.titleLarge),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<List<Product>>(
                future: ProductService.fetchAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return const Center(child: Text('No hay productos'));
                  }
                  // Solo muestra 6 productos random como favoritos
                  products.shuffle();
                  final favorites = products.take(6).toList();
                  return GridView.builder(
                    itemCount: favorites.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 16,
                        ),
                    itemBuilder:
                        (context, index) => ProductCard(
                          product: favorites[index],
                          onPress:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => DetailsScreen(
                                        product: favorites[index],
                                      ),
                                ),
                              ),
                        ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
