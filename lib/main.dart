import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './app_routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './controller/network_controller.dart';
import './controller/account_controller.dart';
import 'controller/current_token_controller.dart';
import './controller/transaction_controller.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //@dev: clear all the data
  await FlutterSecureStorage().deleteAll();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();

  final directory = await getApplicationDocumentsDirectory();
  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
  }

  final hasCurrentAccount =
      await FlutterSecureStorage().containsKey(key: 'current_account');

  await Get.putAsync<NetworkController>(() async {
    final controller = NetworkController();
    await controller.init();
    return controller;
  });

  Get.put(CurrentTokenController());
  Get.put(AccountController());
  Get.put(TransactionController());

  runApp(MyApp(hasCurrentAccount: hasCurrentAccount));
}

class MyApp extends StatelessWidget {
  final bool hasCurrentAccount;

  const MyApp({Key? key, required this.hasCurrentAccount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetCupertinoApp(
      title: 'Haber',
      initialRoute:
          hasCurrentAccount ? AppRoutes.ERC20_PORTFOLIO : AppRoutes.INTRO,
      //AppRoutes.SEND,
      //AppRoutes.HOME,
      getPages: AppRoutes.routes,
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF1DA1F2),
        primaryContrastingColor: Colors.white,
        scaffoldBackgroundColor: CupertinoColors.white, //systemGrey6,
        barBackgroundColor: CupertinoColors.white, //systemGrey6,
      ),
    );
  }
}