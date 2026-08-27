# BLACKBOX-AIRCRASHREPORT
> **Mobil Çok Oyunculu Asimetrik Havacılık Kazası Soruşturma Oyunu (Rainbow Six Tarzı 5 Operatörlü Kriz Masası)**

---

## 📌 PROJE ÖZETİ
**BLACKBOX-AIRCRASHREPORT**, oyuncuları gerçek kaza soruşturma raporlarından kurgulanmış vakaların içine atan **5 oyunculu, asimetrik bir dedüksiyon ve adli tıp kriz masası simülasyonudur**.

Klasik çoktan seçmeli test mantığı yoktur. 5 uzman operatör (FDR Mühendisi, CVR Akustik Analisti, FLIR Video Uzmanı, Adli Bakım Müfettişi ve Adli Psikolog/CRM Sorgucusu) kendi özel terminallerindeki gizli verileri çözümler; telsiz çarkından delil ve direktif paslaşarak uçağın neden düştüğünü **İsviçre Peyniri Kaza Modeli (Swiss Cheese Model)** üzerinden NTSB/BEA heyet raporuna dönüştürürler.

---

## 📂 DOKÜMANTASYON MİMARİSİ

Proje dizininde yer alan temel mimari şartnameler:

| Doküman | Açıklama |
| :--- | :--- |
| **[`ANTIGRAVITY_REVISION_BRIEF.md`](./ANTIGRAVITY_REVISION_BRIEF.md)** | Antigravity uygulama brifi: görev derinliği düzeltmeleri, 5×30 sn uzman nöbeti, yazılı müzakere ve Başmüfettiş nihai karar sistemi. |
| **[`MIMARI_RAPOR_V3.html`](./MIMARI_RAPOR_V3.html)** | İnteraktif SVG Grafiksel Mimari Raporu ve Soruşturma Akışı. |
| **[`GAME_DESIGN_DOCUMENT.md`](./GAME_DESIGN_DOCUMENT.md)** | Oyun Mekanikleri, Core Loop, 5 Asimetrik Operatör Tasarımı, Taktik Telsiz Çarkı, Adli Psikolog Sorgu Ağacı, Çelişki ve Yanıltıcı Delil Dinamikleri, Rütbe Sistemi. |
| **[`CASE_DOCUMENT_ARCHITECTURE.md`](./CASE_DOCUMENT_ARCHITECTURE.md)** | Vaka Paketi JSON Şemaları, FDR Telemetri Zaman Serileri, CVR Kokpit Ses Dökümleri, MEL Bakım Kayıtları, Nedensellik Grafiği (DAG) ve Prosedürel Üretim Şablonu. |
| **[`SERVER_EDGE_ARCHITECTURE.md`](./SERVER_EDGE_ARCHITECTURE.md)** | Aylık 0$ – 5$ Maliyetli Serverless Edge Altyapısı (Cloudflare Workers + Durable Objects, Taktiksel WebSocket Relay, Cloudflare R2 CDN). |

---

## 🎯 5 UZMAN OPERATÖR & SORUŞTURMA SÜTUNLARI

```
                            ┌──────────────────────────────────────────────┐
                            │      BLACKBOX-AIRCRASHREPORT CORE LOOP       │
                            └──────────────────────┬───────────────────────┘
                                                   │
     ┌──────────────────────┬──────────────────────┼──────────────────────┬──────────────────────┐
     ▼                      ▼                      ▼                      ▼                      ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│ OP-01: TELEMETRİ │  │ OP-02: AKUSTİK   │  │ OP-03: FLIR      │  │ OP-04: BAKIM     │  │ OP-05: PSİKOLOG  │
│ (FDR Mühendisi)  │  │ (CVR Ses Analisti│  │ (Aviyonik & Video│  │ (MEL Müfettişi)  │  │ (CRM & Çapraz So.)│
├──────────────────┤  ├──────────────────┤  ├──────────────────┤  ├──────────────────┤  ├──────────────────┤
│ Canlı PFD yapay  │  │ 4-kanallı ses    │  │ Termal FLIR Cam, │  │ MEL ertelemeleri,│  │ Pilot, teknisyen │
│ ufkunu, sürat ve │  │ spektrogramı ve  │  │ kokpit CCTV ve 3D│  │ şirket gizli yazı│  │ ve kuleyi sorgular│
│ lövye açısını    │  │ alarm izolasyon  │  │ çarpışma tel     │  │ ma ve sahte imza │  │ yalan/stresi     │
│ inceler.         │  │ filtrelerini     │  │ kafes modelini   │  │ taramalarını     │  │ açığa çıkarır.   │
│                  │  │ yönetir.         │  │ inceler.         │  │ belgeler.        │  │                  │
└──────────────────┘  └──────────────────┘  └──────────────────┘  └──────────────────┘  └──────────────────┘
```

---

## ⚡ TEKNOLOJİ STACK & ALTYAPI

* **İstemci (Client):** Flutter (iOS & Android) — Space Grotesk / IBM Plex Mono havacılık teması, FL Chart telemetrisi, canlı PFD yapay ufku, CVR spektrogramı, CRT video rekonstrüksiyon oynatıcısı.
* **Taktik Haberleşme (Comms):** Apex/R6 tarzı hızlı direktif çarkı (Quick Pings) + Edge WebSocket senkronu.
* **Oda & Senkronizasyon:** Cloudflare Workers + Durable Objects (Edge WebSocket, sıfır sabit sunucu maliyeti).
* **Medya & Vaka İndirme CDN:** Cloudflare R2 (Sıfır çıkış trafiği ücreti).
