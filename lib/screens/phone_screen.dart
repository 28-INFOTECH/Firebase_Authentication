import 'package:demo/firebase_auth_method.dart';
import 'package:demo/screens/my_home_page.dart';
import 'package:demo/screens/new_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  String? _phone, _code;

  final TextEditingController _phoneCon = TextEditingController();
  final TextEditingController _otpCode = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIdReceived = "";
  bool otpCodeVisible = false;

  @override
  void dispose() {
    _phoneCon.dispose();
    super.dispose();
  }
  void phoneSignIn(){
    FirebaseAuthMethod(FirebaseAuth.instance).phoneWithSignIn(context, _phoneCon.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              autofocus: false,
              controller: _phoneCon,
              keyboardType: TextInputType.phone,
              onChanged: (phone) {
                _phone = phone;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Phone Number",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 15,
            ),
            Visibility(
              visible: otpCodeVisible,
              child: TextFormField(
                autofocus: false,
                controller: _otpCode,
                keyboardType: TextInputType.number,
                onChanged: (code) {
                  _code = code;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Code ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(30),
              color: Colors.blueAccent,
              child: MaterialButton(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                minWidth: MediaQuery.of(context).size.width,
                onPressed: ()  {
                  phoneSignIn();

                },
                child: const Text(
                   "login" ,
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
// *********************************************************** phone number Verify****************************************
//   void verifyNumber() {
//     auth.verifyPhoneNumber(
//         phoneNumber: _phoneCon.text,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await auth.signInWithCredential(credential).then((value) {
//             print('your logged Successfully');
//           });
//         },
//         verificationFailed: (FirebaseAuthException exception) {
//           print(exception.message);
//         },
//         codeSent: (String verificationID, int? resendToken) {
//           verificationIdReceived = verificationID;
//           otpCodeVisible = true;
//         },
//         codeAutoRetrievalTimeout: (String verificationID) {});
//   }
//
//   void verifyOtp() async {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationIdReceived, smsCode: _otpCode.text);
//     await auth.signInWithCredential(credential).then((value) {
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (con) =>
//                   MyHomePage(id: FirebaseAuth.instance.currentUser!.uid)));
//     });
//   }
}
