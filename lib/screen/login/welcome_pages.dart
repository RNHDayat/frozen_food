import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frozen_food/screen/admin/adminPage.dart';
import 'package:frozen_food/screen/home/dashboardMenu.dart';
import 'package:frozen_food/screen/login/shared/shared.dart';
import 'package:frozen_food/screen/profile/components/profile_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;
  bool _isChecked = false;
  final _key = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _repassword = TextEditingController();
  TextEditingController _nama = TextEditingController();
  var rool = "Pelanggan";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            children: [
              Image.asset('assets/images/froz.png',
                  height: 200, fit: BoxFit.contain),
              SizedBox(
                height: 15,
              ),
              Text(
                "Welcome!!",
                style: dangerTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Selamat datang... Kami menghargai pelanggan kami lebih dari segalanya, dan kepuasan Anda adalah tujuan kami. Selamat Berbelanja...",
                style: whiteTextStyle.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              //button sign in
              SizedBox(
                height: 51,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width - 2 * defaultMargin,
                child: ElevatedButton(
                  onPressed: () {
                    modalRegistrasi();
                  },
                  child: Text(
                    'Register',
                    style: whiteTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: primaryColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              //button login
              SizedBox(
                height: 15,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width - 2 * defaultMargin,
                child: ElevatedButton(
                  onPressed: () {
                    modalLogin();
                  },
                  child: Text(
                    'Login',
                    style: whiteTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: secondaryColor),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: secondaryColor, width: 3),
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
              SizedBox(
                height: 36,
              ),
              Text(
                "By Kelompok (  ) @2022",
                textAlign: TextAlign.center,
                style: whiteTextStyle.copyWith(
                    color: secondaryColor, fontSize: 11),
              ),
              SizedBox(
                height: defaultMargin,
              )
            ],
          )),
    );
  }

  void _tooglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  void _toogleConfirmPasswordView() {
    setState(() {
      _isHiddenConfirmPassword = !_isHiddenConfirmPassword;
    });
  }

  modalRegistrasi() {
    showModalBottomSheet(
      //utk menampilkan modal register
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Wrap(
              children: [
                //bagian modal
                Form(
                  key: _key,
                  child: Container(
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: defaultMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //jarak
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hello...",
                                    style: whiteTextStyle.copyWith(
                                        fontSize: 20, color: blackColor),
                                  ),
                                  Text(
                                    "Register",
                                    style: whiteTextStyle.copyWith(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: blackColor),
                                  )
                                ],
                              ),
                              Spacer(),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Image.asset(
                                      'assets/images/close-icon.png',
                                      height: 30,
                                      width: 30),
                                ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 25,
                          ),

                          TextFormField(
                            controller: _email,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: "Email",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email Wajib diisi';
                              }
                              return null;
                            },
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          TextFormField(
                            controller: _password,
                            obscureText: _isHiddenPassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _isHiddenPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _isHiddenPassword = !_isHiddenPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password Wajib diisi';
                              }
                              return null;
                            },
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          TextFormField(
                            controller: _repassword,
                            obscureText: _isHiddenConfirmPassword,
                            decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: "Confirm Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _isHiddenConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _isHiddenConfirmPassword =
                                        !_isHiddenConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            onChanged: (value) {
                              // set
                              if (value != _password.text) {
                                'Password tidak sama';
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm Password Wajib diisi';
                              } else if (value != _password.text) {
                                return 'Password tidak sama';
                              }
                              return null;
                            },
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width -
                                2 * defaultMargin,
                            child: ElevatedButton(
                              onPressed: () {
                                signUp(_email.text, _repassword.text, rool);
                                _email.clear();
                                _password.clear();
                                _repassword.clear();
                              },
                              child: Text(
                                'Register',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: secondaryColor,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Sudah memiliki akun?",
                                  style: whiteTextStyle.copyWith(
                                    color: primaryColor,
                                    fontSize: 18,
                                  )),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  modalLogin();
                                },
                                child: Text("Login",
                                    style: whiteTextStyle.copyWith(
                                      color: dangerColor,
                                      fontSize: 18,
                                    )),
                              )
                            ],
                          ),

                          SizedBox(
                            height: defaultMargin,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  modalLogin() {
    showModalBottomSheet(
      //utk menampilkan modal login
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Wrap(
              children: [
                //bagian modal
                Form(
                  key: _key,
                  child: Container(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40))),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //jarak
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Login",
                                      style: whiteTextStyle.copyWith(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: blackColor),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                        'assets/images/close-icon.png',
                                        height: 30,
                                        width: 30),
                                  ),
                                )
                              ],
                            ),

                            SizedBox(
                              height: 25,
                            ),

                            TextFormField(
                              controller: _email,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: "Email",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email Wajib diisi';
                                }
                                return null;
                              },
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            TextFormField(
                              controller: _password,
                              obscureText: _isHiddenPassword,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: "Password",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _isHiddenPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _isHiddenPassword = !_isHiddenPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password Wajib diisi';
                                }
                                return null;
                              },
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD7D7D7),
                                    border: Border.all(
                                        color: primaryColor, width: 3),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Checkbox(
                                    value: _isChecked,
                                    checkColor: Color(0xFFD7D7D7),
                                    onChanged: (value) {
                                      setState(() {
                                        this._isChecked = value!;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("Ingat Saya",
                                    style: whiteTextStyle.copyWith(
                                      color: primaryColor,
                                      fontSize: 12,
                                    )),
                                Spacer(),
                                Text("Lupa Password?",
                                    style: whiteTextStyle.copyWith(
                                      color: primaryColor,
                                      fontSize: 12,
                                    )),
                              ],
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width -
                                  2 * defaultMargin,
                              child: ElevatedButton(
                                onPressed: () {
                                  signIn(_email.text, _password.text);
                                },
                                child: Text(
                                  'Login',
                                  style: whiteTextStyle.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: secondaryColor),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Belum memiliki akun?",
                                    style: whiteTextStyle.copyWith(
                                      color: primaryColor,
                                      fontSize: 18,
                                    )),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    modalRegistrasi();
                                  },
                                  child: Text("Register",
                                      style: whiteTextStyle.copyWith(
                                        color: dangerColor,
                                        fontSize: 18,
                                      )),
                                )
                              ],
                            ),

                            SizedBox(
                              height: defaultMargin,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  void signUp(String email, String password, String rool) async {
    CircularProgressIndicator();
    if (_key.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email, rool)})
          .catchError((e) {});
    }
  }

  postDetailsToFirestore(String email, String rool) async {
    Fluttertoast.showToast(msg: "Register Berhasil");
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({'email': email, 'rool': rool});
    Navigator.pop(context);
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('rool') == "Pelanggan") {
          Fluttertoast.showToast(msg: "Login Berhasil");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardMenu(),
            ),
          );
        } else if (documentSnapshot.get('rool') == "Admin"){
           Fluttertoast.showToast(msg: "Selamat Datang Admin");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPage(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_key.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
