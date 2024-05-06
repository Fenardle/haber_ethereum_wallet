import 'dart:convert';

import 'package:http/http.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class Network {
  final String name;
  final String symbol;
  final String url;
  final int chainId;
  final String logo;

  Network(
      {required this.name,
      required this.symbol,
      required this.url,
      required this.chainId,
      required this.logo});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol': symbol,
      'url': url,
      'chainId': chainId,
      'logo': logo
    };
  }

  static Network fromMap(Map<String, dynamic> map) {
    return Network(
        name: map['name'],
        symbol: map['symbol'],
        url: map['url'],
        chainId: map['chainId'],
        logo: map['logo']);
  }
}

class NetworkController extends GetxController {
  final networks = RxList<Network>();
  late Rx<Network> selectedNetwork;
  late Web3Client client;

  Future<void> init() async {
    loadNetworks();
    await loadSelectedNetwork();
    client = Web3Client(selectedNetwork.value.url, Client());
  }

  Future<void> loadNetworks() async {
    final db = await _openDb();
    final maps = await db.query('networks');
    networks.value = maps.map((map) => Network.fromMap(map)).toList();
  }

  Future<void> clearApplicationDocumentsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
  }

  Future<Database> _openDb() async {
    //await clearApplicationDocumentsDirectory();
    final appDocDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocDir.path, 'networks.sqlite');

    if (!await File(dbPath).exists()) {
      const assetDbPath = 'lib/assets/db/networks.sqlite';
      final bytes = await rootBundle.load(assetDbPath);
      await File(dbPath).writeAsBytes(bytes.buffer.asUint8List());
    }

    return openDatabase(dbPath);
  }

  Future<void> loadSelectedNetwork() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedNetworkString = prefs.getString('selectedNetwork') ??
        '{"name": "Goerli", "symbol": "ETH", "url": "https://eth-goerli.g.alchemy.com/v2/3eXLF9Q4LWYL_1hOCAt6yngV2mLqNrbg", "chainId": 5, "logo": "lib/assets/chain_logo/ethereum_testnet.svg"}';
    final network = Network.fromMap(json.decode(selectedNetworkString));
    selectedNetwork = network.obs;
  }

  Future<void> saveSelectedNetwork() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'selectedNetwork', json.encode(selectedNetwork.value.toMap()));
  }

  void addNetwork(
      String name, String symbol, String url, int chainId, String logo) async {
    final network = Network(
        name: name, symbol: symbol, url: url, chainId: chainId, logo: logo);
    final db = await _openDb();
    await db.insert('networks', network.toMap());
    networks.add(network);
  }

  Future<void> selectNetwork(Network network) async {
    client = Web3Client(network.url, Client());
    selectedNetwork.value = network;
    final networkId = await client.getNetworkId();
    if (networkId != network.chainId) {
      throw Exception('Invalid chain ID');
    }
    await saveSelectedNetwork();
  }
}
