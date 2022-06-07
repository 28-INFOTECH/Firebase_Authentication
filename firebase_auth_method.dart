import 'package:demo/screens/new_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthMethod {
  final FirebaseAuth _auth;
  FirebaseAuthMethod(this._auth);

  //   Email SignUp   //

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // Email Login //

  Future<void> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //Phone Sign In

  Future<void> phoneWithSignIn(BuildContext context, String phoneNumber,
     ) async {
    TextEditingController codeCont = TextEditingController();
    //  For Android,IOS
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) {
            print('your logged Successfully');
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationID, int? resendToken) async{
          showOTPDialog(
              context: context,
              codeCon: codeCont,
              onPressed: () async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationID,
                    smsCode: codeCont.text.trim());
                await _auth.signInWithCredential(credential);
                Navigator.pop(context);
              });
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }

}
void showSnackBar(BuildContext context, String text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('text')));}

void showOTPDialog({
  required BuildContext context,
  required TextEditingController codeCon,
  required VoidCallback onPressed,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter OTP'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeCon,
            )
          ],
        ),
        actions: [TextButton(onPressed:(){Navigator.pushReplacement(context, MaterialPageRoute(builder: (con)=>NewPage()));}, child: Text('Done'))],
      ));
}
