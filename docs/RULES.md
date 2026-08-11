# Kodlama Kuralları

## Framework

Flutter

## Dil ve Lokalizasyon (i18n)

Çoklu Dil ve Çoklu Para Birimi Desteği Zorunlu:

- **Desteklenen Diller:** Türkçe (tr), İngilizce (en), Almanca (de), İspanyolca (es), Fransızca (fr), Azerice (az), Yunanca (el), Portekizce (pt).
- **Desteklenen Para Birimleri:** TRY (₺), USD ($), EUR (€), AZN (₼), BRL (R$), GBP (£).

## Architecture

Feature First (Özellik Odaklı Mimarî)

## State Management

Riverpod (StreamProvider / StateNotifier)

## Database & Backend

Firebase Cloud Firestore & Firebase Auth

## Notifications

flutter_local_notifications

## Theme

Material Design 3 (Dark & Light Theme Desteği)

## Responsive

Telefon ekranları desteklenecek.

## Null Safety

Zorunlu.

---

# Dil, Para Birimi ve Lokalizasyon Kuralları

- **Hardcoded Metin Yasağı:** UI bileşenlerinde, dialoglarda, toast mesajlarında veya modellerde KESİNLİKLE sabit (hardcoded) metin kullanılmayacaktır.
- **Dil Anahtarları:** Tüm metinler `AppLocalizations` / `context.l10n` (veya projedeki ilgili i18n yapısı) üzerinden çağrılacaktır.
- **Kategori ve Enum Metinleri:** Veritabanında veya kodda sabit duran kategori isimleri (Örn: _Kitchen & Grocery_, _Transport_ vb.) arayüzde gösterilirken her zaman kullanıcının seçili diline uygun lokalize metin metodu/extension'ı üzerinden (`category.localizedName(context)`) gösterilecektir.
- **Dinamik Para Birimi Biçimlendirme:** Para birimi simgeleri (₺, $, €, ₼, R$, £) veya metinleri hardcoded yazılmayacak; kullanıcının seçtiği aktif para birimi konfigürasyonuna (`CurrencyProvider` / `userCurrency`) göre dinamik biçimlendirilecektir.

---

# Dosya Kuralları

- Her ekran kendi klasöründe (`features/`) olacak.
- Büyük widget yazılmayacak, modüler parçalara bölünecek.
- Ortak bileşenler `COMPONENTS.md` dosyasına uygun geliştirilecek.
- Kod tekrarından kaçınılacak.
- Veritabanı işlemleri doğrudan UI içinden değil, ilgili Feature altındaki `repository/` ve `providers/` üzerinden yürütülecektir.

---

# Kod Yazarken

- Sadece ilgili dosyaları değiştir.
- Aynı widget ikinci kez oluşturulmayacak.
- Önce `shared/widgets` klasörü kontrol edilecek.
- Hardcoded değerlerden kaçınılacak.
- Sabitler gerektiğinde `core/constants` altında tutulacak.
- Veritabanı sorguları her zaman aktif kullanıcının `familyId` (Ev ID) değerine göre filtrelenecek.

---

# İsimlendirme

**Dosyalar:**
snake_case

**Sınıflar:**
PascalCase

**Değişkenler:**
camelCase
