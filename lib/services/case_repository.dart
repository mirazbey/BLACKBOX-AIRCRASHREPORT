import '../models/case_model.dart';
import '../models/event_axis_model.dart';
import '../models/source_models.dart';
import '../models/evidence_model.dart';
import '../models/causal_graph_model.dart';
import '../models/unlock_rules_model.dart';
import '../models/forensic_clip_model.dart';
import '../models/interrogation_model.dart';
import '../models/tactical_ping_model.dart';

class CaseRepository {
  static final List<ForensicClip> sampleForensicClips = [
    const ForensicClip(
      id: 'CLIP_01',
      title: 'T+66s Kokpit Birleşik Rekonstrüksiyonu',
      offsetSeconds: 66,
      timestampUtc: '02:10:06',
      cameraType: CameraFeedType.cockpitCctv,
      description:
          'Düşük görüş ve panel aydınlatması FDR/CVR zaman kodlarıyla '
          'eşleştirildi. Görüntü tek başına bir arıza nedenini doğrulamaz.',
      subtitleText:
          '[CVR SENKRON]: "Otopilot attı! Sürat göstergeleri uyuşmuyor!"',
      revealsEvidenceId: 'EVD_RECON_VISIBILITY',
      assetPath: 'assets/forensics/cockpit_reconstruction.mp4',
    ),
    const ForensicClip(
      id: 'CLIP_02',
      title: 'T+75s Dış Gövde Gece Kaydı',
      offsetSeconds: 75,
      timestampUtc: '02:10:15',
      cameraType: CameraFeedType.tailExteriorCam,
      description:
          'Şimşek aralıklarında gövde hareketi seçiliyor; açı ve yön düşük '
          'görüntü güveni nedeniyle FDR olmadan yorumlanamaz.',
      subtitleText: '[CVR SENKRON]: "STALL! STALL!"',
    ),
    const ForensicClip(
      id: 'CLIP_03',
      title: 'T+152s Kokpit Hareket Siluetleri',
      offsetSeconds: 152,
      timestampUtc: '02:11:32',
      cameraType: CameraFeedType.cockpitCctv,
      description:
          'Kabin içindeki hareket yalnızca zaman eşleştirmesi sağlar; kişinin '
          'eylemi veya niyeti görüntüden kesinleştirilemez.',
      subtitleText: '[CVR SENKRON]: "Burnu derhal aşağı ver!"',
    ),
    const ForensicClip(
      id: 'CLIP_04',
      title: 'T+240s Enkaz Dağılımı Tel Kafes Modeli',
      offsetSeconds: 240,
      timestampUtc: '02:14:28',
      cameraType: CameraFeedType.wireframe3dRecon,
      description:
          'Tarama noktalarından üretilen olası darbe geometrisi. Alternatif '
          'açılar enkaz analiziyle karşılaştırılmadan elenemez.',
      subtitleText: '[MODEL]: "Çözüm güven aralığı ±18°"',
    ),
  ];

  static final CaseBundle sampleCaseManifest = CaseBundle(
    id: 'CASE-017',
    code: 'AF-447-INSPIRED',
    title: 'Atlantik Gecesi (The Atlantic Night)',
    subtitle: 'FL350 Seyir İrtifasında Radardan Kayboluş',
    difficulty: CaseDifficulty.hard,
    durationMinutes: 20,
    isHistorical: true,
    aircraft: const AircraftProfile(
      model: 'Airbus A330-200',
      tailNumber: 'TC-ANL',
      engines: '2x CF6-80E1A3 Turbofan',
      operatorName: 'Trans-Atlantic Airways',
      avionicsSuite: 'Fly-By-Wire / Auto-Flight Primaries',
    ),
    flight: const FlightProfile(
      flightNumber: 'TA-447',
      departure: 'Rio de Janeiro (GIG)',
      destination: 'Paris Charles de Gaulle (CDG)',
      phaseOfFlight: 'Seyir (Gece / Fırtına Kuşağı)',
      soulsOnBoard: 228,
      lastKnownAltitude: '35,000 ft (FL350)',
      locationDescription: 'Atlantik Okyanusu Açıkları (Dakar FIR Sınırı)',
      initialSummary:
          'Gece saat 02:10 UTC\'de uçak tropikal fırtına kuşağına girdikten hemen sonra '
          'otomatik pozisyon raporlaması kesilmiş, 4 dakika içinde radar teması kaybolmuştur. '
          'Enkaz okyanus tabanında bulunmuştur.',
    ),
  );

