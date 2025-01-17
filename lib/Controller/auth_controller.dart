import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  static String? hizmetTuru;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // ignore: unused_element
  _uploadProfileImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('profilePics').child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  pickProfileImage(ImageSource fotoSource) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: fotoSource);
    if (file != null) {
      return await file.readAsBytes();
    } else {
      // print('no image selected');
    }
  }

  Future<String> signUpUsers(String email, String name, String phoneNumber,
      String password, Uint8List? image) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty &&
          name.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await _firestore.collection('buyers').doc(cred.user!.uid).set({
          'email': email,
          'name': name,
          'phoneNumber': phoneNumber,
          'buyerId': cred.user!.uid,
          'hizmetTuru': hizmetTuru,
        });
        res = 'success';
      } else {
        res = 'please Fieleds must not be empty';
      }
    } catch (e) {
      res = e.toString(); // Hata durumunda mesaj döndürme
    }
    return res;
  }

  loginUsers(String email, String password) async {
    String res = 'Something went wrong ';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please Fields must not be empty ';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
