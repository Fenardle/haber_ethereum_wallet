import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/transaction_info.dart';

class TransactionController extends GetxController {
  static const String tableName = 'transactions';
  final _transactions = <TransactionInfo>[].obs;
  late Database _db;

  List<TransactionInfo> get transactions => _transactions;

  @override
  Future<void> onInit() async {
    super.onInit();
    _db = await _initDatabase();
    _transactions.addAll(await _getStoredTransactions());
  }

  Future<Database> _initDatabase() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    final databasePath = appDocumentDirectory.path + '/transactions.db';

    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            value TEXT,
            recipient TEXT,
            hash TEXT,
            type INTEGER,
            status INTEGER,
            receipt TEXT,
            network TEXT
          )
        ''');
      },
    );
  }

  Future<List<TransactionInfo>> _getStoredTransactions() async {
    final List<Map<String, dynamic>> transactionMaps =
        await _db.query(tableName);
    return transactionMaps.map((map) => TransactionInfo.fromMap(map)).toList();
  }

  Future<void> updateTransaction(TransactionInfo transaction) async {
    final id = await _db.insert(tableName, transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    int index = _transactions.indexWhere((txn) => txn.id == id);

    if (index != -1) {
      // Update the existing element if the id is found in the list
      _transactions[index] = transaction.copyWith(id: id);
    } else {
      // Add the transaction if the id is not found in the list
      _transactions.add(transaction.copyWith(id: id));
    }
  }

  @override
  void onClose() {
    _db.close();
    super.onClose();
  }
}
