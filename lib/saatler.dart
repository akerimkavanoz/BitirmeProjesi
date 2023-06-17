import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class saatler extends StatefulWidget {
  final String id;
  const saatler({super.key, required this.id});

  @override
  State<saatler> createState() => _saatlerState();
}

class _saatlerState extends State<saatler> {
  List<DataRow> dataRows = [];
  List<TableRow> tableRows = [];
  List<String> haftaiciData = [];
  List<String> haftasonuData = [];
  bool iconState = false;
  toggleIconState() {
    setState(() {
      iconState = !iconState;
      if (iconState == false) {
        test('haftaici', 'kalkis1');
        test('haftasonu', 'kalkis1');
      } else {
        test('haftaici', 'kalkis2');
        test('haftasonu', 'kalkis2');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    test('haftaici', 'kalkis1');
    test('haftasonu', 'kalkis1');

    //toggleIconState();
  }

  Future<String> getFieldValue() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('hatlar')
          .doc(widget.id)
          .get();
      if (iconState == false) {
        if (snapshot.exists) {
          var data = snapshot.data() as Map<String, dynamic>;
          var a = data['id']+" "+data['konum'];
          var fieldValue = data['konum'];
          //print(fieldValue);
          return "${a.toString()} \n ${fieldValue.toString()}";
        } else {
          return 'Belge bulunamadı';
        }
      } else {
        if (snapshot.exists) {
          var data = snapshot.data() as Map<String, dynamic>;
          var fieldValue = data['konum2'];
          var a = data['id']+" "+data['konum'];
          //print(fieldValue);
         return "${a.toString()} \n ${fieldValue.toString()}";
        } else {
          return 'Belge bulunamadı';
        }
      }
    } catch (e) {
      print('Hata: $e');
      return 'Hata oluştu';
    }
  }

  test(String hafta, String yon) async {
    DocumentSnapshot ref = await FirebaseFirestore.instance
        .collection('hatlar')
        .doc(widget.id)
        .collection('konum')
        .doc(hafta)
        .collection(yon)
        .doc('saatler')
        .get();
    
    var veri = ref.data();
    print("gelen${widget.id}");
    Map<String, dynamic>? data = ref.data() as Map<String, dynamic>?;

    if (data != null) {
      List<String> rowData = [];
      data.forEach((key, value) {
        rowData.add(value.toString());
      });

      if (hafta == 'haftaici') {
        haftaiciData = rowData;
      } else if (hafta == 'haftasonu') {
        haftasonuData = rowData;
      }

      // Tabloyu güncelle
      updateTable();
    }
  }

  void updateTable() {
    tableRows.clear();

    int maxLength = haftaiciData.length > haftasonuData.length
        ? haftaiciData.length
        : haftasonuData.length;

    for (int i = 0; i < maxLength; i++) {
      String haftaiciValue = i < haftaiciData.length ? haftaiciData[i] : '';
      String haftasonuValue = i < haftasonuData.length ? haftasonuData[i] : '';

      TableRow row = TableRow(children: [
        TableCell(child: Center(child: Text(haftaiciValue))),
        TableCell(child: Center(child: Text(haftasonuValue))),
      ]);

      tableRows.add(row);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
            future: getFieldValue(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Hata: ${snapshot.error}');
              } else {
                return Text(snapshot.hasData? "${snapshot.data} KALKIŞ": 'Veri bulunamadı' );
              }
            }, 
          ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.change_circle,
              size: 40,
            ),
            onPressed: () {
              toggleIconState();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'Hafta İçi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'Hafta Sonu',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            for (int i = 0;
                i < haftaiciData.length || i < haftasonuData.length;
                i++)
              TableRow(
                children: [
                  TableCell(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        i < haftaiciData.length ? haftaiciData[i] : '',
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        i < haftasonuData.length ? haftasonuData[i] : '',
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),

      // body: Center(
      //   child: Container(
      //     child: Column(
      //       children: [
      //         ElevatedButton(
      //             onPressed: () {
      //               test('haftaici', 'kalkis1');
      //               test('haftasonu', 'kalkis1');
      //             },
      //             child: const Text("deneme")),
      //       ],
      //     ),
      //   ),
      // ),
      //   body: SafeArea(
      //     child: FutureBuilder(
      //       future: test('haftaici', 'kalkis1'),
      //       builder: (context, snapshot) {
      //         return ListView.builder(
      //           itemCount: 2,
      //           itemBuilder: (context, index) =>
      //             DataTable(
      //               columnSpacing: 170,
      //               columns: const <DataColumn>[
      //                 DataColumn(
      //                   label: Expanded(
      //                     child: Text(
      //                       'Haftaiçi',
      //                       style: TextStyle(fontStyle: FontStyle.italic),
      //                     ),
      //                   ),
      //                 ),
      //                 DataColumn(
      //                   label: Expanded(
      //                     child: Text(
      //                       'Haftasonu',
      //                       style: TextStyle(fontStyle: FontStyle.italic),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //               rows: <DataRow>[
      //                 DataRow(
      //                   cells: <DataCell>[
      //                     DataCell(Text(test('haftaici', 'kalkis1')[index])),
      //                     const DataCell(Text('19')),
      //                   ],
      //                 ),
      //                 const DataRow(
      //                   cells: <DataCell>[
      //                     DataCell(Text('Janine')),
      //                     DataCell(Text('43')),
      //                   ],
      //                 ),
      //                 const DataRow(
      //                   cells: <DataCell>[
      //                     DataCell(Text('William')),
      //                     DataCell(Text('27')),
      //                   ],
      //                 ),
      //               ],
      //             ),

      //         );
      //       }
      //     ),
      //   ),
    );
  }

  Widget get _sizedBox => const SizedBox(
        width: 60,
      );
}
