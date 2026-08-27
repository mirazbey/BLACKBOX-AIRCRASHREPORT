# BLACK BOX: AIR CRASH BUREAU (CHASE THE CASE)
> **Mobil Çok Oyunculu Asimetrik Havacılık Kazası Soruşturma Oyunu**

---

## 📌 PROJE ÖZETİ
*Black Box: Air Crash Bureau*, oyuncuları gerçek kaza soruşturma raporlarından kurgulanmış vakaların içine atan **çok oyunculu, asimetrik bir dedüksiyon oyunudur**. 

Klasik çoktan seçmeli test veya bilgi yarışması mantığı yoktur. Oyuncular kaza alanına ve verilere bağımsız olarak dalar; telsizden birbirlerine bulgularını aktararak uçağın neden düştüğünü **İsviçre Peyniri Kaza Modeli (Swiss Cheese Model)** üzerinden çözerler.

---

## 📂 DOKÜMANTASYON MİMARİSİ

Proje dizininde yer alan temel mimari şartnameler:

| Doküman | Açıklama |
| :--- | :--- |
| **[`GAME_DESIGN_DOCUMENT.md`](./GAME_DESIGN_DOCUMENT.md)** | Oyun Mekanikleri, Core Loop, Asimetrik Rol Tasarımları, Dahili Telsiz Sistemi, Çelişki ve Yanıltıcı Delil Dinamikleri, Gelir Modeli. |
| **[`CASE_DOCUMENT_ARCHITECTURE.md`](./CASE_DOCUMENT_ARCHITECTURE.md)** | Vaka Paketi JSON Şemaları, FDR Telemetri Zaman Serileri, CVR Kokpit Ses Dökümleri, MEL Bakım Kayıtları, Nedensellik Grafiği ve Prosedürel Üretim Şablonu. |
| **[`SERVER_EDGE_ARCHITECTURE.md`](./SERVER_EDGE_ARCHITECTURE.md)** | Aylık 0$ – 5$ Maliyetli Serverless Edge Altyapısı (Cloudflare Workers + Durable Objects, LiveKit WebRTC Telsiz, Cloudflare R2 CDN). |

---

## 🎯 4 TEMEL OYUN SÜTUNU

```
                   ┌──────────────────────────────────────────────┐
                   │    BLACK BOX: AIR CRASH BUREAU CORE LOOP     │
                   └──────────────────────┬───────────────────────┘
                                          │
    ┌──────────────────────┬──────────────┴──────────────┬──────────────────────┐
    ▼                      ▼                             ▼                      ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│  1. ASİMETRİK    │  │  2. SESLİ TELSİZ │  │  3. ORTAK TAHTA  │  │  4. NEDENSELLİK  │
│  ROLLER (2-4 Kişi│  │  (Push-to-Talk)  │  │  (Investigation) │  │  (Swiss Cheese)  │
├──────────────────┤  ├──────────────────┤  ├──────────────────┤  ├──────────────────┤
│ Herkes kendi     │  │ Dahili havacılık │  │ Deliller tahtaya │  │ Tek bir neden yok│
│ ekranındaki gizli│  │ cızırtı filtreli │  │ pinlenir; araya  │  │ Tetikleyici, hata│
│ veriyi inceler.  │  │ bas-konuş telsiz.│  │ kırmızı ip çekilir│ ve çevre birleşir. │
└──────────────────┘  └──────────────────┘  └──────────────────┘  └──────────────────┘
```

---

## ⚡ TEKNOLOJİ STACK & ALTYAPI

* **İstemci (Client):** Flutter (iOS & Android) — Offline-first yerel önbellek.
* **Sesli Muhabere (VoIP):** LiveKit Cloud (WebRTC tabanlı, düşük gecikmeli Bas-Konuş).
* **Oda & Senkronizasyon:** Cloudflare Workers + Durable Objects (Edge WebSocket, sıfır sabit sunucu maliyeti).
* **Medya & Vaka İndirme CDN:** Cloudflare R2 (Sıfır çıkış trafiği ücreti).
