import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:demo/firebase_auth_method.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/const.dart';
import 'package:demo/screens/login_screen.dart';
import 'package:demo/screens/my_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? _fname, _lname, _email, _pass, _cpass, _city, _age;
  bool _obscureText = true;
  bool _passText = true;
  bool uploading = false;
  double val = 0;
  var _url;

  //******************************************** _formKey *********************************************

  final _formKey = GlobalKey<FormState>();

  void encryptPassword() async {
    var encryptedPassword = generateMd5(passwordController.text);
    setState(() {
      _pass = encryptedPassword;
    });
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  //******************************************** Controller *********************************************

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conPasswordController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    conPasswordController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //******************************************** SignUp Function *********************************************
  void signUpUser() async {
    if (passwordConfirm()) {
      await FirebaseAuthMethod(FirebaseAuth.instance).signUpWithEmail(
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
      documentReference.set(data);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('LoginId', documentReference.id).then((value) =>
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (con) => MyHomePage(id: documentReference.id))));
    }
  }
  //

  Future addUserDetails(String firstName, String lastName, String email,
      String age, String city, String url, String pass) async {
    await FirebaseFirestore.instance.collection('post').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'age': age,
      'city': city,
      'imgRef': _imageUrls,
      'pass': pass
    });
  }

  bool passwordConfirm() {
    if (passwordController.text.trim() == conPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  late CollectionReference imgRef;
  late firebase_storage.Reference ref;

  final List<File> image = [];
  final picker = ImagePicker();
  List _imageUrls = [];

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('post');
  }

  @override
  Widget build(BuildContext context) {
    final firstnameField = TextFormField(
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.name,
      onChanged: (fname) {
        _fname = fname;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final lastnameField = TextFormField(
      autofocus: false,
      controller: lastnameController,
      keyboardType: TextInputType.name,
      onChanged: (lname) {
        _lname = lname;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Last Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final cityField = TextFormField(
      autofocus: false,
      controller: cityController,
      keyboardType: TextInputType.name,
      onChanged: (city) {
        _city = city;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final ageField = TextFormField(
      autofocus: false,
      controller: ageController,
      keyboardType: TextInputType.number,
      onChanged: (age) {
        _age = age;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "age",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

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
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: _obscureText,
      validator: (pass) {
        if (pass!.isEmpty) return 'Empty';
        return null;
      },
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
            onPressed: _toggle,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final conPasswordField = TextFormField(
      autofocus: false,
      controller: conPasswordController,
      obscureText: _passText,
      validator: (pass) {
        if (pass!.isEmpty) {
          return 'Empty';
        }
        if (pass != passwordController.text) {
          return 'Not Match';
        }
        return null;
      },
      onChanged: (cpass) {
        _cpass = cpass;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passText ? Icons.visibility_off : Icons.visibility,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                setState(() {
                  _passText = !_passText;
                });
              }),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final submitButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await uploadFile();
            encryptPassword();
            signUpUser();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Successfully Done...')));
          }
        },
        child: const Text(
          "Submit",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign up',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 150,
                      child: Stack(children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          child: GridView.builder(
                              itemCount: image.length + 1,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                return index == 0
                                    ? Center(
                                        child: IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () => !uploading
                                                ? chooseImage()
                                                : null),
                                      )
                                    : Container(
                                        margin: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    FileImage(image[index - 1]),
                                                fit: BoxFit.cover)),
                                      );
                              }),
                        ),
                        uploading
                            ? Center(
                                child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    child: const Text(
                                      'uploading...',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CircularProgressIndicator(
                                    value: val,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.green),
                                  )
                                ],
                              ))
                            : Container(),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    firstnameField,
                    const SizedBox(height: 25),
                    lastnameField,
                    const SizedBox(height: 25),
                    ageField,
                    const SizedBox(height: 25),
                    cityField,
                    const SizedBox(height: 25),
                    emailField,
                    const SizedBox(height: 25),
                    passwordField,
                    const SizedBox(height: 25),
                    conPasswordField,
                    const SizedBox(height: 35),
                    submitButton,
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account ?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (con) => LoginScreen()));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  createData() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (con) => LoginScreen()));
    }).onError((error, stackTrace) {
      print("Error ${error.toString()}");
    });
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image.add(File(pickedFile!.path));
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    for (var img in image) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL();
        _imageUrls.add(await ref.getDownloadURL());
      });
    }
    return _imageUrls;
  }
  // Future uploadPic(BuildContext context) async {
  //   try{
  //     String fileName = Path.basename(imagefile!.path);
  //     var firebaseStorageRef = FirebaseStorage.instance.ref().child('photos/$fileName');
  //     var uploadTask = firebaseStorageRef.putFile(imagefile!);
  //     var taskSnapshot = await uploadTask.whenComplete((){});
  //     _url = await taskSnapshot.ref.getDownloadURL();
  //   } catch (e){
  //     print('error :- $e');
  //   }
  //   return _url;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   imgRef = FirebaseFirestore.instance.collection('post');
  // }
}
