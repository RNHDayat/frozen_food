import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frozen_food/screen/cart/cartPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailBayar extends StatefulWidget {
  final String? kota_asal;
  final String? berat;
  final String? kota_tujuan;
  final String? kurir;

  DetailBayar({this.kota_asal, this.kota_tujuan, this.berat, this.kurir});

  @override
  State<DetailBayar> createState() => _DetailBayarState();
}

class _DetailBayarState extends State<DetailBayar> {
  List _data = [];
  var key = '4ef4c3f10a95314afbd9e3ed3b8dd7b9';

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://api.rajaongkir.com/starter/cost",
        ),
        //MENGIRIM PARAMETER
        body: {
          "key": key,
          "origin": '444',
          "destination": widget.kota_tujuan,
          "weight": '1',
          "courier": widget.kurir
        },
      ).then((value) {
        var data = jsonDecode(value.body);

        setState(() {
          _data = data['rajaongkir']['results'][0]['costs'];
          print(_data);
        });
      });
    } catch (e) {
      //ERROR
      print(e);
    }
  }

  saveOngkir(String service, int ongkir) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('service', service);
    prefs.setInt('ongkir', ongkir);
    int? a = prefs.getInt('ongkir');
    print(a);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Cek Ongkir"),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, index) {
          return Card(
            child: ListTile(
              onTap: () {
                saveOngkir(
                  _data[index]['service'],
                  _data[index]['cost'][0]['value'],
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
                Fluttertoast.showToast(
                    msg: "Anda telah memilih : ${_data[index]['service']}");
                // print(_data[index]['cost'][0]['value'].runtimeType);
              },
              title: Text("${_data[index]['service']}"),
              subtitle: Text("${_data[index]['description']}"),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Rp ${_data[index]['cost'][0]['value']}",
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text("${_data[index]['cost'][0]['etd']} Days")
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
