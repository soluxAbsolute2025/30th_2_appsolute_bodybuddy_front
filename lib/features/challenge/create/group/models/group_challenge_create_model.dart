import 'dart:io';

class GroupChallengeCreateModel {
  String title = '';
  String description = '';
  File? imageFile;

  int? period;
  int maxParticipants = 2;
  String privacyScope = 'FRIENDS';

  Map<String, dynamic> toRequestJson() {
    return {
      'title': title.trim(),
      'description': description.trim(),
      'period': period,
      'maxParticipants': maxParticipants,
      'privacyScope': privacyScope,
    }..removeWhere((k, v) => v == null);
  }
}
