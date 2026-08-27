# KAZA SORUŞTURMA MOTORU VE VERİ MİMARİSİ (v3.0 NİHAİ SENTEZ)

---

## 1. TEMEL FELSEFE & MİMARİ İLKELER

1. **Oyun-Öncelikli Tasarım:** Mimari, "veriyi nasıl gizleriz?" sorusu üzerine değil, *"Oyuncu dağınık ipuçlarından kendi teorisini nasıl kurar ve motor bunu nasıl objektif değerlendirir?"* sorusu üzerine kuruludur.
2. **Erişim Modeli Bir Parametredir:** Solo, Co-op ve Competitive modları veri yapısını değiştirmez; `roles/access_policy.json` üzerinden dinamik olarak yönetilir. Solo modda veri broker'ı pasiftir.
3. **Doğrusal Zincir Değil, Yönlü Döngüsüz Graf (DAG):** Kazalar tek bir hat üzerinden değil, birden fazla bağımsız kökten beslenen ve birleşen çoklu-ebeveyn düğümlerle (`investigation/causal_graph.json`) temsil edilir.
4. **Birinci Sınıf Çelişki Motoru (`investigation/contradictions.json`):** Pilot ifadesi ile FDR kaydının uyuşmaması gibi zıtlıklar serbest metin notu değil; `CONTRADICTS` ilişkisiyle modellenmiş dedüksiyon tetikleyicileridir.
5. **Dallanan Soruşturma & AND Kapıları (`unlock_rules.json`):** 4 bağımsız giriş noktası (FDR, CVR, Bakım, Meteoroloji) eşzamanlı açıktır; derin teoriler çoklu kanıt birleşimiyle açılır.
6. **Adil Puanlama:** Keşif ve hipotez denemeleri serbesttir; sadece imzalanıp gönderilen nihai rapor değerlendirilir (Causal Accuracy: 50, Evidence Quality: 35, Efficiency: 15).

---

## 2. MOD-BAĞIMSIZ VAKA PAKETİ ANATOMİSİ

```text
case_017_atlantic_night/
├── manifest.json               # Paket metadata, hash, versiyon
├── case.json                   # Vaka kimliği, zorluk, mod desteği
├── flight.json                 # Uçuş rotası, kalkış/varış, irtifa
├── entities.json               # Uçak tipi, mürettebat profilleri, hava özeti
├── event_axis.json             # Ortak zaman ekseni (T+case_time_s senkronu)
│
├── sources/                    # Ham veri katmanları
│   ├── fdr.json                # FDR telemetri zaman serisi
│   ├── cvr.json                # Kokpit ses kayıt transkripti
│   ├── atc.json                # Kule-pilot telsiz konuşmaları
│   ├── maintenance.json        # MEL defteri ve teknik servis kayıtları
│   └── environment.json        # METAR/TAF hava ve enkaz dağılım verisi
│
├── investigation/              # Soruşturma motorunun çekirdeği
│   ├── observations.json       # Ham kayıtlardan türetilen gözlem birimleri
│   ├── evidence.json           # Düğümler ve ilişkiler (supports / refutes)
│   ├── contradictions.json     # İfade ↔ veri çelişki haritası
│   ├── hypotheses.json         # Oyuncunun kurabileceği teori havuzu
│   ├── causal_graph.json       # Resmi NTSB/BEA kök neden grafı (Ground Truth DAG)
│   ├── unlock_rules.json       # AND/OR kilitleme ve keşif kapıları
│   └── evaluation.json         # 50/35/15 puanlama rubriği
│
├── media/                      # Ses, görsel ve doküman varlıkları
│   ├── audio/ (cvr_cpt.opus, cvr_fo.opus, atc.opus)
│   ├── images/ (radar_storm.webp, wreckage_map.webp)
│   └── documents/ (mel_log.pdf)
│
├── locales/                    # Çoklu dil desteği
│   ├── tr.json
│   └── en.json
│
└── roles/
    └── access_policy.json      # Solo'da pasif; Co-op ve Competitive'de aktif
```

---

## 3. VERİ MODELLERİ VE JSON ŞEMALARI

### 3.1. Ortak Zaman Ekseni (`event_axis.json`)

```json
{
  "$schema": "https://chasethecase.com/schemas/event_axis_v3.json",
  "case_id": "CASE-017",
  "epoch_utc": "02:09:00",
  "resolution_sec": 1,
  "markers": [
    {
      "case_time_s": 66,
      "timestamp_utc": "02:10:06",
      "track": "FDR",
      "label_i18n_key": "event.ap_disconnect",
      "linked_evidence_id": "EVD_FDR_SPD_DROP"
    },
    {
      "case_time_s": 70,
      "timestamp_utc": "02:10:10",
      "track": "CVR",
      "label_i18n_key": "event.stall_warning",
      "linked_evidence_id": "EVD_CVR_STALL_WARN"
    },
    {
      "case_time_s": 152,
      "timestamp_utc": "02:11:32",
      "track": "CVR",
      "label_i18n_key": "event.cpt_returns",
      "linked_evidence_id": "EVD_CVR_CPT_RETURN"
    }
  ]
}
```

