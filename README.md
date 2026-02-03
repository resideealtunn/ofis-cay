Çay Demle 🫖

Türkçe çay demleme zamanlayıcı uygulaması. Çayı demlediğiniz anda 20 dakikalık (veya seçtiğiniz süre) geri sayım başlar; süre dolunca ses çalar ve “Çay hazır” ekranı açılır.

 Özellikler

- Çay demledim butonu — Basınca sayaç başlar
- Ayarlanabilir süre — 5–30 dakika arası (varsayılan 20 dakika)
- Geri sayım — “Çayın hazır olmasına son:” metni ve büyük sayaç
- Sayacı iptal et — Sayaç ekranından ana sayfaya dönüş
- Ses bildirimi — Süre bitince `caylar.mpeg` iki kez çalar (yoksa `cayhazir.mp3`)
- Çay hazır ekranı — Demlenme saati ve “Yeni çay demle” butonu
- Ekran açık kalır — Uygulama açıkken ekran kapanmaz (wakelock)
- Kırmızı tonlarda arayüz — Modern ve sade tasarım

 Gereksinimler

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.0+)
- Android (test edildi) / iOS

 Kurulum ve Çalıştırma

```bash
 Bağımlılıkları yükle
flutter pub get

 Uygulamayı çalıştır (bağlı cihaz veya emülatör)
flutter run

 Release APK oluştur (Android)
flutter build apk
```

 Proje Yapısı

```
lib/
├── main.dart               Uygulama girişi, tema, rotalar, wakelock
└── screens/
    ├── home_screen.dart     Ana ekran: logo, süre seçimi, "Çay demledim" butonu
    ├── timer_screen.dart    Sayaç ekranı: geri sayım, iptal butonu, ses
    └── tea_ready_screen.dart  "Çay hazır" ekranı, demlenme saati, yeni çay butonu

assets/
├── cay.jpg        Uygulama logosu / ikon kaynağı
├── caylar.mpeg    Süre bitince çalan ses (öncelikli)
└── cayhazir.mp3   Ses yedek (mpeg çalışmazsa)
```

 Bağımlılıklar

| Paket | Açıklama |
|-------|----------|
| `audioplayers` | Süre bitince ses çalma |
| `wakelock_plus` | Uygulama açıkken ekranın açık kalması |
| `flutter_launcher_icons` (dev) | Android uygulama ikonu (assets/cay.jpg) |

 Uygulama İkonu

Android launcher ikonu `assets/cay.jpg` ile oluşturulur. İkonu yenilemek için:

```bash
dart run flutter_launcher_icons
```

 Lisans

Bu proje kişisel kullanım içindir.
