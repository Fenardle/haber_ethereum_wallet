import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/current_token_controller.dart';
import '../../controller/account_controller.dart';
import '../components/avatar.dart';
import '../../classes/token.dart';
import './operations/delegate.dart';
import './operations/send.dart';
import './operations/propose.dart';
import '../components/proposal_list.dart';

class TokenDetailPage extends StatelessWidget {
  final currentTokenController = Get.find<CurrentTokenController>();
  final accountController = Get.find<AccountController>();
  FungibleToken token;

  TokenDetailPage(this.token, {super.key}) {
    currentTokenController.currentToken = token;
    accountController.fetchToken(token.contractAddress);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Ethereum',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ),
      child: _buildPage(currentTokenController),
    );
  }
}

Widget _buildPage(CurrentTokenController currentTokenController) {
  return Obx(() {
    return _buildTokenInfo(currentTokenController);
  });
}

Widget _buildTokenInfo(CurrentTokenController currentTokenController) {
  return CupertinoScrollbar(
    child: SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(height: 20),
        buildTokenAvatar(currentTokenController.currentToken, 60),
        SizedBox(height: 20),
        Text(
          '${currentTokenController.currentToken.tokenBalance} ${currentTokenController.currentToken.tokenSymbol}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        _buildOperationMenu(),
        SizedBox(height: 20),
        ProposalsList(),
      ]),
    ),
  );
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

Widget _buildOperationMenu() {
  double indent = 20;
  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconButton(
            CupertinoIcons.arrow_up_right, 'Send', () => Get.to(SendPage())),
        SizedBox(width: indent),
        _buildIconButton(CupertinoIcons.person_alt, 'Delegate',
            () => Get.to(DelegatePage())),
        SizedBox(width: indent),
        _buildIconButton(
            CupertinoIcons.arrow_up, 'Propose', () => Get.to(ProposePage())),
      ],
    ),
  );
}
