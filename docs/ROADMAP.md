# Ev Asistanı Roadmap

## Faz 1 - Proje Altyapısı ✅

- [x] Flutter projesini oluştur
- [x] Tema oluştur
- [x] Router oluştur
- [x] Bottom Navigation oluştur

---

## Faz 2 - Design System ✅

- [x] AppColors
- [x] AppTypography
- [x] AppSpacing
- [x] AppRadius
- [x] AppShadows

---

## Faz 3 - Shared Components ✅

- [x] App Header
- [x] Primary Button
- [x] App Text Field
- [x] DatePickerField
- [x] SearchBar
- [x] EmptyState
- [x] StatCard
- [x] ReminderCard
- [x] CustomBottomNavigation

---

## Faz 4 - UI ✅

- [x] Ana Sayfa
- [x] Son Kullanma
- [x] Garanti
- [x] Alışveriş
- [x] Profil

---

## Faz 5 - Firebase & Aile Altyapısı (Database & Sync) ✅

- [x] Firebase paketlerinin projeye eklenmesi (`firebase_core`, `cloud_firestore`, `firebase_auth`)
- [x] `core/services/` altında Firebase Auth ve Firestore servislerinin kurulması
- [x] `shared/models/` altında `UserModel` ve `FamilyModel` tanımlanması
- [x] Anonymous Auth altyapısının ve Bootstrap mekanizmasının kurulması

---

## Faz 6 - Son Kullanma (Real-time Sync) ✅

- [x] Model güncellemesi (`familyId` ve `createdBy` alanlarının eklenmesi)
- [x] Firestore Stream Repository & Riverpod StreamProvider entegrasyonu
- [x] Ekle / Düzenle / Sil / Listeleme işlemlerinin aile senkronizasyonlu çalışması

---

## Faz 7 - Garanti Takibi (Real-time Sync) ✅

- [x] Model güncellemesi (`familyId` eklenmesi)
- [x] Firestore Stream Repository & Riverpod StreamProvider entegrasyonu
- [x] Ekle / Düzenle / Sil / Listeleme mimarisi

---

## Faz 8 - Alışveriş Listesi (Real-time Sync) ✅

- [x] Model güncellemesi (`familyId` eklenmesi)
- [x] Ortak Alışveriş Listesi için Firestore Stream mimarisi
- [x] Ekle / Tamamlandı (Check) / Sil ve Batch Temizleme işlemlerinin anlık senkronizasyonu

---

## Faz 9 - Yemek Tarifleri & Alışveriş Entegrasyonu ✅

- [x] `RecipeModel` ve `RecipeIngredientModel` güncellemeleri (`familyId`, `createdBy`, `createdAt`, `updatedAt`)
- [x] `RecipeRepository` ve Riverpod `StreamProvider` mimarisi
- [x] Ekle / Düzenle / Sil / Listeleme işlemlerinin aile senkronizasyonlu çalışması
- [x] "Malzemeleri Alışveriş Listesine Ekle" aktarım entegrasyonu

---

## Faz 10 - Kullanıcı Kimlik Doğrulama (Auth, Google Sign-In & Link) ✅

- [x] E-posta / Şifre ile Kayıt Olma & Otomatik Firestore Profil Oluşturma
- [x] E-posta / Şifre ile Giriş Yapma & Şifremi Unuttum Akışı
- [x] **Google Sign-In Entegrasyonu:** Web tabanlı `signInWithPopup` ile giriş altyapısı
- [x] **Account Linking (Hesap Bağlama):** Anonim/Misafir hesabı veri kaybı olmadan Google hesabına bağlama (`linkWithPopup`)
- [x] **Çoklu Hesap Seçim Desteği:** `prompt: 'select_account'` parametresi ile kullanıcıya her seferinde Google hesap seçici çıkarma
- [x] **Ana Giriş Ekranı UI:** Login sayfasına Google ile Giriş Yap butonunun entegrasyonu ve Error Handling
- [x] `AuthGuard` / `GoRouter` ile dinamik oturum yönlendirmesi
- [x] Çıkış Yapma (Logout) entegrasyonu
- [x] Otomatik anonim girişi kaldırma ve "Üyeliksiz Devam Et (Misafir Girişi)" seçeneği

---

## Faz 11 - Profil, Evim Aile Yönetimi & Güvenlik Revizyonu ✅

