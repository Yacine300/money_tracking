import 'package:money_tracking/model/transaction.dart';

class FCard {
  String id;
  String nomFCard;
  String cardNum;
  double totalAmount;
  double initialAmount;
  List<Transaction> transactions;

  FCard(
      {required this.id,
      required this.nomFCard,
      required this.cardNum,
      required this.totalAmount,
      required this.initialAmount,
      required this.transactions});
}
