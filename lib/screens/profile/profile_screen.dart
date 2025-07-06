import 'package:ai_shopper_online/components/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../enums.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mi Perfil")),
      body: const Body(),
      bottomNavigationBar: CustomButtomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
