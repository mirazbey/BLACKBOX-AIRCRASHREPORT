import 'case_model.dart';

class RoomSlot {
  final InvestigatorRole role;
  final String? occupantUserId;
  final String? occupantDisplayName;
  final String? avatarCode;
  final bool isReady;
  final bool isHost;

  const RoomSlot({
    required this.role,
    this.occupantUserId,
    this.occupantDisplayName,
    this.avatarCode,
    this.isReady = false,
    this.isHost = false,
  });

  bool get isOccupied => occupantUserId != null;

  RoomSlot copyWith({
    String? occupantUserId,
    String? occupantDisplayName,
    String? avatarCode,
    bool? isReady,
    bool? isHost,
  }) {
    return RoomSlot(
      role: role,
      occupantUserId: occupantUserId ?? this.occupantUserId,
      occupantDisplayName: occupantDisplayName ?? this.occupantDisplayName,
      avatarCode: avatarCode ?? this.avatarCode,
      isReady: isReady ?? this.isReady,
      isHost: isHost ?? this.isHost,
    );
  }
}

class RoomState {
  final String roomId;
  final String roomCode;
  final String activeCaseId;
  final String hostUserId;
  final Map<InvestigatorRole, RoomSlot> slots;
  final bool isGameStarted;
  final DateTime createdAt;

  const RoomState({
    required this.roomId,
    required this.roomCode,
    required this.activeCaseId,
    required this.hostUserId,
    required this.slots,
    this.isGameStarted = false,
    required this.createdAt,
  });

  int get occupiedCount => slots.values.where((s) => s.isOccupied).length;
  bool get allReady => slots.values.where((s) => s.isOccupied).every((s) => s.isReady);
}
