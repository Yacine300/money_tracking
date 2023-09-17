import 'package:money_tracking/model/card.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import '../model/transaction.dart';

class DBHelper {
  static Future<void> insertCard(
    String tableCard,
    String tableTransaction,
    Map<String, Object> cardData,
  ) async {
    final dbPath = await sql.getDatabasesPath();
    final sqlDB = await sql.openDatabase(
      path.join(dbPath, 'okk9.db'),
      onCreate: (db, version) async {
        await db.execute(
            '''
        CREATE TABLE card (
          id TEXT PRIMARY KEY,
          nomCard TEXT,
          cardNum TEXT,
          totalAmount DOUBLE,
          initialAmount DOUBLE
        )
      ''');
        await db.execute(
            '''
        CREATE TABLE transactions (
          id TEXT PRIMARY KEY,
          cardID TEXT,
          createdAt TEXT,
          amount DOUBLE,
          type TEXT
        )
      ''');
      },
      version: 1,
    );

    await sqlDB.transaction((txn) async {
      await txn.insert('card', cardData,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    });
  }

  static Future<List<FCard>> getAllCardsWithTransactions() async {
    final dbPath = await sql.getDatabasesPath();
    final sqlDB = await sql.openDatabase(
      path.join(dbPath, 'okk9.db'),
      version: 1,
      onCreate: (db, version) async {
        // Create the 'card' and 'transactions' tables if they don't exist
        await db.execute(
            '''
        CREATE TABLE card (
          id TEXT PRIMARY KEY,
          nomCard TEXT,
          cardNum TEXT,
          totalAmount DOUBLE,
          initialAmount DOUBLE
        )
      ''');
        await db.execute(
            '''
        CREATE TABLE transactions (
          id TEXT PRIMARY KEY,
          cardID TEXT,
          createdAt TEXT,
          amount DOUBLE,
          type TEXT
        )
      ''');
      },
    );

    final List<Map<String, dynamic>> cardData = await sqlDB.query('card');
    final List<FCard> cards = [];

    for (final cardRow in cardData) {
      final List<Map<String, dynamic>> transactionData = await sqlDB.query(
        'transactions',
        where: 'cardID = ?',
        whereArgs: [cardRow['id']],
      );

      final List<Transaction> transactions =
          transactionData.map((transactionRow) {
        return Transaction(
          id: transactionRow['id'],
          createdAt: DateTime.parse(
            transactionRow['createdAt'],
          ),
          amount: transactionRow['amount'],
          type: transactionRow['type'],
        );
      }).toList();

      final FCard card = FCard(
        id: cardRow['id'],
        nomFCard: cardRow['nomCard'],
        cardNum: cardRow['cardNum'],
        totalAmount: cardRow['totalAmount'],
        initialAmount: cardRow['initialAmount'],
        transactions: transactions,
      );

      cards.add(card);
    }

    return cards;
  }

  static Future<void> insertTransaction(
      String table, Map<String, Object> data) async {
    final dbPath = await sql.getDatabasesPath();
    final sqlDB = await sql.openDatabase(
      path.join(dbPath, 'okk9.db'),
      version: 1,
      onCreate: (db, version) async {
        // Create the 'transactions' table if it doesn't exist
        await db.execute(
            '''
        CREATE TABLE card (
          id TEXT PRIMARY KEY,
          cardID TEXT,
          createdAt TEXT,
          amount DOUBLE,
          type TEXT
        )
      ''');
      },
    );

    // Check if the 'transactions' table exists; if not, it will be created
    final tables = await sqlDB.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='transactions'");
    final tableExists =
        tables.isNotEmpty && tables.first['name'] == 'transactions';

    if (!tableExists) {
      // If the table doesn't exist, it was just created in the `onCreate` callback
      print('The "transactions" table was created.');
    }

    await sqlDB.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO transactions (id, cardID, createdAt, amount, type) VALUES (?, ?, ?, ?, ?)',
        [
          data['id'],
          data['cardID'],
          data['createdAt'],
          data['amount'],
          data['type'],
        ],
      );
    });
  }

  static Future<List<Map<String, Object?>>> fetchDataCard(String table) async {
    final dbPath = await sql.getDatabasesPath();
    final sqlDB = await sql.openDatabase(path.join(dbPath, 'money.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE produit (id TEXT PRIMARY KEY ,  mark TEXT , classification TEXT , subtitle TEXT,  descreption TEXT,  price DOUBLE,  image TEXT , isLicked INT )');
    }, version: 1);
    return sqlDB.query(table);
  }

  static Future<void> updateItem(
      {id,
      title,
      descrption,
      mark,
      image,
      price,
      isLicked,
      classification}) async {
    final dbPath = await sql.getDatabasesPath();
    final sqlDB = await sql.openDatabase(path.join(dbPath, 'money.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE produit (id TEXT PRIMARY KEY ,  mark TEXT , classification TEXT ,  subtitle TEXT,  descreption TEXT,  price DOUBLE,  image TEXT , isLicked INT )');
    }, version: 1);

    final data = {
      'subtitle': title,
      'descreption': descrption,
      'price': price,
      'image': image,
      'isLicked': isLicked,
      'mark': mark,
      'classification': classification
    };

    await sqlDB.update('produit', data,
        where: "id = ?",
        whereArgs: [id],
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> deleteItem(String id) async {
    final dbPath = await sql.getDatabasesPath();
    final sqlDB = await sql.openDatabase(path.join(dbPath, 'okk9.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE card (id TEXT PRIMARY KEY ,  nomCard TEXT , cardNum TEXT , totalAmount DOUBLE,  initialAmount DOUBLE)');
    }, version: 1);

    await sqlDB.delete("card", where: "id = ?", whereArgs: [id]);
  }
}
