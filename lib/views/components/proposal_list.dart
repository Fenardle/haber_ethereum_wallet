import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber/views/components/password_dialog.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:web3dart/web3dart.dart';
import '../../../generated/ERC20Implementation.g.dart';
import '../../classes/transaction_info.dart';
import '../../controller/current_token_controller.dart';
import '../../controller/network_controller.dart';
import '../../controller/account_controller.dart';
import '../../controller/transaction_controller.dart';
import '../screens/portfolio.dart';

class MintProposal {
  final int id;
  final String receiveAddress;
  final BigInt amount;
  final BigInt blockNumber;
  BigInt totalVotes;
  BigInt votes;
  BigInt proposalVotes;
  bool hasVoted;
  BigInt releaseTime;

  MintProposal({
    required this.id,
    required this.receiveAddress,
    required this.amount,
    required this.blockNumber,
    BigInt? votes,
    BigInt? totalVotes,
    BigInt? proposalVotes,
    required this.hasVoted,
    required this.releaseTime,
  })  : this.votes = votes ?? BigInt.zero,
        this.totalVotes = totalVotes ?? BigInt.zero,
        this.proposalVotes = proposalVotes ?? BigInt.zero;

  factory MintProposal.fromList(int id, List<dynamic> list) {
    return MintProposal(
      id: id,
      receiveAddress: list[0]?.toString() as String,
      amount: list[1] as BigInt? ?? BigInt.zero,
      blockNumber: list[2] as BigInt? ?? BigInt.zero,
      hasVoted: false,
      releaseTime: BigInt.zero,
    );
  }
}

class ProposalsList extends StatefulWidget {
  @override
  _ProposalsListState createState() => _ProposalsListState();
}

