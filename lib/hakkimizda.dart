import 'package:flutter/material.dart';

class hakkimizda extends StatefulWidget {
  const hakkimizda({super.key});

  @override
  State<hakkimizda> createState() => _hakkimizdaState();
}

class _hakkimizdaState extends State<hakkimizda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff21254A),
      appBar: AppBar(
        title: const Text("Hakkımızda"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Container(
          child: const Text(
            "Bu uygulama Erzurum Teknik Üniversitesi Bilgisayar Mühendisliği Bitirme Projesi kapsamında Abdulkerim Kavanoz tarafından yapılmıştır.",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
