import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../components/input_box02.dart';
import '../../../controller/network_controller.dart';
import '../../../controller/transaction_controller.dart';
import '../../../controller/account_controller.dart';
import '../../../classes/transaction_info.dart';
import 'package:web3dart/web3dart.dart';
import '../../components/password_dialog.dart';
import '../portfolio.dart';
import '../../../generated/ERC20ProxyFactory.g.dart';
import '../../../constants.dart';

class IssuePage extends StatelessWidget {
  final TextEditingController _daoNameController = TextEditingController();
  final TextEditingController _daoSymbolController = TextEditingController();
  final accountController = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    final transactionController = Get.find<TransactionController>();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Column(
          children: [
            Text(
              'Issue',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '· ' + Get.find<NetworkController>().selectedNetwork.value.name,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        border: null,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text('Name:'),
                        Spacer(),
                        Container(
                          width: 250,
                          child: InputBox(
                            placeholder: 'DAO Name(Bitcoin)',
                            textEditingController: _daoNameController,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text('Symbol:'),
                        Spacer(),
                        Container(
                          width: 250,
                          child: InputBox(
                            placeholder: 'DAO Symbol(BTC)',
                            textEditingController: _daoSymbolController,
                          ),
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
                              value: '2,100,000 ${_daoNameController.text}',
                              recipient: EthereumAddress.fromHex(
                                  accountController.currentAccount),
                              type: TransactionType.issue,
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
                          issue(credential, _daoNameController.text,
                              _daoSymbolController.text);
                          // Navigate to the transaction page
                          Get.offAll(PortfolioPage(), arguments: 1);
                        }
                      },
                      child: const Text('Issue'),
                      borderRadius: BorderRadius.all(Radius.circular(999.0)),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}

Future<void> issue(
  Credentials credentials,
  String name,
  String symbol,
) async {
  try {
    final accountController = Get.find<AccountController>();
    final networkController = Get.find<NetworkController>();
    // Create an instance of the ercC20ProxyFactory contract
    final ercC20ProxyFactory = ERC20ProxyFactory(
      address: EthereumAddress.fromHex(
          getERC20ProxyFactory(networkController.selectedNetwork.value.name)),
      client: networkController.client,
    );

    // Subscribe to the ERC20TokenProxyCreated event with a filter for the msg.sender address
    // Subscribe to the ERC20TokenProxyCreated event
    final eventStream = ercC20ProxyFactory.eRC20TokenProxyCreatedEvents(
      fromBlock: const BlockNum.pending(),
    );

    // Call the createERC20TokenProxy function on the ercC20ProxyFactory contract
    String hash = await ercC20ProxyFactory.createERC20TokenProxy(
      name,
      symbol,
      credentials: credentials,
    );

    print('Receipt: $hash');

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
      receipt = await networkController.client.getTransactionReceipt(hash);
    }
    print('Transaction receipt: ${receipt.toString()}');

    accountController.fetchERC20Tokens();

    // Update the transaction in the transactionController with the receipt
    final finalTransaction = transactionController.transactions.last.copyWith(
      receipt: receipt.toString(),
      status: TransactionStatus.mined, // Update the status to mined
    );
    transactionController.updateTransaction(finalTransaction);
  } catch (error) {
    print('RPC Error: $error');

    // Get the transactionController instance
    final transactionController = Get.find<TransactionController>();

    // Update the transaction status to failed
    final failedTransaction = transactionController.transactions.last.copyWith(
      status: TransactionStatus.failed,
    );
    transactionController.updateTransaction(failedTransaction);
  }
}
