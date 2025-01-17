import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:shimmer/shimmer.dart";

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Map<String, String>> _categories = [];

  // Firebase'den kategori verilerini almak
  getCategories() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('categories').get();
    setState(() {
      for (var doc in querySnapshot.docs) {
        _categories.add({
          'image': doc['image'], // Görsel URL'si alınıyor
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCategories(); // Kategorileri almak için çağrı
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategoriler'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 120, // Yüksekliği ihtiyaca göre ayarlayabilirsiniz
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: _categories.isEmpty
              ? const Center(
                  child: CircularProgressIndicator()) // Yükleniyor göstergesi
              : ListView.builder(
                  scrollDirection:
                      Axis.horizontal, // Yatay scroll için Axis.horizontal
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 200, // Her kategorinin genişliği
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl:
                                category['image']!, // Firebase'den gelen URL
                            fit: BoxFit.cover,
                            height: 140,
                            width: 140,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey, // Başlangıç rengi
                              highlightColor: Colors.white, // Vurgulanan renk
                              enabled: true, // Animasyonu aktif hale getirir
                              child: Container(
                                color: Colors.white,
                                height: 140,
                                width: 140,
                              ),
                            ),

                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
