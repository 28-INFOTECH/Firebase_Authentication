import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'my_home_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  String? _name, _age, _city;

  //********************************************controllers*********************************************

  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerCity = TextEditingController();




  @override
  Widget build(BuildContext context) {
    //******************************************** name TextFormField *********************************************

    final nameField = TextFormField(
      autofocus: false,
      controller: controllerName,
      keyboardType: TextInputType.emailAddress,
      onChanged: (name) {
        _name = name;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //******************************************** age TextFormField *********************************************

    final ageField = TextFormField(
      autofocus: false,
      controller: controllerAge,
      keyboardType: TextInputType.number,
      onChanged: (age) {
        _age = age;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Age",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    //******************************************** city TextFormField *********************************************

    final cityField = TextFormField(
      autofocus: false,
      controller: controllerCity,
      keyboardType: TextInputType.emailAddress,
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Add User",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          nameField,
          const SizedBox(height: 25),
          ageField,
          const SizedBox(height: 25),
          cityField,
          const SizedBox(height: 35),
          ElevatedButton(
              onPressed: () {
                addData();
              },
              child: Text('Add Data')),
        ],
      ),
    );
  }

  InputDecoration decoration(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());
  //******************************************** add function *********************************************

  addData() {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('post').doc();
    var id = documentReference.id;
    print('ID = $id');
    print('Age =_age');
    Map<String, dynamic> data = {
      'id': documentReference.id,
      'name': _name,
      'age': _age,
      'city': _city,
    };
    documentReference.id;
    documentReference.set(data).then((value) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (con) => MyHomePage(id: documentReference.id))));
  }
}
