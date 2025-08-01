import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
 // doğru yolu kendi dosya yapına göre düzelt


class MesleklerSayfasi extends StatefulWidget {
  final String? adi;
  final String? meslek;
  final String? aciklama;
  final String? deneyim;
  final String? fiyat;
  
  final String? telefonNo;
  final String? Konum;
// Bu değişkenler, meslek bilgilerini tutmak için kullanılır.
  // Meslek bilgilerini tutmak için kullanılır. 
  const MesleklerSayfasi({
    super.key,
    this.adi,
    this.meslek,
    this.aciklama,
    this.deneyim,
    this.fiyat,
    
    this.telefonNo,
    this.Konum,
  });

  @override
  State<MesleklerSayfasi> createState() => _MesleklerSayfasiState();
}

class _MesleklerSayfasiState extends State<MesleklerSayfasi> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _tumMeslekler = [
    {
      "isim": "Boyacı",
      "ikon": Icons.format_paint,
      "buyerId": "kvL004WIHfcTxEPF8bnPvBQqJQI2",
    },
    {
      "isim": "Fayansçı",
      "ikon": Icons.construction,
      "buyerId": "xyz123abc456sdtgzsdfgzfdarggdffgfghzdfhz",
    },
    // Diğer meslekler...
  ];

  List<Map<String, dynamic>> _filtreliMeslekler = [];

  @override
  void initState() {
    super.initState();
    _filtreliMeslekler = List.from(_tumMeslekler);
    _searchController.addListener(_filtrele);
  }

  void _filtrele() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtreliMeslekler = query.isEmpty
          ? List.from(_tumMeslekler)
          : _tumMeslekler
              .where((meslek) =>
                  meslek["isim"].toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _meslekButonu(BuildContext context, Map<String, dynamic> meslek) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          String? buyerId = meslek['buyerId'];
          if (buyerId == null) return;

          try {
            var belge = await FirebaseFirestore.instance
                .collection('buyers')
                .doc(buyerId)
                .collection('profilBilgileri')
                .doc('bilgi')
                .get();

            if (belge.exists) {
              var data = belge.data()!;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MesleklerSayfasi(
                    meslek: meslek['isim'],
                    adi: data['adı'] ?? '',
                    aciklama: data['aciklama'] ?? '',
                    deneyim: data['deneyim'] ?? '',
                    telefonNo: data['telefonNo'] ?? '',
                    Konum: data['konum'] ?? '',
                    fiyat: data['fiyat'] ?? '',
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Veri bulunamadı: ${meslek['isim']}")),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Hata oluştu: $e")),
            );
          }
        },
        icon: Icon(meslek['ikon']),
        label: Text(meslek['isim']),
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          elevation: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.meslek != null &&
        widget.aciklama != null &&
        widget.fiyat != null &&
        widget.adi != null &&
        widget.telefonNo != null &&
        widget.Konum != null &&
        widget.deneyim != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.meslek!)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Adı: ${widget.adi!}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Meslek: ${widget.meslek!}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text("Açıklama: ${widget.aciklama!}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text("Deneyim: ${widget.deneyim!}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text("Fiyat: ${widget.fiyat!} ₺",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text("Telefon: ${widget.telefonNo!}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text("Konum: ${widget.Konum!}",
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Meslekler")),
      body: Container(
       
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: "Meslek ara...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _filtreliMeslekler.isEmpty
                    ? const Center(child: Text("Hiç meslek bulunamadı."))
                    : ListView.separated(
                        itemCount: _filtreliMeslekler.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          var meslek = _filtreliMeslekler[index];
                          return _meslekButonu(context, meslek);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
