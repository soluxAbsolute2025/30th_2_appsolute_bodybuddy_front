DateTime nowKST() {
  // UTC 기준 → 한국 시간(UTC+9)
  return DateTime.now().toUtc().add(const Duration(hours: 9));
}
