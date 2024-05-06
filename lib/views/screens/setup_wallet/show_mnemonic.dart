import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:flutter/services.dart';

import '../portfolio.dart';

class MnemonicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String mnemonic = Get.arguments;
    final List<String> words = mnemonic.split(' ');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    //todo
    ScreenshotCallback screenshotCallback = ScreenshotCallback();
    screenshotCallback.addListener(() {
      Get.snackbar(
        'WARNING',
        'Do not take screenshot, mobile album is not a secret place:(',
        backgroundColor: CupertinoColors.systemRed,
        colorText: CupertinoColors.white,
      );
    });

    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Backup phrase'),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Text(
                'Record your Recovery Phrase secretly',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontWeight: FontWeight.w600, fontSize: screenWidth * 0.05),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Text(
                'You can write it down on a paper and hide it in a secret place :)',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontWeight: FontWeight.w500, fontSize: screenWidth * 0.03),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              _buildMnemonicFrame(words, screenWidth, screenHeight),
              _buildCopyButton(mnemonic, screenWidth, screenHeight),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              CupertinoButton(
                onPressed: () async {
                  Get.offAll(() => PortfolioPage());
                },
                child: const Text("Done"),
              ),
            ],
          ),
        ));
  }

  List<Widget> _buildWordsList(List<String> words, bool isFirstColumn,
      double screenWidth, double screenHeight) {
    return words.asMap().entries.map((entry) {
      final int index = entry.key + 1;
      final String word = entry.value;
      return Container(
        width: screenWidth * 0.3,
        height: screenHeight * 0.03,
        padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.003, horizontal: screenHeight * 0.0002),
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.systemGrey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('${isFirstColumn ? index : index + 6}. $word'),
        ),
      );
    }).toList();
  }

  Widget _buildWordsColumns(
      List<String> words, double screenWidth, double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildWordsList(
              words.sublist(0, 6), true, screenWidth, screenHeight),
        ),
        SizedBox(
          width: screenWidth * 0.1,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildWordsList(
              words.sublist(6), false, screenWidth, screenHeight),
        ),
      ],
    );
  }

  Widget _buildMnemonicFrame(
      List<String> words, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.3,
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 1),
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: _buildWordsColumns(words, screenWidth, screenHeight),
    );
  }

  Widget _buildCopyButton(
      String words, double screenWidth, double screenHeight) {
    CupertinoButton copyButton = CupertinoButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(CupertinoIcons.doc_on_doc_fill),
          Text(' Copy to Clipboard'),
        ],
      ),
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: words));
        Get.snackbar(
        'Copied',
        'Mnemonic has been copied to your clipboard.',
        backgroundColor: CupertinoColors.systemGreen,
        colorText: CupertinoColors.white,
      );
      },
    );

    return Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.05,
        padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.003, horizontal: screenHeight * 0.0002),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: copyButton,
            ),
          ],
        ));
  }
}
