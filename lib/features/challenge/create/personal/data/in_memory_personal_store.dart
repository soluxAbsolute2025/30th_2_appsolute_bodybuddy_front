class InMemoryPersonalStore {
  int _autoId = 1;
  final List<Map<String, dynamic>> _items = [];

  int insert(Map<String, dynamic> item) {
    final id = _autoId++;
    _items.add({"challengeId": id, ...item});
    return id;
  }

  List<Map<String, dynamic>> getAll() => List.unmodifiable(_items);
}
