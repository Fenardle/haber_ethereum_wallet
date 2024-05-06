import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber/classes/token.dart';
import '../../controller/current_token_controller.dart';
import '../../controller/account_controller.dart';
import '../screens/token_detail.dart';
import 'avatar.dart';

class ERC20ListWidget extends StatelessWidget {
  final accountController = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          for (FungibleToken token in accountController.tokens)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                ),
              ),
              child: _buildTokenTile(token),
            ),
          CupertinoButton(
            child: const Text('Import tokens'),
            onPressed: () => print('1'),
          ),
        ],
      );
    });
  }
}

Widget _buildTokenInfo(FungibleToken token) {
  return Row(
    children: [
      SizedBox(height: 70.0, width: 16),
      buildTokenAvatar(token, 40),
      SizedBox(width: 16),
      Text(
        token.tokenBalance.toString() + ' ' + token.tokenName,
        style: TextStyle(color: Colors.black),
      ),
      Spacer(),
      Icon(
        Icons.arrow_forward_ios,
        color: Colors.blueGrey,
      ),
      SizedBox(width: 10),
    ],
  );
}

Widget _buildTokenTile(FungibleToken token) {
  return CupertinoButton(
    onPressed: () async {
      Get.to(TokenDetailPage(token));
    },
    padding: EdgeInsets.zero,
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            //width: 1.0,
          ),
        ),
      ),
      child: _buildTokenInfo(token),
    ),
  );
}
