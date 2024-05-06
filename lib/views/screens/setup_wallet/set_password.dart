import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'show_mnemonic.dart';
import '../../../services/services_implementation.dart';
import '../../components/input_box.dart';
import '../../../controller/account_controller.dart';

class SetPasswordPage extends StatelessWidget {
  final accountController = Get.find<AccountController>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
      
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Create Password',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      child: SingleChildScrollView(
        child: SingleChildScrollView(
           physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Text(
                'This password will be the guardian of your assets',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                'so it should be at least 8 characters.',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
              ),
              SizedBox(height: 16.0),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInputBox('New Password', passwordController),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                      buildInputBox(
                          'Confirm Password', confirmPasswordController),
                    ],
                  ),
                ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              CupertinoButton(
                onPressed: () async {
                  if (passwordController.text != confirmPasswordController.text) {
                    Get.snackbar(
                      'Error',
                      'Passwords do not match',
                      backgroundColor: CupertinoColors.systemRed,
                      colorText: CupertinoColors.white,
                    );
                  } else if (confirmPasswordController.text.length < 8) {
                    Get.snackbar(
                      'Error',
                      'Passwords less than 8 characters',
                      backgroundColor: CupertinoColors.systemRed,
                      colorText: CupertinoColors.white,
                    );
                  } else {
                    String mnemonic = await mnemonicService
                        .generateMnemonic(passwordController.text);
                    await accountController
                        .createAccount(passwordController.text);
                    Get.to(MnemonicPage(), arguments: mnemonic);
                  }
                },
                child: const Text('Create password'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
