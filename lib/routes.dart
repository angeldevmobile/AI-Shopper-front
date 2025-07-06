import 'package:ai_shopper_online/screens/products/products_screen.dart';
import 'package:flutter/widgets.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/chat_user/chat_user_shop/chat_user_screen.dart';
import 'screens/complete_profile/complete_profile_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/init_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'screens/otp/otp_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/favorite/favorite_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  ProductsScreen.routeName: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProductsScreenArguments;
    return ProductsScreen(fetchProducts: args.fetchProducts, title: args.title);
  },
  FavoriteScreen.routeName: (context) => const FavoriteScreen(),
  ChatUserScreen.routeName: (context) => const ChatUserScreen(),
};
