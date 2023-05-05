import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class otobusBilgi extends StatefulWidget {
  const otobusBilgi({super.key});

  @override
  State<otobusBilgi> createState() => _otobusBilgiState();
}

class _otobusBilgiState extends State<otobusBilgi> {
  final Stream<QuerySnapshot> _otobusler = FirebaseFirestore.instance.collection('otobusler').snapshots();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff21254A),
        title: const Text("Otobüs Bilgisi"),
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
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            
              return ListTile(
                title: Text('Otobüs İsmi: '+data['otobusismi']),
                subtitle: Text("Kişi Sayısı: ${data['kisisayisi']}"),
                trailing: Column(children: [
                  Text("Plaka: ${data['plaka']}"),
                  Text("Konum: ${data['konum']}")
                ]),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}