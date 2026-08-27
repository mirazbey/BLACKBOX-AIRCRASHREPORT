# BLACK BOX: FINAL REPORT — ANTIGRAVITY REVİZYON VE DEVİR RAPORU

> **Belge amacı:** Mevcut prototipte tespit edilen oynanış sorunlarını, kabul edilen yeni maç döngüsünü ve Antigravity'nin uygulaması gereken teknik/tasarım işlerini tek kaynakta toplamak.
>
> **Durum:** Uygulama öncesi ürün kararı ve uygulama brifi  
> **Öncelik:** Görev derinliği ve çevrim içi karar döngüsü; sinematik/video katmanı daha sonra  
> **Kapsam:** Flutter istemci, vaka verisi, puanlama ve gerçek zamanlı oda durumu

---

## 1. YÖNETİCİ ÖZETİ

Mevcut prototip görsel olarak güçlü bir adli havacılık terminali hissi vermektedir; ancak temel görevler çoğunlukla **sekme açma, hazır cevabı okuma ve delili tek dokunuşla pinleme** seviyesindedir. Oyuncu gözlem yapmak, hipotez kurmak, alternatifleri elemek veya bir delilin hangi iddiayı desteklediğini açıklamak zorunda kalmamaktadır.

Revizyonun ana hedefi şudur:

> Oyuncuya doğru cevabı göstermek yerine, her uzmanı kendi ham verisi üzerinde kısa ve ölçülebilir bir analiz yapmaya; bulgusunu yapılandırılmış bir iddia kartıyla savunmaya; ardından yetkili Başmüfettişi yazılı tartışmada ikna etmeye zorlamak.

Yeni çevrim içi oyun döngüsü:

1. Beş uzman sırayla **30 saniyelik özel inceleme nöbeti** kullanır.
2. Her uzman gözlem, çıkarım, güven seviyesi ve kaynak delilden oluşan bir **İddia Kartı** teslim eder.
3. Beş nöbet bittikten sonra ekip **60 saniye yazılı müzakere** yapar.
4. Maç başında beş oyuncudan birine ek yetki olarak verilen **Başmüfettiş**, sonraki **60 saniyede** nihai nedensellik zincirini kurar ve raporu mühürler.
5. Oyun, kararın doğruluğunu ve her oyuncunun gerçek katkısını ayrı ayrı puanlar.

Bu yapı mantıklıdır ve oyunun sosyal gerilimini ciddi biçimde artırır. Ancak bekleyen oyuncular tamamen pasif bırakılmamalıdır. Aktif olmayan oyuncular, nöbet sırasında sınırlı gözlem, not hazırlama ve tek soruluk itiraz kuyruğu gibi faaliyetlerle oyunda tutulmalıdır.

---

## 2. KESİN ÜRÜN KARARLARI

### 2.1. Oyuncu ve rol yapısı

- Oda toplam **5 oyuncudan** oluşur.
- Mevcut beş uzmanlık korunur:
  - OP-01 — FDR / Telemetri Mühendisi
  - OP-02 — CVR / Akustik Analisti
  - OP-03 — FLIR / Video Rekonstrüksiyon Uzmanı
  - OP-04 — MEL / Adli Bakım Müfettişi
  - OP-05 — İnsan Faktörleri / CRM Uzmanı
- **Başmüfettiş altıncı bir rol değildir.** Maç başında bu beş uzmandan birine verilen ek bir liderlik yetkisidir.
- Başmüfettiş kendi uzmanlık nöbetini diğerleri gibi tamamlar; final fazında ise tek karar verici olur.
- İlk sürümde Başmüfettiş rastgele seçilebilir. Sonraki sürümde gönüllülük, rütbe, güvenilirlik puanı veya oda oylaması eklenebilir.

### 2.2. İletişim

