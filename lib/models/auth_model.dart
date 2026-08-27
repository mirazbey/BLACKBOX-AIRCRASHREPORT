enum AuthProviderType {
  google,
  apple,
}

class BureauUser {
  final String uid;
  final String displayName;
  final String email;
  final AuthProviderType providerType;
  final String? avatarUrl;
  final String badgeNumber;
  final String rank;
  final int clearanceLevel;
  final int totalCasesSolved;
  final int totalXp;
  final bool isVerifiedFederal;

  const BureauUser({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.providerType,
    this.avatarUrl,
    required this.badgeNumber,
    this.rank = 'BAŞMÜFETTİŞ (LEAD INVESTIGATOR)',
    this.clearanceLevel = 4,
    this.totalCasesSolved = 14,
    this.totalXp = 18450,
    this.isVerifiedFederal = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'providerType': providerType.name,
      'avatarUrl': avatarUrl,
      'badgeNumber': badgeNumber,
      'rank': rank,
      'clearanceLevel': clearanceLevel,
      'totalCasesSolved': totalCasesSolved,
      'totalXp': totalXp,
      'isVerifiedFederal': isVerifiedFederal,
    };
  }

  factory BureauUser.fromJson(Map<String, dynamic> json) {
    return BureauUser(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      providerType: json['providerType'] == 'apple' ? AuthProviderType.apple : AuthProviderType.google,
      avatarUrl: json['avatarUrl'] as String?,
      badgeNumber: json['badgeNumber'] as String? ?? '#44102',
      rank: json['rank'] as String? ?? 'BAŞMÜFETTİŞ (LEAD INVESTIGATOR)',
      clearanceLevel: json['clearanceLevel'] as int? ?? 4,
      totalCasesSolved: json['totalCasesSolved'] as int? ?? 14,
      totalXp: json['totalXp'] as int? ?? 18450,
      isVerifiedFederal: json['isVerifiedFederal'] as bool? ?? true,
    );
  }
}
