lib/

core/
theme/
constants/
services/
utils/

features/

    home/

        data/
        models/
        repository/
        providers/
        screens/
        widgets/

    expiration/

    warranty/

    shopping/

    profile/

shared/

    widgets/

    models/

main.dart

## Feature İsimlendirme

Kod tarafında feature klasörleri İngilizce olacaktır.

| Türkçe Modül   | Feature Klasörü |
| -------------- | --------------- |
| Ana Sayfa      | home            |
| Son Kullanma   | expiration      |
| Garanti Takibi | warranty        |
| Alışveriş      | shopping        |
| Profil         | profile         |

# Mimari Kuralları

Her feature kendi içinde bağımsızdır.

Feature'lar birbirlerinin dosyalarına doğrudan erişmez.

Ortak widgetlar yalnızca shared/widgets altında bulunur.

Global servisler yalnızca core/services altında bulunur.

Yeni feature eklenirken aynı klasör yapısı korunur.
