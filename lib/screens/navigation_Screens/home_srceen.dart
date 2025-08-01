import 'package:flutter/material.dart';
import 'package:ustabuul/screens/Widget/banner_widget.dart';
import 'package:ustabuul/screens/Widget/category_widget.dart';
import 'package:ustabuul/screens/Widget/search_input.dart';
import 'package:ustabuul/screens/Widget/welcome_text.dart';
import 'package:ustabuul/screens/navigation_Screens/Meslekler.dart';//burda bunu inport ederken sayafını ismini yazmak geekiyor
//eğer farkli bir syafaya geçemke isenilirse o dosyanın altındaki  classa geçilir

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // biraz boşluk ekledik
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const WelcomeText(),
            SearchInput(),// Arama çubuğu
           const BannerWidget(),
            const SizedBox(height: 40),
           Center(
            child: ElevatedButton.icon(
              onPressed: () {
             Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MesleklerSayfasi()),
      );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Hizmetler aranıyor...")),
                );
              },
              
              icon: const Icon(Icons.supervised_user_circle),
              label: const Text("Hizmetleri Ara"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 213, 220, 13),
                foregroundColor: const Color.fromARGB(255, 16, 13, 13),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Radius burada
               
              ),
              ),
            ),
           ),
       
          ],
        ),
      ),
    );
  }
}
