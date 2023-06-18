import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otobus/googlemap.dart';
import 'package:otobus/home_page.dart';
import 'package:otobus/login_page.dart';
import 'package:otobus/reset_password.dart';
import 'package:otobus/sign_up.dart';
import 'package:otobus/kayip_esya.dart';
import 'package:otobus/hareketsaatleri.dart';
import 'package:otobus/favoriOtobus.dart';
import 'package:otobus/gorusBildir.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,);
      //SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      await GetStorage.init();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      routes: {
        "/loginPage" : (context) =>  const LoginPage(),
        "/signUp" : (context) => const SignUp(),
        "/homePage" : (context) => const HomePage(),
        "/resetPassword" : (context) => const ResetPassword(),
        "/googleMap" : (context) => googleMap(),
        "/kayipEsya": (context) => const Kayip_Esya(), 
        "/hareketSaatleri": (context) => const hareketSaatleri(),
        "/favoriOtobus": (context) => const favoriOtobus(),
        "/gorusBildir": (context) => const gorusBildir()
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(color: Color(0xff21254A))
      ),
      home: //const otobusBilgi() 
      //googleMap()
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
              return  const LoginPage();
            }
            else
            {
              return const HomePage();
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ));  //const Home()
  }
}
