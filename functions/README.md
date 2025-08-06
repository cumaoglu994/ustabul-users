# Firebase Cloud Functions - Bildirim Sistemi

Bu proje, boya badana tekliflerini Firebase bildirim sistemi ile bildirmek için Firebase Cloud Functions kullanır.

## Kurulum

### 1. Firebase CLI Kurulumu
```bash
npm install -g firebase-tools
```

### 2. Firebase'e Giriş
```bash
firebase login
```

### 3. Proje Dizinine Git
```bash
cd functions
```

### 4. Bağımlılıkları Yükle
```bash
npm install
```

### 5. Functions'ı Deploy Et
```bash
firebase deploy --only functions
```

## Bildirim Sistemi

### Firebase Bildirimleri

Bu sistem Firebase'in kendi bildirim sistemini kullanır:

1. **Bildirim Kaydı:** Firestore'da `bildirimler` koleksiyonuna kaydedilir
2. **E-posta Bildirimi:** Boyacının e-posta adresine bildirim gönderilir
3. **Uygulama İçi Bildirim:** Flutter uygulamasında bildirimler görüntülenir

### Bildirim Formatı

```json
{
  "alici_id": "boyaci_id",
  "alici_email": "boyaci@email.com",
  "alici_adi": "Boyacı Adı",
  "teklif_id": "teklif_id",
  "mesaj": {
    "title": "🎨 Yeni Boya Badana Teklifi!",
    "body": "3 oda, 100 m² - İstanbul, Kadıköy"
  },
  "durum": "gonderildi",
  "tarih": "timestamp",
  "okundu": false
}
```

## Test Etme

### 1. Emülatör ile Test
```bash
firebase emulators:start --only functions
```

### 2. Firebase Console'da Logları İzle
- Firebase Console > Functions > Logs

### 3. Bildirim Logları
- Firebase Console > Firestore > bildirimler koleksiyonu

## Fonksiyonlar

### 1. sendNotificationOnNewTeklif
- **Tetikleyici:** `buyers/{buyerId}/gelen_teklifler/{teklifId}` koleksiyonuna yeni belge eklendiğinde
- **İşlev:** Boyacıya bildirim gönderir ve Firestore'a kaydeder

### 2. sendNotificationOnGeneralTeklif
- **Tetikleyici:** `teklifler/{teklifId}` koleksiyonuna yeni belge eklendiğinde
- **İşlev:** Genel teklif bildirimi gönderir

### 3. sendEmailNotification
- **Tetikleyici:** `bildirimler/{bildirimId}` koleksiyonuna yeni belge eklendiğinde
- **İşlev:** E-posta bildirimi gönderir

## Bildirim Mesaj Formatı

```
🎨 Yeni Boya Badana Teklifi!
3 oda, 100 m² - İstanbul, Kadıköy
```

## Maliyet Kontrolü

- Firebase Functions: Ücretsiz katman (125K çağrı/ay)
- Firebase Firestore: Ücretsiz katman (1GB depolama)
- E-posta bildirimleri: Ücretsiz (Firebase Auth ile)

## Sorun Giderme

### 1. Functions Deploy Hatası
```bash
firebase functions:log
```

### 2. Bildirim Gönderilmiyor
- Boyacının e-posta adresini kontrol et
- Firebase Console'da logları kontrol et
- Bildirimler koleksiyonunu kontrol et

### 3. Test Modu
Şu anda console.log ile simüle ediliyor. Gerçek e-posta için Firebase Auth kurulumu gerekli. 