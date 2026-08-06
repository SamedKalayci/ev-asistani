---
name: Modern Ev
colors:
  surface: '#f9f9fe'
  surface-dim: '#d9dade'
  surface-bright: '#f9f9fe'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f8'
  surface-container: '#ededf2'
  surface-container-high: '#e8e8ed'
  surface-container-highest: '#e2e2e7'
  on-surface: '#1a1c1f'
  on-surface-variant: '#3d4a3c'
  inverse-surface: '#2e3034'
  inverse-on-surface: '#f0f0f5'
  outline: '#6d7b6b'
  outline-variant: '#bccbb8'
  surface-tint: '#006e28'
  primary: '#006e28'
  on-primary: '#ffffff'
  primary-container: '#34c759'
  on-primary-container: '#004d1a'
  inverse-primary: '#53e16f'
  secondary: '#5f5e60'
  on-secondary: '#ffffff'
  secondary-container: '#e2dfe1'
  on-secondary-container: '#636264'
  tertiary: '#005bc1'
  on-tertiary: '#ffffff'
  tertiary-container: '#85aeff'
  on-tertiary-container: '#003f8a'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#72fe88'
  primary-fixed-dim: '#53e16f'
  on-primary-fixed: '#002107'
  on-primary-fixed-variant: '#00531c'
  secondary-fixed: '#e4e2e4'
  secondary-fixed-dim: '#c8c6c8'
  on-secondary-fixed: '#1b1b1d'
  on-secondary-fixed-variant: '#474649'
  tertiary-fixed: '#d8e2ff'
  tertiary-fixed-dim: '#adc6ff'
  on-tertiary-fixed: '#001a41'
  on-tertiary-fixed-variant: '#004493'
  background: '#f9f9fe'
  on-background: '#1a1c1f'
  surface-variant: '#e2e2e7'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  container-margin: 20px
  gutter: 16px
---

## Brand & Style

Bu tasarım sistemi, akıllı ev yönetimi için profesyonel, güvenilir ve yüksek kaliteli bir kullanıcı deneyimi sunmayı hedefler. Modern startup estetiğini yansıtan sistem, **Apple Human Interface Guidelines**'ın zarif sadeliği ile **Material Design 3**'ün işlevsel derinliğini birleştirir.

Hedef kitle, yaşam alanlarında teknoloji ve konforu bir arada arayan, düzene ve estetiğe önem veren kullanıcılardır. Arayüz; havadar, organize ve davetkar bir atmosfer yaratarak karmaşık ev otomasyonu süreçlerini basitleştirir. Tasarım dili, geniş beyaz alanlar ve yüksek kaliteli tipografi kullanımıyla ferahlık hissi uyandırırken, yumuşak geçişlerle teknolojik bir sofistikasyon sunar.

## Colors

