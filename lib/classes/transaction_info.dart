import 'package:web3dart/web3dart.dart';

enum TransactionType {
  send,
  issue,
  propose,
  vote,
  initiateMint,
  mint,
  delegate,
  contractInteraction
}

enum TransactionStatus { sending, pending, mined, failed }

class TransactionInfo {
  final int? id;
  final String value;
  final EthereumAddress recipient;
  final String? hash;
  final TransactionType type;
  final TransactionStatus status;
  final String? receipt;
  final String network;

  TransactionInfo({
    this.id,
    required this.value,
    required this.recipient,
    this.hash,
    required this.type,
    required this.status,
    this.receipt,
    required this.network,
  });

  TransactionInfo.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        value = map['value'],
        recipient = EthereumAddress.fromHex(map['recipient']),
        hash = map['hash'],
        type = TransactionType.values[map['type']],
        status = TransactionStatus.values[map['status']],
        receipt = map['receipt'],
        network = map['network'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
      'recipient': recipient.hex,
      'hash': hash,
      'type': type.index,
      'status': status.index,
      'receipt': receipt,
      'network': network,
    };
  }

  TransactionInfo copyWith({
    int? id,
    String? value,
    EthereumAddress? recipient,
    String? hash,
    TransactionType? type,
    TransactionStatus? status,
    String? receipt,
    String? network,
  }) {
    return TransactionInfo(
      id: id ?? this.id,
      value: value ?? this.value,
      recipient: recipient ?? this.recipient,
      hash: hash ?? this.hash,
      type: type ?? this.type,
      status: status ?? this.status,
      receipt: receipt ?? this.receipt,
      network: network ?? this.network,
    );
  }
}
