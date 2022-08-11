import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 3 ;


  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var duration = Duration(seconds: splashDelay);
    return Timer(duration, navigationPage);
  }

  void navigationPage() async{

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder:(context) => const Login()));

  }

  @override
  Widget build(BuildContext context) {
    Size _size= MediaQuery.of(context).size;

    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: colorWhite,
      body: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        child:Image.asset('assets/images/splash.png',height: _size.width> 756 ?_size.height: height,width: width,fit: _size.width> 756 ? BoxFit.fitHeight: BoxFit.cover,),

      ),
    );
  }
}

