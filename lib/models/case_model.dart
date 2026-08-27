enum InvestigatorRole {
  telemetryFdr,
  acousticCvr,
  avionicsFlir,
  maintenanceOps,
  humanFactorsPsych,
}

extension InvestigatorRoleExtension on InvestigatorRole {
  String get displayName {
    switch (this) {
      case InvestigatorRole.telemetryFdr:
        return 'Telemetri & FDR Mühendisi';
      case InvestigatorRole.acousticCvr:
        return 'Akustik & CVR Analisti';
      case InvestigatorRole.avionicsFlir:
        return 'FLIR & Video Rekonstrüksiyon';
      case InvestigatorRole.maintenanceOps:
        return 'Adli Bakım & MEL Müfettişi';
      case InvestigatorRole.humanFactorsPsych:
        return 'Adli Psikolog & CRM Sorgu';
    }
  }

  String get shortName {
    switch (this) {
      case InvestigatorRole.telemetryFdr:
        return 'FDR Mühendisi';
      case InvestigatorRole.acousticCvr:
        return 'CVR Analisti';
      case InvestigatorRole.avionicsFlir:
        return 'FLIR Video';
      case InvestigatorRole.maintenanceOps:
        return 'Bakım Müfettişi';
      case InvestigatorRole.humanFactorsPsych:
        return 'Adli Psikolog';
    }
  }

  String get operatorCode {
    switch (this) {
      case InvestigatorRole.telemetryFdr:
        return 'OP-01 [FDR]';
      case InvestigatorRole.acousticCvr:
        return 'OP-02 [CVR]';
      case InvestigatorRole.avionicsFlir:
        return 'OP-03 [FLIR]';
      case InvestigatorRole.maintenanceOps:
        return 'OP-04 [MEL]';
      case InvestigatorRole.humanFactorsPsych:
        return 'OP-05 [CRM]';
    }
  }

  String get specialAbilityDescription {
    switch (this) {
      case InvestigatorRole.telemetryFdr:
        return 'Canlı PFD yapay ufku, sensör eğrileri ve anomali tespiti';
      case InvestigatorRole.acousticCvr:
        return '4-kanallı kokpit ses spektrogramı ve ses izolasyon filtreleri';
      case InvestigatorRole.avionicsFlir:
        return 'Termal palet (FLIR), kokpit CCTV ve 3D çarpışma simülasyonu';
      case InvestigatorRole.maintenanceOps:
        return 'MEL kütük defteri, şirket gizli yazışmaları ve sahte imza taraması';
      case InvestigatorRole.humanFactorsPsych:
        return 'Mürettebat ve tanık sorgu ağacı, yalan tespiti ve yorgunluk analizi';
    }
  }

  int get roleIndex {
    switch (this) {
      case InvestigatorRole.telemetryFdr:
        return 1;
      case InvestigatorRole.acousticCvr:
        return 2;
      case InvestigatorRole.avionicsFlir:
        return 3;
      case InvestigatorRole.maintenanceOps:
        return 4;
      case InvestigatorRole.humanFactorsPsych:
        return 5;
    }
  }
}

enum CaseDifficulty { easy, medium, hard, extreme }

class AircraftProfile {
  final String model;
  final String tailNumber;
  final String engines;
  final String operatorName;
  final String avionicsSuite;

  const AircraftProfile({
    required this.model,
    required this.tailNumber,
    required this.engines,
    required this.operatorName,
    required this.avionicsSuite,
  });
}

class FlightProfile {
  final String flightNumber;
  final String departure;
  final String destination;
  final String phaseOfFlight;
  final int soulsOnBoard;
  final String lastKnownAltitude;
  final String locationDescription;
  final String initialSummary;

  const FlightProfile({
    required this.flightNumber,
    required this.departure,
    required this.destination,
    required this.phaseOfFlight,
    required this.soulsOnBoard,
    required this.lastKnownAltitude,
    required this.locationDescription,
    required this.initialSummary,
  });
}

class CaseBundle {
  final String id;
  final String code;
  final String title;
  final String subtitle;
  final CaseDifficulty difficulty;
  final int durationMinutes;
  final bool isHistorical;
  final AircraftProfile aircraft;
  final FlightProfile flight;

  const CaseBundle({
    required this.id,
    required this.code,
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.durationMinutes,
    required this.isHistorical,
    required this.aircraft,
    required this.flight,
  });
}
