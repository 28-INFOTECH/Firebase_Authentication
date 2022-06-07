import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/screens/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../readData/get_user_name.dart';

class MyHomePage extends StatefulWidget {
  final String id;
  const MyHomePage({Key? key, required this.id}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  String? _fname,_lname,_email, _age, _city;
//********************************************controllers*********************************************

  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // List<String> docIDs = [];
  //
  // Future getUserDetails() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .get()
  //       .then((snapshot) => snapshot.docs.forEach((document) {
  //             print(document.reference);
  //             docIDs.add(document.reference.id);
  //           }));
  // }

  //

  @override
  Widget build(BuildContext context) {
    void _settingModalBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              padding: EdgeInsets.all(8),
              child: ListView(
                children: <Widget>[
                  // **************************** Name Textified*************************************
                  TextFormField(
                    autofocus: false,
                    controller: _fNameController,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.name,
                    onChanged: (fName) {
                      _fname = fName;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "First Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    autofocus: false,
                    controller: _lNameController,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.name,
                    onChanged: (lName) {
                      _lname = lName;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Last Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    autofocus: false,
                    controller: _emailController,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.name,
                    onChanged: (email) {
                      _email = email;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail_outline),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 12),
                  //***************************** age Textfield************************************
                  TextFormField(
                    autofocus: false,
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    onChanged: (age) {
                      _age = age;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "age",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 12),
                  //*********************************city textfield***************************
                  TextFormField(
                    autofocus: false,
                    controller: _cityController,
                    keyboardType: TextInputType.name,
                    onChanged: (city) {
                      _city = city;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "city",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 12),
                  //*******************************************update button ***************************
                  ElevatedButton(
                      onPressed: () {
                        update();
                      },
                      child: Text('update')),
                ],
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '${user.email}',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const UserPage()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ListView(
        children: [
          StreamBuilder<DocumentSnapshot<Map>>(
              stream: FirebaseFirestore.instance
                  .collection('post')
                  .doc('${widget.id}')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return  Center(
                    child: Container(
                      child: Text('${user.email}'),
                    ),
                  );
                }
                var userData = snapshot.data;
                // return Card(
                //   elevation: 5,
                //   child: Container(
                //     padding: const EdgeInsets.all(8.0),
                //     margin: const EdgeInsets.all(8.0),
                //     decoration:
                //         BoxDecoration(border: Border.all(color: Colors.grey)),
                //     child: ListTile(
                //       leading: CircleAvatar(
                //         child: Text(userData!['age'].toString()),
                //       ),
                //       trailing: Wrap(
                //         children: [
                //           IconButton(
                //             icon: const Icon(
                //               Icons.edit,
                //               color: Colors.green,
                //             ),
                //             onPressed: () {
                //              //***********************************update textfield use*********************************
                //               _settingModalBottomSheet(context);
                //             },
                //           ),
                //           IconButton(
                //               icon: const Icon(
                //                 Icons.delete,
                //                 color: Colors.red,
                //               ),
                //               onPressed: () {
                //                 // *******************************************delete********************************
                //                 delete();
                //               }),
                //         ],
                //       ),
                //       title: Container(child: Column(children: [
                //         Text(userData['first name'])
                //       ],),),
                //       subtitle: Text(userData['city']),
                //     ),
                //   ),
                // );
                // return Card(
                //   child: Container(
                //     decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                //     height: 200,
                //     padding: EdgeInsets.all(10),
                //     child: Column(
                //      crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text('FirstName :-  ${userData!['firstName'].toString()}'),
                //         SizedBox(height: 10),
                //         Text('LastName  :-  ${userData['lastName'].toString()}'),
                //         SizedBox(height: 10),
                //         Text('age       :-     ${userData['age'].toString()}'),
                //         SizedBox(height: 10),
                //         Text('city      :-     ${userData['city'].toString()}'),
                //         SizedBox(height: 10),
                //         Text('email     :-     ${userData['email'].toString()}'),
                //         SizedBox(height: 10),
                //           Wrap(
                //                     children: [
                //                       IconButton(
                //                         icon: const Icon(
                //                           Icons.edit,
                //                           color: Colors.green,
                //                         ),
                //                         onPressed: () {
                //                          //***********************************update textfield use*********************************
                //                           _settingModalBottomSheet(context);
                //                         },
                //                       ),
                //                       IconButton(
                //                           icon: const Icon(
                //                             Icons.delete,
                //                             color: Colors.red,
                //                           ),
                //                           onPressed: () {
                //                             // *******************************************delete********************************
                //                             delete();
                //                           }),
                //                     ],
                //                   ),
                //
                //       ],
                //     ),
                //   ),
                // );

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: Colors.grey,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14)
                          // shape: BoxShape.circle
                        ),
                        height: 170,
                        width: 170,
                        child: Image.network(
                          userData!['imgRef'][0].toString(),
                          fit: BoxFit.fill,),
                      ),
                    ),
                    Text(
                      "FirstName :- ${userData['firstName'].toString()}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "lastName :- ${userData['lastName']}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Email :- ${userData['email']}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Age :- ${userData['age'].toString()}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "City :- ${userData['city']}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(height: 10),

                              Wrap(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                             //***********************************update textfield use*********************************
                                              _settingModalBottomSheet(context);
                                            },
                                          ),
                                          IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                // *******************************************delete********************************
                                                delete();
                                              }),
                                        ],
                                      ),


                  ],
                );
              }),
        ],
      ),
    );
  }

  //*************************************update function****************************************
  update() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('post').doc(widget.id);

    Map<String, dynamic> data = {
      'id': documentReference.id,
      'firstName': _fname,
      'lastName': _lname,
      'email': _email,
      'age': _age,
      'city': _city
    };
    documentReference.id;
    documentReference.update(data);
  }

//**********************************************delete funtion**************************************
  delete() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('post').doc(widget.id);
    documentReference.delete();
  }
}
