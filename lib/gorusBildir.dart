import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class gorusBildir extends StatefulWidget {
  const gorusBildir({super.key});

  @override
  State<gorusBildir> createState() => _gorusBildirState();
}

class _gorusBildirState extends State<gorusBildir> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();

  yaziEkle() {
    _firestore.collection("gorusBildir").doc().set(
        {'tc': t1.text, 'tel': t2.text, 'email': t3.text, 'mesaj': t4.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Görüş/Öneri Bildir",
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    myRow("TC Kimlik", "Zorunlu Alan"),
                    sizedBox(8),
                    TextFormField(
                      controller: t1,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Bu alan boş bırakılamaz";
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
                    TextFormField(
                      controller: t2,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Bu alan boş bırakılamaz";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        t2.text = value!;
                      },
                      decoration: customDecoration(),
                      maxLength: 11,
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
                    ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("İşlem başarılı")
                                    ),
                                );
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
      "Şikayet iletmek için; \n\n -Hat adı \n -Sefer saati \n -Araç plakası \n -Durak adı \n\n gibi bilgileri doğru olarak yazdığınızdan lütfen emin olunuz. ",
      style: TextStyle(color: Colors.white, fontSize: 14));
}
