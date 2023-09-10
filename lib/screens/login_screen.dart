import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kiranjaapp_driver/screens/register_screen.dart';
import 'package:kiranjaapp_driver/services/firebase_services.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../widgets/reset_password.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String id = "login-screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  Icon icon = const Icon(Icons.email_outlined);
  // initializing with an icon
  bool _visible = false;
  final _emailTextControler = TextEditingController();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/logo.png",
                              height: 80,
                            ),
                            const FittedBox(
                              child: Text(
                                "DELIVERY APP - LOGIN",
                                style: TextStyle(
                                    fontFamily: "",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailTextControler,
                        validator: (value) {
                          final emailText = _emailTextControler.text;
                          if (value == null || value.isEmpty) {
                            return "Enter Email";
                          }
                          final bool _isValid =
                              EmailValidator.validate(emailText);
                          if (!_isValid) {
                            return "Invalid Email format";
                          }
                          setState(() {
                            email = emailText;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: "Email",
                            prefixIcon: const Icon(Icons.email_outlined),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2)),
                            focusColor: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          }
                          if (value.length < 6) {
                            return "Minimum 6 characters";
                          }
                          setState(() {
                            password = value;
                          });
                          return null;
                        },
                        obscureText: _visible == false ? true : false,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _visible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _visible = !_visible;
                                });
                              },
                            ),
                            enabledBorder: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.vpn_key_outlined),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2)),
                            focusColor: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, ResetPassword.id);
                              },
                              child: const Text(
                                'Forgot Password?',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    EasyLoading.show(status: "Please wait ...");
                                    _services.validateUser(email).then((value) {
                                      if (value.exists) {
                                        final data = value.data()
                                            as Map<String, dynamic>?;

                                        if (data != null &&
                                            data["password"] != null) {
                                          final storedPassword =
                                              data["password"] as String;
                                          if (storedPassword == password) {
                                            _authData
                                                .loginBoys(email, password)
                                                .then((credential) {
                                              if (credential != null) {
                                                EasyLoading.showSuccess(
                                                        "Logged in Successfully")
                                                    .then((value) {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          HomeScreen.id);
                                                });
                                              } else {
                                                EasyLoading.showInfo(
                                                        "Need to complete Registration")
                                                    .then((value) {
                                                  _authData.getEmail(email);
                                                  Navigator.pushNamed(context,
                                                      RegisterScreen.id);
                                                });
                                                /*ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          _authData.error)));*/
                                              }
                                            });
                                          } else {
                                            EasyLoading.showError(
                                                "Invalid Password");
                                          }
                                        } else {
                                          EasyLoading.showError(
                                              "$email is not registered as our delivery driver");
                                        }
                                      }
                                    });
                                  }
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
