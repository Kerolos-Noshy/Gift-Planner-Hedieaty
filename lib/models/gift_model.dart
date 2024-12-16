class Gift {
  int? id;
  String name;
  String? description;
  String? category;
  double? price;
  String? status;
  int? eventId;

  Gift({
    this.id,
    required this.name,
    this.description,
    this.category,
    this.price,
    this.status,
    this.eventId,
  });

  // Convert Gift object to a Map (for SQLite insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'event_id': eventId,
    };
  }

  // Create a Gift object from a Map (retrieved from SQLite or Firestore)
  factory Gift.fromMap(Map<String, dynamic> map) {
    return Gift(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price']?.toDouble(),
      status: map['status'],
      eventId: map['event_id'],
    );
  }
}