- Sesli sohbet yoktur.
- Serbest yazılı sohbet yalnızca müzakere fazında açıktır.
- İnceleme nöbetlerinde yapılandırılmış kısa mesajlar kullanılır:
  - `KAYNAK İSTE`
  - `ZAMAN UYUŞMAZLIĞI`
  - `İTİRAZ HAZIRLA`
  - `BU DELİLİ DESTEKLİYORUM`
- Hazır mesajlar cevabı söylememeli; yalnızca belirsizliği veya araştırılacak aralığı bildirmelidir.

### 2.3. Oturum süresi

- Beş uzman nöbeti: `5 × 30 sn = 150 sn`
- Genel yazılı müzakere: `60 sn`
- Başmüfettiş inceleme ve karar: `60 sn`
- Brifing, geçişler ve sonuç: yaklaşık `60–120 sn`
- Hedef toplam: **5–7 dakikalık mobil vaka sprinti**

Mevcut belgelerdeki 15–20 dakikalık maç hedefi bu kararla çelişmektedir. Uzun maç istenirse tek süreyi uzatmak yerine aynı vaka içinde iki veya üç delil dalgası açılmalıdır.

---

## 3. YENİ MAÇ AKIŞI

```text
LOBI / ROL DAĞITIMI
        │
        ▼
BRİFİNG — 15 sn
• Vaka özeti, kurallar, Başmüfettiş ilanı
        │
        ▼
UZMAN NÖBETLERİ — 5 × 30 sn
• Sıradaki uzman kendi terminalini kullanır
• Diğerleri gözlemci modunda not ve tek soru hazırlar
• Uzman süre bitmeden İddia Kartı teslim eder
        │
        ▼
GENEL MÜZAKERE — 60 sn
• Yazılı sohbet açılır
• Delil kartları desteklenir veya çürütülür
• Başmüfettiş soru sorar ve çelişkileri işaretler
        │
        ▼
BAŞMÜFETTİŞ KARARI — 60 sn
• Diğer oyuncular salt okunur izleyici olur
• Başmüfettiş neden zincirini ve delil bağlarını kurar
• Rapor mühürlenir; süre biterse mevcut taslak otomatik teslim edilir
        │
        ▼
SİNEMATİK REKONSTRÜKSİYON + TAKIM/BİREYSEL PUAN
```

### 3.1. Uzman nöbeti — 30 saniye

Aktif oyuncu yalnızca kendi rol aracına tam erişim kazanır. Süre sonunda aşağıdaki yapıda tek bir **İddia Kartı** teslim etmelidir:

```json
{
  "observation": "T+64–72 arasında üç IAS kanalından ikisi eşzamanlı düşüyor.",
  "inference": "Ortak sensör çevresi veya pitot kaynaklı güvenilmez sürat olasılığı.",
  "confidence": 72,
  "evidence_ids": ["EVD_FDR_SPD_DROP"],
  "time_range": { "start": 64, "end": 72 }
}
```

Kurallar:

- **Gözlem**, ham veride gerçekten görülen şeyi anlatır.
- **Çıkarım**, oyuncunun bundan çıkardığı hipotezdir; sistem tarafından hazır yazılmaz.
- Güven seviyesi yüzde veya `Düşük / Orta / Yüksek` olarak seçilir.
- En az bir kaynak delil veya zaman aralığı bağlanmadan kart doğrulanmış sayılmaz.
- Süre biterse eksik taslak teslim edilir ve puan kaybı oluşur; doğru cevap otomatik açılmaz.

### 3.2. Bekleyen oyuncuların aktif tutulması

Dört oyuncuyu her nöbette tamamen kilitlemek toplamda kişi başına yaklaşık iki dakika boş bekleme yaratır. Bu nedenle gözlemci modu şu hakları vermelidir:

- Aktif uzmanın imleç/zaman aralığı hareketini gecikmeli izleme.
- Kişisel not defterine taslak yazma.
- Sonraki müzakere için en fazla **bir soru veya itiraz** kuyruğa alma.
- Aktif uzmana cevabı söylemeyen tek bir yapılandırılmış uyarı gönderme.
- Kendi özel terminalini açamama ve yeni delil işleyememe.

