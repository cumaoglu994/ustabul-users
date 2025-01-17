import 'package:flutter/material.dart';
import 'package:ustabuul/screens/Widget/banner_widget.dart';
import 'package:ustabuul/screens/Widget/category_widget.dart';
import 'package:ustabuul/screens/Widget/search_input.dart';
import 'package:ustabuul/screens/Widget/welcome_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          const WelcomeText(),
          SearchInput(),
          const BannerWidget(),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              'Temizlik Hizmetleri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          CategoryWidget(),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              'Tadilat ve Onarım',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          CategoryWidget(),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              'Web Geliştirme ve Dijital Hizmetler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          CategoryWidget(),
        ],
      ),
    );
  }
}
