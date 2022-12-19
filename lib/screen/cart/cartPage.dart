import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frozen_food/model/cart.dart';
import 'package:frozen_food/screen/cart/alamat.dart';
import 'package:frozen_food/services/dbService.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _visible = true;
  bool _disable = true;
  int ongkir = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userLogin();
    getOngkir();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String? uid;
  void userLogin() async {
    final User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
      print(uid);
    });
  }

  getOngkir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('service');
    prefs.getInt('ongkir') == null
        ? ongkir = 0
        : ongkir = prefs.getInt('ongkir')!;
    // ongkir = prefs.getInt('ongkir')!;
  }

  HexColor primaryColor = HexColor('#CFF5E7');
  HexColor secondaryColor = HexColor('#A0E4CB');
  HexColor tertiaryColor = HexColor('#59C1BD');
  HexColor quaternaryColor = HexColor('#0D4C92');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        backgroundColor: tertiaryColor,
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back)),
        title: Text("Cart"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: tertiaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Alamat(),
                    ),
                  ),
                  title: Text(
                    'Alamat',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_circle_right, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: Database.getCheckout(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot item = snapshot.data!.docs[index];
                        return Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 70,
                                color: Colors.blue,
                                child: Image.network(
                                  item['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(item['name']),
                              subtitle: Text('Rp. ${item['total']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      int jumlah = item['jumlah'];

                                      setState(() {
                                        jumlah--;
                                      });
                                      final keranjang = Cart(
                                        id: item['id'],
                                        name: item['name'],
                                        image: item['image'],
                                        price: item['price'],
                                        jumlah: jumlah,
                                        total: item['price'] * jumlah,
                                        userId: uid!,
                                      );
                                      if (jumlah == 0) {
                                        Database.deleteCart(name: item['name']);
                                      } else {
                                        Database.publishCart(item: keranjang);
                                      }
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        color: quaternaryColor,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '-',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text('${item['jumlah']}'),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      int jumlah = item['jumlah'];
                                      setState(() {
                                        jumlah++;
                                      });
                                      final keranjang = Cart(
                                        id: item['id'],
                                        name: item['name'],
                                        image: item['image'],
                                        price: item['price'],
                                        jumlah: jumlah,
                                        total: item['price'] * jumlah,
                                        userId: uid!,
                                      );
                                      Database.publishCart(item: keranjang);
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        color: quaternaryColor,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '+',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      });
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: Database.getCheckout(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int total = 0;
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              total += int.parse(snapshot.data!.docs[i]['total'].toString());
            }
            if (total == 0) {
              ongkir = 0;
              _visible = false;
              _disable = false;
              print(ongkir);
            } else if (total != 0) {
              total += ongkir;
              _visible = true;
              _disable = true;
            }
            // print(total);
            return Container(
              padding: EdgeInsets.all(30),
              height: 180,
              decoration: BoxDecoration(
                color: tertiaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  children: [
                    Visibility(
                      visible: _visible,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ongkir :'),
                            Text('Rp. ${ongkir}'),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rp. ${total}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 75, //height of button
                          width: 150,
                          child: ElevatedButton(
                              onPressed: _disable
                                  ? () {
                                      print('yeay');
                                    }
                                  : null,
                              child: Text(
                                'Pay Now',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    quaternaryColor, //background color of button //border width and color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(20),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
