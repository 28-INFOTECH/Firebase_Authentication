import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/firebase_auth_method.dart';
import 'package:demo/screens/my_home_page.dart';
import 'package:demo/screens/new_page.dart';
import 'package:demo/screens/phone_screen.dart';
import 'package:demo/screens/registration_screen.dart';
import 'package:demo/screens/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../const.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _fname, _lname, _email, _pass, _city, _age;
  bool _obscureText = true;

  //***************************************** form key *************************************

  final _formKey = GlobalKey<FormState>();

  //****************************************** controllers ***********************************

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //****************************************** sign In function ************************************

  Future signInUser() async {
    FirebaseAuthMethod(FirebaseAuth.instance).signInWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        context: context);

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('post').doc();

    Map<String, dynamic> data = {
      'id': documentReference.id,
      'firstName': _fname,
      'lastName': _lname,
      'email': _email,
      'age': _age,
      'city': _city,
      'imgRef': _imageUrls,
      'pass': _pass,
    };
    // documentReference.id;
    print('Id = ${documentReference.id}');
    documentReference.set(data).then((value) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (con) => NewPage())));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  List _imageUrls = [];

  @override
  Widget build(BuildContext context) {
    //**************************************************** email TextFormField ****************************************
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onChanged: (email) {
        _email = email;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail_outline),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //**************************************************** Password TextFormField ****************************************

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: _obscureText,
      validator: (val) =>
          val!.length < 6 ? "Password length should be Greater than 6" : null,
      onChanged: (pass) {
        _pass = pass;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              setState(() {
                _obscureText != _obscureText;
              });
            },
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    //**************************************************** loginButton ****************************************

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            signInUser();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Successfully login')));
          }
        },
        child: const Text(
          "Sign In",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  emailField,
                  const SizedBox(height: 25),
                  passwordField,
                  const SizedBox(height: 35),
                  loginButton,
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("don't have an account ?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (con) =>
                                      const RegistrationScreen()));
                        },
                        child: const Text(
                          "SignUp",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Center(
                      child: Text(
                    'OR',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(height: 20),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blueAccent,
                    child: MaterialButton(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (con) => const PhoneScreen()));
                      },
                      child: const Text(
                        "Phone",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
}
