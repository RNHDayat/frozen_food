import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frozen_food/model/cart.dart';
import 'package:frozen_food/services/dbService.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  String image, name, desc;
  int id, price;
  DetailPage({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.desc,
    required this.price,
  });

  @override
  State<DetailPage> createState() =>
      _DetailPageState(id, image, name, desc, price);
}

class _DetailPageState extends State<DetailPage> {
  String _image, _name, _desc;
  int _id, _price;
  _DetailPageState(
    this._id,
    this._image,
    this._name,
    this._desc,
    this._price,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userLogin();
    
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String? uid;
  void userLogin() async {
    final User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }
  
  int _jumlah = 0;
  
  saveCart() async {
    setState(() {
      _jumlah++;
    });
    final keranjang = Cart(
      id: _id,
      name: _name,
      image: _image,
      price: _price,
      jumlah: _jumlah,
      total: _price * _jumlah,
      userId: uid!,
    );
    Database.publishCart(item: keranjang);
    Fluttertoast.showToast(msg: "Berhasil Ditambahkan ke keranjang");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          top: true,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Hero(
                  tag: 'img${_image}',
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.image),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                              color: Colors.white54, shape: BoxShape.circle),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            color: Colors.white54, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.width - 50,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  // height: MediaQuery.of(context).size.height,
                  child: Container(
                    height: 1000,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Colors.white,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      _name,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      // textAlign: TextAlign.,
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade700,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: const Icon(
                                            Icons.star,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          child: const Text(
                                            "5",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "About",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              child: Text(
                                _desc,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  saveCart();
                                });
                              },
                              child: Container(
                                height: 50,
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child: const Text(
                                        "Beli",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: const Text(
                                        "|",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        'Rp. ${_price}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
