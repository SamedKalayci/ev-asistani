# Ev Asistanı - v1.0.0 (2) Fiziksel Cihaz Test Sonuçları & İzin Düzeltme Planı

**Test Tarihi:** 7 Ağustos 2026
**Test Ortamı:** iOS (TestFlight v1.0.0 (2) / Fiziksel Cihaz)
**Durum:** Hata Giderme ve İzin Denetimi Aşamasında

---

## 🔐 Faz 1. Kimlik Doğrulama & Hesap Bağlama (Auth)

- [x] **1.1. Google Sign-In Çökme (Crash) Sorunu**
  - Google ile giriş yapıldığında yaşanan uygulama çökmesi giderilecek.
- [x] **1.2. Apple Sign-In Çalışmama Sorunu**
  - Apple ile giriş yap seçeneğinin tetiklenmeme/çalışmama hatası çözülecek.
- [x] **1.3. E-posta Hesabına Google/Apple Bağlama**
  - E-posta ile kayıt olmuş kullanıcılar için Google ve Apple hesaplarını bağlama (link credentials) özelliği getirilecek.
- [x] **1.4. Anonim Hesap Mantığı & Çıkış Uyarıları**
  - Anonim hesapla giriş yapıldığında çıkışta verilerin kaybolmaması için anonim kimlik/oturum yapısı iyileştirilecek.
  - Anonim kullanıcı çıkış yaparken "Hesabınızı bağlayın" uyarısı gösterilecek.
  - Profil ekranındaki doğrudan "Google ile Bağlan" butonu kaldırılacak; yerine "Hesabınızı Bağlayın" detay menüsü eklenip içinde Google, Apple ve E-posta seçenekleri sunulacak.

---

## 🔒 Faz 2. Depolama, İzinler & Firebase Storage (Permissions & Storage)

- [x] **2.1. iOS Info.plist İzin Metinleri Denetimi**
  - `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSPhotoLibraryAddUsageDescription` ve `NSMicrophoneUsageDescription` izin metinlerinin Türkçe ve anlaşılır açıklamalarla `Info.plist` dosyasına tanımlandığı doğrulanacak.
- [x] **2.2. Kamera & Galeri İzin Reddedilme (Permission Denied) Yönetimi**
  - Kamera veya Galeri izni reddedildiğinde/kalıcı olarak engellendiğinde (`isPermanentlyDenied`) hatalı dosya yükleme fonksiyonunun çalışması engellenecek.
  - Kullanıcıya "İzin verilmedi" uyarısı gösterilerek **"Ayarlara Git"** (`openAppSettings()`) yönlendirmesi sunulacak.
- [x] **2.3. Firebase Storage 'No object exists' Hatası**
  - Ürün ve Belge/Evrak ekleme ekranlarında dosya yüklenirken alınan `Exception: Depolama hatası: No object exists at the desired reference` hatası çözülecek (Storage Reference path ve yetkilendirmeler düzeltilecek).
- [x] **2.4. Yerel Bildirim (Notification) İzinleri**
  - Yaklaşan periyodik bakımlar ve son kullanma tarihi uyarıları için iOS ve Android 13+ bildirim izin isteme akışları (`flutter_local_notifications` / `Permission.notification`) denetlenecek.

---

## 📢 Faz 3. Reklamlar & Monetizasyon (Ads)

- [x] **3.1. Aile Kurma Ödüllü Reklam (Rewarded Ad) Gösterimi**
  - "1 Reklam İzle Aile Kur" butonuna basıldığında reklam zorunluluğu tetikleniyor fakat reklam ekranı yüklenmiyor/gösterilmiyor; yükleme ve gösterim akışı düzeltilecek. Garanti, son kullanma veya alış veriş listesindeki geçiş reklamları çıkıyor fakat bu ödüllü reklam çıkmıyor.
- [x] **3.2. Garanti Takibi Reklam Frekansı**
  - Garanti takibi ekranında her eklemeden sonra reklam çıkması engellenecek.
  - 1-3-5 mantığında döngüsel olarak (1 gösterim yap, 1 gösterim atla) frekans düzenlemesi yapılacak.

---

## 🧭 Faz 4. Navigasyon, Widget & UI/UX Düzeltmeleri

- [x] **4.1. Ana Ekran Hızlı Ekle (Quick Add) Menüsü Sıralaması**
  - "Hızlı Harcama Ekle" menüden kaldırılacak.
  - "Garantiler (Garanti Belgesi / Evrak Ekle)" eklenecek.
  - Sıralama: Son Kullanma, Garantiler, Alışveriş şeklinde düzenlenecek.
- [x] **4.2. Garanti Widget Yönlendirme Hatası**
  - Ana ekrandaki Garantiler widget'ına tıklandığında doğrudan Envanter altındaki Garantiler (2. sekme) sayfasına yönlendirme yapılacak.
- [x] **4.3. Finans Sekmesi Tab Reset**
  - Finans sekmesine (bottom tab) tıklandığında, kalınan yer neresi olursa olsun doğrudan Ev Cüzdanı (Genel Bakış) ana sayfasına dönülecek.
- [x] **4.4. Uygulama İkonu (Icon PNG) Kontrolü**
  - iOS ve Android ikonlarının PNG formatı ve derlenme durumları teyit edilecek.