class _ProposalsListState extends State<ProposalsList> {
  List<MintProposal> proposals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProposals();
  }

  Future<void> loadProposals() async {
    final currentTokenController = Get.find<CurrentTokenController>();
    final accountController = Get.find<AccountController>();
    final networkController = Get.find<NetworkController>();
    final erc20Implementation = ERC20Implementation(
      address: EthereumAddress.fromHex(
          currentTokenController.currentToken.contractAddress),
      client: networkController.client,
    );
    try {
      List<dynamic> proposalsList = await erc20Implementation.getAllProposals();
      final address = EthereumAddress.fromHex(accountController.currentAccount);
      List<Future<MintProposal>> futureProposals =
          proposalsList.asMap().entries.map((entry) async {
        int index = entry.key;
        List<dynamic> proposal = entry.value;
        MintProposal mintProposal = MintProposal.fromList(index, proposal);
        BigInt votes = await erc20Implementation.getPastVotes(
            address, mintProposal.blockNumber);
        BigInt totalSupply = await erc20Implementation
            .getPastTotalSupply(mintProposal.blockNumber);
        double totalVotes =
            totalSupply != BigInt.zero ? (votes / totalSupply) * 100 : 0;
        BigInt proposalVotes = await erc20Implementation
            .getProposalVotesNumber(BigInt.from(index));
        bool hasVoted =
            await erc20Implementation.hasVoted(address, BigInt.from(index));
        BigInt releaseTime =
            await erc20Implementation.getMintReleaseTime(BigInt.from(index));
        mintProposal.votes = votes;
        mintProposal.totalVotes = totalSupply;
        mintProposal.proposalVotes = proposalVotes;
        mintProposal.hasVoted = hasVoted;
        mintProposal.releaseTime = releaseTime;
        print(releaseTime);
        return mintProposal;
      }).toList();

      proposals = await Future.wait(futureProposals);

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Error',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> opMintProposal(
    Web3Client client,
    Credentials credentials,
    int mintProposalId,
    TransactionType transactionType,
  ) async {
    try {
      final currentTokenController = Get.find<CurrentTokenController>();
      final erc20Implementation = ERC20Implementation(
        address: EthereumAddress.fromHex(
            currentTokenController.currentToken.contractAddress),
        client: client,
      );

      String hash;
      switch (transactionType) {
        case TransactionType.send:
          hash = await erc20Implementation.voteMintProposal(
            BigInt.from(mintProposalId),
            credentials: credentials,
          );
          break;
        case TransactionType.initiateMint:
          hash = await erc20Implementation.initiateMint(
            BigInt.from(mintProposalId),
            credentials: credentials,
          );
          break;
        case TransactionType.mint:
          hash = await erc20Implementation.mint(
            BigInt.from(mintProposalId),
            credentials: credentials,
          );
          break;
        case TransactionType.vote:
          hash = await erc20Implementation.voteMintProposal(
            BigInt.from(mintProposalId),
            credentials: credentials,
          );
          break;
        default:
          throw Exception('Unsupported transaction type');
      }

      print('Transaction hash: $hash');

      final transactionController = Get.find<TransactionController>();

      final sentTransaction = transactionController.transactions.last.copyWith(
        hash: hash,
        status: TransactionStatus.pending,
      );
      transactionController.updateTransaction(sentTransaction);

      TransactionReceipt? receipt;
      while (receipt == null) {
        await Future.delayed(Duration(seconds: 5));
        receipt = await client.getTransactionReceipt(hash);
      }
      print('Transaction receipt: ${receipt.toString()}');

      final finalTransaction = transactionController.transactions.last.copyWith(
        receipt: receipt.toString(),
        status: TransactionStatus.mined,
      );
      transactionController.updateTransaction(finalTransaction);
      loadProposals();
    } catch (error) {
      final transactionController = Get.find<TransactionController>();

      final failedTransaction =
          transactionController.transactions.last.copyWith(
        status: TransactionStatus.failed,
      );
      transactionController.updateTransaction(failedTransaction);
      print('Error voting on mint proposal: $error');
      Get.snackbar(
        'Error',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final networkController = Get.find<NetworkController>();
    final transactionController = Get.find<TransactionController>();
    final currentTokenController = Get.find<CurrentTokenController>();
    return Column(
      children: proposals.asMap().entries.map((entry) {
        int index = entry.key;
        MintProposal proposal = entry.value;
        return Padding(
          padding: const EdgeInsets.all(13.0),
          child: Container(
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(13.0),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [buildAddressInfo(proposal.receiveAddress)],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Proposal $index'),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recipient',
                                style: TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 13),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Amount',
                                style: TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 13),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Votes',
                                style: TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 13),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Progress',
                                style: TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(truncateRecipient(proposal.receiveAddress),
                                  style: TextStyle(fontSize: 13)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  (proposal.amount.toDouble() / pow(10, 18))
                                      .toStringAsFixed(2),
                                  style: TextStyle(fontSize: 13)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  (proposal.proposalVotes.toDouble() /
                                          pow(10, 18))
                                      .toStringAsFixed(2),
                                  style: TextStyle(fontSize: 13)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  '${((proposal.proposalVotes / proposal.totalVotes) * 100).toStringAsFixed(2)}%',
                                  style: TextStyle(fontSize: 13)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your votes',
                            style: TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 13),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Total votes',
                            style: TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 13),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Your share',
                            style: TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 13),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              (proposal.votes.toDouble() / pow(10, 18))
                                  .toStringAsFixed(2),
                              style: TextStyle(fontSize: 13)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              (proposal.totalVotes.toDouble() / pow(10, 18))
                                  .toStringAsFixed(2),
                              style: TextStyle(fontSize: 13)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              '${((proposal.votes / proposal.totalVotes) * 100).toStringAsFixed(2)}%',
                              style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      Spacer(),
                      if (DateTime.now().millisecondsSinceEpoch <=
                          proposal.releaseTime.toInt() * 1000)
                        Column(
                          children: [
                            Text(
                              'Time left:',
                              style: TextStyle(
                                  color: CupertinoColors.systemGrey,
                                  fontSize: 13),
                            ),
                            CountdownTimer(releaseTime: proposal.releaseTime),
                          ],
                        ),
                      if (proposal.releaseTime != BigInt.from(0) &&
                          DateTime.now().millisecondsSinceEpoch >
                              proposal.releaseTime.toInt() * 1000)
                        _buildIconButton(
                          CupertinoIcons.add,
                          'Mint',
                          () async {
                            final password =
                                await showPasswordInputDialog(context);
                            if (password != null && password.isNotEmpty) {
                              transactionController.updateTransaction(
                                TransactionInfo(
                                  value:
                                      '${(proposal.votes.toDouble() / pow(10, 18)).toStringAsFixed(1)} ${currentTokenController.currentToken.tokenSymbol}',
                                  recipient: EthereumAddress.fromHex(
                                      proposal.receiveAddress),
                                  type: TransactionType.mint,
                                  status: TransactionStatus.sending,
                                  network: Get.find<NetworkController>()
                                      .selectedNetwork
                                      .value
                                      .name,
                                ),
                              );
                              final accountController =
                                  Get.find<AccountController>();
                              String? privateKey = await accountController
                                  .getPrivateKey(password);
                              final credential =
                                  EthPrivateKey.fromHex(privateKey!);
                              opMintProposal(networkController.client,
                                  credential, index, TransactionType.mint);
                              Get.offAll(PortfolioPage(), arguments: 1);
                            }
                          },
                        ),
                      if (proposal.releaseTime == BigInt.from(0) &&
                          (proposal.proposalVotes / proposal.totalVotes) > 0.5)
                        _buildIconButton(
                          CupertinoIcons.arrow_right,
                          'Initiate',
                          () async {
                            final password =
                                await showPasswordInputDialog(context);
                            if (password != null && password.isNotEmpty) {
                              transactionController.updateTransaction(
                                TransactionInfo(
                                  value:
                                      '${(proposal.votes.toDouble() / pow(10, 18)).toStringAsFixed(1)} ${currentTokenController.currentToken.tokenSymbol}',
                                  recipient: EthereumAddress.fromHex(
                                      proposal.receiveAddress),
                                  type: TransactionType.initiateMint,
                                  status: TransactionStatus.sending,
                                  network: Get.find<NetworkController>()
                                      .selectedNetwork
                                      .value
                                      .name,
                                ),
                              );
                              final accountController =
                                  Get.find<AccountController>();
                              String? privateKey = await accountController
                                  .getPrivateKey(password);
                              final credential =
                                  EthPrivateKey.fromHex(privateKey!);
                              opMintProposal(
                                  networkController.client,
                                  credential,
                                  index,
                                  TransactionType.initiateMint);
                              Get.offAll(PortfolioPage(), arguments: 1);
                            }
                          },
                        ),
                      if (!proposal.hasVoted &&
                          (proposal.proposalVotes / proposal.totalVotes) < 0.5)
                        _buildIconButton(
                          CupertinoIcons.check_mark,
                          'Vote',
                          () async {
                            final password =
                                await showPasswordInputDialog(context);
                            if (password != null && password.isNotEmpty) {
                              transactionController.updateTransaction(
                                TransactionInfo(
                                  value:
                                      '${(proposal.votes.toDouble() / pow(10, 18)).toStringAsFixed(1)} ${currentTokenController.currentToken.tokenSymbol}',
                                  recipient: EthereumAddress.fromHex(
                                      proposal.receiveAddress),
                                  type: TransactionType.vote,
                                  status: TransactionStatus.sending,
                                  network: Get.find<NetworkController>()
                                      .selectedNetwork
                                      .value
                                      .name,
                                ),
                              );
                              final accountController =
                                  Get.find<AccountController>();
                              String? privateKey = await accountController
                                  .getPrivateKey(password);
                              final credential =
                                  EthPrivateKey.fromHex(privateKey!);
                              opMintProposal(networkController.client,
                                  credential, index, TransactionType.vote);
                              Get.offAll(PortfolioPage(), arguments: 1);
                            }
                          },
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

Widget _buildIconButton(
    IconData iconData, String text, void Function() onPressed) {
  return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: onPressed,
      child: Column(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(75, 124, 146, 1.0)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: 20,
                  )),
            ),
          ),
          Text(
            text,
            style: TextStyle(
                color: Color.fromRGBO(75, 124, 146, 1.0), fontSize: 12),
          )
        ],
      ));
}

String truncateRecipient(String text) {
    if (text.length <= 14) {
      return text;
    }
    return text.substring(0, 12) + '...' + text.substring(text.length - 4);
}

Widget buildAddressInfo(String address) {
  String truncateText(String text) {
    if (text.length <= 14) {
      return text;
    }
    return text.substring(0, 10) + '...' + text.substring(text.length - 4);
  }

  address = EthereumAddress.fromHex(address).hexEip55;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      RandomAvatar(address, height: 25),
      SizedBox(width: 4),
      Text(
        truncateText(address),
      ),
    ],
  );
}

class CountdownTimer extends StatefulWidget {
  final BigInt releaseTime;

  const CountdownTimer({Key? key, required this.releaseTime}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int remainingTime = (widget.releaseTime.toInt() * 1000 - currentTime)
        .clamp(0, widget.releaseTime.toInt() * 1000);
    Duration remainingDuration = Duration(milliseconds: remainingTime);

    return Text(
      '${remainingDuration.inDays}d ${remainingDuration.inHours.remainder(24)}h ${remainingDuration.inMinutes.remainder(60)}m ${remainingDuration.inSeconds.remainder(60)}s',
      style: TextStyle(fontSize: 13),
    );
  }
}
