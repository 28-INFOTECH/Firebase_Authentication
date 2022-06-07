import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class GetUserName extends StatelessWidget {
  final String DocumentId;
  const GetUserName({Key? key, required this.DocumentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');


    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(DocumentId).get(),
        builder:(con, snapshot){
         if(snapshot.connectionState == ConnectionState.done){
           Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
           return Text( '${data['name']}' + ' ' + '${data['age']}');
         }
         return const Text('Loading......');
        });
  }
}

