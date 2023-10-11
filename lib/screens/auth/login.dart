import 'package:chat_app/model/invited_user_model.dart';
import 'package:chat_app/model/user_model_class.dart';
import 'package:chat_app/screens/navigator/bottom_navbar.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../apis/auth_api.dart';
import '../../provider/user_data_provider.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  
  @override
  LoginState createState() => new LoginState();
}


class LoginState extends State<Login> {
  bool _isObscure = true;
  final TextEditingController inviteController = new TextEditingController();

  final TextEditingController phoneController = new TextEditingController();
  String phone='+92';

  final _inviteKey = GlobalKey<FormState>();
  final _loginKey = GlobalKey<FormState>();

  _verifyUser(String inviteCode) async{
    await FirebaseFirestore.instance.collection('invited_users').where("invitationCode",isEqualTo: inviteCode).get().then((QuerySnapshot querySnapshot) async{
      if (querySnapshot.docs.isEmpty) {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: "Invalid Invite Code!",);
      }
      else{
        querySnapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data()! as Map<String, dynamic>;
          InvitedUserModel userData = InvitedUserModel.fromMap(data, element.reference.id);
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Register(invitedUser: userData)));

        });
      }
    });
  }
  Future<void> _displayInviteCodeDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invite Code Verification'),
            content: Form(
              key: _inviteKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter invitation code!';
                  }
                  return null;
                },
                controller: inviteController,
                decoration: InputDecoration(hintText: "Invitation Code"),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Close'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: Text('Verify'),
                onPressed: () {
                  setState(() {
                    if(_inviteKey.currentState!.validate()) {
                      _verifyUser(inviteController.text);
                      Navigator.pop(context);
                    }
                  });
                },
              ),
            ],
          );
        });
  }
  /*login()async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: 'Authenticating User');
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text
    ).then((value)async{
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) async{
        if (documentSnapshot.exists) {
          pr.close();
          Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
          AppUser user=AppUser.fromMap(data,documentSnapshot.reference.id);
          if(user.status=="Blocked"){
            await FirebaseAuth.instance.signOut();
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: "Your account is blocked by admin",
            );
          }
          else{
            final provider = Provider.of<UserDataProvider>(context, listen: false);
            provider.setUserData(user);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomNavBar()));
          }


        }
        else{
          pr.close();
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: "No User Data",
          );
        }
      });

      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TeacherBar()));
    }).onError((error, stackTrace){
      pr.close();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: error.toString(),
      );
    });
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(preferredSize: Size.fromHeight(0), child: Container(color: primaryColor)),
      body: Stack(
        children: <Widget>[
          Container(color: primaryColor, height: 220),
          Column(
            children: <Widget>[
              Container(height: 40),
              Container(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  backgroundColor: Colors.transparent,
                ),
                width: 80, height: 80,
              ),
              Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(6)),
                  margin: EdgeInsets.all(25),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child :  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Form(
                      key: _loginKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("SIGN IN", style: TextStyle(
                                color: primaryColor, fontWeight: FontWeight.bold, fontSize: 24
                            )),
                          ),
                          Row(
                            children: [
                              Center(
                                child: CountryCodePicker(
                                  onChanged: (value){

                                    phone=value.dialCode!;
                                    print('phone $phone');
                                  },
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: 'PK',
                                  favorite: ['+92','PK'],
                                  // optional. Shows only country name and flag
                                  showCountryOnly: false,
                                  // optional. Shows only country name and flag when popup is closed.
                                  showOnlyCountryWhenClosed: false,
                                  // optional. aligns the flag and the Text left
                                  alignLeft: false,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: phoneController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter phone number';
                                    }

                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: textColor),
                                  decoration: InputDecoration(labelText: "Phone",
                                    labelStyle: TextStyle(color: Colors.blueGrey[400]),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blueGrey, width: 1),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blueGrey, width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),

                          Container(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                              child: Text("SUBMIT",
                                style: TextStyle(color: Colors.white),),

                              onPressed: () async{
                                if(_loginKey.currentState!.validate()){
                                  final ProgressDialog pr = ProgressDialog(context: context);
                                  pr.show(max: 100, msg: 'Please Wait',barrierDismissible: true);
                                  await AuthenticationApi.login('$phone${phoneController.text}').then((value){
                                    pr.close();
                                    if(value){
                                      AuthenticationApi authApi=AuthenticationApi();
                                      authApi.verifyPhoneNumber('$phone${phoneController.text}', context, 1);
                                    }
                                    else{
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: 'No user found. Please register $phone${phoneController.text}',
                                      );
                                    }
                                  }).onError((error, stackTrace) {
                                    pr.close();
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.error,
                                      text: error.toString(),
                                    );
                                  });

                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Center(
                              child: InkWell(
                                onTap: (){
                                  _displayInviteCodeDialog(context);
                                },
                                child: Text("New user? Sign Up",
                                  style: TextStyle(color: primaryColor),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              )
            ],
          )
        ],
      ),

    );
  }
}

