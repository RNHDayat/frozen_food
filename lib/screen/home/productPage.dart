// import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frozen_food/screen/home/detail_page.dart';
import 'package:hexcolor/hexcolor.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  HexColor primaryColor = HexColor('#CFF5E7');
  HexColor secondaryColor = HexColor('#A0E4CB');
  HexColor tertiaryColor = HexColor('#59C1BD');
  HexColor quaternaryColor = HexColor('#0D4C92');
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference product = firestore.collection('product');

    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: product.snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 250,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                id: snapshot.data!.docs[index]['id'],
                                image: snapshot.data!.docs[index]['image']
                                    .toString(),
                                name: snapshot.data!.docs[index]['name'],
                                desc: snapshot.data!.docs[index]['desc'],
                                price: snapshot.data!.docs[index]['price'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: tertiaryColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Hero(
                                  tag: 'img${snapshot.data!.docs[index]['id']}',
                                  child: Image.network(
                                    snapshot.data!.docs[index]['image'],
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Rp. ${snapshot.data!.docs[index]['price']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
