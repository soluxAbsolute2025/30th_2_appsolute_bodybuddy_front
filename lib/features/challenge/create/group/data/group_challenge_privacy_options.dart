class GroupChallengePrivacyOption {
  final String value; // FRIENDS, PUBLIC, PRIVATE
  final String title;
  final String subtitle;

  const GroupChallengePrivacyOption({
    required this.value,
    required this.title,
    required this.subtitle,
  });
}

class GroupChallengePrivacyOptions {
  static const List<GroupChallengePrivacyOption> items = [
    GroupChallengePrivacyOption(
      value: 'FRIENDS',
      title: '친구 공개',
      subtitle: '나와 친구인 사람들에게만 내 챌린지가 표시돼요',
    ),
    GroupChallengePrivacyOption(
      value: 'PUBLIC',
      title: '전체 공개',
      subtitle: '나와 친구가 아닌 사람들도 내 챌린지를 볼 수 있어요',
    ),
    GroupChallengePrivacyOption(
      value: 'PRIVATE',
      title: '비공개',
      subtitle: '그룹 코드를 공유한 친구만 내 챌린지를 볼 수 있어요',
    ),
  ];
}
