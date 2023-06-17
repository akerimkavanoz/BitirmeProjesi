import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otobus/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff21254A),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * .25,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/topImage.png"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Merhaba, \nHoşgeldiniz",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      customSizedBox(),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Bilgileri eksiksiz doldurunuz";
                          } else {}
                          return null;
                        },
                        onSaved: (value) {
                          email = value!;
                        },
                        decoration: customInputDecoration("Email"),
                        style: const TextStyle(color: Colors.white),
                      ),
                      customSizedBox(),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Bilgileri eksiksiz doldurunuz";
                          } else {}
                          return null;
                        },
                        onSaved: (value) {
                          password = value!;
                        },
                        obscureText: true,
                        decoration: customInputDecoration("Şifre"),
                        style: const TextStyle(color: Colors.white),
                      ),
                      customSizedBox(),
                      Center(
                        child: TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, "/resetPassword"),
                            child: Text(
                              "Şifremi Unuttum",
                              style: TextStyle(color: Colors.pink[200]),
                            )),
                      ),
                      customSizedBox(),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              try {
                                final userResult = await firebaseAuth
                                    .signInWithEmailAndPassword(
                                        email: email, password: password);

                                Navigator.pushReplacementNamed(
                                    context, "/homePage");
                                await _firestore
                                    .collection('kullanıcılar')
                                    .doc(userResult.user!.uid)
                                    .set({'userID': userResult.user!.uid});
                              } catch (e) {
                                print(e.toString());
                              }
                            } else {}
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 60),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xff31274F),
                            ),
                            child: const Center(
                              child: Text(
                                "Giriş Yap",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      customSizedBox(),
                      Center(
                        child: TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, "/signUp"),
                            child: Text(
                              "Hesap oluştur",
                              style: TextStyle(color: Colors.pink[200]),
                            )),
                      ),
                      Center(
                          child: ElevatedButton(
                        onPressed: () {
                          signInWithGoogle();
                        },
                        child: const Text('Google ile giriş'),
                      ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customSizedBox() => const SizedBox(
        height: 20,
      );

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
        )),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
        )));
  }

  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);

    if (userCredential.user != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage()));
      await _firestore
          .collection('kullanıcılar')
          .doc(userCredential.user!.uid)
          .set({'userID': userCredential.user!.uid});
    }
  }
}
