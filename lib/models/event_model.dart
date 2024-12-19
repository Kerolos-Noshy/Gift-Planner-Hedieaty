class Event {
  final int? id;
  final String name;
  final DateTime date;
  final String location;
  final String description;
  final String userId;
  final String eventType;
  final bool isPublic;

  Event({
    this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.userId,
    required this.eventType,
    required this.isPublic,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(), // Store as a string for SQLite
      'location': location,
      'description': description,
      'user_id': userId,
      'event_type': eventType,
      "is_public": isPublic ? 1 : 0,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      location: map['location'],
      description: map['description'],
      userId: map['user_id'],
      eventType: map['event_type'],
      isPublic: map['is_public'] == 0 ? false : true,
    );
  }
}