- [x] `UserModel` ve `FamilyModel` tanımlanması
- [x] Ev Davet Kodu Üretme & Kopyalama
- [x] Davet Kodu İle Başka Bir Eve Katılma
- [x] Aile Üyelerini Listeleme
- [x] Dark Mode & Bildirim Ayarları (Arayüz Bağlantıları)
- [x] **`demo_family_dev` Güvenlik Düzeltmesi:**
  - [x] `user_provider.dart`'taki sabit `demo_family_dev` fallback'i kaldırıldı — `activeFamilyIdProvider` artık ailesizken boş string dönüyor.
  - [x] `home`, `expiration`, `warranty`, `shopping` ekranlarında `NoFamilyEmptyState` / `hasRealFamilyProvider` ile "Henüz bir eve katılmadınız" CTA'sı eklendi.
- [x] **Firestore Güvenlik Kuralları (Repository As Code):**
  - [x] Kök dizine `firestore.rules` ve `firebase.json` eklendi.
  - [x] Alt koleksiyonlar (`expiryItems`, `warrantyItems`, `shoppingItems`, `recipes`, `financeItems`, `accounts`, `paymentSchedules`, `vaultItems` vb.) `isFamilyMember(familyId)` kontrolüyle korunuyor.
- [x] **Kod & Mimari Temizliği (Refactoring):**
  - [x] Kullanılmayan ölü mock data dosyaları (`*_mock_data.dart`) tamamen silindi.
  - [x] `recipe_detail_screen.dart` artık `shopping_provider.dart`'ı doğrudan import etmiyor — `shared/services/shopping_list_service.dart` soyut köprü servisi + `main.dart`'ta provider override ile çözüldü.

> **11.08 inceleme notu:** `finance`, `vault` ve `recipes` ekranlarında hâlâ `NoFamilyEmptyState` kontrolü eksik — bkz. Faz 15, madde "Aile-Yok CTA Kapsamını Genişlet".

---

## Faz 12 - Bildirimler ✅

- [x] Son Kullanma Bildirimi (Yerel Bildirim)
- [x] Garanti Bitiş Bildirimi (Yerel Bildirim)

---

## Faz 13 - AdMob Reklam Altyapısı Entegrasyonu (Monetization) ✅

- [x] `google_mobile_ads` paketinin projeye eklenmesi
- [x] Android (`AndroidManifest.xml`) ve iOS (`Info.plist`) için AdMob App ID konfigürasyonu
- [x] Singleton `AdService` katmanının kurulması (Banner, Interstitial, Rewarded)
- [x] `isPremium` bayrağı ile reklamların tek noktadan kontrolü/gizlenmesi
- [x] **Banner Reklam:** Ana ekran ve liste sayfalarının altına gömülü reklam widget'ının (`AdBannerWidget`) yerleştirilmesi
- [x] **Geçiş Reklamı (Interstitial):** Ürün ekleme akışına günde 1 defa sınırı olan (Frequency Capping) reklam mantığının bağlanması
- [x] **Ödüllü Reklam (Rewarded):** Aile/Ev oluşturma popup'ına _"1 Reklam İzle & Aile Oluştur"_ kurgusunun eklenmesi
- [x] Web (`kIsWeb`) platformu için çökme ve yükleme önleyici korumaların eklenmesi

---

## Faz 14 - 🗺️ Ev Asistanı - PRO & Freemium Dönüşüm Yol Haritası ⏳

- [x] **Aşama 1: Navigasyon ve Header Refaktörü**
  - Standardize 5'li Bottom Navigation Bar yapısı.
  - AppHeader bileşeninin genel mimariye entegrasyonu.
  - **GoRouter `StatefulShellRoute.indexedStack` Mimarisi:** BottomNavigationBar sekme geçişlerinde `initialLocation: true` parametresi ile sekme değiştirildiğinde açık kalan alt detay sayfalarının sıfırlanarak kök ekrana dönmesi sağlandı.

- [x] **Aşama 2: Ana Sayfa (Home Dashboard) UI/UX & Kısıtlamalar**
  - Ücretsiz kullanıcılar için Son Kullanma / Garanti kartı limitasyonları (`.take(1)`).
  - Kalan Serbest Bütçe (Nakit Akışı) Banner'ı & `ProBlurOverlay` entegrasyonu.
  - Yaklaşan Ödemeler mini kartı & Hızlı Ekle FAB modalı.

