import 'package:jazzicon/jazzicon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';
import '../../controller/account_controller.dart';
import '../../classes/token.dart';

Widget buildTokenAvatar(FungibleToken token, double size) {
  if (token.tokenLogoURL.isNotEmpty) {
    return Image.network(token.tokenLogoURL);
  } else {
    return Jazzicon.getIconWidget(
        Jazzicon.getJazziconData(size, address: token.contractAddress));
  }
}

Widget buildAccountAvatar(AccountController accountController) {
  print(accountController.currentAccount);
  return Obx(() {
    final address = accountController.currentAccount;
    return RandomAvatar(address, height: 80);
  });
}
