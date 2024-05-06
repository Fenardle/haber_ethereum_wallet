import 'package:get/get.dart';

class Account {
  String name;
  String publicKey;
  String balance;

  Account({required this.name, required this.publicKey, required this.balance});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      name: json['name'],
      publicKey: json['publicKey'],
      balance: json['balance'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'publicKey': publicKey,
        'balance': balance,
      };
}
