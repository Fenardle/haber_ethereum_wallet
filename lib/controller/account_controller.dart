// Dart imports
import 'dart:convert';
import 'dart:math';
import 'dart:async';

// Package imports
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web3dart/web3dart.dart';

// Local imports
import '../services/key_pairs_service.dart';
import '../services/token_info_service.dart';
import '../classes/token.dart';
import '../classes/account.dart';
import 'current_token_controller.dart';
import 'network_controller.dart';

class AccountController extends GetxController {
  late NetworkController networkController;
  late TokenInfoService tokenInfoService;

  final RxString _currentAccount = ''.obs;
  final RxString _currentAccountName = ''.obs;
  final RxString _nativeTokenBalance = '0'.obs;
  final RxString _currentAccountDAO = ''.obs;
  final _tokens = <FungibleToken>[].obs;
  final Rx<FungibleToken> _currentAccountDAOToken = FungibleToken(
          contractAddress: '',
          tokenBalance: 0,
          tokenDecimals: 0,
          tokenName: '',
          tokenSymbol: '',
          tokenLogoURL: '')
      .obs;
  Database? _database;

  RxList<Account> accountList = <Account>[].obs;
  RxList<String> publicKeys = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    networkController = Get.find<NetworkController>();
    ever(networkController.selectedNetwork, (_) {
      for (Account account in accountList) {
        account.balance = '0';
      }
      _tokens.clear(); // clear the tokens list
      _nativeTokenBalance.value = '0';
      tokenInfoService = TokenInfoServiceImpl(
          uri: networkController.selectedNetwork.value.url);
      _loadAccountList();
      _loadCurrentAccount(); // fetch tokens for the newly selected network
    });

    tokenInfoService =
        TokenInfoServiceImpl(uri: networkController.selectedNetwork.value.url);

