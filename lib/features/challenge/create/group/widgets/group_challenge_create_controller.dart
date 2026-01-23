import '../models/group_challenge_create_model.dart';

class GroupChallengeCreateController {
  final GroupChallengeCreateModel model;
  GroupChallengeCreateController(this.model);

  bool get isTypePageValid {
    final p = model.period;
    return p != null && p >= 7 && model.maxParticipants >= 2;
  }

  bool get isPrivacyPageValid {
    return model.privacyScope == 'FRIENDS' ||
        model.privacyScope == 'PUBLIC' ||
        model.privacyScope == 'PRIVATE';
  }

  bool get isInfoPageValid {
    return model.title.trim().isNotEmpty &&
        model.description.trim().isNotEmpty;
  }

  bool get isCreateValid => isTypePageValid && isPrivacyPageValid && isInfoPageValid;
}
