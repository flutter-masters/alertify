import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'ui/screens/auth/auth_screen.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/search/search_screen.dart';
import 'ui/screens/sign_in/sign_in_screen.dart';
import 'ui/screens/sign_up/sign_up_screen.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'ui/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        routes: {
          SplashScreen.route: (_) => const SplashScreen(),
          AuthScreen.route: (_) => const AuthScreen(),
          SignInScreen.route: (_) => const SignInScreen(),
          SignUpScreen.route: (_) => const SignUpScreen(),
          HomeScreen.route: (_) => const HomeScreen(),
          SearchScreen.route: (_) => const SearchScreen(),
        },
      ),
    );
  }
}
