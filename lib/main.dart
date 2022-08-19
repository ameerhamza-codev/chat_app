import 'package:chat_app/provider/audio_provider.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:chat_app/provider/user_data_provider.dart';
import 'package:chat_app/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDataProvider>(
          create: (_) => UserDataProvider(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider<AudioProvider>(
          create: (_) => AudioProvider(),
        ),
      ],
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),

    );
  }
}