  static final EventAxis sampleEventAxis = EventAxis(
    epochUtc: '02:09:00',
    totalDurationSeconds: 240,
    markers: const [
      EventMarker(
        caseTimeSeconds: 60,
        timestampUtc: '02:10:00',
        track: 'FDR',
        label: 'Normal Seyir (FL350, 460 kt)',
        rolesNotified: [1],
      ),
      EventMarker(
        caseTimeSeconds: 66,
        timestampUtc: '02:10:06',
        track: 'FDR',
        label: 'Sürat Göstergesi 110 kt Düşüşü & Otopilot İptali',
        linkedEvidenceId: 'EVD_FDR_SPD_DROP',
        rolesNotified: [1, 2],
      ),
      EventMarker(
        caseTimeSeconds: 70,
        timestampUtc: '02:10:10',
        track: 'CVR',
        label: 'STALL Uyarısı & FO Lövye Geri Çekişi',
        linkedEvidenceId: 'EVD_CVR_STALL_WARN',
        rolesNotified: [1, 2],
      ),
      EventMarker(
        caseTimeSeconds: 152,
        timestampUtc: '02:11:32',
        track: 'CVR',
        label: 'Kaptan Kokpite Dönüşü ("Burnu Aşağı Ver!")',
        linkedEvidenceId: 'EVD_CVR_CPT_RETURN',
        rolesNotified: [2],
      ),
      EventMarker(
        caseTimeSeconds: 220,
        timestampUtc: '02:12:40',
        track: 'SYSTEM',
        label: 'Dakar Okyanus Kule Telsiz İrtibat Kaybı',
        linkedEvidenceId: 'EVD_ATC_HANDOFF_LOST',
        rolesNotified: [2, 4],
      ),
    ],
  );

  static final List<FdrRecord> sampleFdrRecords = [
    const FdrRecord(
      offsetSeconds: 0,
      altitudeFt: 35000,
      indicatedAirspeedKnots: 460,
      groundSpeedKnots: 475,
      pitchDeg: 2.1,
      rollDeg: 0.0,
      controlColumnPct: 0,
      engine1N1Pct: 84.5,
      engine2N1Pct: 84.5,
      autopilotEngaged: true,
    ),
    const FdrRecord(
      offsetSeconds: 60,
      altitudeFt: 35000,
      indicatedAirspeedKnots: 460,
      groundSpeedKnots: 475,
      pitchDeg: 2.1,
      rollDeg: 0.0,
      controlColumnPct: 0,
      engine1N1Pct: 84.5,
      engine2N1Pct: 84.5,
      autopilotEngaged: true,
    ),
    const FdrRecord(
      offsetSeconds: 66,
      altitudeFt: 35000,
      indicatedAirspeedKnots: 110, // Anomalous sensor drop
      groundSpeedKnots: 475,
      pitchDeg: 2.1,
      rollDeg: 0.0,
      controlColumnPct: 0,
      engine1N1Pct: 84.5,
      engine2N1Pct: 84.5,
      autopilotEngaged: false,
      linkedEvidenceId: 'EVD_FDR_SPD_DROP',
    ),
    const FdrRecord(
      offsetSeconds: 75,
      altitudeFt: 35200,
      indicatedAirspeedKnots: 95,
      groundSpeedKnots: 470,
      pitchDeg: 12.5,
      rollDeg: 4.0,
      controlColumnPct: -85, // Nose-up stick pull
      engine1N1Pct: 84.5,
      engine2N1Pct: 84.5,
      autopilotEngaged: false,
      linkedEvidenceId: 'EVD_FDR_STICK_PULL',
    ),
    const FdrRecord(
      offsetSeconds: 120,
      altitudeFt: 31000,
      indicatedAirspeedKnots: 60,
      groundSpeedKnots: 420,
      pitchDeg: 15.0,
      rollDeg: 12.0,
      controlColumnPct: -90,
      engine1N1Pct: 98.0, // TOGA thrust
      engine2N1Pct: 98.0,
      autopilotEngaged: false,
    ),
    const FdrRecord(
      offsetSeconds: 180,
      altitudeFt: 18000,
      indicatedAirspeedKnots: 75,
      groundSpeedKnots: 380,
      pitchDeg: 14.0,
      rollDeg: -18.0,
      controlColumnPct: -75,
      engine1N1Pct: 98.0,
      engine2N1Pct: 98.0,
      autopilotEngaged: false,
    ),
    const FdrRecord(
      offsetSeconds: 240,
      altitudeFt: 0,
      indicatedAirspeedKnots: 80,
      groundSpeedKnots: 360,
      pitchDeg: 11.0,
      rollDeg: 0.0,
      controlColumnPct: -60,
      engine1N1Pct: 98.0,
      engine2N1Pct: 98.0,
      autopilotEngaged: false,
    ),
  ];

