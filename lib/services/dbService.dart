import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frozen_food/model/cart.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final uid = user!.uid;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
CollectionReference _cart = _firestore.collection('cart');
CollectionReference cart = _firestore.collection('checkout').doc(uid.toString()).collection('keranjang');
CollectionReference users = _firestore.collection('users');

class Database {
  static Future<void> publishCart({required Cart item}) async {
    print(uid);

    DocumentReference docRef = cart.doc(item.name);
    var doc = await cart.doc(item.name).get();
    if (doc.exists) {
      await docRef
          .update(item.toJson())
          .whenComplete(() => print('Data berhasil diubah'))
          .catchError((e) => print(e));
    } else {
      await docRef
          .set(item.toJson())
          .whenComplete(() => print('Data berhasil ditambahkan'))
          .catchError((e) => print(e));
    }
  }
  static Future<void> deleteCart({required String name}) async {
    DocumentReference docRef = cart.doc(name);
    await docRef
        .delete()
        .whenComplete(() => print('Data berhasil dihapus'))
        .catchError((e) => print(e));
  }
  static Stream<QuerySnapshot> getCheckout() {
    return cart.snapshots();
  }
  static Stream<QuerySnapshot> getUser() {
    return users.snapshots();
  }



  static Stream<QuerySnapshot> getCart() {
    return _cart.snapshots();
  }

  //add OR update
  static Future<void> tambahCart({required Cart item}) async {
    DocumentReference docRef = _cart.doc(item.name);
    var doc = await _cart.doc(item.name).get();
    if (doc.exists) {
      print('item: ${item.toJson()}');
      await docRef
          .update(item.toJson())
          .whenComplete(() => print('Data berhasil diubah'))
          .catchError((e) => print(e));
    } else {
      print('item: ${item.toJson()}');
      await docRef
          .set(item.toJson())
          .whenComplete(() => print('Data berhasil ditambahkan'))
          .catchError((e) => print(e));
    }
  }

  static Future<void> hapusCart({required String name}) async {
    DocumentReference docRef = _cart.doc(name);
    await docRef
        .delete()
        .whenComplete(() => print('Data berhasil dihapus'))
        .catchError((e) => print(e));
  }
  // static Future<void> ubahCart({required Cart item}) async {
  //   DocumentReference docRef = _cart.doc(item.name);
  //   await docRef
  //       .update(item.toJson())
  //       .whenComplete(() => print('Data berhasil diubah'))
  //       .catchError((e) => print(e));
  // }

}
