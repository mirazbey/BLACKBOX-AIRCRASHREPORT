# BLACK BOX: AIR CRASH BUREAU (GAME DESIGN DOCUMENT)

---

## 1. VİZYON VE OYUN KİMLİĞİ

* **Oyun Başlığı:** *Black Box: Air Crash Bureau*
* **Tür:** Çok Oyunculu Asimetrik Dedüksiyon & Soruşturma (Co-op Aviation Investigation)
* **Platform:** Mobil (iOS & Android) — Teknoloji: Flutter + WebRTC
* **Seans Süresi:** 15 – 25 Dakika
* **Oyuncu Sayısı:** 1 (Solo AI/Eğitim) veya 2 – 4 Kişi (Hızlı Eşleşme / Özel Oda)
* **Temel Hedef:** Oyunculara hazır hikaye anlatılmaz; oyuncular bağımsız veri katmanlarını inceleyip telsiz üzerinden iletişim kurarak uçağın düşüş nedenini İsviçre Peyniri kaza zinciriyle ortaya çıkarır.

---

## 2. MAÇ DÖNGÜSÜ (CORE GAMEPLAY LOOP)

```
┌─────────────────────────────────────────────────────────────┐
│ 1. LOBİ & HIZLI EŞLEŞME ("Oyun Ara" Butonu)                 │
│ • Oyuncu eşleşme kuyruğuna girer. 2-4 kişi dolunca başlar.  │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. ASİMETRİK ROL DAĞITIMI (Gizli / Rastgele)                │
│ • Her oyuncunun telefonuna SADECE KENDİ UZMANLIK VERİSİ iner│
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. SORUŞTURMA & TELSİZ MUHABERESİ (15 Dakika)               │
│ • Dahili Bas-Konuş (Push-to-Talk) Havacılık Telsizi         │
│ • Herkes kendi ekranındaki anomalileri bulur ve anlatır     │
│ • Ortak "Dedektif Masası"na (Investigation Board) pin atma  │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. ORTAK RAPOR TESLİMİ & OYLAMA                             │
│ • Boşluk doldurmalı İsviçre Peyniri (Swiss Cheese) Raporu   │
│ • Ortak Karar veya Bireysel Ayrık Rapor Teslimi             │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. RESMİ RAPOR İLE YÜZLEŞME & SKOR                          │
│ • NTSB/BEA Resmi Rapor Animasyonu açılır                    │
│ • % Doğruluk Oranı, Kaçırılan İpuçları, Rütbe Puanı         │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. ASİMETRİK ROLLER & OYUNCU EKRANLARI

4 kişilik tam bir soruşturma ekibinde roller ve erişebildikleri ekranlar:

```
                  ┌─────────────────────────────────────┐
                  │          VAKA: FLIGHT 817           │
                  └──────────────────┬──────────────────┘
                                     │
         ┌──────────────────┬────────┴─────────┬──────────────────┐
         ▼                  ▼                  ▼                  ▼
