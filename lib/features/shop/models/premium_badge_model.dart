class PremiumBadge { 
  final int id; 
  final String name; 
  final String description; 
  final int price; 
  final String? iconUrl; 
  
const PremiumBadge({ 
  required this.id, 
  required this.name, 
  required this.description, 
  required this.price, 
  this.iconUrl, 
}); 

factory PremiumBadge.fromJson(Map<String, dynamic> json) { 
  return PremiumBadge( 
    id: json['id'] as int, 
    name: json['name'] as String, 
    description: json['description'] as String, 
    price: json['price'] as int, 
    iconUrl: json['iconUrl'] as String?, 
    );
  }
}