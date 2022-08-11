import 'package:chat_app/model/user_model_class.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final AppUser invitedUser;
  const Register({Key? key, required this.invitedUser}) : super(key: key);
  
  @override
  RegisterState createState() => new RegisterState();
}


class RegisterState extends State<Register> {

  final TextEditingController groupNameController = new TextEditingController();
  final TextEditingController groupCodeController = new TextEditingController();
  final TextEditingController subGroupName1Controller = new TextEditingController();
  final TextEditingController subGroupCode1Controller = new TextEditingController();
  final TextEditingController subGroupName2Controller = new TextEditingController();
  final TextEditingController subGroupCode2Controller = new TextEditingController();
  final TextEditingController subGroupName3Controller = new TextEditingController();
  final TextEditingController subGroupCode3Controller = new TextEditingController();
  final TextEditingController subGroupName4Controller = new TextEditingController();
  final TextEditingController subGroupCode4Controller = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController genderController = new TextEditingController();
  final TextEditingController addRespController = new TextEditingController();
  final TextEditingController addRespTypeController = new TextEditingController();


  @override
  void initState() {
    super.initState();
    groupNameController.text = widget.invitedUser.mainGroup.toString();
    groupCodeController.text = widget.invitedUser.mainGroupCode.toString();
    subGroupName1Controller.text = widget.invitedUser.subGroup1.toString();
    subGroupCode1Controller.text = widget.invitedUser.subGroup1Code.toString();
    subGroupName2Controller.text = widget.invitedUser.subGroup2.toString();
    subGroupCode2Controller.text = widget.invitedUser.subGroup2Code.toString();
    subGroupName3Controller.text = widget.invitedUser.subGroup3.toString();
    subGroupCode3Controller.text = widget.invitedUser.subGroup3Code.toString();
    subGroupName4Controller.text = widget.invitedUser.subGroup4.toString();
    subGroupCode4Controller.text = widget.invitedUser.subGroup4Code.toString();
    nameController.text = widget.invitedUser.name.toString();
    emailController.text = widget.invitedUser.email.toString();
    phoneController.text = widget.invitedUser.mobile.toString();
    genderController.text = widget.invitedUser.gender.toString();
    addRespController.text = widget.invitedUser.additionalResponsibility.toString();
    addRespTypeController.text = widget.invitedUser.additionalResponsibilityCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    bool _isObscure = true;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          centerTitle: true,
          title: const Text('REGISTER'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.circle, size: 10,color: primaryColor,),
                    const Text(" GROUP INFORMATION", style: TextStyle(color: textColor)),
                  ],
                ),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(0), elevation: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 750,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        TextField(
                          maxLines: 1,
                          enabled: false,
                          controller: groupNameController,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'GROUP NAME'),
                        ),
                        const Divider(thickness: 1, color: textColor,),
                        TextField(maxLines: 1,
                          enabled: false,
                          controller: groupCodeController,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'GROUP CODE'),
                        ),
                        const Divider(thickness: 1, color: textColor,),
                        TextField(maxLines: 1,
                          enabled: false,
                          controller: subGroupName1Controller,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 1 NAME'),
                        ),
                        const Divider(thickness: 1, color: textColor,),
                        TextField(maxLines: 1,
                          enabled: false,
                          controller: subGroupCode1Controller,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 1 CODE'),
                        ),
                        const Divider(thickness: 1, color: textColor,),
                        TextField(maxLines: 1,
                          enabled: false,
                          controller: subGroupName2Controller,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 2 NAME'),
                        ),
                        const Divider(thickness: 1, color: textColor,),
                        TextField(maxLines: 1,
                          enabled: false,
                          controller: subGroupCode2Controller,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 2 CODE'),
                        ),
                        const Divider(thickness: 1, color: textColor,),
                        TextField(maxLines: 1,
                          enabled: false,
                          controller: subGroupName3Controller,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 3 NAME'),
                        ),
                        const Divider(thickness: 1, color: textColor,),
                        TextField(maxLines: 1,
                          enabled: false,
                          controller: subGroupCode3Controller,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 3 CODE'),
                        ),
                        const Divider(thickness: 1, color: textColor,),
                        TextField(maxLines: 1,
                          enabled: false,
                          controller: subGroupName4Controller,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 4 NAME'),
                        ),
                        const Divider(thickness: 1, color: textColor,),
                        TextField(maxLines: 1,
                          enabled: false,
                          controller: subGroupCode4Controller,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 4 CODE'),
                        ),

                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10,color: primaryColor,),
                    const Text(" BASIC INFORMATION", style: TextStyle(color: textColor)),
                  ],
                ),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(0), elevation: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 300,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        TextField(
                          maxLines: 1,
                          enabled: false,
                          controller: nameController,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'NAME'),
                        ),
                        const Divider(thickness: 1, color: textColor,),
                        TextField(maxLines: 1,
                          enabled: false,
                          controller: emailController,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'EMAIL'),
                        ),
                        const Divider(thickness: 1, color: textColor,),
                        TextField(maxLines: 1,
                          enabled: false,
                          controller: phoneController,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'PHONE NUMBER'),
                        ),
                        const Divider(thickness: 1, color: textColor,),
                        TextField(maxLines: 1,
                          enabled: false,
                          controller: genderController,
                          decoration: InputDecoration( border: InputBorder.none,labelText: 'GENDER'),
                        ),

                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10,color: primaryColor,),
                    const Text(" PERSONAL INFORMATION", style: TextStyle(color: textColor)),
                  ],
                ),
                const SizedBox(height: 20),
                Text("DISPLAY NAME", style: TextStyle(color: textColor)),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(0), elevation: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(maxLines: 1, keyboardType: TextInputType.text,
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("FATHER NAME", style: TextStyle(color: textColor)),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(0), elevation: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(maxLines: 1, keyboardType: TextInputType.text,
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("DOB", style: TextStyle(color: textColor)),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(0), elevation: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(maxLines: 1, keyboardType: TextInputType.text,
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("JOB DESCRIPTION", style: TextStyle(color: textColor)),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(0), elevation: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(maxLines: 1, keyboardType: TextInputType.text,
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("OCCUPATION", style: TextStyle(color: textColor)),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(0), elevation: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(maxLines: 1, keyboardType: TextInputType.text,
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("ADDITIONAL RESPONSIBILITIES", style: TextStyle(color: textColor)),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(0), elevation: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(enabled: false, maxLines: 1, keyboardType: TextInputType.text, controller: addRespController,
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("ADD. RES. TYPE", style: TextStyle(color: textColor)),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(0), elevation: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(enabled: false, maxLines: 1, keyboardType: TextInputType.text, controller: addRespTypeController,

                      decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("LANDLINE", style: TextStyle(color: textColor)),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(0), elevation: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(maxLines: 1, keyboardType: TextInputType.phone,
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("CITY", style: TextStyle(color: textColor)),
                          Container(height: 5),
                          Card(
                            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            margin: EdgeInsets.all(0), elevation: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              height: 40,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: <Widget>[
                                  Container(width: 15),
                                  Expanded(
                                    child: TextFormField(maxLines: 1, keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(-12), border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("COUNTRY", style: TextStyle(color: textColor)),
                          Container(height: 5),
                          Card(
                            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            margin: EdgeInsets.all(0), elevation: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              height: 40,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(maxLines: 1, keyboardType: TextInputType.phone,
                                decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Text("PASSWORD", style: TextStyle(color: textColor)),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(0), elevation: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      obscureText: _isObscure,
                      maxLines: 1, keyboardType: TextInputType.text,
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("CONFIRM PASSWORD", style: TextStyle(color: textColor)),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(0), elevation: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      obscureText: _isObscure,
                      maxLines: 1, keyboardType: TextInputType.text,
                      decoration: InputDecoration( contentPadding: EdgeInsets.all(-12),border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity, height: 45,
                  child: ElevatedButton(
                    child: Text("SUBMIT", style: TextStyle(color: Colors.white)),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

