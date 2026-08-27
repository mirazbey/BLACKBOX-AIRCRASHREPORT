import '../models/case_model.dart';
import '../models/event_axis_model.dart';
import '../models/source_models.dart';
import '../models/evidence_model.dart';
import '../models/causal_graph_model.dart';
import '../models/unlock_rules_model.dart';
import '../models/forensic_clip_model.dart';
import '../models/interrogation_model.dart';
import '../models/tactical_ping_model.dart';
import '../models/cinematic_debrief_model.dart';

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

  static final CaseBundle heliosCaseManifest = CaseBundle(
    id: 'CASE-002',
    code: 'HCU-522-GHOST',
    title: 'Hayalet Uçak (The Ghost Flight)',
    subtitle: 'FL340 Tırmanışta Sessizliğe Gömülen Kabin & Hipoksi',
    difficulty: CaseDifficulty.medium,
    durationMinutes: 18,
    isHistorical: true,
    aircraft: const AircraftProfile(
      model: 'Boeing 737-300',
      tailNumber: '5B-DBY',
      engines: '2x CFM56-3B2 Turbofan',
      operatorName: 'Helios Sun Airways',
      avionicsSuite: 'Pneumatic Pressurization / Master Caution',
    ),
    flight: const FlightProfile(
      flightNumber: 'HCU-522',
      departure: 'Larnaka (LCA)',
      destination: 'Atina & Prag (ATH/PRG)',
      phaseOfFlight: 'Tırmanış & Seyir (FL340)',
      soulsOnBoard: 121,
      lastKnownAltitude: '34,000 ft (FL340)',
      locationDescription: 'Grammatiko Dağlık Bölgesi (Yunanistan)',
      initialSummary:
          'Uçak 12.000 ft tırmanıştayken kabin basınç uyarısı çalmış, kule ile irtibat kesilmiştir. '
          'Otopilotta 2 saat boyunca Atina üzerinde daire çizen uçağa F-16 savaş jetleri eşlik etmiş; '
          'pilotların baygın olduğu ve yakıt bitince uçağın düştüğü bildirilmiştir.',
    ),
  );

  static final CaseBundle tenerifeCaseManifest = CaseBundle(
    id: 'CASE-001',
    code: 'TEN-1977-COLLISION',
    title: 'Sisli Pist Faciası (Tenerife Runway Collision)',
    subtitle: 'Yoğun Siste Kalkış İzni Karmaşası & Çift 747 Faciası',
    difficulty: CaseDifficulty.extreme,
    durationMinutes: 25,
    isHistorical: true,
    aircraft: const AircraftProfile(
      model: 'Boeing 747-206B / 747-121',
      tailNumber: 'PH-BUF / N736PA',
      engines: '4x JT9D-7Q Turbofan',
      operatorName: 'KLM / Pan American',
      avionicsSuite: 'VHF Radio / Non-Radar Tower Procedures',
    ),
    flight: const FlightProfile(
      flightNumber: 'KLM-4805 / PA-1736',
      departure: 'Amsterdam / New York',
      destination: 'Gran Canaria (LPA) ➔ Los Rodeos',
      phaseOfFlight: 'Kalkış & Pist Kat Etme',
      soulsOnBoard: 583,
      lastKnownAltitude: '0 ft (Pist Yüzeyi)',
      locationDescription: 'Los Rodeos Havalimanı (Tenerife)',
      initialSummary:
          'Yoğun sis altında görüş 300 metrenin altına düşmüşken, kule ve uçaklar arasındaki '
          'telsiz paraziti ve yanlış anlaşılan "Take-off" ibaresi nedeniyle iki dev jumbo jet '
          'aynı pistte kafa kafaya çarpışmıştır. Havacılık tarihinin en ölümcül kazasıdır.',
    ),
  );

  static final List<CaseBundle> allCaseManifests = [
    sampleCaseManifest,
    heliosCaseManifest,
    tenerifeCaseManifest,
  ];

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
      stressStatus: 'AKUT TRAVMA FLASHBACK (138 BPM)',
      questions: [
        DialogueQuestion(
          id: 'Q_FO_01',
          questionText: 'Otopilot attığında lövyeyi neden sonuna kadar geriye çektiniz?',
          answerText: 'Kokpit ekranında sürat göstergesi 60 knot\'a çakıldı! Uçak düşüyor zannettim, yere çarpmamak için refleksle lövyeyi geriye asıldım!',
          stressReaction: 'Göz bebekleri büyüyor; elleri titriyor (Akut Ölüm Korkusu).',
          stressNature: StressNature.traumaFlashback,
          contradictionHint: 'İfade doğru; ancak pilot hız kaybı illüzyonu yaşadı (FDR Stick Pull ile eşleşiyor).',
          unlocksEvidenceId: 'EVD_FDR_STICK_PULL',
          unlockedEvidenceTitle: 'Pilotun Panik Lövye Refleksi (Stall Girişi)',
        ),
        DialogueQuestion(
          id: 'Q_FO_02',
          questionText: 'Kaptan pilot kokpitten ayrılırken ne talimat verdi?',
          answerText: 'Fırtına hattına giriyoruz, rotayı koruyun dedi ve dinlenme kabinine geçti. Sol koltukta yalnız kaldım...',
          stressReaction: 'Sesi kısılıyor, başını öne eğiyor (Vicdan Azabı).',
          stressNature: StressNature.guiltAnxiety,
          contradictionHint: 'CVR ses kaydıyla teyitli (CRM hatası).',
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
      stressStatus: 'ŞÜPHELİ GERGİNLİK (146 BPM)',
      questions: [
        DialogueQuestion(
          id: 'Q_MECH_01',
          questionText: 'Uçuş öncesi pitot ısıtıcı direnç arızası deftere işlendi mi?',
          answerText: 'Evet, Rio hangarda parça yoktu. Operasyon Müdürü "Uçağı yerde tutamayız, MEL ertelemesi yapın, Paris\'te değişsin" diye baskı yaptı.',
          stressReaction: 'Göz temasından kaçınıyor, masanın altındaki parmaklarını sıkıyor (Baskı İtirafı).',
          stressNature: StressNature.guiltAnxiety,
          contradictionHint: 'OP-04 MEL kütüğündeki ertelenen parça koduyla örtüşüyor.',
          unlocksEvidenceId: 'EVD_MEL_HEATER',
          unlockedEvidenceTitle: 'Yasadışı MEL Erteleme Talimatı (Parça Yokluğu)',
        ),
        DialogueQuestion(
          id: 'Q_MECH_02',
          questionText: 'Bakım kütüğündeki ıslak imzanın size ait olmadığını iddia edebilir misiniz?',
          answerText: 'O imzayı ben atmak istemedim, şirket nöbetçi mühendisi zorla kaşeletti...',
          stressReaction: 'Poligraf iğnesi ani sıçrama yapıyor (148 BPM).',
          stressNature: StressNature.deliberateDeception,
          contradictionHint: 'İmza sahteciliği şüphesi; resmi sicil defteriyle çapraz kanıtlama gerektirir.',
        ),
      ],
    ),
    const SuspectProfile(
      id: 'SUSPECT_ATC',
      name: 'Amadou Diallo',
      title: 'Dakar FIR Nöbetçi Hava Trafik Kontrolörü',
      organization: 'ASECNA Hava Sahası Otoritesi',
      avatarCode: '🎧',
      stressStatus: 'DENGELİ / GÖZLEMCİ (74 BPM)',
      questions: [
        DialogueQuestion(
          id: 'Q_ATC_01',
          questionText: 'Uçuş ekibi fırtına etrafından dolaşmak için rota sapması istedi mi?',
          answerText: 'Hayır, hiçbir rota değişikliği veya acil durum çağrısı (MAYDAY) yapmadılar. Direkt fırtına çekirdeğine girdiler.',
          stressReaction: 'Radar kayıt logunu ve ses bandı saatini masaya koyuyor.',
          stressNature: StressNature.calmTruth,
          contradictionHint: 'Doppler radarı ve telsiz kütüğüyle %100 uyumlu.',
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

  static final List<CinematicReconstructionScene> sampleReconstructionScenes = [
    const CinematicReconstructionScene(
      sequenceOrder: 1,
      timeUtc: '2 Gün Önce',
      timeOffsetLabel: 'T-48h',
      primaryOperatorRole: InvestigatorRole.maintenanceOps,
      stageTitle: 'AŞAMA 1: GİZLİ BAKIM ERTELEMESİ',
      headline: 'Rio İstasyonunda Ertelenen Pitot Isıtıcı Değişimi',
      description: 'Yedek parça bulunamadığı için pitot ısıtıcı probundaki direnç arızası şirket emriyle MEL kapsamına sokulup ertelendi.',
      mediaAssetOrSceneType: 'mel_log',
      audioVoiceOver: '[BAKIM DEFTERİ]: "Parça yokluğu teyit edildi. Uçuş gecikmesin, Paris\'te değişsin."',
      swissCheeseHoleTitle: 'Gizli Organizasyonel İhmal (Latent Failure)',
    ),
    const CinematicReconstructionScene(
      sequenceOrder: 2,
      timeUtc: '02:10:06 UTC',
      timeOffsetLabel: 'T+66s',
      primaryOperatorRole: InvestigatorRole.avionicsFlir,
      stageTitle: 'AŞAMA 2: SENSÖR KİLİTLENMESİ',
      headline: 'FL350 Tropikal Fırtınada Pitot Tüplerinin Donması',
      description: 'Tropikal fırtına hücresindeki aşırı rime buzu ısıtılmayan pitot problarını tamamen tıkadı. Hız verisi sıfırlandı.',
      mediaAssetOrSceneType: 'flir_ice',
      audioVoiceOver: '[FLIR TERMAL]: "Pitot tüpleri aşırı buzlanmayla tıkandı. Otopilot devreden çıktı."',
      swissCheeseHoleTitle: 'Doğrudan Mekanik Tetikleyici (Active Trigger)',
    ),
    const CinematicReconstructionScene(
      sequenceOrder: 3,
      timeUtc: '02:10:15 UTC',
      timeOffsetLabel: 'T+75s',
      primaryOperatorRole: InvestigatorRole.telemetryFdr,
      stageTitle: 'AŞAMA 3: GÖSTERGE İLLÜZYONU & STALL ÇEKİŞİ',
      headline: 'Yardımcı Pilotun Lövyeyi Panikle %85 Geriye Çekmesi',
      description: 'Hız göstergelerinin düşüşüyle uçağın irtifa kaybettiğini sanan yardımcı pilot, burnu 15 derece yukarı dikerek uçağı ölümcül Stall\'a soktu.',
      mediaAssetOrSceneType: 'pfd_stall',
      audioVoiceOver: '[FDR TELEMETRİ]: "Lövye sonuna kadar geride. Hücum açısı aşıldı: STALL! STALL!"',
      swissCheeseHoleTitle: 'İnsan Hatası & Durumsal Farkındalık Kaybı',
    ),
    const CinematicReconstructionScene(
      sequenceOrder: 4,
      timeUtc: '02:11:32 UTC',
      timeOffsetLabel: 'T+152s',
      primaryOperatorRole: InvestigatorRole.acousticCvr,
      stageTitle: 'AŞAMA 4: KOKPİT İLETİŞİM KOPUKLUĞU (CRM)',
      headline: 'Kaptanın Kokpite Dönüşü ve Geç Müdahale',
      description: 'Dinlenme kabininden dönen kaptan pilot lövye pozisyonunu fark ettiğinde uçak derin perdövitese girmişti.',
      mediaAssetOrSceneType: 'pfd_stall',
      audioVoiceOver: '[CVR SES]: "KAPTAN: Ne yapıyorsunuz siz?! Burnu derhal aşağı ver!"',
      swissCheeseHoleTitle: 'Mürettebat Kaynak Yönetimi (CRM) Çöküşü',
    ),
    const CinematicReconstructionScene(
      sequenceOrder: 5,
      timeUtc: '02:14:28 UTC',
      timeOffsetLabel: 'T+240s',
      primaryOperatorRole: InvestigatorRole.humanFactorsPsych,
      stageTitle: 'AŞAMA 5: DENİZE DARBE & NİHAİ KAZA',
      headline: 'Okyanus Yüzeyine Tek Parça Kompakt Çarpışma',
      description: 'Uçak havada parçalanmamış, derin stall açısıyla okyanusa çarpmıştır. 228 can kaybı.',
      mediaAssetOrSceneType: 'impact_3d',
      audioVoiceOver: '[NTSB RESMİ KARARI]: "Tüm kaza faktörleri doğrulandı. Soruşturma tamamlandı."',
      swissCheeseHoleTitle: 'Nihai Kaza Sonucu (Fatal Crash Event)',
    ),
  ];

  static final List<SuspectProfile> heliosSuspects = [
    const SuspectProfile(
      id: 'SUSPECT_H_MECH',
      name: 'Alan Irwin',
      title: 'Larnaka Yer Bakım Teknisyeni',
      organization: 'Helios Ground Maintenance',
      avatarCode: '🛠️',
      stressStatus: 'AĞIR VİCDAN AZABI (132 BPM)',
      questions: [
        DialogueQuestion(
          id: 'Q_HMECH_01',
          questionText: 'Uçuş öncesi kapı basınç kaçak testini nasıl tamamladınız?',
          answerText: 'Kabin basınçlandırma şalterini MANUAL moduna alıp basınç testi yaptık. Test bittikten sonra şalteri AUTO moduna geri almayı unuttum...',
          stressReaction: 'Gözyaşlarını tutamıyor, ellerini yüzüne kapatıyor (Gerçek İtiraf).',
          stressNature: StressNature.guiltAnxiety,
          contradictionHint: 'Kokpit pnömatik şalter paneliyle %100 örtüşüyor.',
          unlocksEvidenceId: 'EVD_MEL_HEATER',
          unlockedEvidenceTitle: 'Basınçlandırma Şalterinin MANUAL Unutulması',
        ),
      ],
    ),
    const SuspectProfile(
      id: 'SUSPECT_F16_PILOT',
      name: 'Binbaşı Prodromou',
      title: 'Hellenic Air Force F-16 Kol Lideri',
      organization: 'Yunan Hava Kuvvetleri • 111. Filo',
      avatarCode: '🪖',
      stressStatus: 'SAKİN & GÖZLEMCİ (72 BPM)',
      questions: [
        DialogueQuestion(
          id: 'Q_F16_01',
          questionText: 'Havada uçağa yaklaştığınızda kokpitte ne gördünüz?',
          answerText: 'Kaptan koltuğunda baygın yatıyordu. Kabin pencereleri tamamen buz tutmuştu. Sol koltuğa elinde taşınabilir oksijen tüpü olan bir kabin memuru oturdu...',
          stressReaction: 'F-16 kask kamera kaydını masaya koyuyor.',
          stressNature: StressNature.calmTruth,
          contradictionHint: 'FLIR kask kamerasıyla teyitli (Hipoksi / Kabin Donması).',
          unlocksEvidenceId: 'EVD_METAR_ICING',
          unlockedEvidenceTitle: 'F-16 Kask Kamerası: Kokpitte Hipoksi Teyidi',
        ),
      ],
    ),
  ];

  static final List<CinematicReconstructionScene> heliosReconstructionScenes = [
    const CinematicReconstructionScene(
      sequenceOrder: 1,
      timeUtc: '09:00 UTC',
      timeOffsetLabel: 'T-30m',
      primaryOperatorRole: InvestigatorRole.maintenanceOps,
      stageTitle: 'AŞAMA 1: GİZLİ BAKIM İHMALİ',
      headline: 'Basınçlandırma Şalterinin MANUAL Konumunda Unutulması',
      description: 'Larnaka yer bakım teknisyeni kaçak testinden sonra tavan panelindeki basınç şalterini AUTO konumuna geri almadı.',
      mediaAssetOrSceneType: 'mel_log',
      audioVoiceOver: '[YER BAKIM]: "Basınç testi tamamlandı. Şalter MANUAL\'de unutuldu."',
      swissCheeseHoleTitle: 'Gizli Bakım İhmali (Latent Failure)',
    ),
    const CinematicReconstructionScene(
      sequenceOrder: 2,
      timeUtc: '09:12 UTC',
      timeOffsetLabel: 'T+120s',
      primaryOperatorRole: InvestigatorRole.telemetryFdr,
      stageTitle: 'AŞAMA 2: BASINÇ ALARMI & GÖSTERGE YANILSAMASI',
      headline: 'Kabin İrtifası 10.000 ft\'i Aşınca Çalan Master Caution',
      description: 'Pilotlar kalkış konfigürasyon düdüğü sandıkları kabin basınç alarmını teşhis edemedi.',
      mediaAssetOrSceneType: 'pfd_stall',
      audioVoiceOver: '[FDR TELEMETRİ]: "Kabin irtifası alarmı çalıyor: BEEP-BEEP-BEEP!"',
      swissCheeseHoleTitle: 'Gösterge İllüzyonu & Alarm Yanılgısı',
    ),
    const CinematicReconstructionScene(
      sequenceOrder: 3,
      timeUtc: '09:30 UTC',
      timeOffsetLabel: 'T+1800s',
      primaryOperatorRole: InvestigatorRole.humanFactorsPsych,
      stageTitle: 'AŞAMA 3: SİNSİ HİPOKSİ & BİLİNÇ KAYBI',
      headline: 'Oksijensiz Kalan Tüm Mürettebat ve Yolcuların Bayılması',
      description: 'FL340 seyir irtifasında 15 saniyede faydalı bilinç süresi doldu; tüm uçak hipoksiye girdi.',
      mediaAssetOrSceneType: 'pfd_stall',
      audioVoiceOver: '[ADLİ PSİKOLOJİ]: "Sinsi hipoksi oksijen eksikliğini fark ettirmeden bilinci kapattı."',
      swissCheeseHoleTitle: 'İnsan Faktörü & Hipoksiye Bağlı Bayılma',
    ),
    const CinematicReconstructionScene(
      sequenceOrder: 4,
      timeUtc: '11:24 UTC',
      timeOffsetLabel: 'T+7000s',
      primaryOperatorRole: InvestigatorRole.avionicsFlir,
      stageTitle: 'AŞAMA 4: F-16 JET ÖNLEMESİ & KAHRAMANCA MÜCADELE',
      headline: 'Kabin Memuru Andreas\'ın Kokpitteki Son Çabası',
      description: 'Taşınabilir oksijenle kokpite giren kabin memuru uçağı kurtarmaya çalıştı ancak yakıt tükendi.',
      mediaAssetOrSceneType: 'flir_ice',
      audioVoiceOver: '[F-16 KASK KAMERA]: "Pilotlar baygın, kokpitte bir kabin memuru el sallıyor!"',
      swissCheeseHoleTitle: 'Otopilot Eşliğinde Yakıt Tükenişi',
    ),
    const CinematicReconstructionScene(
      sequenceOrder: 5,
      timeUtc: '11:41 UTC',
      timeOffsetLabel: 'T+7350s',
      primaryOperatorRole: InvestigatorRole.humanFactorsPsych,
      stageTitle: 'AŞAMA 5: GRAMMATIKO DAĞLIK ALAN DARBESİ',
      headline: 'Çift Motor Durması Sonucu Dağa Çarpış',
      description: 'Yakıtı tamamen biten uçak spiral dalışla dağa çarptı. 121 can kaybı.',
      mediaAssetOrSceneType: 'impact_3d',
      audioVoiceOver: '[NTSB / AAIASB KARARI]: "Kaza zinciri doğrulandı. Soruşturma tamamlandı."',
      swissCheeseHoleTitle: 'Nihai Kaza Sonucu (Fatal Crash Event)',
    ),
  ];

  static List<SuspectProfile> getSuspectsForCase(String caseId) {
    if (caseId == 'CASE-002') {
      return heliosSuspects;
    }
    return sampleSuspects;
  }

  static List<CinematicReconstructionScene> getReconstructionScenesForCase(String caseId) {
    if (caseId == 'CASE-002') {
      return heliosReconstructionScenes;
    }
    return sampleReconstructionScenes;
  }

  static List<OperatorScoreDetail> getSampleOperatorScores(int totalScore) {
    return [
      const OperatorScoreDetail(
        role: InvestigatorRole.telemetryFdr,
        operatorCode: 'OP-01 [FDR]',
        specialistTitle: 'Telemetri & FDR Mühendisi',
        earnedXp: 520,
        accuracyPercentage: 96,
        isMvp: true,
        keyDiscoveryTitle: 'Lövye Geri Çekişi (Stall Girişi)',
        unlockedBadges: ['★ MVP', 'KARA KUTU HACKER', 'STALL AVCISI'],
      ),
      const OperatorScoreDetail(
        role: InvestigatorRole.avionicsFlir,
        operatorCode: 'OP-03 [FLIR]',
        specialistTitle: 'FLIR & Video Rekonstrüksiyon',
        earnedXp: 480,
        accuracyPercentage: 92,
        isMvp: false,
        keyDiscoveryTitle: 'Termal Pitot Buzlanma Kadrajı',
        unlockedBadges: ['KESKİN GÖZ: FLIR', 'TERMAL DEDEKTİF'],
      ),
      const OperatorScoreDetail(
        role: InvestigatorRole.maintenanceOps,
        operatorCode: 'OP-04 [MEL]',
        specialistTitle: 'Adli Bakım & MEL Müfettişi',
        earnedXp: 500,
        accuracyPercentage: 94,
        isMvp: false,
        keyDiscoveryTitle: 'Ertelenmiş Pitot Isıtıcı MEL Kaydı',
        unlockedBadges: ['ADLİ MÜHÜR AVCI', 'KÖK NEDEN BULUCU'],
      ),
      const OperatorScoreDetail(
        role: InvestigatorRole.humanFactorsPsych,
        operatorCode: 'OP-05 [CRM]',
        specialistTitle: 'Adli Psikolog & CRM Sorgu',
        earnedXp: 490,
        accuracyPercentage: 90,
        isMvp: false,
        keyDiscoveryTitle: 'Pilotun Panik Refleksi İtirafı',
        unlockedBadges: ['YALAN AVCISI', 'BİYOMETRİK UZMAN'],
      ),
      const OperatorScoreDetail(
        role: InvestigatorRole.acousticCvr,
        operatorCode: 'OP-02 [CVR]',
        specialistTitle: 'Akustik & CVR Analisti',
        earnedXp: 440,
        accuracyPercentage: 88,
        isMvp: false,
        keyDiscoveryTitle: 'Stall Alarmı & Kaptan Uyarısı',
        unlockedBadges: ['SES FİLTRE USTASI', 'CVR KULAK'],
      ),
    ];
  }
}
