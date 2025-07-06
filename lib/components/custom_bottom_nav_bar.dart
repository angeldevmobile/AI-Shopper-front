import 'package:ai_shopper_online/screens/chat_user/chat_user_shop/chat_user_screen.dart';
import 'package:ai_shopper_online/screens/favorite/favorite_screen.dart';
import 'package:ai_shopper_online/screens/home/home_screen.dart';
import 'package:ai_shopper_online/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
import '../enums.dart';

class CustomButtomNavBar extends StatelessWidget {
  const CustomButtomNavBar({super.key, required this.selectedMenu});

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = const Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/Shop Icon.svg",
                color:
                    MenuState.home == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
              ),
              onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName),
            ),
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/Heart Icon.svg",
                color:
                    MenuState.favourite == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
              ),
              onPressed: () => Navigator.pushNamed(context, FavoriteScreen.routeName),
            ),
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/Chat bubble Icon.svg",
                color:
                    MenuState.message == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
              ),
              onPressed: () => Navigator.pushNamed(context, ChatUserScreen.routeName),
            ),
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/User Icon.svg",
                color:
                    MenuState.profile == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
              ),
              onPressed: () => Navigator.pushNamed(context, ProfileScreen.routeName),
            ),
          ],
        ),
      ),
    );
  }
}