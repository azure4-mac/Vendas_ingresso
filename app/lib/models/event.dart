class Event {
  int? id;
  String name;
  int ticketQuantidade;

  Event({this.id, required this.name, required this.ticketQuantidade});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'ticketQuantidade': ticketQuantidade};
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      ticketQuantidade: map['ticketQuantidade'],
    );
  }
}
