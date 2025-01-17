import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ustabuul/Controller/auth_controller.dart';
import 'package:ustabuul/auth/login_screen.dart';
import 'package:ustabuul/utils/show_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late String email;

  late String name;

  late String phoneNumber;

  late String password;
  bool _isloading = false;
  Uint8List? _image;

  _signUpUsers() async {
    setState(() {
      _isloading = true;
    });
    if (_formkey.currentState!.validate()) {
      await _authController
          .signUpUsers(email, name, phoneNumber, password, _image)
          .whenComplete(() {
        setState(() {
          _formkey.currentState!.reset();
          _isloading = false;
        });
      });
      return showSnakBar(
          // ignore: use_build_context_synchronously
          context,
          'Congratulations An Account Has Been Created For You ');
    } else {
      setState(() {
        _isloading = false;
      });
      return showSnakBar(context, 'Please fieled Must no be empty ');
    }
  }

  selectGalleryImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  selectCamerasImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/background.jpg'), // Arka plan resmi buraya
            fit: BoxFit.cover, // Resmin nasıl yerleştirileceğini belirler
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Müşteri Hesabı Oluştur",
                    style: TextStyle(fontSize: 20),
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundColor: Colors.amber,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundColor: Colors.amber,
                              backgroundImage:
                                  AssetImage('assets/images/default_user.jpg'),
                            ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: IconButton(
                          onPressed: () {
                            selectGalleryImage();
                          },
                          icon: const Icon(
                            CupertinoIcons.photo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "E-postayı boş olamaz.";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        email = value;
                      },
                      decoration:
                          const InputDecoration(labelText: "E-postayı Girin"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "İsim boş olamaz.";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        name = value;
                      },
                      decoration:
                          const InputDecoration(labelText: "Adınızı Girin"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Numara boş olamaz.";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                      decoration:
                          const InputDecoration(labelText: "Numarayı Girin"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Şifre boş olamaz.";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      decoration:
                          const InputDecoration(labelText: "Şifreyi Girin"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _signUpUsers();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 160, 160, 160),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                          child: _isloading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Kayıt Ol",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 4),
                                )),
                    ),
                  ),
                  Row(
                    children: [
                      const Text("Zaten bir hesabınız var mı?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return LoginScreen();
                              }),
                            );
                          },
                          child: const Text("Giriş Yap")),
                    ],
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
