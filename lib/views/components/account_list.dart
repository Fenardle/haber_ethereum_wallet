import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:random_avatar/random_avatar.dart';
import 'package:haber/classes/account.dart';
import '../../controller/account_controller.dart';
import '../../controller/network_controller.dart';
import './password_dialog.dart';

class accountListWidget extends StatelessWidget {
  final accountController = Get.find<AccountController>();
  final networkController = Get.find<NetworkController>();

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text('Select Account'),
      actions: [
        for (int i = 0; i < accountController.accountList.length; i++)
          CupertinoActionSheetAction(
            onPressed: () {
              accountController.setCurrentAccount(
                  accountController.accountList[i].publicKey);
              Navigator.pop(context);
            },
            child: _buildAccountInfo(i),
          ),
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.pop(context);
            final password = await showPasswordInputDialog(context);
            if (password != null && password.isNotEmpty) {
              accountController.createAccount(password);
            }
          },
          child: _buildAddAccount(),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Cancel'),
        isDefaultAction: true,
      ),
    );
  }

  Widget _buildAccountInfo(int index) {
    Account account = accountController.accountList[index];
    Color fontColor = (account.publicKey == accountController.currentAccount)
        ? CupertinoColors.activeBlue
        : Colors.black;
    return Row(
      children: [
        SizedBox(height: 30.0, width: 16),
        RandomAvatar(account.publicKey, height: 45),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account.name,
              style: TextStyle(color: fontColor, fontSize: 18),
            ),
            SizedBox(height: 4),
            Text(
              truncateText(account.publicKey),
              style: TextStyle(color: fontColor, fontSize: 12),
            ),
          ],
        ),
        Spacer(),
        Obx(() => Text(
              '${accountController.accountList[index].balance} ${networkController.selectedNetwork.value.symbol}',
              style: TextStyle(color: fontColor, fontSize: 18),
            )),
        SizedBox(width: 10),
      ],
    );
  }
}

Widget _buildAddAccount() {
  return Row(
    children: const [
      SizedBox(width: 25),
      Icon(CupertinoIcons.add, color: Colors.black, size: 25),
      SizedBox(width: 10),
      Text(
        'New account',
        style: TextStyle(color: Colors.black),
      ),
    ],
  );
}

String truncateText(String text) {
  if (text.length <= 10) {
    return text;
  }
  return text.substring(0, 6) + '...' + text.substring(text.length - 4);
}