  static final List<AudioSegment> sampleAudioSegments = [
    const AudioSegment(
      id: 'SEG_01',
      offsetSeconds: 66,
      timestampUtc: '02:10:06',
      channel: 'CVR_HOTMIC_FO',
      speaker: 'Yardımcı Pilot (FO - Uçuran Pilot)',
      text:
          'Otopilot attı! Kontrol bende! Sürat göstergeleri uyuşmuyor, değerler delirdi!',
      alarms: ['CAUTION_CHIME', 'AP_DISCONNECT_CAVALRY'],
      linkedEvidenceId: 'EVD_FDR_SPD_DROP',
    ),
    const AudioSegment(
      id: 'SEG_02',
      offsetSeconds: 70,
      timestampUtc: '02:10:10',
      channel: 'CVR_COCKPIT_AREA',
      speaker: 'Sentetik Kokpit Alarmı (GPWS / Stall)',
      text: 'STALL! STALL! (Sürekli sesli ikaz ve cırcır alarmı)',
      alarms: ['STALL_WARNING_SYNTHETIC'],
      linkedEvidenceId: 'EVD_CVR_STALL_WARN',
    ),
    const AudioSegment(
      id: 'SEG_03',
      offsetSeconds: 110,
      timestampUtc: '02:10:50',
      channel: 'CVR_HOTMIC_FO',
      speaker: 'Yardımcı Pilot (FO)',
      text:
          'Tırmanmaya çalışıyorum, levyeyi çekiyorum ama uçak düşüyor gibi hissediyorum!',
      alarms: ['STALL_WARNING_SYNTHETIC'],
      linkedEvidenceId: 'EVD_PILOT_STATEMENT',
    ),
    const AudioSegment(
      id: 'SEG_04',
      offsetSeconds: 152,
      timestampUtc: '02:11:32',
      channel: 'CVR_HOTMIC_CPT',
      speaker: 'Kaptan Pilot (Kokpite Döner)',
      text:
          'Ne yapıyorsunuz siz?! Tırmanmıyoruz, derin perdövitese (Stall) girdik! Burnu derhal aşağı ver!',
      alarms: ['STALL_WARNING_SYNTHETIC'],
      linkedEvidenceId: 'EVD_CVR_CPT_RETURN',
    ),
    const AudioSegment(
      id: 'SEG_05',
      offsetSeconds: 220,
      timestampUtc: '02:12:40',
      channel: 'ATC_VHF_DAKAR',
      speaker: 'Dakar Okyanus Kule',
      text:
          'Trans-Atlantic 447, Dakar radar, yanıt verin... TA447, irtifa teyit edin...',
      linkedEvidenceId: 'EVD_ATC_HANDOFF_LOST',
    ),
  ];

