class Sale {
  int? id;
  String compradorNome;
  String compradorNasc;
  int quantidadeVendida;
  int eventId;

  Sale({
    this.id,
    required this.compradorNome,
    required this.compradorNasc,
    required this.quantidadeVendida,
    required this.eventId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'compradorNome': compradorNome,
      'compradorNasc': compradorNasc,
      'quantidadeVendida': quantidadeVendida,
      'eventId': eventId,
    };
  }
}
