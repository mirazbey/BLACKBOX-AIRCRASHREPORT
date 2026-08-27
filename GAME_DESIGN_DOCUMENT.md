# BLACKBOX-AIRCRASHREPORT (GAME DESIGN DOCUMENT)

---

## 1. VİZYON VE OYUN KİMLİĞİ

* **Oyun Başlığı:** *BLACKBOX-AIRCRASHREPORT*
* **Tür:** Çok Oyunculu Asimetrik Dedüksiyon & Adli Tıp Kriz Masası (Co-op Aviation Forensics & Investigation)
* **İlham Kaynağı:** *Rainbow Six Siege / Valorant Operatör Dinamikleri + Mayday: Air Crash Investigation + Apex Taktiksel Ping Sistemi*
* **Platform:** Mobil (iOS & Android) — Teknoloji: Flutter (Offline-First / Edge WebSocket)
* **Seans Süresi:** 15 – 20 Dakika (3 Fazlı Taktiksel Sprint Döngüsü)
* **Oyuncu Sayısı:** 1 (Solo AI/Rol Değiştirme) veya 5 Kişi (5 Operatörlü Kriz Masası)
* **Temel Felsefe:** Oyunculara hazır metin verilmez. 5 uzman operatör kendi özel terminalindeki canlı grafikleri, ses dalgalarını, termal kamera kayıtlarını, bakım belgelerini ve biyometrik sorgu ağacını inceler; taktik telsiz çarkından direktif paslaşarak uçağın düşüş nedenini İsviçre Peyniri Kaza Modeli üzerinden çözerler.

---

## 2. MAÇ DÖNGÜSÜ (CORE 3-PHASE SPRINT LOOP)

```
┌─────────────────────────────────────────────────────────────┐
│ 1. LOBİ & 5 KİŞİLİK KRİZ MASASI EŞLEŞMESİ                   │
│ • "Oyun Ara" radarı 5 oyuncuyu toplar, rolleri gizli dağıtır│
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ FAZ 1: ALARM & HIZLI ANOMALİ TARAMASI (30-45 Saniye)        │
│ • Her operatör kendi terminalindeki acil anomalileri yakalar│
│ • FDR hız düşüşünü, FLIR pitot buzunu, CVR stall ikazını bul│
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ FAZ 2: TAKTİK TELSİZ ÇARKI & DELİL PASLAŞMASI (45-60 Saniye)│
│ • Sesli sohbet YOKTUR. Taktik Çarktan hızlı direktif atılır:│
│   [🚨 ACİL ZAMAN SENKRONU] [🔍 ÇELİŞKİ VAR] [👤 SORGU İSTE] │
│ • Deliller masaya fırlatılır; araya Kırmızı Çelişki İpi çeki│
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ FAZ 3: NTSB RAPOR OYLAMASI & MÜHÜRLEME                      │
│ • İsviçre Peyniri boşlukları doldurulur (Tetikleyici, İnsan,│
│   Gizli Bakım, CRM Hatası). Heyet oylaması yapılır.         │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ BÜYÜK FİNAL: SİNEMATİK KAZA REKONSTRÜKSİYON KOLAJI & XP     │
│ • 5 Operatörün bulduğu delillerden oluşan 5 Sahneli FİLM!   │
│ • Bireysel Operatör XP Karnesi, MVP Rozeti ve Rütbe Terfisi │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. 5 ASİMETRİK OPERATÖR (ROLLER & ÖZEL TERMİNALLER)

```
                            ┌────────────────────────────────────────────────────────┐
                            │           BLACKBOX-AIRCRASHREPORT KRİZ MASASI          │
                            └───────────────────────────┬────────────────────────────┘
                                                        │
         ┌──────────────────┬───────────────────────────┼───────────────────────────┬──────────────────┐
         ▼                  ▼                           ▼                           ▼                  ▼
