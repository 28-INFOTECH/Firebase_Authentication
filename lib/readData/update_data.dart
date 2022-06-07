import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UpdateData extends StatefulWidget {
  final String documentId;
  const UpdateData({Key? key,required this.documentId}) : super(key: key);

  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();


  Future updateUserDetails(String firstName, String lastName, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(widget.documentId)
        .update({

      'first name': firstName,
      'last name': lastName,
      'email': email,
    });
  }
  @override
  Widget build(BuildContext context) {
    void settingModalBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              padding: EdgeInsets.all(8),
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    autofocus: false,
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    onChanged: (name) {
                     _nameController.text= name;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    autofocus: false,
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    onChanged: (age) {
                      _ageController.text = age;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "age",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    autofocus: false,
                    controller: _cityController,
                    keyboardType: TextInputType.name,
                    onChanged: (city) {
                     _cityController.text= city;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "city",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: () {
                        updateUserDetails(_nameController.text, _cityController.text, _ageController.text);
                      },
                      child: Text('update')),

                ],
              ),
            );
          });
    }
    return Scaffold(
     body: ListView(
       children: [

       ],
     ),
    );
  }
}
