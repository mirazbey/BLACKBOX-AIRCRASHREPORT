import 'package:flutter/material.dart';
import '../models/case_model.dart';
import '../services/multiplayer_service.dart';

enum MatchStatus { idle, searching, found, joining }

class MatchmakingProvider extends ChangeNotifier {
  final MultiplayerService _service = MultiplayerService();
  MatchStatus status = MatchStatus.idle;
  MultiplayerSession? currentSession;
  String searchStatusText = '';

  Future<void> startMatchmaking({int targetRoles = 2}) async {
    status = MatchStatus.searching;
    searchStatusText = 'Açık Soruşturma Odaları Taranıyor...';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));
    searchStatusText = 'Müfettiş Ekibi Oluşturuluyor (2/2)...';
    notifyListeners();

    final session = await _service.findMatch(targetRoleCount: targetRoles);
    currentSession = session;
    status = MatchStatus.found;
    searchStatusText = 'Vaka Dosyası Açıldı: [${session.roomCode}]';
    notifyListeners();
  }

  Future<void> joinCustomRoom(String code, InvestigatorRole chosenRole) async {
    status = MatchStatus.joining;
    searchStatusText = 'Odaya Bağlanılıyor: $code...';
    notifyListeners();

    final session = await _service.joinRoom(code, chosenRole.roleIndex);
    currentSession = session;
    status = MatchStatus.found;
    notifyListeners();
  }

  void reset() {
    status = MatchStatus.idle;
    currentSession = null;
    searchStatusText = '';
    notifyListeners();
  }
}
