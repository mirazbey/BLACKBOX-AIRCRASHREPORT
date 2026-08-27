class EventMarker {
  final int caseTimeSeconds;
  final String timestampUtc;
  final String track; // FDR, CVR, ATC, SYSTEM
  final String label;
  final String? linkedEvidenceId;
  final List<int> rolesNotified;

  const EventMarker({
    required this.caseTimeSeconds,
    required this.timestampUtc,
    required this.track,
    required this.label,
    this.linkedEvidenceId,
    this.rolesNotified = const [],
  });

  factory EventMarker.fromJson(Map<String, dynamic> json) {
    return EventMarker(
      caseTimeSeconds: json['case_time_s'] as int? ?? 0,
      timestampUtc: json['timestamp_utc'] as String? ?? '00:00:00',
      track: json['track'] as String? ?? 'SYSTEM',
      label: json['label'] as String? ?? '',
      linkedEvidenceId: json['linked_evidence_id'] as String?,
      rolesNotified: (json['roles_notified'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
    );
  }
}

class EventAxis {
  final String epochUtc;
  final int totalDurationSeconds;
  final List<EventMarker> markers;

  const EventAxis({
    required this.epochUtc,
    required this.totalDurationSeconds,
    required this.markers,
  });

  factory EventAxis.fromJson(Map<String, dynamic> json) {
    final list = json['markers'] as List<dynamic>? ?? [];
    return EventAxis(
      epochUtc: json['epoch_utc'] as String? ?? '00:00:00',
      totalDurationSeconds: json['total_duration_s'] as int? ?? 330,
      markers: list.map((e) => EventMarker.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