  static final List<MaintenanceLog> sampleMaintenanceLogs = [
    const MaintenanceLog(
      logId: 'ATL-9844',
      date: '2026-08-20',
      station: 'Rio de Janeiro (GIG)',
      defectDescription:
          'Kaptan Pitot Isıtıcı Probu #1 aralıklı arıza ikazı veriyor.',
      actionTaken:
          'Parça stokta bulunamadı. MEL 34-11-01 uyarınca 10 gün ertelendi (Deferred).',
      inspectorCode: 'ENG-44102',
      isDeferred: true,
      linkedEvidenceId: 'EVD_MEL_HEATER',
    ),
    const MaintenanceLog(
      logId: 'ATL-9810',
      date: '2026-08-15',
      station: 'Paris (CDG)',
      defectDescription: 'Sağ motor yakıt akış sensörü rutin kalibrasyonu.',
      actionTaken: 'Kalibrasyon tamamlandı, testler nominal.',
      inspectorCode: 'ENG-11090',
      isDeferred: false,
    ),
  ];

  static const EnvironmentReport sampleEnvironmentReport = EnvironmentReport(
    rawMetar: 'METAR SBRF 270200Z 12008KT 9999 TS SCT020CB OVC080 24/22 Q1013=',
    decodedSummary:
        'Tropikal fırtına kuşağı (ITCZ), yoğun kümülonimbus bulut hücreleri ve şimşek aktivitesi.',
    severeIcingAltitudeRange:
        '28,000 ft — 37,000 ft arası Şiddetli Buzlanma Kuşağı',
    turbulenceLevel: 'Orta - Şiddetli Konvektif Türbülans',
    wreckagePattern: 'Kompakt ve Dikey Darbe Dağılımı',
    wreckageInterpretation:
        'Enkaz parçaları okyanus tabanında dar bir alana toplanmıştır. '
        'Uçağın havada parçalanmadığını, gövdenin tek parça halinde yüksek dikey hızla suya çarptığını kanıtlar.',
    linkedEvidenceId: 'EVD_WRECKAGE_COMPACT',
  );

  static final List<EvidenceNode> sampleEvidenceNodes = [
    const EvidenceNode(
      id: 'EVD_FDR_SPD_DROP',
      type: EvidenceType.telemetryAnomaly,
      title: '02:10:06 Hız Göstergesi Ani Düşüşü',
      description:
          'Hız 1 saniyede 460 kt\'tan 110 kt\'a düştü. Motor gücü sabitken bu fiziksel imkansızlıktır.',
      visibleToRoles: [1],
      sourceRef: 'fdr.json#t_66',
    ),
    const EvidenceNode(
      id: 'EVD_FDR_STICK_PULL',
      type: EvidenceType.telemetryAnomaly,
      title: 'Lövyenin Sürekli Geriye Çekilmesi',
      description:
          'Uçuran pilot sürat kaybı algısıyla lövyeyi geriye (%85) çekerek hücum açısını 15 dereceye çıkarmıştır.',
      visibleToRoles: [1],
      sourceRef: 'fdr.json#t_75',
    ),
    const EvidenceNode(
      id: 'EVD_CVR_STALL_WARN',
      type: EvidenceType.audioSegment,
      title: 'Stall (Perdövites) Alarmı',
      description:
          'Kokpitte sürekli STALL alarmı çalmış ancak pilotlar tarafından yanlış yorumlanmıştır.',
      visibleToRoles: [2],
      sourceRef: 'cvr.json#seg_02',
    ),
    const EvidenceNode(
      id: 'EVD_CVR_CPT_RETURN',
      type: EvidenceType.audioSegment,
      title: 'Kaptanın "Burnu Aşağı Ver" Emri',
      description:
          'Dinlenmeden dönen kaptan pilot durumun derin perdövites olduğunu anlayıp burnu indirmeyi emretmiştir.',
      visibleToRoles: [2],
      sourceRef: 'cvr.json#seg_04',
    ),
    const EvidenceNode(
      id: 'EVD_PILOT_STATEMENT',
      type: EvidenceType.testimony,
      title: 'Pilotun "Tırmanıyorum" İfadesi',
      description:
          'FO düşüş sırasında tırmanmaya çalıştığını söylemiş ancak uçak irtifa kaybetmiştir.',
      visibleToRoles: [2],
      sourceRef: 'cvr.json#seg_03',
      confidence: 'UNVERIFIED',
    ),
    const EvidenceNode(
      id: 'EVD_MEL_HEATER',
      type: EvidenceType.maintenanceRecord,
      title: 'Ertelenen Pitot Isıtıcı Arızası',
      description:
          'Pitot tüpü ısıtıcı direnci arızası MEL listesi kapsamında ertelenmiştir.',
      visibleToRoles: [3],
      sourceRef: 'maintenance.json#ATL-9844',
    ),
    const EvidenceNode(
      id: 'EVD_METAR_ICING',
      type: EvidenceType.environmentRecord,
      title: '28.000 - 37.000 ft Ağır Buzlanma Kuşağı',
      description:
          'Uçağın seyir irtifasında aşırı soğuk su damlacıkları ve buz kristalleri mevcuttur.',
      visibleToRoles: [4],
      sourceRef: 'environment.json#icing',
    ),
    const EvidenceNode(
      id: 'EVD_WRECKAGE_COMPACT',
      type: EvidenceType.fieldAnalysis,
      title: 'Kompakt Enkaz Dağılımı (Tek Parça Çarpma)',
      description:
          'Enkazın dağılma yarıçapı dardır; havada patlama veya parçalanma hipotezini çürütür.',
      visibleToRoles: [4],
      sourceRef: 'environment.json#wreckage',
    ),
    const EvidenceNode(
      id: 'EVD_RECON_VISIBILITY',
      type: EvidenceType.derivedReconstruction,
      title: 'T+70 Rekonstrüksiyon Karesi — Düşük Dış Görüş',
      description:
          'Şiddetli yağış ve düşük dış görüş ekip iş yükünü artırmış olabilir. '
          'Bu kare FDR/CVR verilerinden üretilmiştir; bağımsız kanıt değildir.',
      visibleToRoles: [1, 2, 3, 4],
      sourceRef: 'reconstruction.json#RECON_COCKPIT_01@T+70',
      confidence: 'DERIVED',
    ),
  ];

