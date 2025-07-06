import 'package:flutter/material.dart';

import '../../../components/rounded_icon_btn.dart';
import '../../../constants.dart';
import '../../../models/Product.dart';

class ColorDots extends StatelessWidget {
  const ColorDots({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    // Si tu modelo Product no tiene colores, muestra solo los botones de cantidad
    // Puedes agregar un campo colors a Product si lo necesitas en el futuro
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Si tienes colores, descomenta y usa esto:
          // ...List.generate(
          //   product.colors.length,
          //   (index) => ColorDot(
          //     color: product.colors[index],
          //     isSelected: index == selectedColor,
          //   ),
          // ),
          const Spacer(),
          RoundedIconBtn(icon: Icons.remove, press: () {}),
          const SizedBox(width: 20),
          RoundedIconBtn(icon: Icons.add, showShadow: true, press: () {}),
        ],
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  const ColorDot({super.key, required this.color, this.isSelected = false});

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 2),
      padding: const EdgeInsets.all(8),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: isSelected ? kPrimaryColor : Colors.transparent,
        ),
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}