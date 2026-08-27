import 'dart:async';
import 'dart:math';

class MultiplayerSession {
  final String roomCode;
  final int localRoleIndex;
  final int totalPlayers;
  final bool isHost;

  const MultiplayerSession({
    required this.roomCode,
    required this.localRoleIndex,
    required this.totalPlayers,
    required this.isHost,
  });
}

class MultiplayerService {
  static final MultiplayerService _instance = MultiplayerService._internal();
  factory MultiplayerService() => _instance;
  MultiplayerService._internal();

  final _boardEventStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get boardEventStream => _boardEventStreamController.stream;

  bool isRadioTransmitting = false;

  Future<MultiplayerSession> findMatch({required int targetRoleCount}) async {
    // Simulated fast edge matchmaking
    await Future.delayed(const Duration(seconds: 2));
    final random = Random();
    final code = 'CRASH-${random.nextInt(900) + 100}';
    final roleIndex = random.nextInt(targetRoleCount) + 1;

    return MultiplayerSession(
      roomCode: code,
      localRoleIndex: roleIndex,
      totalPlayers: targetRoleCount,
      isHost: true,
    );
  }

  Future<MultiplayerSession> joinRoom(String roomCode, int chosenRole) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MultiplayerSession(
      roomCode: roomCode.toUpperCase(),
      localRoleIndex: chosenRole,
      totalPlayers: 2,
      isHost: false,
    );
  }

  void broadcastPinPlaced(String pinId, String evidenceId, double x, double y) {
    _boardEventStreamController.add({
      'type': 'PIN_PLACED',
      'pinId': pinId,
      'evidenceId': evidenceId,
      'x': x,
      'y': y,
    });
  }

  void toggleRadio(bool transmitting) {
    isRadioTransmitting = transmitting;
    _boardEventStreamController.add({
      'type': 'RADIO_STATUS',
      'isTransmitting': transmitting,
    });
  }
}
