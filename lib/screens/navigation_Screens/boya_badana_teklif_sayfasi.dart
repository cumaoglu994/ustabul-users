import 'package:flutter/material.dart';

class BoyaBadanaTeklifSayfasi extends StatefulWidget {
  const BoyaBadanaTeklifSayfasi({super.key});

  @override
  State<BoyaBadanaTeklifSayfasi> createState() => _BoyaBadanaTeklifSayfasiState();
}

class _BoyaBadanaTeklifSayfasiState extends State<BoyaBadanaTeklifSayfasi> {
  int _currentStep = 0;

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
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        steps: _steps,
        onStepTapped: (index) => setState(() => _currentStep = index),
        onStepContinue: () {
          if (_currentStep < _steps.length - 1) {
            setState(() => _currentStep++);
          } else {
            _teklifiOlustur();
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
// Method to create the offer
  // This method can be modified to send the data to a server or save it locally  
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
    // Gönderim işlemleri burada yapılabilir
  }
}
