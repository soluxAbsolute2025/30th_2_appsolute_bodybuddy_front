class Booster {
  final int id;
  final String name;
  final String description;
  final int price;

  const Booster({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Booster.fromJson(Map<String, dynamic> json) {
    return Booster(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
    );
  }
}
