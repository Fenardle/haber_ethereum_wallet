import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import '../../../controller/account_controller.dart';
import '../../../controller/network_controller.dart';

import '../../../blank.dart';
import '../../../generated/ERC20ProxyFactory.g.dart';
import '../../components/input_box.dart';
import '../../../constants.dart';

class HomePage extends StatelessWidget {
  final NetworkController networkController = Get.put(NetworkController());
  final AccountController accountController = Get.put(AccountController());
  final TextEditingController DAONameController = TextEditingController();
  final TextEditingController DAOSymbolController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CupertinoPageScaffold(
        child: accountController.currentAccountDAO.isEmpty
            ? _buildEmptyAccountView(context)
            : BlankPage(),
      ),
    );
  }

  Widget _buildEmptyAccountView(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Forge Your Own DAO,',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Unlock the Blockchain Cosmos'),
                  ],
                ),
                SizedBox(height: 20),
                buildInputBox('DAO Name',
                    DAONameController), //screenWidth, screenHeight),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                buildInputBox(
                  'DAO Symbol',
                  DAOSymbolController,
                ), // screenWidth, screenHeight),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                CupertinoButton.filled(
                  onPressed: () {
                    // Navigate to import token address page or create new DAO
                  },
                  child: Text('Create New DAO'),
                  borderRadius: BorderRadius.circular(999.0),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(16), // Add desired padding here
            child: _buildImportDAOButton(context),
          ),
        ),
      ],
    );
  }

  Widget _buildImportDAOButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Already join a DAO?',
          style: TextStyle(fontSize: 12),
        ),
        CupertinoButton(
          onPressed: () {
            // Navigate to create new DAO page
          },
          child: Text(
            'Import',
            style: TextStyle(fontSize: 12),
          ),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Future<void> createHayekToken(Web3Client client, Credentials credentials,
      String name, String symbol) async {
    // Create an instance of the ERC20ProxyFactory contract
    final erc20ProxyFactory = ERC20ProxyFactory(
        address: EthereumAddress.fromHex(
            getERC20ProxyFactory(networkController.selectedNetwork.value.name)),
        client: client);

    final subscription = erc20ProxyFactory
        .eRC20TokenProxyCreatedEvents()
        .take(1)
        .listen((event) {
      print('Token has been deployed at ${event.proxy}');
    });

    // Call the createERC20TokenProxy function on the ERC20ProxyFactory contract
    String receipt = await erc20ProxyFactory.createERC20TokenProxy(
      name,
      symbol,
      credentials: credentials,
    );

    print('Receipt: $receipt');

    await subscription.asFuture();
    await subscription.cancel();
  }
}
