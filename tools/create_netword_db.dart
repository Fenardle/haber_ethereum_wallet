import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Initialize FFI for sqflite.
  sqfliteFfiInit();

  // Get the documents directory.
  final documentsDirectory = await getApplicationDocumentsDirectory();

  // Set the database path.
  final dbPath = join(documentsDirectory.path, 'networks.db');

  // Delete the existing database file if it exists.
  final file = File(dbPath);
  if (await file.exists()) {
    await file.delete();
  }

  // Open the database.
  final database =
      await openDatabase(dbPath, version: 1, onCreate: (db, version) {
    return db.execute(
      'CREATE TABLE networks(id INTEGER PRIMARY KEY, name TEXT, url TEXT, chainId INTEGER)',
    );
  });

  // Insert Ethereum and Goerli networks.
  await database.insert('networks', {
    'name': 'Ethereum',
    'url':
        'https://eth-goerli.g.alchemy.com/v2/0buUeIRgxRtsTFI99izdAK2FOCMak7vG',
    'chainId': 1,
  });
  await database.insert('networks', {
    'name': 'Goerli',
    'url':
        'https://eth-goerli.g.alchemy.com/v2/3eXLF9Q4LWYL_1hOCAt6yngV2mLqNrbg',
    'chainId': 5,
  });

  // Close the database.
  await database.close();

  print('Database created and pre-populated at: $dbPath');
}
