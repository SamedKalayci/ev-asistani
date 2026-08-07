# Ev Asistanı - v1.0.0 Test Sonuçları & Düzeltme Planı

**Test Tarihi:** 6 Ağustos 2026  
**Test Ortamı:** iOS (TestFlight / Fiziksel Cihaz)  
**Durum:** Adım Adım Düzeltme Aşamasında

---

## 🚀 Faz 1: Kimlik Doğrulama, E-posta Doğrulama & Güvenlik

_Bu faz tamamlandıktan sonra build alınıp giriş/kayıt akışları test edilecektir._

- [x] **1.1. E-posta Doğrulama (Email Verification) Akışı**
  - Kayıt olunduğunda (`createUserWithEmailAndPassword`) `user.sendEmailVerification()` çalıştırılacak.
  - Kullanıcı "E-posta Adresinizi Doğrulayın" bekleme ekranına yönlendirilecek.
  - Bekleme ekranına "Doğruladım / Kontrol Et" ve "Tekrar Mail Gönder" butonları eklenecek.
  - Giriş yapılırken `emailVerified == false` ise giriş engellenip uyarı verilecek.
- [x] **1.2. Google Sign-In Çökme (Crash) Sorunu**
  - Google ile giriş sırasındaki çökme hatası tespit edilip giderilecek.
- [x] **1.3. Anonim Hesap Mantığı & Uyarı**
  - Çıkış yaparken anonim kullanıcıya _"Tüm verileriniz kaybolacak"_ uyarısı eklenecek veya cihaz bazlı aynı hesaba girmesi sağlanacak.
- [x] **1.4. Hesap Silme ve Aile Temizliği**
  - Silinen hesap ailedeki tek üye ise veritabanından aile kaydı da tamamen temizlenecek.
- [x] **1.5. Kayıt Formu Validasyonları**
  - Geçersiz mail formatı ile kayıt olunması engellenecek.
  - Şifre ve Şifre Tekrar alanlarına bağımsız göster/gizle butonları konulacak.

---

## 📦 Faz 2: Envanter, Medya & Dosya Yönetimi

_Görsel ve belge kaydetme süreçlerini kapsar._

- [x] **2.1. Kameradan / Galeriden Görsel Kaydetme**
  - Envanter ekranında çekilen veya seçilen fotoğrafların veritabanına/storage'a kaydolmama sorunu çözülecek.
- [x] **2.2. PDF Dosyası Kaydetme**
  - Envanterdeki PDF yükleme/kaydetme izin ve dosya yolu hataları giderilecek.

---

## 💳 Faz 3: Reklamlar, Monetizasyon & Senkronizasyon

_AdMob ve RevenueCat (Pro) entegrasyon düzeltmelerini kapsar._

- [x] **3.1. Ödüllü Reklam (Rewarded Ad) Akışı**
  - "1 Reklam İzle Aile Kur" butonuna basıldığında reklam izleme zorunlu kılınacak.
- [x] **3.2. Reklam Gösterim Frekansı**
  - Alışveriş listesine öge eklerken çalışan reklam sayacı/frekansı mantığı düzeltilecek. Sürekli olarak belirleyici aralıklarla reklam gösterilmeye devam edecek.

---

## 📊 Faz 4: Finans, Navigasyon & Arayüz (UI/UX)

_Ekran kaymaları, tarih mantığı ve genel gezinti hatalarını kapsar._

- [x] **4.1. Finansal Tarih & Filtreleme Hataları**
  - Yıllık görünümdeki sabit 2026 yılı kısıtlaması kaldırılacak.
  - Haftalık görünümdeki tarih aralığı karışıklığı düzeltilecek.
  - Yıllık ödemelerin haftalık verilere yansıması engellenecek.
- [x] **4.2. Finans Ekranı Scroll & Navigasyon**
  - Finansal durum ekranındaki kaydırma kilitlenmesi çözülecek.
  - Alt tab bar butonlarına tıklandığında sekmenin ilk sayfasına dönmesi sağlanacak. Tekrardan sekmeye tıklandığında önceki kalan yere değil sekmenin ilk sayfasına yönlendirilecek. kısacası envanter kısmında garantiler bölümünde olduğumuzu varsayarsak tekrar Envanter butonuna basıldığında ilk sayfa olan son kullanmaya gelmesi gerekiyor, bu bütün sayfalar için geçerli.
- [x] **4.3. Navigasyon & Arayüz Düzeltmeleri**
  - Sol üstteki ana ekran simgesi profil yerine Ana Sayfa'ya yönlendirecek.
  - Bütçeni Planla kısmına "Yeme / İçme" kategorisi eklenecek.
  - Özet Gör kısmındaki uzun ay isimlerinde yaşanan sağa kayma (overflow) giderilecek.
- [x] **4.4. Periyodik Bakım Geliştirmesi**
  - Bildirim altyapısı kurulacak ve Ana Sayfaya "Yaklaşan Periyodik Bakımlar" widget'ı eklenecek.

## ⚡ Faz 5: Hızlı Ekle (Quick Action) & UX Güncellemeleri

_Ana ekran hızlı erişim aksiyonlarının ve modal yapıların güncellenmesini kapsar._

- [x] **5.1. Hızlı Ekle Butonu Seçeneklerinin Güncellenmesi**
  - Ana ekrandaki "+" (Hızlı Ekle) butonuna basıldığında açılan menü/bottom sheet seçenekleri güncellenecek:
    1. **Son Kullanma Tarihli Ürün Ekle** _(Mevcut yapı korunacak)_
    2. **Alışveriş Listesine Ürün Ekle** _(Eski "Garanti Belgesi" seçeneği çıkarılıp yerine eklenecek, doğrudan Alışveriş Listesi hızlı ekleme diyaloğuna yönlendirecek)_
    3. **Hızlı Harcama Ekle** _(Eski "Sabit Gider Ödeme Pro" seçeneği çıkarılıp yerine eklenecek, Finans/Ev Cüzdanı modülüne hızlıca harcama/gider kaydedecek)_
