import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../classes/token.dart';
import '../../controller/account_controller.dart';
import '../../controller/current_token_controller.dart';
import '../../controller/network_controller.dart';

import 'package:flutter/cupertino.dart';

class TokenInputBox extends StatelessWidget {
  final accountController = Get.find<AccountController>();
  final networkController = Get.find<NetworkController>();
  final currentTokenController = Get.find<CurrentTokenController>();
  final TextEditingController textEditingController;

  TokenInputBox({
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                    currentTokenController.currentToken.tokenName.isEmpty
                        ? 'ETH'
                        : currentTokenController.currentToken.tokenName,
                  )),
              Icon(CupertinoIcons.arrowtriangle_down_fill, size: 10),
            ],
          ),
          onPressed: () async {
            FungibleToken? selectedToken =
                await showCupertinoModalPopup<FungibleToken>(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                  title: Text('Select a token'),
                  cancelButton: CupertinoActionSheetAction(
                    child: Text('Cancel'),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  actions: [
                    CupertinoActionSheetAction(
                      child:
                          Text(networkController.selectedNetwork.value.symbol),
                      onPressed: () {
                        Get.back(
                            result: FungibleToken(
                                contractAddress: '',
                                tokenBalance: 0,
                                tokenDecimals: 0,
                                tokenName: '',
                                tokenSymbol: '',
                                tokenLogoURL: ''));
                      },
                    ),
                    for (FungibleToken token in accountController.tokens)
                      CupertinoActionSheetAction(
                        child: Text(token.tokenName),
                        onPressed: () {
                          Get.back(result: token);
                        },
                      ),
                  ],
                );
              },
            );

            if (selectedToken != null) {
              currentTokenController.currentToken = selectedToken;
            }
          },
        ),
        CupertinoTextField(
          padding: EdgeInsets.all(10.0),
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.top,
          placeholder: '0.0',
          placeholderStyle:
              TextStyle(fontSize: 40, color: CupertinoColors.placeholderText),
          style: TextStyle(fontSize: 40),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: textEditingController,
          decoration: BoxDecoration(
            border: Border.all(style: BorderStyle.none),
          ),
        ),
        Obx(() => Text(
            'Balance: ${currentTokenController.currentToken.tokenName.isEmpty ? accountController.nativeTokenBalance : currentTokenController.currentToken.tokenBalance} ${currentTokenController.currentToken.tokenName.isEmpty ? 'ETH' : currentTokenController.currentToken.tokenSymbol}'))
      ],
    );
  }
}
