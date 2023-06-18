
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otobus/favoriOtobus.dart';
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
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
       drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                    color: Color(0xff21254A),
                    image: DecorationImage(
                      image: AssetImage("assets/images/bus.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                child: Container(

                ),
                  ),
                //myDrawerItem(Icons.credit_card, Colors.blue, "Kart Dolum Merkezleri"),
                //myDrawerItem(Icons.add_alert_sharp, Colors.blue, "Alarm Yönetimi"),

                myDrawerItem(Icons.watch_later_outlined, Colors.blue, "Hareket Saatleri", "/hareketSaatleri"),
                Divider(
                  thickness: 1,
                  color: Colors.grey.shade500,
                ),
                myDrawerItem(Icons.shopping_bag,Colors.amber, "Kayıp Eşya Bildir", "/kayipEsya"),
                  Divider(
                  thickness: 1,
                  color: Colors.grey.shade500,
                ),

                myDrawerItem(Icons.location_on, Colors.deepOrange, "Haritada konumumu göster", "/googleMap")

            ],
          ),
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
            ElevatedButton(onPressed: () => Get.to(const favoriOtobus()), child: const Text("Favori Otobüsler")),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
                itemCount: items.length,
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
                            "Otobüs İsmi: " + items[index],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.off(otobusBilgi(
                        oismi: items[index], gelenSayfa: false));
                  },
                );
                }),

          ],
        ),
      ),
    );
  }
  Widget myDrawerItem(IconData icon, MaterialColor color, String title, String routeName)=> ListTile(
    leading: Icon(icon, color: color),
    title: Text(title), textColor: color,
    onTap: () {
      _scaffoldKey.currentState?.openEndDrawer();
      Navigator.pushNamed(context, routeName);
    }
  );
}
// return InkWell(
//                     onTap: () {
//                       Get.off(otobusBilgi(oismi: items[index],gelenSayfa: false,));
//                       //print(items);
//                     },
//                     child: ListTile(
//                       title: Text(items[index]),
//                     ),
//                   );

