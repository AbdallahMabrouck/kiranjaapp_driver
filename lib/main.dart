import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kiranjaapp_driver/provider/auth_provider.dart';
import 'package:kiranjaapp_driver/screens/home_screen.dart';
import 'package:kiranjaapp_driver/screens/login_screen.dart';
import 'package:kiranjaapp_driver/screens/register_screen.dart';
import 'package:kiranjaapp_driver/screens/reset_password_screen.dart';
import 'package:kiranjaapp_driver/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => AuthProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kiranjaapp - Driver',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ResetPasswordScreen.id: (context) => const ResetPasswordScreen(),
        RegisterScreen.id: (context) => const RegisterScreen()
      },
    );
  }
}
