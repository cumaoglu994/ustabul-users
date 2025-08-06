import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeslekTeklifSayfasi extends StatefulWidget {
  final String meslekAdi; // Örn: 'boyaci', 'elektrikci'

  const MeslekTeklifSayfasi({super.key, required this.meslekAdi});

  @override
  State<MeslekTeklifSayfasi> createState() => _MeslekTeklifSayfasiState();
}

class _MeslekTeklifSayfasiState extends State<MeslekTeklifSayfasi> {
  int _currentStep = 0;
  List<DocumentSnapshot> sorular = [];
  final Map<String, dynamic> cevaplar = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _sorulariGetir();
  }

  Future<void> _sorulariGetir() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.meslekAdi)
        .collection('sorular')
        .get();

    setState(() {
      sorular = snapshot.docs;
      loading = false;
    });
  }

  List<Step> _adimlariOlustur() {
    return sorular.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final soru = data['soru'] ?? '';
      final tip = data['tip'] ?? '';
      final secenekler = data['secenekler'];

      Widget content;

      switch (tip) {
        case 'secim':
          content = Wrap(
            spacing: 8,
            children: List<String>.from(secenekler).map((secenek) {
              return ChoiceChip(
                label: Text(secenek),
                selected: cevaplar[doc.id] == secenek,
                onSelected: (_) {
                  setState(() {
                    cevaplar[doc.id] =
                        cevaplar[doc.id] == secenek ? null : secenek;
                  });
                },
              );
            }).toList(),
          );
          break;
        case 'evet_hayir':
          content = Wrap(
            spacing: 8,
            children: [true, false].map((deger) {
              return ChoiceChip(
                label: Text(deger ? 'Evet' : 'Hayır'),
                selected: cevaplar[doc.id] == deger,
                onSelected: (_) {
                  setState(() {
                    cevaplar[doc.id] =
                        cevaplar[doc.id] == deger ? null : deger;
                  });
                },
              );
            }).toList(),
          );
          break;
        case 'sayi':
          content = TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Sayı giriniz'),
            onChanged: (val) => cevaplar[doc.id] = val,
          );
          break;
        case 'metin':
        default:
          content = TextField(
            decoration: const InputDecoration(hintText: 'Metin giriniz'),
            onChanged: (val) => cevaplar[doc.id] = val,
          );
      }

      return Step(
        title: Text(soru),
        content: content,
        isActive: true,
        state: cevaplar[doc.id] != null ? StepState.complete : StepState.indexed,
      );
    }).toList();
  }

  void _teklifiGonder() {
    print('Meslek: ${widget.meslekAdi}');
    print('Cevaplar: $cevaplar');
    // Firestore'a ekleme istersen:
    /*
    FirebaseFirestore.instance.collection("teklifler").add({
      'meslek': widget.meslekAdi,
      'cevaplar': cevaplar,
      'tarih': Timestamp.now(),
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final steps = _adimlariOlustur();

    return Scaffold(
      appBar: AppBar(title: Text('${widget.meslekAdi.toUpperCase()} Teklif Formu')),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        steps: steps,
        onStepTapped: (index) => setState(() => _currentStep = index),
        onStepContinue: () {
          if (_currentStep < steps.length - 1) {
            setState(() => _currentStep++);
          } else {
            _teklifiGonder();
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
    );
  }
}