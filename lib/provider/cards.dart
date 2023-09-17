import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_tracking/helper/db_helper.dart';

import '../model/card.dart';
import '../model/transaction.dart';

final initialCardsProvider = FutureProvider<List<FCard>>((ref) async {
  final cards = await DBHelper.getAllCardsWithTransactions();
  return cards;
});

class CardNotifier extends StateNotifier<List<FCard>> {
  CardNotifier(List<FCard> initialCardsProvider) : super(initialCardsProvider);

  void initializeWithFetchedData(List<FCard> fetchedData) {
    state = fetchedData;
  }

  void addNewCard(FCard newCard) async {
    await DBHelper.insertCard("card", "transactions", {
      "id": newCard.id,
      "nomCard": newCard.nomFCard,
      "cardNum": newCard.cardNum,
      "totalAmount": newCard.totalAmount,
      "initialAmount": newCard.initialAmount,
    });

    state = [...state, newCard];
  }

  void addNewTransaction(String cartID, Transaction newTransaction) async {
    await DBHelper.insertTransaction("ok", {
      "id": newTransaction.id,
      "cardID": cartID,
      "createdAt": newTransaction.createdAt.toIso8601String(),
      "amount": newTransaction.amount,
      "type": newTransaction.type
    });
    final FCard targetedCard = state.firstWhere((card) => card.id == cartID);
    targetedCard.transactions.add(newTransaction);
    targetedCard.totalAmount -= newTransaction.amount;
    deleteCard(cartID);
    addNewCard(targetedCard);
  }

  void deleteCard(String id) async {
    await DBHelper.deleteItem(id);
    state = state.where((card) => card.id != id).toList();
  }

  double getInitialAmount(String cardID) {
    FCard targetedCard = state.firstWhere((card) => card.id == cardID);
    return targetedCard.initialAmount;
  }

  double calculateAmountAll() {
    double allAmount = 0.0;
    for (var card in state) {
      allAmount += card.totalAmount;
    }
    return allAmount;
  }

  double spentAll() {
    double allSpent = 0.0;
    for (var card in state) {
      for (var transaction in card.transactions) {
        allSpent += transaction.amount;
      }
    }
    return allSpent;
  }

  void addIncome(double newIncome, String id) {
    FCard targetedCard = state.firstWhere((card) => card.id == id);
    targetedCard.totalAmount += newIncome;
    deleteCard(targetedCard.id);
    addNewCard(targetedCard);
  }

  List<Transaction> extractTransaction() {
    List<Transaction> allTransaction = [];
    state.forEach((card) {
      allTransaction += [...card.transactions];
    });
    return allTransaction;
  }

  List<Transaction> extractSpecificTransaction(String cardID, int month) {
    FCard specificCard = state.firstWhere((card) => card.id == cardID);
    List<Transaction> monthTransaction = specificCard.transactions
        .where((transaction) => transaction.createdAt.month == month)
        .toList();
    return monthTransaction;
  }

  double spendMedian(String cardID, int month) {
    double median = 0;
    double initialAmount = 0;
    List<Transaction> selectedSpecificTransaction =
        extractSpecificTransaction(cardID, month);
    initialAmount = getInitialAmount(cardID);
    selectedSpecificTransaction.forEach((transaction) {
      median += transaction.amount;
    });
    return (median * initialAmount) / 100;
  }

  double extractSomeTransactionByDay(
      int day, String cardID, int monthTranche, int month) {
    double total = 0.0;
    List<Transaction> cardTransaction =
        extractSpecificTransaction(cardID, month);

    if (monthTranche == 0) {
      cardTransaction.forEach((transaction) {
        if (transaction.createdAt.weekday == day &&
            transaction.createdAt.month == month &&
            transaction.createdAt.day > 0 &&
            transaction.createdAt.day < 8) {
          total += transaction.amount;
        }
      });
    } else if (monthTranche == 1) {
      cardTransaction.forEach((transaction) {
        if (transaction.createdAt.weekday == day &&
            transaction.createdAt.month == month &&
            transaction.createdAt.day > 7 &&
            transaction.createdAt.day < 15) {
          total += transaction.amount;
        }
      });
    } else if (monthTranche == 2) {
      cardTransaction.forEach((transaction) {
        if (transaction.createdAt.weekday == day &&
            transaction.createdAt.month == month &&
            transaction.createdAt.day > 14 &&
            transaction.createdAt.day < 22) {
          total += transaction.amount;
        }
      });
    } else {
      cardTransaction.forEach((transaction) {
        if (transaction.createdAt.weekday == day &&
            transaction.createdAt.month == month &&
            transaction.createdAt.day > 21 &&
            transaction.createdAt.day < 32) {
          total += transaction.amount;
        }
      });
    }
    return total;
  }
}

final cardProvider = StateNotifierProvider<CardNotifier, List<FCard>>(
  (ref) {
    final initialCardsAsyncValue = ref.watch(initialCardsProvider);

    return CardNotifier(initialCardsAsyncValue.when(
      data: (data) => data, // Use data if available or an empty list
      loading: () => [
        FCard(
            id: "",
            nomFCard: "nomFCard",
            cardNum: "cardNum",
            totalAmount: 0.0,
            initialAmount: 0.0,
            transactions: [])
      ], // Handle loading state by returning an empty list
      error: (error, stackTrace) {
        // Handle error state by logging the error and returning an empty list
        print('Error fetching initial cards: $error');
        return [];
      },
    ));
  },
);
