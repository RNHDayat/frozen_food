import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frozen_food/screen/login/welcome_pages.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _id = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _desc = TextEditingController();
  File? _pickedImage;
  HexColor primaryColor = HexColor('#CFF5E7');
  HexColor secondaryColor = HexColor('#A0E4CB');
  HexColor tertiaryColor = HexColor('#59C1BD');
  HexColor quaternaryColor = HexColor('#0D4C92');

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(msg: "Logout");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomePage(),
      ),
    );
  }

  Future _pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  String? url;
  save() async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please Pick an Image'),
        ),
      );
    } else {
      final ref = FirebaseStorage.instance
          .ref()
          .child('productImages')
          .child(_name.text + '.jpg');
      await ref.putFile(_pickedImage!);
      url = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('product').doc().set({
        'id': int.parse(_id.text),
        'name': _name.text,
        'price': int.parse(_price.text),
        'desc': _desc.text,
        'image': url,
      });
      Fluttertoast.showToast(msg: "Produk Berhasil ditambahkan");
      _id.clear();
      _name.clear();
      _price.clear();
      _desc.clear();
      _pickedImage == null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Admin Dashboard'),
        elevation: 0,
        backgroundColor: tertiaryColor,
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Logout"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              logout(context);
            }
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Tambah Produk',
                    style: TextStyle(
                      color: quaternaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _id,
                    decoration: InputDecoration(
                      hintText: 'Id',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: tertiaryColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ID wajib diisi';
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      hintText: 'Nama Produk',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: tertiaryColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Produk wajib diisi';
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _price,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Rp.",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      prefixIconConstraints:
                          BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: 'Harga',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: tertiaryColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga wajib diisi';
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _desc,
                    decoration: InputDecoration(
                      hintText: 'Desc',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: tertiaryColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Desc wajib diisi';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _pickImageGallery();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _pickedImage == null
                          ? Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 100,
                            )
                          : Image.file(
                              _pickedImage!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          save();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: quaternaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
