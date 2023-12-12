import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lunchly1/screens/home_screen.dart';
import 'package:lunchly1/utils/routes.dart';

const double buttonWidth = 0.30;
const double inputFieldFontSize = 0.018;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool hide = true;
  bool isLoading = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 243, 223, 223)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 0.0 * constraints.maxHeight),
                    Image.asset(
                      "assets/images/LoginImg.png",
                      fit: BoxFit.contain,
                      height: 0.27 * constraints.maxHeight,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ),
                    SizedBox(height: 0.02 * constraints.maxHeight),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 0.02 * constraints.maxHeight,
                        horizontal: 0.1 * constraints.maxWidth,
                      ),
                      child: Column(
                        children: [
                          TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onChanged: (value) {},
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: hide,
                  controller: passController,
                  decoration: InputDecoration(
                      suffix: InkWell(
                        onTap: showPassword,
                        child: const Icon(Icons.visibility),
                      ),
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onChanged: (value) {},
                ),
                          buildRememberMeCheckbox(),
                          SizedBox(height: 0.02 * constraints.maxHeight),
                          buildLoginButton(context),
                          SizedBox(height: 0.015 * constraints.maxHeight),
                          buildDividerWithText(constraints),
                          SizedBox(height: 0.015 * constraints.maxHeight),
                          buildRegisterButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildInputField({
    required String label,
    required String hint,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: inputFieldFontSize * MediaQuery.of(context).size.height,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 0.008 * MediaQuery.of(context).size.height),
        TextFormField(
          obscureText: isPassword,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: Color.fromARGB(255, 230, 60, 9),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Color.fromARGB(255, 251, 236, 236),
          ),
        ),
        SizedBox(height: 0.012 * MediaQuery.of(context).size.height),
      ],
    );
  }

  Widget buildRememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (value) {
            setState(() {
              rememberMe = value!;
            });
          },
          activeColor: Color.fromARGB(255, 230, 60, 9),
        ),
        Text(
          "Remember Me",
          style: TextStyle(
            fontSize: 0.02 * MediaQuery.of(context).size.height,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Container(
      width: buttonWidth * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.red],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          _perflogin();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0.02 * MediaQuery.of(context).size.height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          "Login",
          style: TextStyle(
            fontSize: 0.025 * MediaQuery.of(context).size.height,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildDividerWithText(BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.black,
            thickness: 1.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.03 * constraints.maxWidth,
          ),
          child: Text(
            "OR",
            style: TextStyle(color: Colors.black),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.black,
            thickness: 1.0,
          ),
        ),
      ],
    );
  }

  Widget buildRegisterButton(BuildContext context) {
    return Container(
      width: buttonWidth * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, MyRoutes.registerRoute);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0.02 * MediaQuery.of(context).size.height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          "Register",
          style: TextStyle(
              fontSize: 0.023 * MediaQuery.of(context).size.height,
              color: Colors.white),
        ),
      ),
    );
  }
  void _perflogin() async
 {
  try {
                              // ignore: unused_local_variable

                              // ignore: unused_local_variable
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                      email: emailController.text.toString(),
                                      password: passController.text.toString());

                              setState(() {
                                isLoading = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                isLoading = false;
                              });

                              if (e.code == 'user-not-found') {
                                setState(() {
                                  isLoading = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            'No user found for that email.')));
                              } else if (e.code == 'wrong-password') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            'Wrong password provided for that user.')));
                              }
                            }
 }
 showPassword() {
    setState(() {
      if (hide == true) {
        hide = false;
      } else {
        hide = true;
      }
    });
  }
}