    _loadAccountList();
    _loadCurrentAccount();
  }

  Future<void> _loadAccountList() async {
    final keys = await keyPairsService.getPublicKeys();
    publicKeys.assignAll(keys);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Account> accounts = [];

    // Use Future.wait to fetch native token balance concurrently
    await Future.wait(publicKeys.map((String publicKey) async {
      String accountName = prefs.getString(publicKey) ?? '';

      // Fetch the native token balance concurrently
      String balance = await getNativeTokenBalance(publicKey);
      print(balance);

      accounts.add(Account(
        name: accountName,
        publicKey: publicKey,
        balance: balance,
      ));
    }));

    // Sort accounts list based on the order of publicKeys
    accounts.sort((a, b) =>
        publicKeys.indexOf(a.publicKey) - publicKeys.indexOf(b.publicKey));

    accountList.assignAll(accounts);
  }

  Future<void> _loadCurrentAccount() async {
    final account = await keyPairsService.getCurrentAccount();
    if (account != null) {
      currentAccount = account;
      _loadAccountName();
      _loadAccountDAO();
      initDatabase(); // Initialize the SQLite database
    }
  }

  Future<void> _loadAccountName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountName = prefs.getString(_currentAccount.value);
    if (accountName != null) {
      _currentAccountName.value = accountName;
    } else {
      currentAccountName = 'Account ${publicKeys.length + 1}';
    }
  }

  Future<void> _loadAccountDAO() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountDAO = prefs.getString(_currentAccount.value + '_DAO_token');
    if (accountDAO != null) {
      _currentAccountDAO.value = accountDAO;
      String DAOTokenBalance = await tokenInfoService.getERC20TokenBalance(
          accountDAO, currentAccount);
      final tokenMetadata = await tokenInfoService.getTokenMetadata(accountDAO);
      int decimals = tokenMetadata['decimals'];
      String logo = tokenMetadata['logo'] ?? '';
      String name = tokenMetadata['name'];
      String symbol = tokenMetadata['symbol'];

      final tokenBalance = double.parse(
          (BigInt.parse(DAOTokenBalance).toDouble() / pow(10, decimals))
              .toStringAsFixed(2));
      _currentAccountDAOToken.value = FungibleToken(
          contractAddress: accountDAO,
          tokenBalance: tokenBalance,
          tokenDecimals: decimals,
          tokenName: name,
          tokenSymbol: symbol,
          tokenLogoURL: logo);
    } else {
      _currentAccountDAO.value = '';
    }
  }

  Future<void> setCurrentAccount(String publicKey) async {
    await keyPairsService.setCurrentAccount(publicKey);
    _loadCurrentAccount();
  }

  String get currentAccount => _currentAccount.value;

  set currentAccount(String value) {
    // Update the accountController.currentAccount variable and trigger a refresh of the token list data
    _tokens.clear();
    _currentAccount.value = value;
  }

  String get currentAccountName => _currentAccountName.value;

  set currentAccountName(String value) {
    _currentAccountName.value = value;
    _saveAccountName();
  }

  Future<void> _saveAccountName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_currentAccount.value, _currentAccountName.value);
  }

  String get currentAccountDAO => _currentAccountDAO.value;

  set currentAccountDAO(String value) {
    _currentAccountDAO.value = value;
    _saveAccountDAO();
  }

  Future<void> _saveAccountDAO() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        _currentAccount.value + '_DAO_token', _currentAccountDAO.value);
  }

  String get nativeTokenBalance => _nativeTokenBalance.value;

  set nativeTokenBalance(String value) {
    _nativeTokenBalance.value = value;
  }

  Future<void> createAccount(String password) async {
    _tokens.clear(); // clear the tokens list
    _nativeTokenBalance.value = '0';
    await keyPairsService.createAccount(password);
    await _loadCurrentAccount();
    await _loadAccountList();
  }

  Future<void> importAccount(String privateKey, String password) async {
    await keyPairsService.importAccount(privateKey, password);
    await _loadAccountList();
    await _loadCurrentAccount();
  }

  Future<String?> getPrivateKey(String password) async {
    if (currentAccount.isEmpty) return null;
    return await keyPairsService.getPrivateKey(currentAccount, password);
  }

  Future<void> fetchTokens() async {
    fetchERC20Tokens();
    await fetchNativeToken();
  }

  double roundDown(double number) {
      int hundredths = (number * 10000).floor();
      return hundredths / 10000;
  }


  Future<void> fetchNativeToken() async {

    String account = currentAccount;
    String network = networkController.selectedNetwork.value.name;
    // Fetch native token
    EtherAmount etherBalance = await networkController.client
        .getBalance(EthereumAddress.fromHex(account));
    if (account != currentAccount ||
        network != networkController.selectedNetwork.value.name) return;
    nativeTokenBalance =
        roundDown(etherBalance.getInWei.toDouble() / pow(10, 18)).toString();
  }

  Future<void> fetchERC20Tokens() async {
    String account = currentAccount;
    String network = networkController.selectedNetwork.value.name;
    final tokenBalances = await tokenInfoService.getTokenBalances(account);
    tokenBalances.removeWhere(
        (tokenData) => BigInt.parse(tokenData['tokenBalance']).toDouble() == 0);

    // Use Future.wait to process all tokens concurrently
    await Future.wait(tokenBalances.map((tokenData) async {
      final contractAddress = tokenData['contractAddress'];
      final existingTokenIndex = _tokens
          .indexWhere((token) => token.contractAddress == contractAddress);

      if (existingTokenIndex != -1) {
        final tokenBalance = double.parse(
            (BigInt.parse(tokenData['tokenBalance']).toDouble() /
                    pow(10, _tokens[existingTokenIndex].tokenDecimals))
                .toStringAsFixed(2));
        if (account != currentAccount ||
            network != networkController.selectedNetwork.value.name) return;
        _tokens[existingTokenIndex].tokenBalance = tokenBalance;
        upsertTokenInDatabase(_tokens[existingTokenIndex]);
      } else {
        final tokenMetadata =
            await tokenInfoService.getTokenMetadata(contractAddress);
        int decimals = tokenMetadata['decimals'];
        String logo = tokenMetadata['logo'] ?? '';
        String name = tokenMetadata['name'];
        String symbol = tokenMetadata['symbol'];

        final tokenBalance = double.parse(
            (BigInt.parse(tokenData['tokenBalance']).toDouble() /
                    pow(10, decimals))
                .toStringAsFixed(2));
        final token = FungibleToken(
            contractAddress: contractAddress,
            tokenBalance: tokenBalance,
            tokenDecimals: decimals,
            tokenName: name,
            tokenSymbol: symbol,
            tokenLogoURL: logo);
        if (account != currentAccount ||
            network != networkController.selectedNetwork.value.name) return;
        _tokens.add(token);
        upsertTokenInDatabase(token);
      }
    }));
  }

  Future<void> fetchToken(String contractAddress) async {
    String erc20Balance = await tokenInfoService.getERC20TokenBalance(
        contractAddress, currentAccount);
    // Check if the token already exists in the tokens list
    final existingTokenIndex =
        _tokens.indexWhere((token) => token.contractAddress == contractAddress);

    if (existingTokenIndex != -1) {
      // If the token already exists, update its properties
      _tokens[existingTokenIndex].tokenBalance = double.parse(
          (BigInt.parse(erc20Balance).toDouble() /
                  pow(10, _tokens[existingTokenIndex].tokenDecimals))
              .toStringAsFixed(2));
      Get.find<CurrentTokenController>().currentToken =
          _tokens[existingTokenIndex];
      upsertTokenInDatabase(_tokens[existingTokenIndex]);
    } else {
      // If the token does not exist, add it to the tokens list
      final tokenMetadata =
          await tokenInfoService.getTokenMetadata(contractAddress);
      int decimals = tokenMetadata['decimals'];
      String logo = tokenMetadata['logo'] ?? '';
      String name = tokenMetadata['name'];
      String symbol = tokenMetadata['symbol'];

      final tokenBalance = double.parse(
          (BigInt.parse(erc20Balance).toDouble() / pow(10, decimals))
              .toStringAsFixed(2));
      final token = FungibleToken(
          contractAddress: contractAddress,
          tokenBalance: tokenBalance,
          tokenDecimals: decimals,
          tokenName: name,
          tokenSymbol: symbol,
          tokenLogoURL: logo);
      Get.find<CurrentTokenController>().currentToken = token;
      upsertTokenInDatabase(token);
    }
  }

  List<FungibleToken> get tokens => _tokens;

  Future<String> get _databasePath async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path,
        '${networkController.selectedNetwork.value.name}.sqlite');
  }

  Future<void> _openDatabase() async {
    _database = await openDatabase(
      await _databasePath,
      version: 1,
      onCreate: (Database db, int version) async {},
    );
    await _createTable();
  }

  Future<void> _createTable() async {
    await _database!.execute('''
      CREATE TABLE IF NOT EXISTS _${_currentAccount.value} (
        contractAddress TEXT PRIMARY KEY,
        tokenBalance REAL,
        tokenDecimals INTEGER,
        tokenName TEXT,
        tokenSymbol TEXT,
        tokenLogoURL TEXT
      )
    ''');
  }

  Future<void> initDatabase() async {
    await _openDatabase();
    await loadTokensFromDatabase();
    fetchTokens();
  }

  Future<void> upsertTokenInDatabase(FungibleToken token) async {
    if (_database == null) return;
    await _database!.insert(
      '_' + _currentAccount.value,
      token.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> loadTokensFromDatabase() async {
    if (_database == null) return;
    final List<Map<String, dynamic>> tokenRows =
        await _database!.query('_' + _currentAccount.value);
    _tokens.assignAll(
        tokenRows.map((row) => FungibleToken.fromJson(row)).toList());
  }

  Future<String> getNativeTokenBalance(String publicKey) async {
    try {
      EtherAmount etherBalance = await networkController.client
          .getBalance(EthereumAddress.fromHex(publicKey));
      return roundDown(etherBalance.getInWei.toDouble() / pow(10, 18)).toString();
    } catch (e) {
      print('Error getting native token balance: $e');
      return '0';
    }
  }
}
