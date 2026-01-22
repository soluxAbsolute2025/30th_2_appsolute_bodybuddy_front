// common/kst_time.dart
DateTime nowKST() {
  // ✅ 어떤 기기/에뮬레이터 타임존이든 "KST"로 고정
  return DateTime.now().toUtc().add(const Duration(hours: 9));
}

DateTime dateOnlyKST([DateTime? dt]) {
  final kst = (dt ?? nowKST()).toUtc().add(const Duration(hours: 9));
  return DateTime(kst.year, kst.month, kst.day);
}
