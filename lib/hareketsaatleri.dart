import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobus/saatler.dart';

class hareketSaatleri extends StatefulWidget {
  const hareketSaatleri({super.key});

  @override
  State<hareketSaatleri> createState() => _hareketSaatleriState();
}

class _hareketSaatleriState extends State<hareketSaatleri> {
  late final List<dynamic> duplicateItems = [];
  late final List<String> dizi = [];
  TextEditingController editingController = TextEditingController();
  var ref = FirebaseFirestore.instance.collection('hatlar');

  _incerementCounter() async {
    var allDocs = await ref.get();
    var response = allDocs.docs;
    if (duplicateItems.isEmpty) {
      for (var doc in response) {
        duplicateItems.add(doc.data()['id'] + " " + doc.data()['konum']);
        //print(doc.data()['konum']);
      }
    }
  }

  List<dynamic> items = [];

  @override
  void initState() {
    _incerementCounter().then((_) {
      setState(() {
        items.addAll(duplicateItems);
      });
    });
    super.initState();
  }

  // void filterSearchResults(String query) {
  //   List<String> dummySearchList = <String>[];
  //   dummySearchList.addAll(duplicateItems);

  //   if (query.isNotEmpty) {
  //     List<String> dummyListData = <String>[];
  //     for (var item in dummySearchList) {
  //       if (item.contains(query)) {
  //         dummyListData.add(item);
  //       }
  //     }
  //     setState(() {
  //       items.clear();
  //       items.addAll(dummyListData);
  //       print(items);

  //     });
  //     return;
  //   } else {
  //     setState(() {
  //       items.clear();
  //       items.addAll(duplicateItems);

  //        print(items);
  //     });
  //   }
  // }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      for (var item in duplicateItems) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text("HAT SEÇİNİZ"),
      ),
      body: Container(
        color: const Color(0xff21254A),
        height: heigth,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 20, top: 10),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Hat Ara",
                  prefixIcon: const Icon(Icons.search),
                  counterText: "",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    String a = items[index];
                    String b = a.substring(0, a.indexOf(" "));
                    print("giden$b");
                    Get.to(() => saatler(id: b));
                  },
                  child: ListTile(
                    leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/bus0.png')),
                    title: Text(
                      items[index],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const Divider(thickness: 3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
