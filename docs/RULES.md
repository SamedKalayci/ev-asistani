# Kodlama Kuralları

## Framework

Flutter

## Dil

Türkçe

## Architecture

Feature First (Özellik Odaklı Mimarî)

## State Management

Riverpod (StreamProvider / StateNotifier)

## Database & Backend

Firebase Cloud Firestore & Firebase Auth

## Notifications

flutter_local_notifications

## Theme

Material Design 3

## Responsive

Telefon ekranları desteklenecek.

## Null Safety

Zorunlu.

---

# Dosya Kuralları

- Her ekran kendi klasöründe (features/) olacak.
- Büyük widget yazılmayacak, modüler parçalara bölünecek.
- Ortak bileşenler COMPONENTS.md dosyasına uygun geliştirilecek.
- Kod tekrarından kaçınılacak.
- Veritabanı işlemleri doğrudan UI içinden değil, ilgili Feature altındaki `repository/` ve `providers/` üzerinden yürütülecektir.

---

# Kod Yazarken

- Sadece ilgili dosyaları değiştir.
- Aynı widget ikinci kez oluşturulmayacak.
- Önce shared/widgets klasörü kontrol edilecek.
- Hardcoded değerlerden kaçınılacak.
- Sabitler gerektiğinde core/constants altında tutulacak.
- Veritabanı sorguları her zaman aktif kullanıcının `familyId` (Ev ID) değerine göre filtrelenecek.

---

# İsimlendirme

Dosyalar

snake_case

Sınıflar

PascalCase

Değişkenler

camelCase
