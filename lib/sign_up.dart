import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Color(0xff21254A),
      body: SingleChildScrollView(
        child: Form(
          key : formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: height * .25,
                  decoration: BoxDecoration(
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
                      Text("Merhaba, \nHoşgeldiniz", style: TextStyle(fontSize: 30,
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold),
                      ),
                      customSizedBox(),
                      TextFormField(
                        validator: (value){
                          if (value!.isEmpty) {
                            return "Bilgileri eksiksiz doldurunuz";
                          }
                          else {

                          }
                        },
                        onSaved: (value) {
                          email = value!;
                        },
                        decoration: customInputDecoration("Email"),
                        style: TextStyle(color: Colors.white),
                      ),
                      customSizedBox(),
                      TextFormField(
                        validator: (value){
                          if (value!.isEmpty) {
                            return "Bilgileri eksiksiz doldurunuz";
                          }
                          else {

                          }
                        },
                        onSaved: (value) {
                          password = value!;
                        },
                        obscureText: true,
                        decoration: customInputDecoration("Şifre"),
                        style: TextStyle(color: Colors.white),
                      ),
                      customSizedBox(),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              try {
                                var userResult = await firebaseAuth.createUserWithEmailAndPassword(
                                    email: email, password: password);
                                formKey.currentState!.reset();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Hesap oluşturuldu, giriş sayfasına yönlendiriliyorsunuz.")
                                    ),
                                );
                                Navigator.pushReplacementNamed(context, "/loginPage");
                              }
                              catch (e){
                                print(e.toString());
                              }
                            }
                            else {

                            }
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            margin: EdgeInsets.symmetric(horizontal: 60),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xff31274F),
                            ),
                            child: Center(
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
                          onPressed: () => Navigator.pushNamed(context, "/loginPage"),
                          child: Text(
                            "Giriş sayfasına geri dön",
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

  Widget customSizedBox()=>SizedBox(
    height: 20,
  );

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            )
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            )
        )
    );
  }
}