Bu kısıt, nöbetin sahipliğini korurken diğer oyuncuların dikkatini canlı tutar.

### 3.3. Genel müzakere — 60 saniye

- Beş İddia Kartı ortak masada görünür.
- Yazılı mesajlar rol etiketi ve renk koduyla gösterilir.
- Her oyuncuya önerilen sınır: en fazla **3 kısa mesaj** ve **1 kart itirazı**.
- Mesaj türleri:
  - Serbest kısa savunma
  - Delili destekleme
  - Delili çürütme
  - Kaynak/zaman kodu isteme
  - Alternatif hipotez önerme
- Başmüfettiş bir karta `KABUL ADAYI`, `ŞÜPHELİ` veya `YETERSİZ KAYNAK` etiketi koyabilir.

Mesaj sınırı, mobil ekranda beş kişinin aynı anda oluşturacağı gürültüyü azaltır ve ikna gücünü mesaj sayısından daha önemli hâle getirir.

### 3.4. Başmüfettiş kararı — 60 saniye

Başmüfettiş şu bilgileri görür:

- Beş uzmanın İddia Kartları
- Her karta bağlı orijinal deliller
- Ortak zaman çizelgesi
- Destek ve itiraz sayıları
- Tespit edilmiş çelişkiler
- Oyuncuların güven beyanları

Başmüfettiş şu dört nedensellik alanını doldurur:

1. Çevresel koşul
2. Gizli organizasyonel/bakım faktörü
3. Doğrudan tetikleyici
4. İnsan faktörü/CRM tepkisi

Her neden düğümüne ayrı delil bağlanmalıdır. Aynı delilin birden fazla düğümde kullanılması mümkün olabilir; fakat sistem oyuncudan ilişki türünü seçmesini ister: `DESTEKLER`, `ÇÜRÜTÜR`, `NEDEN OLUR`, `SONUCUDUR`.

Başmüfettişin bir kez kullanabileceği **SON SORU** hakkı olabilir. Bu hak seçilen uzmana 100 karakterlik son cevap ve 10 saniye ek süre verir. Ana zaman durmaz.

Başmüfettiş süre bitmeden `RAPORU MÜHÜRLE` butonuna basmazsa mevcut taslak otomatik gönderilir. Hiç düğüm doldurulmamışsa sonuç `YETERSİZ BULGU / KARARSIZ RAPOR` olur.

---

## 4. ROL BAZLI GÖREVLERİN DERİNLEŞTİRİLMESİ

### OP-01 — FDR / Telemetri

Mevcut sorun: Düşüş noktası ve doğru yorum görsel olarak fazla açık.

Yeni görev:

- Üç farklı IAS kanalını karşılaştır.
- Anomali başlangıç/bitiş aralığını grafikte işaretle.
- İrtifa, hücum açısı, dikey hız ve lövye girdisini aynı zaman aralığında üst üste getir.
- `Sensör arızası`, `gerçek hız kaybı` veya `veri kesintisi` hipotezlerinden birini gerekçeyle seç.

### OP-02 — CVR / Akustik

Mevcut sorun: Dalga formu dekoratif; transkript ve alarm etiketi doğrudan açık.

Yeni görev:

- Ham kayıtta zaman aralığı seç.
- Uygun bant geçiren filtreyi ve kanalı kullan.
- Gürültü altındaki kelime/alarm sınıfını etiketle.
- CVR olayını ortak zaman çizgisiyle senkronla.
- Yanlış filtre veya aşırı kazanç, sinyali bozarak güven puanını düşürsün.

### OP-03 — FLIR / Video

Mevcut sorun: Görsel doğru nesneye doğrudan odaklanırsa video cevabı verir.

Yeni görev:

