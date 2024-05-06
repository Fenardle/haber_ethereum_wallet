import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber/controller/current_token_controller.dart';
import 'package:web3dart/web3dart.dart';
import '../../../generated/ERC20Implementation.g.dart';
import '../../../controller/transaction_controller.dart';
import '../../../classes/transaction_info.dart';
import '../../../controller/account_controller.dart';
import '../../../controller/network_controller.dart';
import '../../../services/key_pairs_service.dart';

class TransactionList extends StatelessWidget {
  final transactionController = Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          for (TransactionInfo transaction
              in transactionController.transactions.reversed)
            GestureDetector(
              onTap: () {
                Get.to(TransactionDetailsPage(transaction: transaction));
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: getTxnColor(transaction.status),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    getTxnIcon(transaction.type),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.type.toString().split('.').last,
                          style: TextStyle(fontSize: 20),
                        ),
                        getTxnTo(transaction),
                        Text(transaction.status.toString().split('.').last,
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    Spacer(),
                    Expanded(child: getTxnValue(transaction)),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}

String truncateText(String text) {
  if (text.length <= 14) {
    return text;
  }
  return text.substring(0, 10) + '...' + text.substring(text.length - 4);
}

CupertinoDynamicColor getTxnColor(TransactionStatus status) {
  if (status == TransactionStatus.sending) return CupertinoColors.systemGrey5;
  if (status == TransactionStatus.failed) return CupertinoColors.systemGrey;
  if (status == TransactionStatus.pending) return CupertinoColors.systemOrange;
  if (status == TransactionStatus.mined) return CupertinoColors.systemGreen;
  return CupertinoColors.inactiveGray;
}

Icon getTxnIcon(TransactionType type) {
  double size = 30;
  Color color = Colors.black;
  if (type == TransactionType.send)
    return Icon(
      CupertinoIcons.arrow_up_right_circle,
      size: size,
      color: color,
    );
  if (type == TransactionType.issue)
    return Icon(
      CupertinoIcons.add_circled,
      size: size,
      color: color,
    );
  if (type == TransactionType.vote)
    return Icon(
      CupertinoIcons.check_mark_circled,
      size: size,
      color: color,
    );
  if (type == TransactionType.propose)
    return Icon(
      CupertinoIcons.arrow_up_circle,
      size: size,
      color: color,
    );
  if (type == TransactionType.delegate)
    return Icon(
      CupertinoIcons.person_alt_circle,
      size: size,
      color: color,
    );
  if (type == TransactionType.contractInteraction)
    return Icon(
      CupertinoIcons.arrow_swap,
      size: size,
      color: color,
    );
  if (type == TransactionType.initiateMint)
    return Icon(
      CupertinoIcons.arrow_right_circle,
      size: size,
      color: color,
    );
  if (type == TransactionType.mint)
    return Icon(
      CupertinoIcons.add_circled,
      size: size,
      color: color,
    );
  return Icon(CupertinoIcons.arrow_up_right);
}

Text getTxnTo(TransactionInfo txn) {
  double size = 12;
  if (txn.type == TransactionType.send)
    return Text(
      'To: ${truncateText(txn.recipient.toString())}',
      style: TextStyle(fontSize: size),
    );
  if (txn.type == TransactionType.propose)
    return Text(
      'To: ${truncateText(txn.recipient.toString())}',
      style: TextStyle(fontSize: size),
    );
  if (txn.type == TransactionType.delegate)
    return Text(
      'To: ${truncateText(txn.recipient.toString())}',
      style: TextStyle(fontSize: size),
    );
  if (txn.type == TransactionType.vote)
    return Text(
      'For: ${truncateText(txn.recipient.toString())}',
      style: TextStyle(fontSize: size),
    );
  if (txn.type == TransactionType.contractInteraction)
    return Text(
      'With ${truncateText(txn.recipient.toString())}',
      style: TextStyle(fontSize: size),
    );
  return Text(
    'To: ${truncateText(txn.recipient.toString())}',
    style: TextStyle(fontSize: size),
  );
}

Text getTxnValue(TransactionInfo txn) {
  double size = 18;
  if (txn.type == TransactionType.send)
    return Text(
      '-${txn.value}',
      style: TextStyle(fontSize: size),
    );
  if (txn.type == TransactionType.issue)
    return Text(
      '+${txn.value}',
      style: TextStyle(fontSize: size),
    );
  if (txn.type == TransactionType.propose)
    return Text(
      '${txn.value}',
      style: TextStyle(fontSize: size),
    );
  if (txn.type == TransactionType.vote)
    return Text(
      '${txn.value} Votes',
      style: TextStyle(fontSize: size),
    );
  if (txn.type == TransactionType.delegate)
    return Text(
      '${txn.value} Votes',
      style: TextStyle(fontSize: size),
    );
  if (txn.type == TransactionType.contractInteraction)
    return Text(
      '',
      style: TextStyle(fontSize: size),
    );
  return Text(
    '${txn.value}',
    style: TextStyle(fontSize: size),
  );
}

class TransactionDetailsPage extends StatefulWidget {
  final TransactionInfo transaction;

  TransactionDetailsPage({required this.transaction});

  @override
  _TransactionDetailsPageState createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  bool _showReceipt = false;

  String formatReceipt(String receipt) {
    return receipt.replaceAllMapped(
        RegExp(r'(?<=[a-z0-9]{2})(?=(?:[a-z0-9]{2}){1,}(?![a-z0-9]))'),
        (match) => ' ');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text('Transaction Details'),
            border: null,
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Transaction ID: ${widget.transaction.id}'),
                        Text('Value: ${widget.transaction.value}'),
                        Text('Recipient: ${widget.transaction.recipient}'),
                        Text('Hash: ${widget.transaction.hash}'),
                        Text('Type: ${widget.transaction.type}'),
                        Text('Status: ${widget.transaction.status}'),
                        Text('Network: ${widget.transaction.network}'),
                        SizedBox(
                          height: 20,
                        ),
                        CupertinoButton(
                          color: CupertinoColors.black,
                          onPressed: () {
                            print(widget.transaction.receipt);
                            setState(() {
                              _showReceipt = !_showReceipt;
                              print(_showReceipt);
                            });
                          },
                          child: Text('${_showReceipt ? '' : 'Show'} Receipt'),
                        ),
                        if (_showReceipt &&
                            (widget.transaction.receipt != null))
                          for (MapEntry<String, dynamic> entry
                              in receiptToMap(widget.transaction.receipt ?? '')
                                  .entries)
                            Text('${entry.key}: ${entry.value}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, dynamic> receiptToMap(String receipt) {
  receipt = receipt.replaceAll('EtherAmount: ', '');
  // Create a RegExp pattern to match the key-value pairs
  RegExp pattern = RegExp(
      r'(\w+): (0x[a-fA-F0-9]{1,}|[a-zA-Z]+\(.*?\)|\[[^\]]*\]|null|true|false|[+-]?\d+(\.\d+)?(?:[eE][+-]?\d+)?|\b\w+\b)',
      multiLine: true);

  // Create a Map with the extracted key-value pairs
  Map<String, dynamic> data = {};
  pattern.allMatches(receipt).forEach((match) {
    String key = match.group(1)!;
    String value = match.group(2)!;

    // Check if the value is a number
    final numberMatch = RegExp(r'^[+-]?\d+(\.\d+)?(?:[eE][+-]?\d+)?$').firstMatch(value);

    if (value.startsWith('0x') || (numberMatch != null && numberMatch.group(0) == value)) {
      // Keep the hex value as a string, or parse the number
      data[key] = numberMatch != null ? num.tryParse(value) : value;
    } else {
      data[key] = value;
    }
  });

  print(data);
  return data;
}