- [x] **Aşama 3: Envanter Ekranı Birleştirmesi & 👑 Dijital Ev Kasası (Vault)**
  - 3 Sekmeli Top TabBar (Son Kullanma, Garantiler, Dijital Ev Kasası).
  - Dijital Ev Kasası 4'lü Grid kart yapısı (Belgeler, Rehber, Bakım Takvimi, Kullanım Kılavuzları) ve PRO kilit mantığı.
  - `VaultItemModel` ve Firestore provider altyapısı.
  - Native dosya seçici UI'ı (Kamera / Galeri / PDF-Dosya) `image_picker` + `file_picker` ile bağlandı; manuel URL input alanı kaldırıldı.
  - **CRUD & Tam Düzenleme Desteği:** Belge kartlarına tıklandığında mevcut verilerle açılan Düzenleme (Edit BottomSheet) modalı bağlandı.
  - `share_plus` ile native paylaşım mekanizması eklendi.
  - [ ] ⚠️ **BİLİNEN SORUN — bkz. Faz 15:** Seçilen dosya Firebase Storage'a yüklenmiyor; `fileUrl` alanına cihazın yerel dosya yolu yazılıyor (`vault_document_form_bottom_sheet.dart`). Bu yüzden bir aile üyesinin eklediği belge diğer üyelerin cihazında **açılamıyor** — asıl "aile senkronizasyonu" vaadi bu modülde çalışmıyor.

- [x] **Aşama 3.5: Profil Görseli, Avatar & Emoji Yönetim Modülü**
  - Network/Google resim bağımlılığının kaldırılması.
  - [x] **Aşama 4: Finans & Nakit Akışı Modülü**
  - Sabit Giderler, Gelir/Gider takibi ve Gelir İdaresi özet kartları.
  - **Month-Picker Dinamik Arşiv:** Aylık gelir/gider ayrıştırması ve arşiv takibi.
  - Ödendi/Bekliyor (Paid/Pending) durum togglesı — Ödeme Takvimi satırlarında hızlı Checkbox + çarpı ile silme + "Sadece Bu Kaydı / Gelecek Tüm Tekrarları" diyalogları.
  - Bekleyen/Gerçekleşen ayrımı ve üstü çizili/gri stil ile liste gruplaması.
  - Kalan Serbest Bütçe hesaplamasının banka/nakit bakiyelerinden tamamen izole edilmesi (yalnızca seçili ayın Gelir − Gider farkı).
  - Toplam Net Varlık hesaplaması (Banka + Nakit + Kredi Kartı + Cari bakiyeler + Aylık Serbest Bütçe).
  - PRO kullanıcılar için PDF Nakit Akış Raporu aktarım altyapısı.

- [x] **Aşama 5: Profil Sekmesi & Paywall UI**
  - `PaywallBottomSheet` responsive layout düzenlemesi (16px RenderFlex overflow hatası giderildi).
  - `isPremiumProvider`: bireysel + aile + üye bazlı PRO kontrolü, Firestore `isPremium` alanını gerçek zamanlı dinliyor.

---

## Faz 15 - 🔧 Kritik Sağlamlaştırma (Release Öncesi Zorunlu) ✅

> 11.08 tarihli detaylı kod incelemesinde bulunan, release'e çıkmadan önce mutlaka kapatılması gereken maddeler. Öncelik sırasına göre listelenmiştir.

- [x] **Dijital Ev Kasası (Vault) — Bulut Depolama Entegrasyonu (P0):**
  - [x] `firebase_storage` paketini projeye ekle.
  - [x] `vault_document_form_bottom_sheet.dart`'ta seçilen dosyayı (`image_picker` / `file_picker` çıktısı) `families/{familyId}/vault/{itemId}` yoluna yükle.
  - [x] Firestore'a yerel dosya yolu yerine Storage'dan dönen `downloadURL`'i `fileUrl` olarak kaydet.
  - [x] `vault_documents_screen.dart`'taki paylaşım/önizleme mantığını (`Share.shareXFiles`, resim önizleme) gerçek URL ile çalışacak şekilde güncelle; büyük dosyalar için yükleme sırasında ilerleme göstergesi ekle.

- [x] **Profil Fotoğrafı — Gerçek Galeri/Kamera Entegrasyonu (P0):**
  - [x] `profile_edit_bottom_sheet.dart`'taki "Galeriden Seç" ve "Fotoğraf Çek" butonlarını gerçek `ImagePicker.pickImage` çağrılarına bağla.
  - [x] Seçilen fotoğrafı Firebase Storage'a (`users/{uid}/avatar.jpg`) yükleyip `avatarUrl`/`photoUrl` alanlarını gerçek indirme linkiyle güncelle.
  - [x] Sabit Unsplash placeholder URL'lerini kaldır (yalnızca "Hazır Avatarlar" galerisi için kullanılmaya devam edebilir, ama kullanıcı yükleme akışında olmamalı).

