import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import '../../../generated/ERC20Implementation.g.dart';
import '../../../controller/transaction_controller.dart';
import '../../../controller/account_controller.dart';
import '../../../controller/network_controller.dart';
import '../../../controller/current_token_controller.dart';
import '../../../classes/transaction_info.dart';
import '../../../services/key_pairs_service.dart';
import '../../components/input_box.dart';
import '../../components/address_input_box.dart';
import '../../components/token_input_box.dart';
import '../../components/password_dialog.dart';
import '../portfolio.dart';

class ProposePage extends StatelessWidget {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final accountController = Get.find<AccountController>();
  final networkController = Get.find<NetworkController>();
  final currentTokenController = Get.find<CurrentTokenController>();

  @override
  Widget build(BuildContext context) {
    final transactionController = Get.find<TransactionController>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Create Mint Proposal'),
        border: null,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Text('To:'),
                          Spacer(), // Add a Spacer to push the ToInputBox to the right
                          Container(
                            width: 300, // Set the fixed width you desire
                            child: ToInputBox(
                                textEditingController: _recipientController),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      TokenInputBox(textEditingController: _amountController),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      CupertinoButton.filled(
                        onPressed: () async {
                          final password = await showPasswordInputDialog(context);
                          if (password != null && password.isNotEmpty) {
                            String? privateKey =
                                await accountController.getPrivateKey(password);
                            transactionController.updateTransaction(
                              TransactionInfo(
                                value:
                                    '${_amountController.text} ${currentTokenController.currentToken.tokenName.isEmpty ? networkController.selectedNetwork.value.name : currentTokenController.currentToken.tokenName}',
                                recipient: EthereumAddress.fromHex(
                                    _recipientController.text),
                                type: TransactionType.propose,
                                status: TransactionStatus.sending,
                                network: Get.find<NetworkController>()
                                    .selectedNetwork
                                    .value
                                    .name,
                              ),
                            );
                            print(privateKey);
                            final credential = EthPrivateKey.fromHex(privateKey!);
                            createMintProposal(
                                networkController.client,
                                credential,
                                _recipientController.text,
                                _amountController.text);
      
                            // Navigate to the transaction page
                            Get.offAll(PortfolioPage(), arguments: 1);
                          }
                        },
                        child: const Text('Propose'),
                        borderRadius: BorderRadius.all(Radius.circular(999.0)),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          ],
        ),
      ),
    );
  }
}

Future<void> createMintProposal(
  Web3Client client,
  Credentials credentials,
  String receiver,
  String amount,
) async {
  try {
    final currentTokenController = Get.find<CurrentTokenController>();
    // Create an instance of the ercC20Implementation contract
    final erc20Implementation = ERC20Implementation(
      address: EthereumAddress.fromHex(
          currentTokenController.currentToken.contractAddress),
      client: client,
    );

    // Call the createMintProposal function on the erc20Implementation contract
    String hash = await erc20Implementation.createMintProposal(
      EthereumAddress.fromHex(receiver),
      BigInt.from((double.parse(amount) *
          pow(10, currentTokenController.currentToken.tokenDecimals))),
      credentials: credentials,
    );

    print('Transaction hash: $hash');

    // Get the transactionController instance
    final transactionController = Get.find<TransactionController>();

    final sentTransaction = transactionController.transactions.last.copyWith(
      hash: hash,
      status: TransactionStatus.pending, // Update the status to mined
    );
    transactionController.updateTransaction(sentTransaction);

    // Poll for transaction receipt
    TransactionReceipt? receipt;
    while (receipt == null) {
      await Future.delayed(Duration(seconds: 5));
      receipt = await client.getTransactionReceipt(hash);
    }
    print('Transaction receipt: ${receipt.toString()}');

    // Update the transaction in the transactionController with the receipt
    final finalTransaction = transactionController.transactions.last.copyWith(
      receipt: receipt.toString(),
      status: TransactionStatus.mined, // Update the status to mined
    );
    transactionController.updateTransaction(finalTransaction);
  } catch (error) {
    // Get the transactionController instance
    final transactionController = Get.find<TransactionController>();

    // Update the transaction status to failed
    final failedTransaction = transactionController.transactions.last.copyWith(
      status: TransactionStatus.failed,
    );
    transactionController.updateTransaction(failedTransaction);
    print('Error creating mint proposal: $error');
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