---

### 3.2. Kanıt & Çelişki Motoru (`investigation/evidence.json` & `contradictions.json`)

```json
// investigation/evidence.json
{
  "nodes": [
    {
      "id": "EVD_PILOT_STATEMENT",
      "type": "TESTIMONY",
      "source_ref": "cvr.json#seg_14",
      "title_i18n_key": "evidence.pilot_stmt.title",
      "confidence": "UNVERIFIED"
    },
    {
      "id": "EVD_FDR_AP_DISCONNECT",
      "type": "TELEMETRY",
      "source_ref": "fdr.json#t_66",
      "title_i18n_key": "evidence.ap_disc.title",
      "confidence": "CONFIRMED"
    }
  ],
  "relations": [
    {
      "from": "EVD_PILOT_STATEMENT",
      "to": "EVD_FDR_AP_DISCONNECT",
      "type": "CONTRADICTS",
      "strength": 0.95,
      "reason_i18n_key": "contradiction.autopilot_timing_mismatch"
    },
    {
      "from": "EVD_METAR_ICING",
      "to": "EVD_MEL_HEATER",
      "type": "SUPPORTS",
      "strength": 0.85
    }
  ]
}
```

---

### 3.3. Resmi Nedensel Graf (`investigation/causal_graph.json`)
*Yazar tarafından önceden tanımlanır (Ground Truth DAG). Oyuncuya oyun içinde kapalıdır; sadece Evaluation'da karşılaştırılır.*

```json
{
  "nodes": [
    { "id": "C_ENV_ICING", "category": "ENVIRONMENT", "title_i18n_key": "cause.icing_layer" },
    { "id": "C_LAT_HEATER", "category": "LATENT_MAINTENANCE", "title_i18n_key": "cause.deferred_heater" },
    { "id": "C_ORG_PRESSURE", "category": "ORGANIZATIONAL", "title_i18n_key": "cause.fuel_pressure" },
    { "id": "C_TRIG_PITOT", "category": "TRIGGER", "title_i18n_key": "cause.pitot_freeze" },
    { "id": "C_SYS_AIRSPEED", "category": "SYSTEM_FAULT", "title_i18n_key": "cause.unreliable_speed" },
    { "id": "C_SYS_AP_DROP", "category": "SYSTEM_FAULT", "title_i18n_key": "cause.ap_disconnect" },
    { "id": "C_HUM_STICK_PULL", "category": "HUMAN_ERROR", "title_i18n_key": "cause.pilot_stall_pull" },
    { "id": "C_OUTCOME_IMPACT", "category": "OUTCOME", "title_i18n_key": "cause.ocean_impact" }
  ],
  "edges": [
    { "from": "C_ENV_ICING", "to": "C_TRIG_PITOT" },
    { "from": "C_LAT_HEATER", "to": "C_TRIG_PITOT" },
    { "from": "C_TRIG_PITOT", "to": "C_SYS_AIRSPEED" },
    { "from": "C_TRIG_PITOT", "to": "C_SYS_AP_DROP" },
    { "from": "C_SYS_AIRSPEED", "to": "C_HUM_STICK_PULL" },
    { "from": "C_SYS_AP_DROP", "to": "C_HUM_STICK_PULL" },
    { "from": "C_ORG_PRESSURE", "to": "C_HUM_STICK_PULL", "is_indirect_contributor": true },
    { "from": "C_HUM_STICK_PULL", "to": "C_OUTCOME_IMPACT" }
  ]
}
```

---

### 3.4. Keşif ve Kilit Kapıları (`investigation/unlock_rules.json`)

```json
{
  "theories": [
    {
      "theory_id": "THEORY_PITOT_ICING",
      "gate_type": "AND",
      "required_evidence_ids": [
        "EVD_FDR_SPD_DROP",
        "EVD_MEL_HEATER",
        "EVD_METAR_ICING"
      ],
      "unlocks_hypothesis_id": "HYP_PITOT_FAILURE"
    },
    {
      "theory_id": "THEORY_BOMB_EXPLOSION",
      "gate_type": "OR",
      "required_evidence_ids": ["EVD_CVR_STALL_WARN"],
      "refuted_by_evidence_id": "EVD_WRECKAGE_COMPACT",
      "is_red_herring": true
    }
  ]
}
```

---

### 3.5. Nihai Rapor Değerlendirme Modeli (`investigation/evaluation.json`)

```json
{
  "max_score": 100,
  "weights": {
    "causal_accuracy": 50,
    "evidence_quality": 35,
    "investigation_efficiency": 15
  },
  "rubrics": {
    "causal_accuracy": "Oyuncunun teslim ettiği kaza zincirinin Ground Truth DAG ile yapısal benzerliği.",
    "evidence_quality": "Rapor edilen nedenlerin arkasına bağlanan delillerin doğruluk ve güç katsayısı.",
    "efficiency": "Gereksiz dağılmadan ve çürütülen teorilere saplanmadan raporun tamamlanma oranı."
  }
}
```
