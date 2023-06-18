import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otobus/favoriOtobus.dart';
import 'package:otobus/home_page.dart';

class otobusBilgi extends StatefulWidget {
  final String oismi;
  final bool gelenSayfa;
  const otobusBilgi({
    Key? key,
    required this.oismi,
    required this.gelenSayfa,
  }) : super(key: key);

  @override
  State<otobusBilgi> createState() => _otobusBilgiState();
}

class _otobusBilgiState extends State<otobusBilgi> {
  late Stream<QuerySnapshot> _otobusler;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var ref = FirebaseFirestore.instance.collection('otobusler');
  final box = GetStorage();
  late RxBool isFavorite;

  @override
  void initState() {
    final User? user = FirebaseAuth.instance.currentUser;
    String userID = "";
    if (user != null) {
      userID = user.uid;
    }
    super.initState();
    isFavorite = RxBool(box.read(userID + widget.oismi) ?? false);

    _otobusler = ref.where('otobusismi', isEqualTo: widget.oismi).snapshots();
  }

  void setFavorite() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String userID = "";
    if (user != null) {
      userID = user.uid;
    }

    // var allDocs = await _firestore
    //     .collection('kullanıcılar')
    //     .doc(userID)
    //     .collection('favoriOtobus')
    //     .get();

    // var response = allDocs.docs;

    // for (var doc in response) {
    //   if (doc.data()['otobusismi'] == widget.oismi){
    //     isFavorite.value = true;
    //   }
    //   else {
    //     isFavorite.value = false;
    //   }

    // }

    if (isFavorite == false) {
      await _firestore
          .collection('kullanıcılar')
          .doc(userID)
          .collection('favoriOtobus')
          .doc(widget.oismi)
          .set({'otobusismi': widget.oismi});
      isFavorite.toggle();
      box.write(userID + widget.oismi, isFavorite.value);
    } else {
      await _firestore
          .collection('kullanıcılar')
          .doc(userID)
          .collection('favoriOtobus')
          .doc(widget.oismi)
          .delete();

      isFavorite.toggle();
      box.remove(userID + widget.oismi);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.gelenSayfa == false) {
              Get.off(const HomePage());
            } else {
              Get.off(const favoriOtobus());
            }
          },
        ),
        backgroundColor: const Color(0xff21254A),
        title: Text(widget.oismi),
        actions: [
          InkWell(
            child: Obx(() => isFavorite.value
                ? const Icon(
                    Icons.star,
                    size: 40,
                  )
                : const Icon(
                    Icons.star_border,
                    size: 40,
                  )),
            onTap: () {
              setFavorite();
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _otobusler,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Column(
                children: [
                  card("Otobüs ismi : ${ data['otobusismi']}", Icons.bus_alert),
                  card("Kişi sayısı : ${ data['kisisayisi']}", Icons.people_alt_sharp),
                  card("Konum : ${ data['konum']}", Icons.location_on),
                  card("Plaka : ${ data['plaka']}", Icons.format_list_numbered),
              ],);
              
            }).toList(),
          );
        },
      ),
    );
  }

  Widget card(String text, IconData icon) {
    return SizedBox(
      height: 80,
      width: double.maxFinite,
      child: Card(
        color: Colors.blue.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(icon),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// return ListTile(
//                 title: Text('Otobüs İsmi: ' + data['otobusismi']),
//                 subtitle: Text("Kişi Sayısı: ${data['kisisayisi']}"),
//                 trailing: Column(children: [
//                   Text("Plaka: ${data['plaka']}"),
//                   Text("Konum: ${data['konum']}"),
//                 ]),
//               );