- 4–8 saniyelik ham/adli klibi kare kare tara.
- Doğru karede ilgi bölgesi çiz.
- Palet/kontrast filtresi seç.
- Buzlanma, yansıma, sıkıştırma artefaktı ve yağmur izini ayırt et.
- Sistem yalnızca işaretlenen bölge ve diğer deliller tutarlıysa bulguyu doğrulasın.

### OP-04 — MEL / Adli Bakım

Mevcut sorun: Hazır ping ve soru metni ertelenmiş pitot arızasını açıkça söyler.

Yeni görev:

- Arıza kayıtları arasında doğru uçak kuyruğu, parça numarası ve tarihi ara.
- MEL erteleme kodunu yetkilendirme imzasıyla karşılaştır.
- Parça stok kaydı ve şirket e-postasındaki çelişkiyi bağla.
- Yanlış uçak veya benzer parça numarası red herring olarak kullanılabilir.

### OP-05 — İnsan Faktörleri / CRM

Mevcut sorun: Yönlendirici soru tam olayı söyler; statik poligraf otomatik hüküm verir.

Yeni görev:

- Tarafsız, baskıcı veya doğrulayıcı soru türlerinden seçim yap.
- Sınırlı soru hakkı kullan.
- İfadeyi CVR/FDR zaman kodlarıyla karşılaştır.
- Stres grafiği yalnızca tepki değişimini gösterir; **yalanın kesin kanıtı değildir**.
- Delil, “itirafı pinle” yerine oyuncunun seçtiği çelişki ve kaynak eşleşmesinden doğar.

---

## 5. MEVCUT PROTOTİPTE ZORUNLU DÜZELTMELER

### P0 — Final rapor ve değerlendirme

- Rapor seçenekleri başlangıçta seçili gelmemeli.
- Ground-truth grafiğindeki dört kategori rapor ekranında eksiksiz bulunmalı.
- Neden eşleştirme metin içinde kelime aramayla değil sabit `cause_id` ve kategoriyle yapılmalı.
- Her rapor nedenine deliller oyuncu tarafından ayrı ayrı bağlanmalı.
- Bulunan bütün deliller otomatik olarak her nedene eklenmemeli.
- `pinnedEvidenceIds` ve `totalDiscoveredEvidences` gerçekten puanlamada kullanılmalı veya API'den kaldırılmalı.
- Fazla, ilgisiz ve çelişkili delil kullanımına kalite/etkinlik cezası verilmeli.
- Çevresel neden eksik olduğu için oluşan ulaşılamaz/tutarsız maksimum skor düzeltilmeli.

### P0 — Çevrim içi faz ve süre otoritesi

- Faz, aktif operatör ve kalan süre istemci tarafından değil sunucu oda otoritesi tarafından belirlenmeli.
- İstemciler yalnızca sunucu zaman damgasından görsel sayaç üretmeli.
- Faz kapandıktan sonra eski eylemler sunucu tarafından reddedilmeli.
- Bağlantısı kopan aktif oyuncu için yeniden bağlanma ve tur devri kuralı bulunmalı.
- Başmüfettiş karar fazında 10 saniye boyunca etkisiz kalırsa yetki güvenilirlik sırasındaki bir sonraki oyuncuya devredilebilmeli.

### P1 — Gerçek görev etkileşimi

- Her rolün aracı, yalnız renk/etiket değiştirmek yerine oyun durumunu ve elde edilen bilgiyi değiştirmeli.
- Hazır cevaplar, tam transkriptler ve çözümü söyleyen görev başlıkları kaldırılmalı.
- Her rol için en az bir doğru işlem, bir yanlış işlem ve bir belirsiz/red-herring sonuç bulunmalı.
- Delil keşfi tek bir genel `discoverEvidence(id)` çağrısından ibaret olmamalı; keşif yöntemi ve oyuncu eylemi kaydedilmeli.

### P1 — Başmüfettiş modu

