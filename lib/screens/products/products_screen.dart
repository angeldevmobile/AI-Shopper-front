import 'package:ai_shopper_online/components/product_card.dart';
import 'package:ai_shopper_online/models/Product.dart';
import 'package:flutter/material.dart';

import '../details/details_screen.dart';

class ProductsScreenArguments {
  final Future<List<Product>> Function() fetchProducts;
  final String title;

  ProductsScreenArguments({required this.fetchProducts, required this.title});
}

class ProductsScreen extends StatelessWidget {
  final Future<List<Product>> Function() fetchProducts;
  final String title;
  const ProductsScreen({super.key, required this.fetchProducts, required this.title});

  static String routeName = "/products";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<List<Product>>(
            future: fetchProducts(),
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
              return GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) => ProductCard(
                  product: products[index],
                    onPress: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(
                          product: products[index],
                        ),
                      ),
                    ),

                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
