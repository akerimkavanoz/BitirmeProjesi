import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late String email;
  final formKey = GlobalKey<FormState>();
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Form(
                    key: formKey,
                    child: Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          
                          children: [
                          IconButton(onPressed: (){Navigator.pushReplacementNamed(context, "/loginPage");}, icon: const Icon(Icons.arrow_back) , color: Colors.white, alignment: Alignment.bottomLeft ,),
                        const Text("Şifremi Unuttum", style: TextStyle(fontSize: 30,
                            color: Colors.white,
                            fontWeight:
                            FontWeight.bold),
                        ),
                        ],),
                       
                        customSizedBox(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 10),
                          child: TextFormField(
                            validator: (value){
                              if (value!.isEmpty) {
                                return "Bilgileri eksiksiz doldurunuz";
                              }
                              else {
                          
                              }
                              return null;
                            },
                            onSaved: (value) {
                              email = value!;
                            },
                            decoration: customInputDecoration("Email"),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        customSizedBox(),                              
                        Center(
                          child: TextButton(
                            onPressed: () async {
                            
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
                                  "Şifreyi sıfırla",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),

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
}

InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        )
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        )
      )
    );
  }

 Widget customSizedBox()=>const SizedBox(
     height: 20,
   );
