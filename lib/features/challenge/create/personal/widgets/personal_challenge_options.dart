class PersonalChallengeOptions {
  static const units = ['걸음', '분', '회', 'km'];

  static const Map<String, String> unitToApi = {
    '걸음': 'steps',
    '분': 'minutes',
    '회': 'count',
    'km': 'km',
  };
}
