enum CameraFeedType {
  cockpitCctv,
  tailExteriorCam,
  avionicsFlir,
  wireframe3dRecon,
}

class ForensicClip {
  final String id;
  final String title;
  final int offsetSeconds;
  final String timestampUtc;
  final CameraFeedType cameraType;
  final String description;
  final String subtitleText;
  final String? revealsEvidenceId;
  final String? assetPath;
  final Uri? remoteUri;
  final bool isReconstruction;

  const ForensicClip({
    required this.id,
    required this.title,
    required this.offsetSeconds,
    required this.timestampUtc,
    required this.cameraType,
    required this.description,
    required this.subtitleText,
    this.revealsEvidenceId,
    this.assetPath,
    this.remoteUri,
    this.isReconstruction = true,
  });

  String get cameraLabel {
    switch (cameraType) {
      case CameraFeedType.cockpitCctv:
        return 'KOKPİT BİRLEŞİK REKONSTRÜKSİYONU';
      case CameraFeedType.tailExteriorCam:
        return 'KUYRUK DIŞ GÖVDE REKONSTRÜKSİYONU';
      case CameraFeedType.avionicsFlir:
        return 'AVİYONİK TERMAL REKONSTRÜKSİYON (FLIR)';
      case CameraFeedType.wireframe3dRecon:
        return '3D ENKAZ DAĞILIM REKONSTRÜKSİYONU';
    }
  }

  String get selectorLabel {
    final number = id.split('_').last;
    return cameraType == CameraFeedType.wireframe3dRecon
        ? 'SIM-$number'
        : 'CAM-$number';
  }
}
