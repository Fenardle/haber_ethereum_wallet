import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class TokenInfoService {
  Future<String> getERC20TokenBalance(
      String contractAddress, String userAddress);
  Future<List> getTokenBalances(String address);
  Future<Map<String, dynamic>> getTokenMetadata(String contractAddress);
}

class TokenInfoServiceImpl implements TokenInfoService {
  late final Uri _uri;

  TokenInfoServiceImpl({required String uri}) : _uri = Uri.parse(uri);

  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json'
  };

  @override
  Future<String> getERC20TokenBalance(
      String contractAddress, String userAddress) async {
    const balanceOfMethod = '0x70a08231'; // balanceOf function signature
    final paddedUserAddress =
        userAddress.replaceFirst('0x', '').padLeft(64, '0');
    final payload = {
      'id': 1,
      'jsonrpc': '2.0',
      'method': 'eth_call',
      'params': [
        {
          'to': contractAddress,
          'data': '$balanceOfMethod$paddedUserAddress',
        },
        'latest',
      ]
    };
    final response =
        await http.post(_uri, headers: headers, body: jsonEncode(payload));
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final balanceHex = decodedResponse['result'];
      return balanceHex;
    } else {
      throw Exception('Failed to get token balance');
    }
  }

  @override
  Future<List> getTokenBalances(String address) async {
    final payload = {
      'id': 1,
      'jsonrpc': '2.0',
      'method': 'alchemy_getTokenBalances',
      'params': [address]
    };
    final response =
        await http.post(_uri, headers: headers, body: jsonEncode(payload));
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      return decodedResponse['result']['tokenBalances'];
    } else {
      throw Exception('Failed to load token balances');
    }
  }

  @override
  Future<Map<String, dynamic>> getTokenMetadata(String contractAddress) async {
    final payload = {
      'id': 1,
      'jsonrpc': '2.0',
      'method': 'alchemy_getTokenMetadata',
      'params': [contractAddress]
    };
    final response =
        await http.post(_uri, headers: headers, body: jsonEncode(payload));
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      return decodedResponse['result'];
    } else {
      throw Exception('Failed to load metadata');
    }
  }
}
