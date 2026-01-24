import '../models/group_challenge_create_model.dart';

class GroupChallengeCreateController {
  final GroupChallengeCreateModel model;
  GroupChallengeCreateController(this.model);

  /// 기간(>=7) + 최대 인원(>=2)
  bool get isTypePageValid {
    final p = model.period;
    return p != null && p >= 7 && model.maxParticipants >= 2;
  }

  /// 공개 범위: PUBLIC / SECRET
  bool get isPrivacyPageValid {
    return model.visibility == 'PUBLIC' || model.visibility == 'SECRET';
  }

  /// 제목/설명 필수
  bool get isInfoPageValid {
    return model.title.trim().isNotEmpty && model.description.trim().isNotEmpty;
  }

  bool get isCreateValid => isTypePageValid && isPrivacyPageValid && isInfoPageValid;
}
