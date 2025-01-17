import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ustabuul/auth/login_screen.dart';
import 'package:ustabuul/screens/Account/user_information.dart';
import 'package:ustabuul/screens/main_srceen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Firestore'dan alıcı koleksiyonunu al
    CollectionReference buyers =
        FirebaseFirestore.instance.collection('buyers');

    // Kullanıcı kimliğini al
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Eğer kullanıcı giriş yapmamışsa, kullanıcı giriş ekranına yönlendir
    if (currentUser == null) {
      return const KullanciYok();
    }

    // Kullanıcı verilerini al
    return FutureBuilder<DocumentSnapshot>(
      future: buyers.doc(currentUser.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Bir şeyler yanlış gitti."));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const KullanciYok(); //const Center(child: Text("Kullanıcı verisi bulunamadı."));
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        // Kullanıcı profil ekranı
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(125, 98, 98, 98),
            title: const Text(
              'Profil',
              style: TextStyle(
                letterSpacing: 4,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            actions: const [
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Icon(Icons.dark_mode),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ClipOval(
                  child: Container(
                    width:
                        168, // Yükseklik ve genişlik için çemberin çapı (2 * radius)
                    height:
                        168, // Yükseklik ve genişlik için çemberin çapı (2 * radius)
                    decoration: const BoxDecoration(
                      color: Colors.amberAccent, // Arka plan rengi
                    ),
                    child: Image(
                      image: NetworkImage(
                        data['profileImage'] != null &&
                                data['profileImage'].isNotEmpty
                            ? data['profileImage'] // Kullanıcının profil resmi
                            : 'assets/images/default_user.jpg', // Varsayılan resim yolu
                      ),
                      fit: BoxFit.fill, // Resmi kapsayacak şekilde kaplar
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Görsel ve metin arasında boşluk
                Center(
                  child: Text(
                    data['name'] ?? 'Anonim Kullanıcı',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Divider(
                    thickness: 2,
                    color: Colors.black45,
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.settings, size: 30),
                  title: Text('Ayarlar', style: TextStyle(fontSize: 18)),
                ),

                ListTile(
                  leading: const Icon(Icons.info, size: 30),
                  title: const Text('Hesap Bilgileri',
                      style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // UserInformation sayfasına yönlendirme
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserInformation(data: data)),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.share, size: 30),
                  title: const Text('Paylaş', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Paylaşım işlemleri burada yapılacak
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, size: 30),
                  title:
                      const Text('Çıkış Yap', style: TextStyle(fontSize: 18)),
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Başarıyla çıkış yapıldı!')),
                        // burada ise hemen KullanciYok() wedget gostersin
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    } catch (e) {
                      /*  ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Çıkış yaparken hata oluştu: $e')),
                      );*/
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class KullanciYok extends StatelessWidget {
  const KullanciYok({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Giriş yapmadınız."),
            ElevatedButton(
              onPressed: () {
                // Giriş ekranına yönlendirme kodu buraya gelecek
                Navigator.pushReplacement(
                  context,
                  // ignore: non_constant_identifier_names
                  MaterialPageRoute(builder: (BuildContext Context) {
                    return LoginScreen();
                  }),
                );
              },
              child: const Text("Giriş Yap"),
            ),
          ],
        ),
      ),
    );
  }
}
