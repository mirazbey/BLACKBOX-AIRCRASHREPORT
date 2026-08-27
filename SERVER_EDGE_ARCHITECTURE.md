# SUNUCU & EDGE AĞ MİMARİSİ (Aylık 0$ – 5$ Maliyetli Altyapı)

---

## 1. MİMARİ FELSEFESİ & SIFIR SABİT MALİYET

Dedektiflik ve bulmaca oyunlarında sürekli çalışan pahalı özel sunucular (Dedicated Game Servers) açmak büyük bir finansal kayıptır. 

*Black Box*, **Serverless Edge & Peer-to-Peer** prensibiyle inşa edilmiştir:

```
┌────────────────────────────────────────────────────────────────────────┐
│ 1. STATİK MEDYA & VAKA PAKETLERİ (Ses, Görsel, Rapor PDF'leri, JSON)   │
│ ──> CLOUDFLARE R2 (Egress/Trafik Ücreti 0$, 10 GB Depolama Bedava)     │
└────────────────────────────────────────────────────────────────────────┘
                               │
┌────────────────────────────────────────────────────────────────────────┐
│ 2. DAHİLİ HAVACILIK TELSİZİ (Push-to-Talk VoIP)                        │
│ ──> LIVEKIT CLOUD (Aylık 50 GB Ücretsiz WebRTC Ses Trafiği)            │
└────────────────────────────────────────────────────────────────────────┘
                               │
┌────────────────────────────────────────────────────────────────────────┐
│ 3. MATCHMAKING & REALTIME DEDEKTİF MASASI (WebSocket)                  │
│ ──> CLOUDFLARE WORKERS + DURABLE OBJECTS                               │
│ • Sadece 50 baytlık pin/çizgi JSON paketleri taşınır.                  │
│ • Boşta duran sunucu maliyeti = 0$                                     │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 2. AĞ İLETİŞİM PROTOKOLÜ (JSON EVENT ŞEMASI)

Mobil istemciler arasında WebSocket üzerinden akan hafif veri paketleri:

### 2.1. Odaya Pin Ekleme (Pin Placed)
```json
{
  "type": "BOARD_PIN_ADDED",
  "room_id": "CRASH-817",
  "sender_role": "telemetryFdr",
  "payload": {
    "pin_id": "PIN_991",
    "evidence_id": "EVD_FDR_SPD_DROP",
    "pos_x": 310.5,
    "pos_y": 140.0,
    "label": "02:10:06 Hız Göstergesi 110 Knot'a Çakıldı"
  }
}
```

### 2.2. İki Delil Arasına Nedensellik İpi Çekme (String Connection)
```json
{
  "type": "BOARD_LINK_CREATED",
  "room_id": "CRASH-817",
  "payload": {
    "from_pin_id": "PIN_991",
    "to_pin_id": "PIN_842",
    "relation_type": "CAUSES"
  }
}
```

---

## 3. MALİYET TABLOSU (KULLANDIKÇA ÖDE / PAY-AS-YOU-GO)

| Aktif Kullanıcı (MAU) | Depolama (R2) | Sesli Telsiz (LiveKit) | Eşleşme & Tahta (Cloudflare DO) | Toplam Aylık Masraf |
| :--- | :--- | :--- | :--- | :--- |
| **0 – 1.000** | $0.00 | $0.00 | $0.00 | **$0.00** |
| **10.000** | ~$0.50 | $0.00 (Limit altı) | ~$4.50 | **~$5.00** |
| **100.000** | ~$4.00 | ~$15.00 | ~$18.00 | **~$37.00** |