  static final List<EvidenceRelation> sampleEvidenceRelations = [
    const EvidenceRelation(
      fromEvidenceId: 'EVD_PILOT_STATEMENT',
      toEvidenceId: 'EVD_FDR_STICK_PULL',
      type: RelationType.contradicts,
      strength: 0.95,
      reason:
          'Pilot kontrolün kendisinde ve uçağın tırmanışta olduğunu sanarken, lövye çekişi uçağı daha derin stalla sokmaktadır.',
    ),
    const EvidenceRelation(
      fromEvidenceId: 'EVD_METAR_ICING',
      toEvidenceId: 'EVD_MEL_HEATER',
      type: RelationType.supports,
      strength: 0.90,
      reason:
          'Aşırı buzlanma şartları arızalı pitot ısıtıcı probunun donmasını doğrudan tetiklemiştir.',
    ),
    const EvidenceRelation(
      fromEvidenceId: 'EVD_WRECKAGE_COMPACT',
      toEvidenceId: 'THEORY_BOMB_EXPLOSION',
      type: RelationType.refutes,
      strength: 1.0,
      reason:
          'Enkaz parçaları havaya saçılmamış, okyanusa tek parça çarpmıştır.',
    ),
    const EvidenceRelation(
      fromEvidenceId: 'EVD_RECON_VISIBILITY',
      toEvidenceId: 'EVD_METAR_ICING',
      type: RelationType.supports,
      strength: 0.35,
      reason:
          'Rekonstrüksiyon yalnızca meteoroloji kaydındaki görüş şartlarını '
          'görselleştirir; bağımsız doğrulama sayılmaz.',
    ),
  ];

