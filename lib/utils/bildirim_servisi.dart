import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BildirimServisi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Yeni bildirimleri dinle
  static Stream<QuerySnapshot> yeniBildirimleriDinle(String userId) {
    return _firestore
        .collection('bildirimler')
        .where('alici_id', isEqualTo: userId)
        .where('okundu', isEqualTo: false)
        .orderBy('tarih', descending: true)
        .snapshots();
  }

  // Tüm bildirimleri getir
  static Stream<QuerySnapshot> tumBildirimleriGetir(String userId) {
    return _firestore
        .collection('bildirimler')
        .where('alici_id', isEqualTo: userId)
        .orderBy('tarih', descending: true)
        .snapshots();
  }

  // Bildirimi okundu olarak işaretle
  static Future<void> bildirimiOkunduIsaretle(String bildirimId) async {
    try {
      await _firestore
          .collection('bildirimler')
          .doc(bildirimId)
          .update({
        'okundu': true,
      });
    } catch (e) {
      print('Bildirim okundu işaretlenirken hata: $e');
    }
  }

  // Bildirim sayısını getir
  static Stream<int> okunmamisBildirimSayisi(String userId) {
    return _firestore
        .collection('bildirimler')
        .where('alici_id', isEqualTo: userId)
        .where('okundu', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Bildirim gönder (manuel)
  static Future<void> bildirimGonder({
    required String aliciId,
    required String aliciAdi,
    required String aliciTelefon,
    required String teklifId,
    required Map<String, dynamic> teklifDetaylari,
  }) async {
    try {
      final bildirimVerisi = {
        'alici_id': aliciId,
        'alici_email': aliciTelefon, // Telefon numarasını e-posta olarak kullan
        'alici_adi': aliciAdi,
        'teklif_id': teklifId,
        'mesaj': {
          'title': '🎨 Yeni Boya Badana Teklifi!',
          'body': '${teklifDetaylari['oda_sayisi']} oda, ${teklifDetaylari['metrekare']} m² - ${teklifDetaylari['adres']}',
        },
        'durum': 'gonderildi',
        'tarih': FieldValue.serverTimestamp(),
        'okundu': false,
        'teklif_detaylari': teklifDetaylari,
      };

      await _firestore
          .collection('bildirimler')
          .add(bildirimVerisi);

      print('Bildirim gönderildi: $aliciAdi');
    } catch (e) {
      print('Bildirim gönderme hatası: $e');
    }
  }
} 