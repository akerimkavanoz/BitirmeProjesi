
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otobus/googlemap.dart';
import 'package:otobus/otobusbilgi.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late final List<dynamic> duplicateItems = [];
  //final Stream<QuerySnapshot> _otobusler = FirebaseFirestore.instance.collection('otobusler').snapshots();
  var ref = FirebaseFirestore.instance.collection('otobusler');

  _incerementCounter() async {
    var allDocs = await ref.get();
    for (var element in allDocs.docs) {duplicateItems.add(element.id);}
    //print(docID);
    //duplicateItems.add(docID);
  }

  TextEditingController editingController = TextEditingController();
  
  var items = [];

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
    _incerementCounter();
  }
  void filterSearchReslut(String query) {
    List dummySearchList = [];
    dummySearchList.addAll(duplicateItems);

    if(query.isNotEmpty)
      {
        List<String> dummyListData = <String>[];
        for (var item in dummySearchList) {
          if(item.contains(query))
            {
              dummyListData.add(item);
            }
        }
        setState(() {
          items.clear();
          items.addAll(dummyListData);
        });
        return;
      }
    else
      {
        setState(() {
          items.clear();
          items.addAll(duplicateItems);
        });
      }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () async{
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, "/loginPage");
          }, icon: const Icon(Icons.power_settings_new)
      )],
        backgroundColor: const Color(0xff21254A),
        title: const Text("Arama"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            TextField(
              onChanged: (value){
                filterSearchReslut(value);
              },
              controller: editingController,
              decoration: const InputDecoration(
                labelText: "Otobüs/Durak Arama",
                hintText: "Aramak için yazınız",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))
                )
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(otobusBilgi(oismi: items[index],));
                      //print(items);
                    },
                    child: ListTile(
                      title: Text(items[index]),
                    ),
                  );
                }),
                ElevatedButton(onPressed: () => Get.to(googleMap()), child: const Text("Haritada konumumu göster")),
          ],
        ),
      ),
    );
  }
}

