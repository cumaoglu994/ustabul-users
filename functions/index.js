/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {setGlobalOptions} = require("firebase-functions");
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Yeni teklif geldiğinde Firebase bildirimi gönder
exports.sendNotificationOnNewTeklif = functions.firestore
    .document('buyers/{buyerId}/gelen_teklifler/{teklifId}')
    .onCreate(async (snap, context) => {
        try {
            const teklifData = snap.data();
            const buyerId = context.params.buyerId;
            const teklifId = context.params.teklifId;

            // Boyacının bilgilerini al
            const boyaciDoc = await admin.firestore()
                .collection('buyers')
                .doc(buyerId)
                .collection('profilBilgileri')
                .doc('bilgi')
                .get();

            if (!boyaciDoc.exists) {
                console.log('Boyacı bilgileri bulunamadı');
                return null;
            }

            const boyaciData = boyaciDoc.data();
            const boyaciEmail = boyaciData.email || boyaciData.e_posta;

            if (!boyaciEmail) {
                console.log('Boyacı e-posta adresi bulunamadı');
                return null;
            }

            // Bildirim mesajını hazırla
            const notificationMessage = {
                title: '🎨 Yeni Boya Badana Teklifi!',
                body: `${teklifData.teklif_detaylari?.oda_sayisi || 'N/A'} oda, ${teklifData.teklif_detaylari?.metrekare || 'N/A'} m² - ${teklifData.teklif_detaylari?.adres || 'N/A'}`,
                data: {
                    teklifId: teklifId,
                    buyerId: buyerId,
                    type: 'new_teklif'
                }
            };

            // Firebase'e bildirim kaydı ekle
            await admin.firestore()
                .collection('bildirimler')
                .add({
                    alici_id: buyerId,
                    alici_email: boyaciEmail,
                    alici_adi: boyaciData.adı || boyaciData.adi,
                    teklif_id: teklifId,
                    mesaj: notificationMessage,
                    durum: 'gonderildi',
                    tarih: admin.firestore.FieldValue.serverTimestamp(),
                    okundu: false
                });

            // Console'a log yazdır
            console.log('=== FIREBASE BİLDİRİM GÖNDERİLDİ ===');
            console.log('Alıcı ID:', buyerId);
            console.log('Alıcı E-posta:', boyaciEmail);
            console.log('Alıcı Adı:', boyaciData.adı || boyaciData.adi);
            console.log('Teklif ID:', teklifId);
            console.log('Mesaj:', notificationMessage);
            console.log('=====================================');

            return null;

        } catch (error) {
            console.error('Bildirim gönderme fonksiyonu hatası:', error);
            return null;
        }
    });

// Genel teklifler koleksiyonuna da bildirim gönder
exports.sendNotificationOnGeneralTeklif = functions.firestore
    .document('teklifler/{teklifId}')
    .onCreate(async (snap, context) => {
        try {
            const teklifData = snap.data();
            const teklifId = context.params.teklifId;

            // Bildirim mesajını hazırla
            const notificationMessage = {
                title: '🎨 Yeni Genel Teklif!',
                body: `${teklifData.teklif_detaylari?.oda_sayisi || 'N/A'} oda, ${teklifData.teklif_detaylari?.metrekare || 'N/A'} m² - ${teklifData.teklif_detaylari?.adres || 'N/A'}`,
                data: {
                    teklifId: teklifId,
                    type: 'general_teklif'
                }
            };

            console.log('=== GENEL TEKLIF BİLDİRİMİ ===');
            console.log('Teklif ID:', teklifId);
            console.log('Mesaj:', notificationMessage);
            console.log('==============================');

            return null;

        } catch (error) {
            console.error('Genel teklif bildirimi hatası:', error);
            return null;
        }
    });

// E-posta bildirimi gönder (opsiyonel - Firebase Auth ile)
exports.sendEmailNotification = functions.firestore
    .document('bildirimler/{bildirimId}')
    .onCreate(async (snap) => {
        try {
            const bildirimData = snap.data();
            
            // E-posta gönderme işlemi burada yapılabilir
            // Firebase Auth ile entegre edilebilir
            
            console.log('=== E-POSTA BİLDİRİMİ ===');
            console.log('Alıcı:', bildirimData.alici_email);
            console.log('Konu:', bildirimData.mesaj.title);
            console.log('İçerik:', bildirimData.mesaj.body);
            console.log('=======================');

            return null;

        } catch (error) {
            console.error('E-posta bildirimi hatası:', error);
            return null;
        }
    });
