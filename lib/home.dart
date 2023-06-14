import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(),
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
                myDrawerItem(Icons.shopping_bag,Colors.amber, "Kayıp Eşya Bildir", "/kayipEsya")
                
                
            ],
          ),
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