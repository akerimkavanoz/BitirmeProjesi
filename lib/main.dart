import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:otobus/home_page.dart';
import 'package:otobus/login_page.dart';
import 'package:otobus/reset_password.dart';
import 'package:otobus/sign_up.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        "/loginPage" : (context) => const LoginPage(),
        "/signUp" : (context) => const SignUp(),
        "/homePage" : (context) => const HomePage(title: 'Arama'),
        "/resetPassword" : (context) => const ResetPassword(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: //const LoginPage()
      StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasError)
          {
            return Text(snapshot.error.toString());
          }

          if(snapshot.connectionState==ConnectionState.active)
          {
            if(snapshot.data == null)
            {
              return const LoginPage();
            }
            else
            {
              return const HomePage(title: 'Arama');
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      )); 
  }
}