┌─────────────────┐┌─────────────────┐         ┌─────────────────┐         ┌─────────────────┐┌─────────────────┐
│ OP-01: TELEMETRİ││ OP-02: AKUSTİK  │         │ OP-03: FLIR     │         │ OP-04: BAKIM    ││ OP-05: PSİKOLOG │
│ (FDR Mühendisi) ││ (CVR Analisti)  │         │ (Video Rekonst.)│         │ (MEL Müfettişi) ││ (CRM & Sorgu)   │
├─────────────────┤├─────────────────┤         ├─────────────────┤         ├─────────────────┤├─────────────────┤
│ • Canlı PFD     ││ • İnteraktif Ses│         │ • Termal FLIR   │         │ • MEL Arıza     ││ • Çapraz Sorgu  │
│   Yapay Ufuk    ││   Dalga Formu   │         │   Palet Filtresi│         │   Defteri       ││   Diyalog Ağacı │
│ • İrtifa/Sürat  ││ • DSP Ses İzol. │         │ • Gece Kokpit   │         │ • Şirket İçi    ││ • Canlı EKG/    │
│   Zaman Eğrisi  ││   (Voice/Alarm) │         │   CCTV (VHS)    │         │   Gizli Mail    ││   Poligraf Testi│
│ • Lövye Açısı % ││ • 4-Kanal CVR   │         │ • 3D Darbe Tel  │         │ • Islak İmza &  ││ • Pilot/Teknisyen│
│ • Stall Alarmlar││   Transkripti   │         │   Kafes Modeli  │         │   Mühür Analizi ││   İtirafları    │
└─────────────────┘└─────────────────┘         └─────────────────┘         └─────────────────┘└─────────────────┘
```

---

## 4. TAKTİK TELSİZ ÇARKI (NON-VOICE DIRECTIVE WHEEL)

Sesli sohbetin getirdiği arka plan gürültüsü, dil bariyeri ve toksisite tamamen kaldırılmıştır. Bunun yerine:

| Direktif Kodu | Telsiz Mesajı | Hedef Operatör | Etkisi |
| :--- | :--- | :--- | :--- |
| **`🚨 ACİL ZAMAN SENKRONU`** | *"T+66s anomali anına geçin ve verilerinizi eşitleyin!"* | Herkese (Broadcast) | Tüm ekranların zaman kursörünü tek tıkla o saniyeye odaklar. |
| **`🔍 ÇELİŞKİ BİLDİR`** | *"Bu ifade telemetri verileriyle çelişiyor!"* | Ortak Tahta | İki delil arasına kalın Kırmızı Çelişki İpi çeker. |
| **`👤 SORGU TALEBİ`** | *"Psikolog: Pilotun lövye çekiş motivasyonunu sorgulayın!"* | OP-05 [CRM] | Psikoloğun ekranında ilgili tanık soru dalını parlatır. |
| **`🛠️ MEL KONTROLÜ`** | *"Bakım: Pitot ısıtıcısının MEL erteleme kaydını bulun!"* | OP-04 [MEL] | Bakım kütüğündeki ertelenen arıza sayfasına odaklatır. |
| **`📹 FLIR ODAKLANMA`** | *"FLIR: T+66s termal kamerasında pitot donmasını doğrulayın!"* | OP-03 [FLIR] | Video oynatıcıyı FLIR termal kamera açısına kilitler. |
| **`✅ HİPOTEZ ONAYLANDI`** | *"Bu delil kök neden zincirini doğruluyor, masaya pinliyorum!"* | Herkese | İsviçre peyniri kaza zincirine yeşil teyit mührü basar. |

---

## 5. BÜYÜK FİNAL: SİNEMATİK KAZA REKONSTRÜKSİYON KOLAJI

Soruşturma raporu teslim edildikten sonra 5 operatör ortak bir sinema ekranına kilitlenir:
1. **1. Sahne (OP-04 Bakım):** 2 gün önceki MEL bakım ertelemesi belgesi ekranda mühürlenir.
2. **2. Sahne (OP-03 FLIR):** T+66s'de pitot tüplerinin buz tuttuğu termal FLIR görüntüsü oynar.
3. **3. Sahne (OP-01 FDR):** T+75s'de otopilotun atışı ve lövyenin geriye çekildiği PFD HUD grafiği oynar.
4. **4. Sahne (OP-02 CVR):** T+152s'de kaptanın kokpite girişi ve STALL alarmının ses dalgaları çınlar.
5. **5. Sahne (OP-05 CRM):** T+240s'de uçağın okyanusa çarpış tel kafes simülasyonu oynar.

---

## 6. OPERATÖR BİREYSEL XP & RÜTBE SİSTEMİ

Her operatör kendi uzmanlık alanındaki doğruluğuna göre bireysel puan ve unvan kazanır:
* **XP Dağılımı:**
  * Kök Neden Tespiti: **+500 XP**
  * Yanıltıcı İpucunu (Red Herring) Çürütme: **+200 XP**
  * Hızlı Telsiz Eşzamanlaması: **+100 XP**
  * **★ MVP Unvanı:** Maçın en yüksek doğruluk oranına sahip uzmanına verilir (+250 Bonus XP).
* **Rütbe Terfileri:**
  1. *Stajyer Araştırmacı (Level 1-5)*
  2. *Kıdemli Saha Müfettişi (Level 6-15)*
  3. *Başmüfettiş (Level 16-30)*
  4. *NTSB Daire Başkanı / Bureau Director (Level 31+)*
* **Açılabilir İçerikler:** Klasik tarihi kaza dosyaları (*Tenerife, Helios 522, Concorde*), özel HUD termal filtre kaplamaları ve adli dedektif unvanları.
