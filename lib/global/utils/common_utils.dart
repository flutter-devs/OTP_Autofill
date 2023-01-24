import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommonUtils {
  static String verify = "";

  static Future<String> firebasePhoneAuth(
      {required String phone, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {
          print("Phone credentials $credential");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed $e");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Verification Failed! Try after some time.")));
        },
        codeSent: (String verificationId, int? resendToken) async {
          CommonUtils.verify = verificationId;
          print("Verify: $verificationId");
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return CommonUtils.verify;
    } catch (e) {
      print("Exception $e");
      return "";
    }
  }

  static Future<bool> firebaseSignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