- Liderlik yetkisi oda durumuna eklenmeli.
- İddia Kartı, destek/itiraz ve nihai karar modelleri oluşturulmalı.
- Başmüfettiş ekranı, rapor seçicisi değil sürükle-bırak nedensellik masası olarak tasarlanmalı.
- Müzakere geçmişi ve karar gerekçesi sonuç ekranına taşınmalı.

### P1 — Puan ve XP

- Sabit örnek XP/MVP değerleri kaldırılmalı.
- Uzman puanı şu ölçümlerden üretilmeli:
  - Doğru zaman/bölge tespiti
  - Kaynak delil kalitesi
  - Çıkarım doğruluğu
  - Yanlış/red-herring işlem sayısı
  - Süre kullanımı
  - Müzakeredeki desteklenen veya doğrulanan katkı
- Başmüfettiş puanı:
  - Nedensellik zinciri doğruluğu
  - Delil–iddia bağlarının kalitesi
  - Haklı itirazları dikkate alma
  - Desteksiz iddia sayısı
  - Süre içinde karar
- MVP, hesaplanan katkı skorundan çıkmalı; belirli bir role sabitlenmemeli.

### P2 — Arayüz ve kimlik tutarlılığı

- “Sesli sohbet yok” kararı nedeniyle `TELSİZ (BAS-KONUŞ)` düğmesi kaldırılmalı.
- Alt ping şeridi, zaman çizelgesi ve kayan düğme çakışması giderilmeli.
- `BLACK BOX / AIR CRASH BUREAU`, `BLACKBOX-AIRCRASHREPORT` ve `BLACK BOX: FINAL REPORT` adlarından biri kesinleştirilip tüm arayüz ve belgelerde uygulanmalı.
- “Yalan testi” dili daha doğru olan “biyometrik stres tepkisi” diline çevrilmeli.
- Sinematik rekonstrüksiyon sonuç ödülü olarak kalmalı; soruşturma sırasında cevabı açık etmemeli.

### P2 — Test kapsamı

- Şu anda yalnız temel provider/arayüz testleri bulunmaktadır.
- Eklenmesi gereken testler:
  - Faz geçişleri ve sunucu zamanı
  - Sırası olmayan operatörün eyleminin reddi
  - İddia Kartı doğrulaması
  - Başmüfettiş yetkisi ve otomatik teslim
  - Yeniden bağlantı ve liderlik devri
  - Neden kimliği/kategori bazlı puanlama
  - Delil–iddia eşleştirme kalitesi
  - Gerçek eylemlerden bireysel XP ve MVP hesabı

---

## 6. GERÇEK ZAMANLI ODA DURUMU VE OLAYLAR

Önerilen oda durumu:

```json
{
  "room_id": "CASE-447-01",
  "phase": "operator_turn",
  "active_role": "telemetryFdr",
  "chief_player_id": "player_03",
  "phase_started_at": "server_timestamp",
  "phase_ends_at": "server_timestamp",
  "submitted_claim_ids": [],
  "verdict_status": "draft"
}
```

Gerekli WebSocket olayları:

| Olay | Amaç |
| :--- | :--- |
| `MATCH_BRIEFING_STARTED` | Rol ve Başmüfettiş duyurusu |
| `OPERATOR_TURN_STARTED` | Aktif rolü ve 30 sn süreyi kilitleme |
| `OBSERVER_NOTE_QUEUED` | Sınırlı soru/itiraz hazırlama |
| `CLAIM_SUBMITTED` | Uzmanın İddia Kartını ortak masaya verme |
| `DELIBERATION_STARTED` | 60 sn yazılı sohbeti açma |
| `DELIBERATION_MESSAGE_SENT` | Rol etiketli kısa mesaj |
| `CLAIM_SUPPORTED` | İddia desteği |
| `CLAIM_CHALLENGED` | İddia itirazı ve karşı kaynak |
| `CHIEF_REVIEW_STARTED` | Başmüfettişin 60 sn karar fazı |
| `CHIEF_FINAL_QUESTION` | Tek kullanımlık son soru |
| `CHIEF_VERDICT_SUBMITTED` | Nihai neden zincirini mühürleme |
| `PHASE_TIMER_SYNC` | Sunucu zamanına göre sayaç düzeltme |
| `LEADERSHIP_TRANSFERRED` | AFK/bağlantı kaybında yetki devri |

