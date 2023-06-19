import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email, password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff21254A),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
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
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              try {
                                var userResult = await firebaseAuth
                                    .createUserWithEmailAndPassword(
                                        email: email, password: password);
                                formKey.currentState!.reset();
                                Get.snackbar("İşlem Başarılı",
                                    "Hesap oluşturulmuştur. Giriş sayfasına yönlendiriliyorsunuz",
                                    backgroundColor: Colors.blue.shade100,
                                    icon: const Icon(Icons.check));
                                Navigator.pushReplacementNamed(
                                    context, "/loginPage");
                              } catch (e) {
                                Get.snackbar("Uyarı",
                                    "Bu hesap zaten mevcut.",
                                    backgroundColor: Colors.red.shade200,
                                    icon: const Icon(Icons.error));
                              }
                            }
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
                                "Hesap oluştur",
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
                              Navigator.pushNamed(context, "/loginPage"),
                          child: Text("Giriş sayfasına geri dön",
                              style: TextStyle(color: Colors.pink[200])),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
}
