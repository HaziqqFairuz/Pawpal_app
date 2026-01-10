import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal_app/models/user.dart';
import 'package:pawpal_app/myconfig.dart';
import 'package:pawpal_app/view/home_screen.dart';
import 'package:pawpal_app/view/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool visible = true;
  bool isChecked = false;

  late double height, width;

  late User user;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    if (width > 400) width = 400;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        backgroundColor: Color.fromARGB(255, 11, 124, 68),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFFD3F5ED),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  // Logo
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Image.asset(
                      'assets/images/pawpal_logov2.jpg',
                      scale: 4.5,
                    ),
                  ),

                  SizedBox(height: 10),

                  // Email field
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Password field
                  TextField(
                    controller: passwordController,
                    obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            visible = !visible;
                          });
                        },
                        icon: Icon(
                          visible ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Remember Me Checkbox
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Row(
                      children: [
                        Text('Remember Me'),
                        Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            isChecked = value!;
                            setState(() {});
                            if (isChecked) {
                              if (emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                prefUpdate(isChecked);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Preferences Stored"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please fill your email and password",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                isChecked = false;
                                setState(() {});
                              }
                            } else {
                              prefUpdate(isChecked);
                              if (emailController.text.isEmpty &&
                                  passwordController.text.isEmpty) {
                                return;
                                // do nothing
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Preferences Removed"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              emailController.clear();
                              passwordController.clear();
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Sign In Button
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 11, 124, 68),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        loginuser();
                      },
                      child: Text('Sign In'),
                    ),
                  ),

                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ", // normal text
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Sign Up here.",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 11, 124, 68),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void prefUpdate(bool isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
      prefs.setBool('rememberMe', isChecked);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }

  void loadPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        emailController.text = email ?? '';
        passwordController.text = password ?? '';
        isChecked = true;
        setState(() {});
      }
    });
  }

  Future<void> saveUserSession(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<void> loginuser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in email and password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/login.php'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        var resarray = jsonDecode(response.body);

        if (resarray['status'] == 'success') {
          user = User.fromJson(resarray['data'][0]);

          // ✅ FIX: await works now
          await saveUserSession(user);

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login successful"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen(user: user)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(resarray['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }
}
