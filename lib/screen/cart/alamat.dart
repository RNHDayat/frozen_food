import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:frozen_food/screen/cart/detail_bayar.dart';
import 'kota.dart';

import 'package:http/http.dart' as http;

class Alamat extends StatefulWidget {
  const Alamat({super.key});

  @override
  State<Alamat> createState() => _AlamatState();
}

class _AlamatState extends State<Alamat> {
  var key = '4ef4c3f10a95314afbd9e3ed3b8dd7b9';
  var kota_tujuan;
  var kurir;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shipping",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            SizedBox(height: 20),
            DropdownSearch<kota>(
              //kamu bisa merubah tampilan field sesuai keinginan
              dropdownSearchDecoration: InputDecoration(
                labelText: "Kota Tujuan",
                hintText: "Pilih Kota Tujuan",
              ),

              //tersedia mode menu dan mode dialog
              mode: Mode.MENU,

              //jika kamu ingin menampilkan pencarian
              showSearchBox: true,

              //di dalam onchang3e kamu bisa set state
              onChanged: (value) {
                kota_tujuan = value?.cityId;
                print(kota_tujuan);
              },

              //kata yang akan ditampilkan setelah dipilih
              itemAsString: (item) => "${item!.type} ${item.cityName}",

              //find data from api
              onFind: (text) async {
                //get data from api
                var response = await http.get(Uri.parse(
                    "https://api.rajaongkir.com/starter/city?key=${key}"));

                //parse string json as dart string dynamic
                //get data just from results

                List allKota = (jsonDecode(response.body)
                    as Map<String, dynamic>)['rajaongkir']['results'];

                //store data to model
                var dataKota = kota.fromJsonList(allKota);

                //return data
                return dataKota;
              },
            ),
            const SizedBox(height: 20),
            // TextField(
            //   //input hanya angka
            //   keyboardType: TextInputType.number,
            //   decoration: const InputDecoration(
            //     labelText: "Berat Paket (gram)",
            //     hintText: "Input Berat Paket",
            //   ),
            //   onChanged: (text) {
            //     berat = text;
            //   },
            // ),
            // const SizedBox(height: 20),
            DropdownSearch<String>(
                mode: Mode.MENU,
                showSelectedItems: true,
                //pilihan kurir
                items: ["jne", "tiki", "pos"],
                dropdownSearchDecoration: const InputDecoration(
                  labelText: "Kurir",
                  hintText: "Kurir",
                ),
                popupItemDisabled: (String s) => s.startsWith('I'),
                onChanged: (text) {
                  kurir = text;
                }),
            const SizedBox(
              height: 300,
            ),
            GestureDetector(
              onTap: () {
                if (kota_tujuan == '' || kurir == '') {
                  final snackBar =
                      SnackBar(content: Text("Isi bidang yang masih kosong!"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  //berpindah halaman dan bawa data
                  Navigator.pushReplacement(
                    context,
                    // DetailPage adalah halaman yang dituju
                    MaterialPageRoute(
                      builder: (context) => DetailBayar(
                        kota_asal: 'Kota Surabaya',
                        kota_tujuan: kota_tujuan,
                        berat: '2',
                        kurir: kurir,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: Color.fromRGBO(89, 193, 190, 100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), //BoxShadow
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Cek Ongkir",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
