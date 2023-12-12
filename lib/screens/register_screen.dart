import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lunchly1/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(
    MaterialApp(
      home: RegisterScreen(),
    ),
  );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

enum RegistrationType { basic, corporate, admin }

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username = 'Enter your username';
  String _email = 'Enter your email';
  String _password = 'Enter your password';
  String _phoneNumber = 'Enter your phone number';
  String _streetAddress = 'Enter your street address';
  String _city = 'Enter your city';
  String _state = 'Enter your state';
  String _postalCode = 'Enter your postal code';
  String _companyName = 'Enter your company name';
  RegistrationType _registrationType = RegistrationType.basic;
 // bool _isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Back to Login',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Colors.redAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 243, 223, 223),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  DropdownButtonFormField<RegistrationType>(
                    value: _registrationType,
                    onChanged: (value) {
                      setState(() {
                        _clearFields();
                        _registrationType = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: RegistrationType.basic,
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 8.0),
                            Text('Basic Registration'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: RegistrationType.admin,
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 8.0),
                            Text('Admin Registration'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: RegistrationType.corporate,
                        child: Row(
                          children: [
                            Icon(Icons.business),
                            SizedBox(width: 8.0),
                            Text('Corporate Registration'),
                          ],
                        ),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Registration Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 251, 236, 236),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 251, 236, 236),
                    ),
                    initialValue: _username,
                    onTap: () {
                      setState(() {
                        _username = '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value!;
                    },
                  ),
                  
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 251, 236, 236),
                    ),
                    initialValue: _email,
                    onTap: () {
                      setState(() {
                        _email = '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 251, 236, 236),
                    ),
                    initialValue: _password,
                    onTap: () {
                      setState(() {
                        _password = '';
                      });
                    },
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 251, 236, 236),
                    ),
                    initialValue: _phoneNumber,
                    onTap: () {
                      setState(() {
                        _phoneNumber = '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _phoneNumber = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Street Address',
                      hintText: 'Enter your street address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 251, 236, 236),
                      contentPadding: EdgeInsets.all(16.0),
                    ),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    controller: TextEditingController(text: _streetAddress),
                    onTap: () {
                      setState(() {
                        _streetAddress = '';
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _streetAddress = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 251, 236, 236),
                          ),
                          initialValue: _city,
                          onTap: () {
                            setState(() {
                              _city = '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the city';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _city = value!;
                          },
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'State',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 251, 236, 236),
                          ),
                          initialValue: _state,
                          onTap: () {
                            setState(() {
                              _state = '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the state';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _state = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Postal Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 251, 236, 236),
                    ),
                    initialValue: _postalCode,
                    onTap: () {
                      setState(() {
                        _postalCode = '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the postal code';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _postalCode = value!;
                    },
                  ),
                  if (_registrationType == RegistrationType.corporate) ...[
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Company Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 251, 236, 236),
                      ),
                      initialValue: _companyName,
                      onTap: () {
                        setState(() {
                          _companyName = '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the company name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _companyName = value!;
                      },
                    ),
                  ],
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _register();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                        foregroundColor: Colors.transparent,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.red],
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 17,
                        ),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _clearFields() {
    _phoneNumber = 'Enter your phone number';
    _streetAddress = 'Enter your street address';
    _city = 'Enter your city';
    _state = 'Enter your state';
    _postalCode = 'Enter your postal code';
    _companyName = 'Enter your company name';
  //  _isAdmin = false;
  }

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      print(
          'Registering with: $_username, $_email, $_password, Phone Number: $_phoneNumber, Street Address: $_streetAddress, City: $_city, State: $_state, Postal Code: $_postalCode');

      try {
        UserCredential result =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Access the user information
        User? user = result.user;

        // Store user data in Firestore
        await _storeUserData(
          userId: user?.uid ?? "",
          username: _username,
          phoneNumber: _phoneNumber,
          streetAddress: _streetAddress,
          city: _city,
          state: _state,
          postalCode: _postalCode,
          companyName: _companyName,
          registrationType: _registrationType,
         // isAdmin: _admin,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (error) {
        print(error.toString());
        // Handle registration error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed. Please try again.'),
          ),
        );
      }
    }
  }

  Future<void> _storeUserData({
    required String userId,
    required String username,
    required String phoneNumber,
    required String streetAddress,
    required String city,
    required String state,
    required String postalCode,
    required String companyName,
    required RegistrationType registrationType,
   // required bool isAdmin =
     //   false, // Include the isAdmin parameter with a default value
  }) async {
    String userTypeString =
        registrationType == RegistrationType.basic ? 'client' : 'corporate';

    // For example, if you have a 'users' collection in Firestore
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'username': username,
      'phoneNumber': phoneNumber,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'companyName': companyName,
      'userType': userTypeString,
    //  'isAdmin': isAdmin, // Include isAdmin in Firestore data
      // Add other user data as needed
    });
  }
}
