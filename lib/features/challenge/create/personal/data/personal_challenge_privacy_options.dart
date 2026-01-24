class PersonalChallengePrivacyOption {
  final String value;
  final String title;
  final String subtitle;

  const PersonalChallengePrivacyOption({
    required this.value,
    required this.title,
    required this.subtitle,
  });
}

class PersonalChallengePrivacyOptions {
  static const items = <PersonalChallengePrivacyOption>[
    PersonalChallengePrivacyOption(
      value: 'PUBLIC',
      title: '전체 공개',
      subtitle: '모든 사용자가 이 챌린지를 볼 수 있어요',
    ),
    PersonalChallengePrivacyOption(
      value: 'PRIVATE',
      title: '비공개',
      subtitle: '나만 볼 수 있어요',
    ),
  ];
}
