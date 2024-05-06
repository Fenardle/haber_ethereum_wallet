import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controller/account_controller.dart';
import '../../../services/mnemonic_service.dart';
import '../../components/input_box.dart';
import '../portfolio.dart';

class importMnemonicPage extends StatelessWidget {
  final accountController = Get.find<AccountController>();

  final TextEditingController mnemonicController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final legalMnemonicLength = [12, 15, 18, 21, 24];
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Import',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      child: SingleChildScrollView(
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
                    buildInputBox('Secret Recovery Phrase',
                        mnemonicController), //screenWidth, screenHeight),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                    buildInputBox(
                      'New Password',
                      passwordController,
                    ), // screenWidth, screenHeight),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                    buildInputBox('Confirm Password',
                        confirmPasswordController), // screenWidth, screenHeight),
                  ],
                ),
              ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, loading, _) {
                  return loading
                      ? CupertinoActivityIndicator()
                      : CupertinoButton(
                          onPressed: () async {
                            final mnemonicLength =
                                mnemonicController.text.split(' ').length;
                            if (!legalMnemonicLength.contains(mnemonicLength)) {
                              Get.snackbar(
                                'Error',
                                'Recovery Phrase must be 12, 15, 18, 21 or 24 words, but your phrase is $mnemonicLength words',
                                backgroundColor: CupertinoColors.systemRed,
                                colorText: CupertinoColors.white,
                              );
                            } else if (passwordController.text !=
                                confirmPasswordController.text) {
                              Get.snackbar(
                                'Error',
                                'Passwords do not match',
                                backgroundColor: CupertinoColors.systemRed,
                                colorText: CupertinoColors.white,
                              );
                            } else if (confirmPasswordController.text.length <
                                8) {
                              Get.snackbar(
                                'Error',
                                'Passwords less than 8 characters',
                                backgroundColor: CupertinoColors.systemRed,
                                colorText: CupertinoColors.white,
                              );
                            } else {
                              isLoading.value = true;
                              await mnemonicService.safeStoreMnemonic(
                                  mnemonicController.text,
                                  passwordController.text);
                              await accountController
                                  .createAccount(passwordController.text);
                              Get.offAll(() => PortfolioPage());
                            }
                          },
                          child: const Text('Import'),
                        );
                }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }
}

// Widget _buildInputBox
// (String hintText, TextEditingController textEditingController, double screenWidth, double screenHeight) {
//   Row hint = Row(
//     children: [
//       Text(
//         hintText,
//         style: const TextStyle(
//               fontWeight: FontWeight.w300,
//               fontSize: 12
//             ),
//       ),
//     ],
//   );

//   FocusNode _focusNode = FocusNode();

//   return Column(
//     children: [
//       hint,
//       SizedBox(height: screenHeight * 0.005),
//       CupertinoTextField(
//         controller: textEditingController,
//         focusNode: _focusNode,
//         obscureText: true,
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: _focusNode.hasFocus ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         onTap: () => _focusNode.requestFocus(),
//       )
//     ],
//   );
// }
