import 'package:chat_app/model/user_model_class.dart';
import 'package:chat_app/screens/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../provider/user_data_provider.dart';
import '../../utils/constants.dart';
import '../navigator/bottom_navbar.dart';

class OtpVerificationScreen extends StatefulWidget {
  String id;
  int intent;
  String phone;


  OtpVerificationScreen(this.id, this.intent,this.phone);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  Future<void> _showDeleteAccountDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Your account is deleted'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (Route<dynamic> route) => false);

              },
            ),
          ],
        );
      },
    );
  }

  Future<void> register(PhoneAuthCredential credential)async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: 'Please Wait');
       if (FirebaseAuth.instance.currentUser == null) {
         await FirebaseAuth.instance.signInWithCredential(credential).then((value)async{
           String? token="";
           FirebaseMessaging _fcm=FirebaseMessaging.instance;
           token=await _fcm.getToken();
           final provider = Provider.of<UserDataProvider>(context, listen: false);


           provider.setUserId(FirebaseAuth.instance.currentUser!.uid);
           await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(provider.userData!.toMap());
           pr.close();
           Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BottomNavBar()), (Route<dynamic> route) => false);

           //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const RegisterScreen()));

         }).onError((error, stackTrace) {
           pr.close();
           CoolAlert.show(
             context: context,
             type: CoolAlertType.error,
             text: error.toString(),
           );
         });
       }
       else{
         String? token="";
         FirebaseMessaging _fcm=FirebaseMessaging.instance;
         token=await _fcm.getToken();
         final provider = Provider.of<UserDataProvider>(context, listen: false);

         provider.setUserId(FirebaseAuth.instance.currentUser!.uid);
         await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(provider.userData!.toMap());
         pr.close();
         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BottomNavBar()), (Route<dynamic> route) => false);
       }

  }

  Future<void> login(PhoneAuthCredential credential)async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: 'Please Wait');
    
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInWithCredential(credential).then((value)async{
        pr.close();
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) async{
          if (documentSnapshot.exists) {
            print("user exists");
            Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
            AppUser user=AppUser.fromMap(data,documentSnapshot.reference.id);
            print("user ${user.userId} ${user.status}");
            String? token="";

            FirebaseMessaging _fcm=FirebaseMessaging.instance;
            token=await _fcm.getToken();
            print('fcm token else $token');
            FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
              'token':token,
            });
            final provider = Provider.of<UserDataProvider>(context, listen: false);
            provider.setUserData(user);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomNavBar()));
          }
          else{
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: 'No User In Database',
            );
          }

        });

      }).onError((error, stackTrace) {
        pr.close();
        CoolAlert.show(
          context: context,
          title: 'Login Error',
          type: CoolAlertType.error,
          text: error.toString(),
        );
      });
    }
    else{
      pr.close();
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) async{
        if (documentSnapshot.exists) {
          print("user exists");
          Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
          AppUser user=AppUser.fromMap(data,documentSnapshot.reference.id);
          print("user ${user.userId} ${user.status}");
          String? token="";
          FirebaseMessaging _fcm=FirebaseMessaging.instance;
          token=await _fcm.getToken();
          print('fcm token else $token');
          FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
            'token':token,
          });
          final provider = Provider.of<UserDataProvider>(context, listen: false);
          provider.setUserData(user);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomNavBar()));
        }




      });
    }


  }



  Future<void> deleteAccount(PhoneAuthCredential credential)async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: 'Please Wait');
    await FirebaseAuth.instance.signInWithCredential(credential).then((value)async{
      String userId=FirebaseAuth.instance.currentUser!.uid;
      FirebaseAuth.instance.currentUser!.delete().then((value){
        pr.close();
        FirebaseFirestore.instance.collection('users').doc(userId).delete();
        _showDeleteAccountDialog();
      }).onError((error, stackTrace) {
        pr.close();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: error.toString(),
        );
      });

    }).onError((error, stackTrace) {
      pr.close();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: error.toString(),
      );
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('confirm OTP'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.06,),
            Image.asset('assets/images/otp.png',height: MediaQuery.of(context).size.height*0.2,),
            SizedBox(height: MediaQuery.of(context).size.height*0.06,),
            Text('You will receive a code to confirm your mobile number shortly',textAlign: TextAlign.center,),
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
            Localizations.override(
              context: context,
              locale: Locale('en'),
              child: OtpTextField(
                numberOfFields: 6,

                borderColor: primaryColor,
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode)async{


                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.id,
                    smsCode: verificationCode,
                  );

                  if(widget.intent==0){
                    register(credential,);
                  }
                  else if(widget.intent==1){
                    login(credential);
                  }
                  else if(widget.intent==2){
                    //forgotPassword(credential);
                  }
                  else if(widget.intent==3){
                    deleteAccount(credential);
                  }


                }, // end onSubmit
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget otpTextField(int index) {
    return SizedBox(
      width: 60.0,
      child: TextFormField(
        controller: _otpController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: '*',
          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
