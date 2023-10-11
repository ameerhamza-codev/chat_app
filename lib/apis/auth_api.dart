import 'package:chat_app/model/user_model_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../screens/auth/otp_screen.dart';

class AuthenticationApi{

  //intent 0 = register ; 1= login ; 2 = forgot password ; 3 = delete account

  static Future<bool> login(String phone)async{
    List<AppUser> users=[];
    await FirebaseFirestore.instance.collection('users').where('mobile',isEqualTo: phone).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        AppUser model=AppUser.fromMap(data, doc.reference.id);
        users.add(model);
      });
    });

    return users.length>0?true:false;
  }

  static Future<bool> checkIfUserExists(String phone)async{
    List<AppUser> users=[];
    await FirebaseFirestore.instance.collection('users').where('mobile',isEqualTo: phone).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        AppUser model=AppUser.fromMap(data, doc.reference.id);
        users.add(model);
      });
    });

    return users.length>0?true:false;
  }

  Future<void> verifyPhoneNumber(String phoneNumber,context,int intent) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: 'Please Wait',barrierDismissible: true);

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval of verification code completed.
        // Sign the user in (or link) with the auto-generated credential.
        /*await _auth.currentUser!.reload();
        if (_auth.currentUser == null) {
          await _auth.signInWithCredential(credential);
        }*/
      },
      verificationFailed: (FirebaseAuthException e) {
        pr.close();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: 'Auth Error ${e.code} : ${e.message}',
        );
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        // Handle other errors here
      },
      codeSent: (String verificationId, int? resendToken) async {
        pr.close();
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => OtpVerificationScreen(verificationId,intent,phoneNumber)));

        // Save the verification ID somewhere, for example, using SharedPreferences.
        // Use the verificationId to build the credential by combining
        // the verification code entered by the user and the verification ID.
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        pr.close();
        // Auto-resolution timed out
      },
    );
  }
}