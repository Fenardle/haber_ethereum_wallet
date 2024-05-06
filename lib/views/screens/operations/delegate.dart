import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:web3dart/web3dart.dart';
import '../../../generated/ERC20Implementation.g.dart';
import '../../../controller/transaction_controller.dart';
import '../../../controller/account_controller.dart';
import '../../../controller/network_controller.dart';
import '../../../controller/current_token_controller.dart';
import '../../../classes/transaction_info.dart';
import '../../components/address_input_box.dart';
import '../../components/password_dialog.dart';
import '../portfolio.dart';

class DelegatePage extends StatelessWidget {
  final TextEditingController _delegateeController = TextEditingController();

  final accountController = Get.find<AccountController>();
  final networkController = Get.find<NetworkController>();
  final currentTokenController = Get.find<CurrentTokenController>();

  @override
  Widget build(BuildContext context) {
    final transactionController = Get.find<TransactionController>();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Delegate Votes'),
        border: null,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            FutureBuilder<String>(
              future: getCurrentDelegatee(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                        height: 60, child: Text('Loading current delegatee...')),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: buildAddressInfo(snapshot.data!),
                  );
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
                Column(children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Text('To:'),
                      Spacer(),
                      Container(
                        width: 300,
                        child: ToInputBox(
                            textEditingController: _delegateeController),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  CupertinoButton.filled(
                    onPressed: () async {
                      final password = await showPasswordInputDialog(context);
                      if (password != null && password.isNotEmpty) {
                        transactionController.updateTransaction(
                          TransactionInfo(
                            value:
                                '${currentTokenController.currentToken.tokenBalance} ${currentTokenController.currentToken.tokenName.isEmpty ? networkController.selectedNetwork.value.name : currentTokenController.currentToken.tokenName}',
                            recipient: EthereumAddress.fromHex(
                                _delegateeController.text),
                            type: TransactionType.delegate,
                            status: TransactionStatus.sending,
                            network: Get.find<NetworkController>()
                                .selectedNetwork
                                .value
                                .name,
                          ),
                        );
                        String? privateKey =
                            await accountController.getPrivateKey(password);
                        print(privateKey);
                        final credential = EthPrivateKey.fromHex(privateKey!);
                        delegateVotes(networkController.client, credential,
                            _delegateeController.text);
      
                        Get.offAll(PortfolioPage(), arguments: 1);
                      }
                    },
                    child: const Text('Delegate'),
                    borderRadius: BorderRadius.all(Radius.circular(999.0)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                ]),
          ],
        ),
      ),
    );
  }

  Future<String> getCurrentDelegatee() async {
    final erc20Implementation = ERC20Implementation(
      address: EthereumAddress.fromHex(
          currentTokenController.currentToken.contractAddress),
      client: networkController.client,
    );

    EthereumAddress delegateeAddress = await erc20Implementation
        .delegates(EthereumAddress.fromHex(accountController.currentAccount));

    return delegateeAddress.toString();
  }
}

Widget buildAddressInfo(String address) {
  String truncateText(String text) {
    if (text.length <= 14) {
      return text;
    }
    return text.substring(0, 10) + '...' + text.substring(text.length - 4);
  }

  address = EthereumAddress.fromHex(address).hexEip55;
  return Container(
    width: 270,
    height: 60,
    // decoration: BoxDecoration(
    //   border: Border.all(color: CupertinoColors.systemGrey),
    //   borderRadius: BorderRadius.circular(20),
    // ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RandomAvatar(address, height: 50),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              truncateText(address),
              style: TextStyle(fontSize: 22),
            ),
            Text(
              'Your current delegatee',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    ),
  );
}

Future<void> delegateVotes(
  Web3Client client,
  Credentials credentials,
  String delegatee,
) async {
  try {
    final currentTokenController = Get.find<CurrentTokenController>();
    final accountController = Get.find<AccountController>();
    // Create an instance of the ercC20Implementation contract
    final erc20Implementation = ERC20Implementation(
      address: EthereumAddress.fromHex(
          currentTokenController.currentToken.contractAddress),
      client: client,
    );

    // Call the delegate function on the erc20Implementation contract
    String hash = await erc20Implementation.delegate(
      EthereumAddress.fromHex(delegatee),
      credentials: credentials,
    );

    print('Transaction hash: $hash');

    final transactionController = Get.find<TransactionController>();

    final sentTransaction = transactionController.transactions.last.copyWith(
      hash: hash,
      status: TransactionStatus.pending, // Update the status to mined
    );
    transactionController.updateTransaction(sentTransaction);

    TransactionReceipt? receipt;
    while (receipt == null) {
      await Future.delayed(Duration(seconds: 5));
      receipt = await client.getTransactionReceipt(hash);
    }
    accountController.fetchNativeToken();
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
    print('Error delegating votes: $error');
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