Renk paleti, temizlik ve canlılık üzerine kuruludur. Ana aksiyon rengi olan **Canlı Yeşil (#34C759)**, enerji tasarrufunu ve evdeki yaşamı simgeler. 

- **Primary:** Ana etkileşimler, aktif durumlar ve başarı geri bildirimleri için kullanılır.
- **Neutral/Surface:** Saf beyaz (#FFFFFF) arka plan üzerine, derinlik oluşturmak ve farklı alanları gruplandırmak için çok açık gri tonları kullanılır.
- **Text:** Metin hiyerarşisi için koyu antrasit (#1C1C1E) ve ikincil bilgiler için orta gri tonları tercih edilir.
- **Borders:** Kart sınırlarını ve giriş alanlarını belirlemek için çok ince ve düşük kontrastlı gri çizgiler kullanılır.

## Typography

Sistem, maksimum okunabilirlik ve modern bir duruş için **Inter** yazı tipini kullanır. Tipografi hiyerarşisi, bilgi yoğunluğunu yönetmek ve kullanıcıyı yönlendirmek için net ağırlık farklarına dayanır.

Başlıklarda daha sıkı harf arası boşluğu (letter-spacing) kullanılarak premium bir dergi mizanpajı hissi verilir. Gövde metinlerinde ise konforlu bir okuma için cömert satır yükseklikleri tercih edilmiştir. Mobil cihazlarda, büyük başlıklar ekran genişliğine uyum sağlamak adına dinamik olarak ölçeklenir.

## Layout & Spacing

Tasarım sistemi 8px tabanlı bir ızgara (grid) sistemi üzerine kuruludur. Bu ritim, tüm bileşenler arasında matematiksel bir uyum sağlar.

- **Desktop:** 12 sütunlu fluid grid, maksimum 1440px genişlik.
- **Mobile:** 4 sütunlu yapı, 20px yan marjinler ve 16px sütun arası boşluk.
- **Hiyerarşi:** Gruplandırılmış öğeler arasında `sm` (12px), ana bölümler arasında `xl` (32px) boşluk bırakılarak görsel nefes alanları oluşturulur.

İçerik akışı, "önce mobil" yaklaşımıyla tasarlanmıştır; kartlar masaüstünde yan yana dizilirken mobil ekranlarda dikey olarak istiflenir.

## Elevation & Depth

Bu tasarım sisteminde derinlik, sert gölgeler yerine **tonal katmanlar** ve **ortam gölgeleri** ile sağlanır. 

- **Z-0 (Arka Plan):** Saf beyaz.
- **Z-1 (Kartlar):** Arka plandan çok hafif bir gölge (Blur: 20px, Y: 4px, Opacity: %4 Black) veya ince bir border (1px, #E5E5EA) ile ayrılır.
- **Z-2 (Modallar/Floating):** Daha belirgin ama yine de yumuşak gölgeler (Blur: 40px, Y: 12px, Opacity: %8 Black).

Cam efekti (Backdrop blur), özellikle alt navigasyon barlarında ve üst başlık alanlarında içeriğin altından hafifçe sızmasını sağlayarak derinlik hissini pekiştirir.

## Shapes

Tasarım sisteminin en karakteristik özelliği, son derece yumuşak ve geniş köşelerdir. Bu tercih, teknolojik bir araca insani ve dostane bir dokunuş katar.

- **Standart Kartlar:** 24px köşe yarıçapı (radius).
- **Giriş Alanları (Inputs):** 12px - 16px köşe yarıçapı.
- **Butonlar:** Tam yuvarlak (Pill-shaped) veya 16px köşe yarıçapı.
- **Konteynerlar:** Büyük ana panellerde 32px'e kadar çıkan radius değerleri kullanılır.

## Components

### Butonlar
Birincil butonlar dolu (solid) yeşil arka plan ve beyaz metinle sunulur. İkincil butonlar ise ince gri bir çerçeve veya hafif gri bir dolgu ile tasarlanır. Hover ve aktif durumlarında renk tonu %10 oranında koyulaşır.

### Kartlar (Dashboard Cards)
Uygulamanın temel yapı taşıdır. 24px-32px arası radius değerine sahip, beyaz zeminli ve çok ince gri borderlıdır. İçerisinde geniş padding (24px) barındırır. Cihaz durumları (açık/kapalı) kartın ikon rengi veya arka planındaki çok hafif bir renk değişimi ile belirtilir.

### Giriş Alanları (Inputs)
Minimalist bir yaklaşımla, sadece alt çizgi veya tam çevreleyen çok ince bir border ile sunulur. Odaklanıldığında (focus) border rengi birincil yeşile döner.

### Çipler (Chips)
Kategori seçimi veya oda filtreleme için kullanılır. Seçili durumda yeşil dolgu, pasif durumda ise hafif gri dolgu ile yüksek yuvarlaklıkta tasarlanır.

### Listeler
Liste öğeleri arasında ayrıcı çizgiler (divider) yerine geniş boşluklar kullanılır. Her öğe etkileşim alanı olarak geniş tutulur (minimum 56px yükseklik).

### Kontrol Elemanları (Switches & Sliders)
iOS stili yuvarlak switchler kullanılır. Sliderlar, dokunmatik hassasiyeti yüksek, kalın ve yumuşak hatlara sahiptir.