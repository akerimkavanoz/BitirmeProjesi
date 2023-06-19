import 'package:flutter/material.dart';

class odeme extends StatefulWidget {
  const odeme({super.key});

  @override
  State<odeme> createState() => _odemeState();
}

class _odemeState extends State<odeme> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  String? a;
  List<String> initialValue = ['50 TL', '100 TL', '150 TL', '200 TL'];
  String copyValue = '';

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Karta Para Yükleme"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Kartınıza yüklemek istediğiniz tutarı giriniz'),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          setState(() {
                              copyValue = initialValue[index];
                          });
                        },
                        child: SizedBox(
                          width: 75,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            initialValue: initialValue[index],
                            enabled: false,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _textEditingController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Diğer Tutar',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        newValue =  "${_textEditingController.text} TL";
                        a = newValue;
                      });
                     
                    },
                  ),
                  const SizedBox(height: 20),
                  textField('Ulasim karti numarasini giriniz'),
                  const SizedBox(height: 20),
                  textField('Ad Soyad giriniz'),
                  const SizedBox(height: 20),
                  const Text(
                    'Kredi Kartı Bilgileri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: const InputDecoration(
                      counterText: "",
                      labelText: 'Kart Numarasi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    maxLength: 16,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cvvController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            labelText: 'CVV',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showExpiryDatePicker();
                          },
                          child: TextFormField(
                            controller: _expiryDateController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              labelText: 'Son Kullanma Tarihi',
                            ),
                            readOnly: true,
                            onTap: () {
                              _showExpiryDatePicker();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Image.asset('assets/images/visa.jpg'),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.orange),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _textEditingController.text.isEmpty
                                  ? copyValue
                                  : a.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width:20),
                            const Text(
                              'Bakiye Yükle',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField textField(String text) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: text,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Future<void> _showExpiryDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (pickedDate != null) {
      final month = pickedDate.month;
      final year = pickedDate.year % 100;

      setState(() {
        _expiryDateController.text = '$month/$year';
      });
    }
  }
}
