class Pemasukan {
  int? id;
  String? source;
  int? amount;
  int? frequency;

  Pemasukan({this.id, this.source, this.amount, this.frequency});

  factory Pemasukan.fromJson(Map<String, dynamic> obj) {
    return Pemasukan(
      id: obj['id'],
      source: obj['source'],
      amount: obj['amount'],
      frequency: obj['frequency']
    );
  }
}