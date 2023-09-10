import 'package:flutter/material.dart';
import 'package:kiranjaapp_driver/provider/auth_provider.dart';
import 'package:kiranjaapp_driver/screens/home_screen.dart';
import 'package:kiranjaapp_driver/screens/login_screen.dart';
import 'package:kiranjaapp_driver/screens/register_screen.dart';
import 'package:kiranjaapp_driver/screens/reset_password_screen.dart';
import 'package:kiranjaapp_driver/screens/splash_screen.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetFlutterBinding.ensureInitialized();
  await Firebase.initilizeApp();
  runApp(MultiProvider(
    providers: [
      provider (create: (_) => AuthProvider()),
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
        SplashScreen.id:(context) => const SplashScreen(), 
        LoginScreen.id:(context) => const LoginScreen(), 
        HomeScreen.id:(context) => const HomeScreen(),
        ResetPasswordScreen.id:(context) => const ResetPasswordScreen(), 
        RegisterScreen.id:(context) => const RegisterScreen()
      },
    );
  }
}
