import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List _bannerImage = [];

  getBanners() {
    return _firestore
        .collection('Banners')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _bannerImage.add(doc['image']);
        });
      }
    });
  }

  @override
  void initState() {
    getBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 214, 214, 214),
              borderRadius: BorderRadius.circular(25),
            ),
            child: PageView.builder(
                itemCount: _bannerImage.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: _bannerImage[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer(
                        duration: const Duration(seconds: 10), //Default value
                        interval: const Duration(
                            seconds: 10), //Default value: Duration(seconds: 0)
                        color: Colors.white, //Default value
                        colorOpacity: 0, //Default value
                        enabled: true, //Default value
                        direction:
                            const ShimmerDirection.fromLTRB(), //Default Value
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
