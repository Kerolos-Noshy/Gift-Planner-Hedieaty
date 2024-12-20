class Gift {
  int? id;
  String? documentId;
  String name;
  String? description;
  String category;
  double price;
  String status;
  int eventId;
  String eventDocId; // firestore event id
  String giftCreatorId;
  late String? pledgerId = null;


  Gift({
    this.id,
    this.documentId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    required this.eventId,
    required this.giftCreatorId,
    required this.eventDocId,
    this.pledgerId
  });

  Map<String, dynamic> toMap() {
    return {
      'document_id': documentId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'event_id': eventId,
      'event_doc_id': eventDocId,
      'gift_creator_id': giftCreatorId,
      'pledger_id': pledgerId
    };
  }

  factory Gift.fromMap(Map<String, dynamic> map) {
    return Gift(
      id: map['id'],
      documentId: map['document_id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price']?.toDouble(),
      status: map['status'],
      eventId: map['event_id'],
      eventDocId: map['event_doc_id'],
      giftCreatorId: map['gift_creator_id'],
      pledgerId: map['pledger_id']
    );
  }
}
