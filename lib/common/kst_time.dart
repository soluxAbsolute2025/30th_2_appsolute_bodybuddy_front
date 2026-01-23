DateTime nowKST() {
  final utc = DateTime.now().toUtc();
  final kst = utc.add(const Duration(hours: 9));
  return DateTime(kst.year, kst.month, kst.day, kst.hour, kst.minute, kst.second, kst.millisecond, kst.microsecond);
}

DateTime dateOnlyKST() {
  final kst = nowKST();
  return DateTime(kst.year, kst.month, kst.day);
}
