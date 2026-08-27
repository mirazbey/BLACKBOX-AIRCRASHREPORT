import 'package:flutter/material.dart';

class BoardPin {
  final String pinId;
  final String evidenceId;
  final String title;
  final String sourceTag;
  final Offset position;
  final int ownerRoleIndex;

  const BoardPin({
    required this.pinId,
    required this.evidenceId,
    required this.title,
    required this.sourceTag,
    required this.position,
    required this.ownerRoleIndex,
  });

  BoardPin copyWith({Offset? position}) {
    return BoardPin(
      pinId: pinId,
      evidenceId: evidenceId,
      title: title,
      sourceTag: sourceTag,
      position: position ?? this.position,
      ownerRoleIndex: ownerRoleIndex,
    );
  }
}

class BoardConnection {
  final String connectionId;
  final String fromPinId;
  final String toPinId;
  final String relationType; // SUPPORTS, CONTRADICTS

  const BoardConnection({
    required this.connectionId,
    required this.fromPinId,
    required this.toPinId,
    required this.relationType,
  });
}
