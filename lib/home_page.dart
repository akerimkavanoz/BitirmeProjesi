import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController editingController = TextEditingController();
  final duplicateItems = ["g4","k4","b2a"];
  var items = <String>[];

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchReslut(String query) {
    List<String> dummySearchList = <String>[];
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
        title: Text(widget.title),
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
                  return ListTile(
                    title: Text(items[index]),
                  );
                })
          ],
        ),
      ),
    );
  }
}

