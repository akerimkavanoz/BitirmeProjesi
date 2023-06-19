import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Kayip_Esya extends StatefulWidget {
  const Kayip_Esya({super.key});

  @override
  State<Kayip_Esya> createState() => _Kayip_EsyaState();
}

class _Kayip_EsyaState extends State<Kayip_Esya> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();

  yaziEkle() {
    _firestore.collection("kayipEsya").doc().set(
        {'tc': t1.text, 'tel': t2.text, 'email': t3.text, 'mesaj': t4.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Kayıp Eşya Bildir",
            style: TextStyle(fontWeight: FontWeight.normal)),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xff21254A)),
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(children: [
              // myTextFild("TC Kimlik", text2: "Zorunlu Alan", length: 11),
              // myTextFild("Tel No", text2: "Zorunlu Alan"),
              // myTextFild("E-Mail Adres"),
              // myTextFild("Mesajınızı giriniz", text2: "Zorunlu Alan", vert: 70),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    myRow("TC Kimlik", "Zorunlu Alan"),
                    sizedBox(8),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: t1,
                      validator: (value) {
                        if (value!.isEmpty || value.length != 11) {
                          return '11 haneli kimlik numaranızı giriniz.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        t1.text = value!;
                      },
                      decoration: customDecoration(),
                      maxLength: 11,
                    ),
                    sizedBox(15),
                    myRow("Tel No", "Zorunlu Alan"),
                    sizedBox(8),
                    // TextFormField(
                    //   keyboardType: TextInputType.number,
                    //   controller: t2,
                    //   validator: (value) {
                    //     if (value!.isEmpty || value.length != 11) {
                    //       return '11 haneli telefon numaranızı giriniz.';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) {
                    //     t2.text = value!;
                    //   },
                    //   decoration: customDecoration(),
                    //   maxLength: 11,
                    // ),
                    IntlPhoneField(
                      controller: t2,
                      decoration: customDecoration(),
                      initialCountryCode:
                          'TR', // Başlangıçta Türkiye ülke kodunu ayarlar
                    ),
                    sizedBox(15),
                    myRow("E-Mail Adres", "Zorunlu Alan"),
                    sizedBox(8),
                    TextFormField(
                      controller: t3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Bu alan boş bırakılamaz";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        t3.text = value!;
                      },
                      decoration: customDecoration(),
                    ),
                    sizedBox(15),
                    myRow("Mesajınızı giriniz", "Zorunlu Alan"),
                    sizedBox(8),
                    TextFormField(
                      controller: t4,
                      maxLines: 10,
                      textAlignVertical: TextAlignVertical.top,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Bu alan boş bırakılamaz";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        t4.text = value!;
                      },
                      decoration: customDecoration(),
                    ),
                    sizedBox(8)
                  ],
                ),
              ),
              _text,
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //print("a");
                    yaziEkle();
                    Get.snackbar("İşlem Başarılı",
                        "Kayıp eşya bildiriminiz gönderilmiştir.",
                        backgroundColor: Colors.blue.shade100,
                        icon: const Icon(Icons.check));
                  }
                },
                child: const Text("Gönder"),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  InputDecoration customDecoration({double vert = 15}) {
    return InputDecoration(
      contentPadding: EdgeInsets.only(bottom: vert, left: 8, top: 8),
      counterText: "",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  /*
  Widget myTextFild(String text1, {String text2="", int length=100, double vert=15}) => 
    Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text1.toString(), style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text(text2.toString(), style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        Form(
          key: _formKey,
          child: TextFormField(
            key: _formKey,
            validator: (value) {
              if (value!.isEmpty) {
                return "Bu alan boş bırakılamaz";
              }
              return null;
            },
            maxLength: length,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: vert),
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            
          ),
        ),
        const SizedBox(height: 15),
      ],
      ); */
  Widget myRow(String text1, String text2) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text1.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          Text(text2.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      );

  Widget sizedBox(double height) => SizedBox(
        height: height,
      );
  Widget get _text => const Text(
      "Lütfen eşyanızı unuttuğunuz araç bilgilerini ve eşyanızın özelliklerini belirtiniz.",
      style: TextStyle(color: Colors.white, fontSize: 14));
}
