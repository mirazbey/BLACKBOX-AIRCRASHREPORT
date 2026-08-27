// FDR Telemetry Records
class FdrRecord {
  final int offsetSeconds;
  final double altitudeFt;
  final double indicatedAirspeedKnots;
  final double groundSpeedKnots;
  final double pitchDeg;
  final double rollDeg;
  final double controlColumnPct; // Negative: Pull-up / Positive: Push-down
  final double engine1N1Pct;
  final double engine2N1Pct;
  final bool autopilotEngaged;
  final String? linkedEvidenceId;

  const FdrRecord({
    required this.offsetSeconds,
    required this.altitudeFt,
    required this.indicatedAirspeedKnots,
    required this.groundSpeedKnots,
    required this.pitchDeg,
    required this.rollDeg,
    required this.controlColumnPct,
    required this.engine1N1Pct,
    required this.engine2N1Pct,
    required this.autopilotEngaged,
    this.linkedEvidenceId,
  });

  factory FdrRecord.fromJson(Map<String, dynamic> json) {
    final readings = json['readings'] as Map<String, dynamic>? ?? {};
    return FdrRecord(
      offsetSeconds: json['offset_s'] as int? ?? 0,
      altitudeFt: (readings['altitude_ft'] as num?)?.toDouble() ?? 0.0,
      indicatedAirspeedKnots: (readings['ias_kt'] as num?)?.toDouble() ?? 0.0,
      groundSpeedKnots: (readings['gs_kt'] as num?)?.toDouble() ?? 0.0,
      pitchDeg: (readings['pitch_deg'] as num?)?.toDouble() ?? 0.0,
      rollDeg: (readings['roll_deg'] as num?)?.toDouble() ?? 0.0,
      controlColumnPct: (readings['control_column_pct'] as num?)?.toDouble() ?? 0.0,
      engine1N1Pct: (readings['eng1_n1_pct'] as num?)?.toDouble() ?? 0.0,
      engine2N1Pct: (readings['eng2_n1_pct'] as num?)?.toDouble() ?? 0.0,
      autopilotEngaged: readings['autopilot_engaged'] as bool? ?? false,
      linkedEvidenceId: json['linked_evidence_id'] as String?,
    );
  }
}

// CVR & ATC Transcript Segments
class AudioSegment {
  final String id;
  final int offsetSeconds;
  final String timestampUtc;
  final String channel;
  final String speaker;
  final String text;
  final List<String> alarms;
  final String? linkedEvidenceId;

  const AudioSegment({
    required this.id,
    required this.offsetSeconds,
    required this.timestampUtc,
    required this.channel,
    required this.speaker,
    required this.text,
    this.alarms = const [],
    this.linkedEvidenceId,
  });

  factory AudioSegment.fromJson(Map<String, dynamic> json) {
    return AudioSegment(
      id: json['id'] as String? ?? '',
      offsetSeconds: json['offset_s'] as int? ?? 0,
      timestampUtc: json['timestamp_utc'] as String? ?? '00:00:00',
      channel: json['channel'] as String? ?? 'CVR_COCKPIT',
      speaker: json['speaker'] as String? ?? 'Bilinmiyor',
      text: json['text'] as String? ?? '',
      alarms: (json['alarms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      linkedEvidenceId: json['linked_evidence_id'] as String?,
    );
  }
}

// Maintenance & Operational Tech Logs
class MaintenanceLog {
  final String logId;
  final String date;
  final String station;
  final String defectDescription;
  final String actionTaken;
  final String inspectorCode;
  final bool isDeferred;
  final String? linkedEvidenceId;

  const MaintenanceLog({
    required this.logId,
    required this.date,
    required this.station,
    required this.defectDescription,
    required this.actionTaken,
    required this.inspectorCode,
    this.isDeferred = false,
    this.linkedEvidenceId,
  });

  factory MaintenanceLog.fromJson(Map<String, dynamic> json) {
    return MaintenanceLog(
      logId: json['log_id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      station: json['station'] as String? ?? '',
      defectDescription: json['defect_description'] as String? ?? '',
      actionTaken: json['action_taken'] as String? ?? '',
      inspectorCode: json['inspector_code'] as String? ?? '',
      isDeferred: json['is_deferred'] as bool? ?? false,
      linkedEvidenceId: json['linked_evidence_id'] as String?,
    );
  }
}

// Environment & Wreckage Analysis
class EnvironmentReport {
  final String rawMetar;
  final String decodedSummary;
  final String severeIcingAltitudeRange;
  final String turbulenceLevel;
  final String wreckagePattern;
  final String wreckageInterpretation;
  final String? linkedEvidenceId;

  const EnvironmentReport({
    required this.rawMetar,
    required this.decodedSummary,
    required this.severeIcingAltitudeRange,
    required this.turbulenceLevel,
    required this.wreckagePattern,
    required this.wreckageInterpretation,
    this.linkedEvidenceId,
  });

  factory EnvironmentReport.fromJson(Map<String, dynamic> json) {
    return EnvironmentReport(
      rawMetar: json['raw_metar'] as String? ?? '',
      decodedSummary: json['decoded_summary'] as String? ?? '',
      severeIcingAltitudeRange: json['severe_icing_altitude_range'] as String? ?? '',
      turbulenceLevel: json['turbulence_level'] as String? ?? '',
      wreckagePattern: json['wreckage_pattern'] as String? ?? '',
      wreckageInterpretation: json['wreckage_interpretation'] as String? ?? '',
      linkedEvidenceId: json['linked_evidence_id'] as String?,
    );
  }
}
