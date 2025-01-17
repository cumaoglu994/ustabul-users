import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List _categories = [];

  getCategories() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('categories').get();
    setState(() {
      for (var doc in querySnapshot.docs) {
        _categories.add({
          'image': doc['image'],
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 120, // Yüksekliği ihtiyaca göre ayarlayabilirsiniz
        width: double.infinity,
        decoration: BoxDecoration(
          // color: const Color.fromARGB(255, 214, 214, 214),
          borderRadius: BorderRadius.circular(25),
        ),
        child: _categories.isEmpty
            ? const Center(child: CircularProgressIndicator())
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
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            //  color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: category['image'],
                          fit: BoxFit.cover,
                          height: 140,
                          width: 140,
                          placeholder: (context, url) => Shimmer(
                            duration: const Duration(seconds: 2),
                            interval: const Duration(seconds: 1),
                            color: Colors.white,
                            enabled: true,
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
    );
  }
}
