class Transaction {
  String id;
  DateTime createdAt;
  double amount;
  String type;

  Transaction(
      {required this.amount,
      required this.createdAt,
      required this.id,
      required this.type});
}
