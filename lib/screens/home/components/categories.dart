import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../services/api_service.dart';
import '../../products/products_screen.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  String getCategoryIcon(String category) {
    switch (category) {
      case "beauty":
        return "assets/icons/Star Icon.svg";
      case "fragrances":
        return "assets/icons/Flash Icon.svg";
      case "furniture":
        return "assets/icons/furniture_view.svg";
      case "groceries":
        return "assets/icons/Gift Icon.svg";
      case "home-decoration":
        return "assets/icons/decoration.svg";
      case "kitchen-accessories":
        return "assets/icons/Shop Icon.svg";
      case "laptops":
        return "assets/icons/Bill Icon.svg";
      case "mens-shirts":
        return "assets/icons/Call.svg";
      case "mens-shoes":
        return "assets/icons/Camera Icon.svg";
      case "mens-watches":
        return "assets/icons/Bill Icon.svg";
      case "mobile-accessories":
        return "assets/icons/Cart Icon.svg";
      case "motorcycle":
        return "assets/icons/Cash.svg";
      case "skin-care":
        return "assets/icons/Conversation.svg";
      case "smartphones":
        return "assets/icons/Smartphone.svg";
      case "sports-accessories":
        return "assets/icons/Game Icon.svg";
      case "sunglasses":
        return "assets/icons/Heart Icon.svg";
      case "tablets":
        return "assets/icons/Mail.svg";
      case "tops":
        return "assets/icons/Phone.svg";
      case "vehicle":
        return "assets/icons/Question mark.svg";
      case "womens-bags":
        return "assets/icons/receipt.svg";
      case "womens-dresses":
        return "assets/icons/Shop Icon.svg";
      case "womens-jewellery":
        return "assets/icons/Success.svg";
      case "womens-shoes":
        return "assets/icons/Trash.svg";
      case "womens-watches":
        return "assets/icons/User Icon.svg";
      default:
        return "assets/icons/Discover.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: ProductService.fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar categorías'));
        }
        final categories = snapshot.data ?? [];
        final visibleCategories =
            categories.length > 7 ? categories.sublist(0, 7) : categories;
        final hiddenCategories =
            categories.length > 7 ? categories.sublist(7) : [];

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ), // Menos espacio arriba
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (hiddenCategories.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder:
                              (context) => ListView(
                                children: [
                                  ...categories.map(
                                    (cat) => ListTile(
                                      leading: SvgPicture.asset(
                                        getCategoryIcon(cat),
                                        width: 32,
                                        height: 32,
                                      ),
                                      title: Text(cat),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => ProductsScreen(
                                                  fetchProducts:
                                                      () =>
                                                          ProductService.fetchProductsByCategories(
                                                            [cat],
                                                          ),
                                                  title: cat,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFECDF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/menu.svg",
                          width: 32,
                          height: 32,
                          color: const Color(
                            0xFF222B45,
                          ), // Cambia el color aquí
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Lista horizontal de categorías (solo 7, sin botón "Más")
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(
                      visibleCategories.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: CategoryCard(
                          icon: getCategoryIcon(visibleCategories[index]),
                          text: visibleCategories[index],
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ProductsScreen(
                                      fetchProducts:
                                          () =>
                                              ProductService.fetchProductsByCategories(
                                                [visibleCategories[index]],
                                              ),
                                      title: visibleCategories[index],
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.icon,
    required this.text,
    required this.press,
  });

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFECDF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(icon),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 70,
            height: 32, // Altura fija para alinear todos los íconos
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
