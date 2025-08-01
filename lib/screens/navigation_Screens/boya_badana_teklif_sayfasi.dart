import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoyaBadanaTeklifSayfasi extends StatefulWidget {
  const BoyaBadanaTeklifSayfasi({super.key});

  @override
  State<BoyaBadanaTeklifSayfasi> createState() => _BoyaBadanaTeklifSayfasiState();
}

class _BoyaBadanaTeklifSayfasiState extends State<BoyaBadanaTeklifSayfasi> {
  int _currentStep = 0;
  bool _isLoading = false;
  List<Map<String, dynamic>> _boyaciVerileri = [];

  String? selectedOdaSayisi;
  String? selectedMetrekare;
  bool? malzemeDahilMi;
  bool? esyaliMi;
  bool? tavanBoyansinMi;
  String? adresDetay;
  String? zamanSecimi;
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  String? ekAciklama;

  List<Step> get _steps => [
        Step(
          title: const Text("Oda Sayısı"),
          content: Wrap(
            spacing: 8,
            children: ["1", "2", "3", "4+"].map((oda) {
              return ChoiceChip(
                label: Text(oda),
                selected: selectedOdaSayisi == oda,
                onSelected: (_) => setState(() => selectedOdaSayisi = selectedOdaSayisi == oda ? null : oda),
              );
            }).toList(),
          ),
          isActive: true,
          state: selectedOdaSayisi != null ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text("Metrekare"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Örn: 100"),
            onChanged: (val) => setState(() => selectedMetrekare = val.isEmpty ? null : val),
          ),
          isActive: true,
          state: selectedMetrekare != null ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text("Malzeme Dahil Mi?"),
          content: Wrap(
            spacing: 8,
            children: [true, false].map((secim) {
              return ChoiceChip(
                label: Text(secim ? "Evet" : "Hayır"),
                selected: malzemeDahilMi == secim,
                onSelected: (_) => setState(() => malzemeDahilMi = malzemeDahilMi == secim ? null : secim),
              );
            }).toList(),
          ),
          isActive: true,
          state: malzemeDahilMi != null ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text("Ev Eşyalı mı?"),
          content: Wrap(
            spacing: 8,
            children: [true, false].map((secim) {
              return ChoiceChip(
                label: Text(secim ? "Evet" : "Hayır"),
                selected: esyaliMi == secim,
                onSelected: (_) => setState(() => esyaliMi = esyaliMi == secim ? null : secim),
              );
            }).toList(),
          ),
          isActive: true,
          state: esyaliMi != null ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text("Tavan Boyansın mı?"),
          content: Wrap(
            spacing: 8,
            children: [true, false].map((secim) {
              return ChoiceChip(
                label: Text(secim ? "Evet" : "Hayır"),
                selected: tavanBoyansinMi == secim,
                onSelected: (_) => setState(() => tavanBoyansinMi = tavanBoyansinMi == secim ? null : secim),
              );
            }).toList(),
          ),
          isActive: true,
          state: tavanBoyansinMi != null ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text("Adres Detay"),
          content: TextField(
            decoration: const InputDecoration(hintText: "Adresinizi giriniz"),
            onChanged: (val) => setState(() => adresDetay = val.isEmpty ? null : val),
          ),
          isActive: true,
          state: adresDetay != null ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text("Ne zaman yapılmalı?"),
          content: Wrap(
            spacing: 8,
            children: ["1 hafta içinde", "1-3 hafta", "1-2 ay", "4+ ay"].map((secenek) {
              return ChoiceChip(
                label: Text(secenek),
                selected: zamanSecimi == secenek,
                onSelected: (_) => setState(() => zamanSecimi = zamanSecimi == secenek ? null : secenek),
              );
            }).toList(),
          ),
          isActive: true,
          state: zamanSecimi != null ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text("Ek Açıklama"),
          content: TextField(
            decoration: const InputDecoration(hintText: "Ekstra bilgi (isteğe bağlı)"),
            onChanged: (val) => setState(() => ekAciklama = val),
          ),
          isActive: true,
          state: StepState.complete,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Boya Badana Teklifi Al")),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              steps: _steps,
              onStepTapped: (index) => setState(() => _currentStep = index),
              onStepContinue: () {
                if (_currentStep < _steps.length - 1) {
                  setState(() => _currentStep++);
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) setState(() => _currentStep--);
              },
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: const Text("İleri"),
                    ),
                    const SizedBox(width: 8),
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text("Geri"),
                      )
                  ],
                );
              },
            ),
          ),
          // En alta teklif al butonu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _teklifiOlustur,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text("Teklifler Yükleniyor..."),
                      ],
                    )
                  : const Text(
                      "Teklif Al",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _teklifiOlustur() {
    final teklif = {
      'oda_sayisi': selectedOdaSayisi,
      'metrekare': selectedMetrekare,
      'malzeme_dahil': malzemeDahilMi,
      'esyali': esyaliMi,
      'tavan_boyasi': tavanBoyansinMi,
      'adres': adresDetay,
      'zaman': zamanSecimi,
      'ek_aciklama': ekAciklama,
    };
    print(teklif);
    
    // Firebase'den boyacı verilerini çek
    _firebaseVerileriniCek();
  }

  Future<void> _firebaseVerileriniCek() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Önce tüm buyers koleksiyonunu çekelim
      QuerySnapshot buyersSnapshot = await FirebaseFirestore.instance
          .collection('buyers')
          .get();

      List<Map<String, dynamic>> boyaciListesi = [];

      for (var doc in buyersSnapshot.docs) {
        try {
          // Her kullanıcının profil bilgilerini çek
          DocumentSnapshot profilDoc = await FirebaseFirestore.instance
              .collection('buyers')
              .doc(doc.id)
              .collection('profilBilgileri')
              .doc('bilgi')
              .get();

          if (profilDoc.exists) {
            var data = profilDoc.data() as Map<String, dynamic>;
            
            // Meslek alanını kontrol et (farklı alan isimleri olabilir)
            String? meslek = data['meslek'] ?? data['Meslek'] ?? data['MESLEK'];
            
            // Boyacı olup olmadığını kontrol et
            if (meslek != null && 
                (meslek.toLowerCase().contains('boyacı') || 
                 meslek.toLowerCase().contains('boyaci') ||
                 meslek.toLowerCase().contains('boya'))) {
              
              boyaciListesi.add({
                'id': doc.id,
                'adı': data['adı'] ?? data['adi'] ?? data['Adı'] ?? 'İsim yok',
                'aciklama': data['aciklama'] ?? data['açıklama'] ?? 'Açıklama yok',
                'deneyim': data['deneyim'] ?? data['deneyim'] ?? 'Deneyim bilgisi yok',
                'fiyat': data['fiyat'] ?? data['Fiyat'] ?? 'Fiyat belirtilmemiş',
                'telefonNo': data['telefonNo'] ?? data['telefon'] ?? data['Telefon'] ?? 'Telefon yok',
                'konum': data['konum'] ?? data['Konum'] ?? data['lokasyon'] ?? 'Konum belirtilmemiş',
              });
            }
          }
        } catch (e) {
          print('Profil bilgisi çekilirken hata: $e');
        }
      }

      setState(() {
        _boyaciVerileri = boyaciListesi;
        _isLoading = false;
      });

      // Debug için konsola yazdır
      print('Bulunan boyacı sayısı: ${boyaciListesi.length}');
      print('Boyacı listesi: $boyaciListesi');

      // Boyacı listesini göster
      if (boyaciListesi.isNotEmpty) {
        _boyaciListesiniGoster();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Henüz boyacı bulunmamaktadır.')),
        );
      }

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veri çekilirken hata oluştu: $e')),
      );
    }
  }

  void _boyaciListesiniGoster() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mevcut Boyacılar'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _boyaciVerileri.length,
                    itemBuilder: (context, index) {
                      var boyaci = _boyaciVerileri[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(boyaci['adı']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Deneyim: ${boyaci['deneyim']}'),
                              Text('Fiyat: ${boyaci['fiyat']} ₺'),
                              Text('Konum: ${boyaci['konum']}'),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Boyacı ile iletişim kurma işlemi
                              _boyaciIletisimKur(boyaci);
                            },
                            child: const Text('İletişim'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  void _boyaciIletisimKur(Map<String, dynamic> boyaci) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${boyaci['adı']} ile İletişim'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Telefon: ${boyaci['telefonNo']}'),
              const SizedBox(height: 8),
              Text('Açıklama: ${boyaci['aciklama']}'),
              const SizedBox(height: 16),
              const Text('Teklifiniz boyacıya iletilecektir.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _teklifiBoyaciyaGonder(boyaci);
              },
              child: const Text('Teklifi Gönder'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _teklifiBoyaciyaGonder(Map<String, dynamic> boyaci) async {
    try {
      // Teklif verilerini hazırla
      final teklifVerisi = {
        'teklif_veren_id': boyaci['id'],
        'teklif_veren_adi': boyaci['adı'],
        'teklif_veren_telefon': boyaci['telefonNo'],
        'teklif_tarihi': DateTime.now().toIso8601String(),
        'teklif_durumu': 'beklemede', // beklemede, kabul_edildi, reddedildi
        'teklif_detaylari': {
          'oda_sayisi': selectedOdaSayisi,
          'metrekare': selectedMetrekare,
          'malzeme_dahil': malzemeDahilMi,
          'esyali': esyaliMi,
          'tavan_boyasi': tavanBoyansinMi,
          'adres': adresDetay,
          'zaman': zamanSecimi,
          'ek_aciklama': ekAciklama,
        },
        'musteri_bilgileri': {
          'adres': adresDetay,
          'zaman_tercihi': zamanSecimi,
        }
      };

      // Firebase'e teklifi kaydet
      await FirebaseFirestore.instance
          .collection('teklifler')
          .add(teklifVerisi);

      // Boyacının teklifler koleksiyonuna da ekle
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(boyaci['id'])
          .collection('gelen_teklifler')
          .add(teklifVerisi);

      // Başarı mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Teklifiniz ${boyaci['adı']} adlı boyacıya başarıyla iletildi!'),
          backgroundColor: Colors.green,
        ),
      );

      // Ana sayfaya dön
      Navigator.of(context).pop();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Teklif gönderilirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