  static final CausalGraph sampleGroundTruthCausalGraph = CausalGraph(
    nodes: const [
      CausalNode(
        id: 'C_ENV_ICING',
        category: CausalCategory.environment,
        title: 'Aşırı Fırtına ve Buzlanma Kuşağı',
        description:
            '35.000 ft irtifada süper-soğumuş su damlacıkları ile karşılaşılması.',
        requiredEvidenceIds: ['EVD_METAR_ICING'],
        pointsWeight: 10,
      ),
      CausalNode(
        id: 'C_LAT_HEATER',
        category: CausalCategory.latentMaintenance,
        title: 'Pitot Isıtıcı Direncinin Ertelenmiş Bakımı',
        description: 'MEL kapsamında arızalı probun sefere verilmesi.',
        requiredEvidenceIds: ['EVD_MEL_HEATER'],
        pointsWeight: 10,
      ),
      CausalNode(
        id: 'C_TRIG_PITOT',
        category: CausalCategory.trigger,
        title: 'Pitot Tüplerinin Eşzamanlı Donması & Güvenilmez Sürat',
        description:
            'Sensörlerin donarak hız göstergelerinin aniden 110 knot\'a çakılması.',
        requiredEvidenceIds: [
          'EVD_FDR_SPD_DROP',
          'EVD_MEL_HEATER',
          'EVD_METAR_ICING',
        ],
        pointsWeight: 15,
      ),
      CausalNode(
        id: 'C_HUM_STICK_PULL',
        category: CausalCategory.humanError,
        title: 'Pilotun Hatalı Lövye Geri Çekişi (Stall Girişi)',
        description:
            'Hız göstergesi hatasında burun yukarı çekilerek hücum açısının aşılması.',
        requiredEvidenceIds: ['EVD_FDR_STICK_PULL', 'EVD_CVR_STALL_WARN'],
        pointsWeight: 15,
      ),
    ],
    edges: const [
      CausalEdge(fromNodeId: 'C_ENV_ICING', toNodeId: 'C_TRIG_PITOT'),
      CausalEdge(fromNodeId: 'C_LAT_HEATER', toNodeId: 'C_TRIG_PITOT'),
      CausalEdge(fromNodeId: 'C_TRIG_PITOT', toNodeId: 'C_HUM_STICK_PULL'),
    ],
  );

  static final List<TheoryUnlockRule> sampleTheoryRules = [
    const TheoryUnlockRule(
      theoryId: 'THEORY_PITOT_ICING',
      title: 'Pitot Donması & Sürat Kaybı İllüzyonu',
      description:
          'Sensör donması hatalı gösterge verisine ve otopilot iptaline yol açtı.',
      gateType: GateType.andGate,
      requiredEvidenceIds: [
        'EVD_FDR_SPD_DROP',
        'EVD_MEL_HEATER',
        'EVD_METAR_ICING',
      ],
    ),
    const TheoryUnlockRule(
      theoryId: 'THEORY_BOMB_EXPLOSION',
      title: 'Kabin İçi Patlama / Terör',
      description: 'Ani irtibat kaybı bir patlamadan kaynaklanmış olabilir.',
      gateType: GateType.orGate,
      requiredEvidenceIds: ['EVD_CVR_STALL_WARN'],
      refutedByEvidenceId: 'EVD_WRECKAGE_COMPACT',
      isRedHerring: true,
    ),
  ];