Cloudflare Durable Object oda için tek otorite olmalıdır. İstemciden gelen olayda `room_id`, `player_id`, `role`, `phase_version` ve tekrar gönderimleri önleyen `event_id` doğrulanmalıdır.

---

## 7. PUANLAMA İLKESİ

Takım sonucu iki ayrı katmandan oluşmalıdır:

- **Uzman bulgu kalitesi — %60**
- **Başmüfettiş nihai rapor doğruluğu — %40**

Önerilen bireysel katkı puanı:

```text
Uzman Puanı =
  %35 gözlem doğruluğu
+ %25 delil kalitesi
+ %20 çıkarım doğruluğu
+ %10 süre verimliliği
+ %10 müzakere katkısı
- yanlış işlem ve desteksiz kesinlik cezaları
```

Başmüfettiş Puanı:

```text
Başmüfettiş Puanı =
  %45 neden zinciri doğruluğu
+ %30 delil–iddia eşleştirmesi
+ %15 çelişki yönetimi
+ %10 zamanında karar
```

Takım doğru delilleri bulduğu hâlde Başmüfettiş yanlış karar verirse vaka kaybedilebilir. Bu, ikna fazının gerçek bir oyun mekaniği olmasını sağlar. Buna karşılık kötü niyetli veya AFK lider riskini azaltmak için liderlik devri ve güvenilirlik sistemi gereklidir.

---

## 8. ANTIGRAVITY UYGULAMA SIRASI

### Aşama 1 — Çekirdek modeller ve çevrim dışı simülasyon

1. `MatchPhase`, `OperatorTurn`, `ClaimCard`, `ClaimReaction` ve `ChiefVerdict` modellerini ekle.
2. Beş nöbet, müzakere ve karar fazını yerel state ile çalıştır.
3. Sayaç, sıra kilidi ve otomatik teslim davranışını oluştur.
4. Mevcut rapor puanlama hatalarını kimlik/kategori bazlı olacak şekilde düzelt.

**Çıkış ölçütü:** Tek cihazda beş rol taklit edilerek bütün maç döngüsü baştan sona tamamlanabilmeli.

### Aşama 2 — Rol görevlerini gerçek bulmacaya dönüştürme

1. FDR zaman aralığı işaretleme.
2. CVR kanal/filtre ve olay etiketleme.
3. FLIR kare/bölge işaretleme.
4. MEL kayıt eşleştirme.
5. CRM soru seçimi ve deliller arası çelişki kurma.

**Çıkış ölçütü:** Hiçbir rol yalnızca hazır metin okuyup tek butonla doğru delili alamamalı.

### Aşama 3 — Başmüfettiş ve puanlama

1. Başmüfettiş nedensellik masası.
2. Yazılı müzakere ve sınırlı mesajlar.
3. Gerçek eylem telemetrisi üzerinden XP/MVP.
4. Son karar ve sinematik sonuç karşılaştırması.

**Çıkış ölçütü:** Aynı delillerle farklı Başmüfettiş kararları farklı sonuç ve puan üretebilmeli.

### Aşama 4 — Çevrim içi oda

1. Durable Object otoriter faz makinesi.
2. WebSocket olayları ve idempotency.
3. Yeniden bağlanma, AFK ve liderlik devri.
4. Beş gerçek cihazla gecikme/sıra testleri.

**Çıkış ölçütü:** İstemci saatini değiştirerek sıra veya süre aşılamamalı; kopan oyuncu geri dönebilmelidir.