- [x] **Ödeme Takvimi — Tekrarlayan Kayıt Güncelleme Hatası (P1):**
  - [x] `payment_schedule_bottom_sheet.dart`'ta "Gelecek Tüm Tekrarları" güncellemesinde `updateData` map'inden `date` ve `isPaid` alanlarını çıkar; bu iki alan yalnızca tek kayıt düzenlemesinde (`single`) gönderilmeli.
  - [x] `FinanceRepository.updateRecurringPaymentSchedules` için birim testi ekle (aynı `recurringGroupId`'ye sahip 3+ kayıttan sadece gelecektekilerin, sadece ortak alanlarının değiştiğini doğrulayan).

- [x] **Firestore Güvenlik Kuralları — `families` Update İzni Sıkılaştırma (P1):**
  - [x] `firestore.rules`'ta `match /families/{familyId} { allow update: if isAuthenticated(); }` kuralını daralt: yalnızca üyesi olunan aile güncellenebilsin ya da kullanıcı `memberUids` listesine davet kodu ile tek seferde eklenebilsin.
  - [x] Alt koleksiyonların okuma/yazma izinleri için `isFamilyMember(familyId)` şartı zorunlu kılındı.

- [x] **Aile-Yok CTA Kapsamını Genişlet (P2):**
  - [x] `finance_screen.dart`, `vault/screens/*.dart` ve `recipes/screens/*.dart` ekranlarına da `hasRealFamilyProvider` kontrolü ile `NoFamilyEmptyState` ekle (şu an sadece home/expiration/warranty/shopping'de var).

- [x] **Ölü Kod Temizliği (P2):**
  - [x] `FinanceRepository.togglePaidStatus` hiçbir yerden çağrılmıyor — ya kullan (checkbox handler'ını buna yönlendir) ya da sil.

---

## Faz 16 - In-App Purchase & Freemium Model (Abonelik ve Ödeme) ✅

- [x] `purchases_flutter` (RevenueCat) paketinin projeye entegre edilmesi
- [x] Profil veya Ayarlar ekranına **"Premium'a Yükselt / Reklamları Kaldır"** butonunun ve yönlendirmesinin eklenmesi
- [x] Ödeme / Abonelik paketlerinin sunulduğu Paywall (Satın Alma) ekranı UI tasarımı — mevcut `PaywallBottomSheet` UI'ı temel alınacak
- [x] Satın alma başarılı olduğunda Firestore üzerindeki kullanıcı profilinde `isPremium: true` alanının güncellenmesi
- [x] `isPremium == true` olan kullanıcılar için tüm Reklam alanlarının (Banner, Geçiş, Ödüllü) gizlenmesi
- [x] Geçmiş satın alımları geri yükleme (**Restore Purchases**) mekanizmasının eklenmesi

---

## Faz 17 - Release & Canlıya Alış (Store Submission & Security) ✅

- [x] **İkon ve Görsel Kimlik:** `flutter_launcher_icons` ve `flutter_native_splash` paketleri yapılandırılarak Android (Adaptive & Android 12+) ve iOS için ikon ve native splash screen varlıkları üretildi.
- [x] **API Key & Güvenlik Altyapısı:** `flutter_dotenv` entegrasyonu tamamlandı. AdMob, RevenueCat ve servis anahtarları `.env` yapısına taşındı, `.env` dosyası `.gitignore` ile gizlendi ve `EnvConfig` güvenli erişim sınıfı kuruldu.
- [x] **Store Submission Pre-flight Check:** 
  - Android (`AndroidManifest.xml`) için `INTERNET` ve `ACCESS_NETWORK_STATE` izinleri ile AdMob App ID doğrulandı.
  - iOS (`Info.plist`) için zorunlu izin açıklama metinleri (`NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSUserTrackingUsageDescription`) eklendi.
- [x] **Sürüm & Kod Kalite Analizi:** `dart analyze lib/` ile 0 syntax/type hatası doğrulandı. `flutter build appbundle` ile AAB üretimi test edildi.
- [x] **Widget Test & Mock Temizliği:** Proje derleme bağımlılıkları ve mock altyapıları release öncesi stabilize edildi.
