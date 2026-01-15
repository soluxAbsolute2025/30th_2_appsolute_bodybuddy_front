class GroupChallengeCreateModel {
  String title = '';
  String description = '';

  String imageUrl = '';
  String goalSummary = '';

  int? period;
  int maxParticipants = 2;
  String privacyScope = 'FRIENDS'; 

  Map<String, dynamic> toJson() {
    return {
      'title': title.trim(),
      'description': description.trim(),
      'imageUrl': imageUrl.trim().isEmpty ? null : imageUrl.trim(),
      'period': period,
      'maxParticipants': maxParticipants,
      'privacyScope': privacyScope,
    }..removeWhere((k, v) => v == null);
  }
}
