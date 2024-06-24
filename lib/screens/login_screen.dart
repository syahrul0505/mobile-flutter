import 'package:ecommerce/model/user.dart';
import 'package:ecommerce/network/api.dart';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart'; // Ensure the correct import path
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isChecked = false;

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
      // Call your "Remember me" function here
      _rememberMeFunction(_isChecked);
    });
  }

  void _rememberMeFunction(bool isChecked) {
    // Implement your "Remember me" functionality here
    print("Remember me: $isChecked");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF164863),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF123456), Colors.black],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email,
                        color: Color.fromARGB(255, 68, 68, 68)),
                    hintText: 'Email / Username',
                    hintStyle: TextStyle(color: Color(0xFF575757)),
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock,
                        color: Color.fromARGB(255, 68, 68, 68)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF575757),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Color(0xFF575757)),
                    filled: true,
                    fillColor: const Color(0xFFD9D9D9),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: _toggleCheckbox,
                      checkColor: const Color(0xFF164863),
                      fillColor: MaterialStateProperty.all(Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            4.0), // Set the desired border radius here
                      ),
                    ),
                    const Text(
                      'Remember me',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: double.infinity, // Full width
                  child: ElevatedButton(
                    onPressed: () async {
                      final response =
                          await Network().getData('/api/tokoonline/user');

                      if (response.statusCode == 200) {
                        List jsonResponse = json.decode(response.body);
                        List<User> users = jsonResponse
                            .map((data) => User.fromJson(data))
                            .toList();

                        User user = users.firstWhere(
                          (element) =>
                              element.name == emailController.text &&
                              element.email == passwordController.text,
                          orElse: () =>
                              User(id: 0, name: '', email: '', password: ''),
                        );

                        print(user.id);

                        if (user.id != 0) {
                          // set the user to the shared preferences
                          // and navigate to the home screen
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          prefs.setInt('id', user.id);
                          prefs.setString('name', user.name);
                          prefs.setString('email', user.email);

                          Navigator.pushReplacementNamed(
                              context, AppRoutes.home);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content:
                                    const Text('Invalid email or password'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'API Error, please try again later'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0766AD),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Sign in'),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {},
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
