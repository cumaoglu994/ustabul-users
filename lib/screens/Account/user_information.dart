import 'dart:typed_data'; // ByteData tipini kullanmak için
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore kullanımı için
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // Resim seçme işlemi için

class UserInformation extends StatefulWidget {
  final Map<String, dynamic> data; // Veriyi almak için data değişkeni

  const UserInformation({required this.data});

  @override
  // ignore: library_private_types_in_public_api
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Uint8List? _image; // Seçilen resim için
  final ImagePicker _picker = ImagePicker(); // Galeriden resim seçmek için

  @override
  void initState() {
    super.initState();
    // Başlangıçta kullanıcı bilgilerini controller'lara atıyoruz
    _nameController.text = widget.data['name'] ?? '';
    _surnameController.text = widget.data['surname'] ?? '';
    _emailController.text = widget.data['email'] ?? 'email@example.com';
    _phoneController.text = widget.data['phoneNumber'] ?? '';
    _addressController.text = widget.data['address'] ?? '';
  }

  Future<void> _selectGalleryImage() async {
    // Galeriden resim seçme işlemi
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() async {
        _image = Uint8List.fromList(await image.readAsBytes());
      });
    }
  }

  Future<void> _updateUserInfo() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Firestore'da kullanıcıya ait belgeyi güncelle
        await FirebaseFirestore.instance
            .collection('buyers')
            .doc(currentUser.uid)
            .update({
          'name': _nameController.text,
          'surname': _surnameController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneController.text,
          'address': _addressController.text,
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bilgiler başarıyla güncellendi')),
        );
      } else {
        //  print('Kullanıcı bulunamadı.');
      }
    } catch (e) {
      //  print('Güncelleme hatası: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bilgiler güncellenemedi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesab bilgilerim'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Geri butonu işlevi
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
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
                                AssetImage('assets/images/photo.jpg'),
                          ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: IconButton(
                        onPressed:
                            _selectGalleryImage, // Galeriden resim seçme işlemi
                        icon: const Icon(
                          CupertinoIcons.photo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  labelText: 'Soyad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Telefon numarası',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Değiştir"),
                    onPressed: () {
                      // Telefon numarası değiştirme işlemi burada yapılır
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'İl/İlçe/Mahalle',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateUserInfo, // Bilgileri güncelleme fonksiyonu
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Buton rengi
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Center(
                  child: Text(
                    'KAYDET',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
