import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobus/otobusbilgi.dart';

class favoriOtobus extends StatefulWidget {
  const favoriOtobus({super.key});

  @override
  State<favoriOtobus> createState() => _favoriOtobusState();
}

class _favoriOtobusState extends State<favoriOtobus> {
  final List<dynamic> duplicateItems = [];

  favOtobus() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String userID = "";
    if (user != null) {
      userID = user.uid;
    }

    var ref = FirebaseFirestore.instance
        .collection('kullanıcılar')
        .doc(userID)
        .collection('favoriOtobus');
    var allDocs = await ref.get();
    var response = allDocs.docs;

    if (duplicateItems.isEmpty) {
      for (var doc in response) {
        duplicateItems.add(doc.data()['otobusismi']);
      }
    }
    setState(() {
      
    });
    
  }
  @override
  void initState() {
    favOtobus();
    super.initState();
  }

  @override
  void didUpdateWidget(favoriOtobus oldWidget) {
    favOtobus();
    if (oldWidget != widget) {
      setState(() {
        duplicateItems.clear();
        favOtobus();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Favori Otobüsler"),
      ),
      body: Center(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
                itemCount: duplicateItems.length,
                itemBuilder: (context, index) {
                  return InkWell(
                  child: SizedBox(
                    height: 80,
                    width: double.maxFinite,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/bus0.png')),
                          const SizedBox(width: 20),
                          Text(
                            "Otobüs İsmi: " + duplicateItems[index],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.off(otobusBilgi(
                        oismi: duplicateItems[index], gelenSayfa: true));
                  },
                );
                }),
          ],)),
    );
  }
}