  static final List<SuspectProfile> sampleSuspects = [
    const SuspectProfile(
      id: 'SUSPECT_FO',
      name: 'Pierre Bonin',
      title: 'Yardımcı Pilot (First Officer)',
      organization: 'Trans-Atlantic Airways • Uçuş Ekibi',
      avatarCode: '👨‍✈️',
      stressStatus: 'AŞIRI PANİK / AKUT STRES',
      questions: [
        DialogueQuestion(
          id: 'Q_FO_01',
          questionText: 'Otopilot attığında lövyeyi neden sonuna kadar geriye çektiniz?',
          answerText: 'Kokpit ekranında sürat göstergesi 60 knot\'a çakıldı! Uçak düşüyor zannettim, yere çarpmamak için refleksle lövyeyi geriye asıldım!',
          stressReaction: 'Göz bebekleri büyüyor, titreyen elleriyle lövyeyi gösteriyor.',
          unlocksEvidenceId: 'EVD_FDR_STICK_PULL',
          unlockedEvidenceTitle: 'Pilotun Panik Lövye Refleksi (Stall Girişi)',
        ),
        DialogueQuestion(
          id: 'Q_FO_02',
          questionText: 'Kaptan pilot kokpitten ayrılırken ne talimat verdi?',
          answerText: 'Fırtına hattına giriyoruz, rotayı koruyun dedi ve dinlenme kabinine geçti. Sol koltukta yalnız kaldım...',
          stressReaction: 'Suçluluk duygusuyla başını öne eğiyor.',
          unlocksEvidenceId: 'EVD_CVR_CPT_RETURN',
          unlockedEvidenceTitle: 'Kaptanın Kokpiti Terk Edişi & CRM Boşluğu',
        ),
      ],
    ),
    const SuspectProfile(
      id: 'SUSPECT_CHIEF_MECH',
      name: 'Carlos Mendez',
      title: 'Rio İstasyon Bakım Şefi',
      organization: 'Varig-Tech Line Maintenance',
      avatarCode: '🛠️',
      stressStatus: 'SAVUNMACI / GERGİN',
      questions: [
        DialogueQuestion(
          id: 'Q_MECH_01',
          questionText: 'Uçuş öncesi pitot ısıtıcı direnç arızası deftere işlendi mi?',
          answerText: 'Evet, Rio hangarda parça yoktu. Operasyon Müdürü "Uçağı yerde tutamayız, MEL ertelemesi yapın, Paris\'te değişsin" diye baskı yaptı.',
          stressReaction: 'Sesi titriyor, şirketin baskı mailini ima ediyor.',
          unlocksEvidenceId: 'EVD_MEL_HEATER',
          unlockedEvidenceTitle: 'Yasadışı MEL Erteleme Talimatı (Parça Yokluğu)',
        ),
      ],
    ),
    const SuspectProfile(
      id: 'SUSPECT_ATC',
      name: 'Amadou Diallo',
      title: 'Dakar FIR Nöbetçi Hava Trafik Kontrolörü',
      organization: 'ASECNA Hava Sahası Otoritesi',
      avatarCode: '🎧',
      stressStatus: 'SAKİN / GÖZLEMCİ',
      questions: [
        DialogueQuestion(
          id: 'Q_ATC_01',
          questionText: 'Uçuş ekibi fırtına etrafından dolaşmak için rota sapması istedi mi?',
          answerText: 'Hayır, hiçbir rota değişikliği veya acil durum çağrısı (MAYDAY) yapmadılar. Direkt fırtına çekirdeğine girdiler.',
          stressReaction: 'Radar kayıt logunu masaya koyuyor.',
          unlocksEvidenceId: 'EVD_METAR_ICING',
          unlockedEvidenceTitle: 'Fırtına Hattına Doğrudan Giriş Teyidi',
        ),
      ],
    ),
  ];

  static const List<PingPreset> samplePingPresets = [
    PingPreset(
      type: DirectiveType.urgentTimeSync,
      title: 'Zaman Senkronu İste',
      defaultMessage: '🚨 T+66s anomali anına geçin ve verilerinizi eşitleyin!',
    ),
    PingPreset(
      type: DirectiveType.flagContradiction,
      title: 'Çelişki Bildir',
      defaultMessage: '🔍 Bu ifade telemetri verileriyle çelişiyor!',
    ),
    PingPreset(
      type: DirectiveType.requestInterrogation,
      title: 'Psikolog: Pilotu Sorgula',
      defaultMessage: '👤 Psikolog: Pilotun lövye çekiş motivasyonunu ve yorgunluğunu sorgulayın!',
      recommendedTargetRole: InvestigatorRole.humanFactorsPsych,
    ),
    PingPreset(
      type: DirectiveType.requestMaintenanceCheck,
      title: 'Bakım: MEL Defterine Bak',
      defaultMessage: '🛠️ Bakım Müfettişi: Pitot ısıtıcısının MEL erteleme kaydını bulun!',
      recommendedTargetRole: InvestigatorRole.maintenanceOps,
    ),
    PingPreset(
      type: DirectiveType.requestFlirEnhance,
      title: 'FLIR: Pitot Yakınlaş',
      defaultMessage: '📹 FLIR Uzmanı: T+66s termal kamerasında pitot donmasını doğrulayın!',
      recommendedTargetRole: InvestigatorRole.avionicsFlir,
    ),
    PingPreset(
      type: DirectiveType.confirmHypothesis,
      title: 'Hipotezi Onayla',
      defaultMessage: '✅ Bu delil kök neden zincirini doğruluyor, masaya pinliyorum!',
    ),
  ];
}