### Aşama 5 — Sinematik/video kalite katmanı

1. 4–8 saniyelik hafif adli klipler.
2. FLIR/VHS/scanline estetiği.
3. Sonuçta delillere göre derlenen rekonstrüksiyon.
4. Video ve ses paketlerini vaka bazında isteğe bağlı indirme.

**Çıkış ölçütü:** Video, ham delil veya sonuç ödülü olmalı; tek başına kök nedeni açık etmemelidir.

---

## 9. KABUL KRİTERLERİ

Revizyon tamamlanmış sayılmadan önce aşağıdakilerin tümü sağlanmalıdır:

- [ ] Rapor ekranında hiçbir doğru cevap varsayılan seçili değildir.
- [ ] Dört nedensellik kategorisi eksiksizdir.
- [ ] Her neden için deliller ayrı seçilir ve kategori/kimlik bazlı puanlanır.
- [ ] Beş rolün her birinde oyuncu yorumu gerektiren en az bir gerçek işlem vardır.
- [ ] Hazır pingler kök nedeni veya doğru zaman kodunu doğrudan söylemez.
- [ ] Beş adet 30 saniyelik nöbet sunucu otoritesiyle işler.
- [ ] Bekleyen oyuncular not ve sınırlı itiraz hazırlayabilir; aktif rolün aracını kullanamaz.
- [ ] 60 saniyelik yazılı müzakere çalışır.
- [ ] Başmüfettiş 60 saniyede delilleri bağlayıp tek başına nihai kararı verir.
- [ ] AFK/bağlantı kaybında Başmüfettiş yetkisi devredilir.
- [ ] XP ve MVP sabit değildir; gerçek eylemlerden hesaplanır.
- [ ] `TELSİZ (BAS-KONUŞ)` kaldırılmıştır.
- [ ] Video cevabı göstermeden analiz veya sonuç işlevi görür.
- [ ] Faz, puanlama ve bağlantı kopması için otomatik testler vardır.
- [ ] Flutter analiz ve testleri temiz geçer.

---

## 10. KAPSAM DIŞI / ŞİMDİLİK YAPILMAYACAKLAR

- Sesli sohbet ve Push-to-Talk
- Altıncı oyuncu olarak ayrı Başmüfettiş rolü
- Uzun ve yüksek boyutlu 1080p sinematik paketler
- Stres verisini kesin yalan kanıtı sayan otomatik sistem
- Yapay zekânın oyuncu yerine nihai nedeni seçmesi
- Görsel iyileştirme uğruna görev mantığının ertelenmesi

---

## 11. BEYİN İÇİN KALICI KARAR KAYITLARI

Bu bölüm, sonraki ajanların ürünü eski tasarıma döndürmemesi için kanonik karar özetidir:

```text
stable.game.title_candidate: BLACK BOX: FINAL REPORT
stable.game.player_count: 5
stable.game.specialist_roles: FDR,CVR,FLIR,MEL,CRM
stable.game.chief_inspector: one_of_five_players_with_temporary_final_authority
stable.game.operator_turn_duration_seconds: 30
stable.game.operator_turns_are_sequential: true
stable.game.observers_are_not_fully_passive: notes_and_one_queued_objection_allowed
stable.game.deliberation_mode: bounded_text_chat
stable.game.deliberation_duration_seconds: 60
stable.game.chief_review_duration_seconds: 60
stable.game.final_verdict_authority: chief_inspector
stable.game.voice_chat: disabled
stable.game.evidence_design: raw_clues_require_player_interpretation
stable.game.video_role: analyzable_raw_evidence_or_post_verdict_payoff
stable.game.report_evidence_linking: explicit_per_cause
stable.game.scoring: action_based_not_hardcoded
```

`stable.game.title_candidate` henüz kesin ad kararı değildir. İsim onaylandığında `stable.game.title` anahtarıyla kesinleştirilmelidir.