┌─────────────────┐┌─────────────────┐┌─────────────────┐┌─────────────────┐
│ ROL 1: TELEMETRİ││ ROL 2: AKUSTİK  ││ ROL 3: ADLİ BAKIM││ ROL 4: METEOROLO│
│ & KARA KUTU     ││ & KOKPİT SESİ   ││ & OPERASYON      ││ Jİ & ENKAZ     │
├─────────────────┤├─────────────────┤├─────────────────┤├─────────────────┤
│ • FDR Grafikleri││ • CVR Ses Kaydı ││ • Uçak Bakım    ││ • Canlı Radar   │
│   (İrtifa, Hız, ││   (Kokpit içi   ││   Defteri (MEL) ││   Fırtına Harita│
│   Lövye, Motor) ││   konuşmalar)   ││ • Pilot Sağlık &││ • Enkaz Dağılım │
│ • GPWS/Stall    ││ • Kule (ATC)    ││   Uçuş Geçmişi  ││   Şeması        │
│   Alarmları     ││   Telsiz Kaydı  ││ • Şirket İçi    ││ • Rüzgar/Buzlan │
│ • Otopilot Modu ││ • Spektrum Ses  ││   Baskı E-maili ││   ma Katmanları │
└─────────────────┘└─────────────────┘└─────────────────┘└─────────────────┘
```

### Oynanış İçi Telsiz Diyaloğu Örneği:
* **Rol 2 (Akustik):** *(Telsize basar)* "Kaptan 'Gazı kökledim ama uçak hızlanmıyor' diyor, arkadan motor sesi geliyor."
* **Rol 1 (Telemetri):** "İmkansız! Bende motor devri (N1) %30 görünüyor. Pilot levyeyi geriye çekiyor ama motorlar rölantide!"
* **Rol 3 (Bakım):** "Bakım defterine bakın, 2 gün önce otomatik gaz kelebeği (Auto-throttle) arızalanmış ve 'manuel sefere devam' denmiş!"
* **Rol 4 (Meteoroloji):** "Ve şu an fırtına içine girmişler, aşırı buzlanma motor sensörünü kilitledi!"

---

## 4. İKİ VAKA MOTORU (EL YAPIMI VS. SONSUZ ÜRETİM)

### A. Tarihi / Hikayeli Vakalar (Handcrafted Cases)
* Gerçek havacılık felaketlerinin (AF447, Helios 522, Kegworth, Tenerife, Spanair 5022) kurgusallaştırılmış senaryoları.
* Profesyonel seslendirme, gerçek dökümler ve derin anlatım.
* **Format:** Sezonluk Paketler (Season Pass / Case DLC).

### B. Prosedürel Sonsuz Kaza Motoru (Procedural Swiss Cheese Engine)
Her yeni eşleşmede motor 4 katmanı rastgele birleştirerek benzersiz bir kaza senaryosu üretir:

```
[ KATMAN 1: TETİKLEYİCİ ] ➔ [ KATMAN 2: GİZLİ ARIZA ] ➔ [ KATMAN 3: İNSAN HATASI ] ➔ [ KATMAN 4: ÇEVRESEL FAKTÖR ]
 Örn: Pitot Buzlanması        Örn: İkaz Işığı Patlak     Örn: Yanlış Motoru Kapatma    Örn: Gece / Sıfır Görüş
```
* **Sonuç:** FDR grafiği, CVR dökümü ve bakım defteri bu parametrelere göre dinamik oluşturulur. Ezberlenemez, sonsuz tekrar oynanabilirlik sağlar.

---

## 5. DEDEKTİFLİK MEKANİĞİ: ÇELİŞKİ VE YALAN YAKALAMA (RED HERRINGS)

1. **Yanıltıcı Tanık (Red Herring):** Kabin amiri veya yolcu ifadesi teknik veriyle çelişir. Oyuncular bunu fark edip tanığı "Güvenilmez" olarak işaretlemelidir.
2. **Kör Noktalar (Fog of Mystery):** Her oyuncu kendi ekranındaki kritik bir bilgiyi tahtaya koymadan nihai kaza zinciri tamamlanamaz.
3. **İsviçre Peyniri Rapor Formu:** Maç sonunda oyuncular boşlukları delil kartlarıyla doldurur:
   > `[ Telsiz Arızası ]` ➔ `[ Kule Talimatının Yanlış Anlaşılması ]` ➔ `[ Sisli Havada İzin Almadan Piste Giriş ]` ➔ `[ Çarpışma ]`

---

## 6. GELİR MODELİ (MONETIZATION)

* **Fiyatlandırma:** Ücretsiz İndirme (Free-to-Play).
* **Ücretsiz İçerik:** 1 Eğitim Vakası + 2 Tarihi Vaka + Günde 2 Maç Ücretsiz Prosedürel Matchmaking.
* **Vaka Paketleri (IAP):** 3'lü Tarihi Kaza Paketleri ($2.99 – $4.99).
* **Sınırsız Dedektiflik Lisansı:** Tek Seferlik ($9.99 ömür boyu sınırsız prosedürel vaka).
* **Kozmetikler:** Özel Telsiz Filtreleri (Retro 70'ler Kule Sesi, Modern Dijital VHF), Özel Soruşturma Masası Temaları.
