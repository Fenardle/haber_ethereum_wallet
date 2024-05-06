import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'set_password.dart';
import 'import_mnemonic.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'HABER',
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w100,
                fontSize: 30,
              ),
            ),
            const Flexible(
              child: FractionallySizedBox(
                heightFactor: 1,
              ),
            ),
            CupertinoButton.filled(
              onPressed: () => Get.to(importMnemonicPage()),
              child: const Text('Import from existing wallet'),
              borderRadius: BorderRadius.all(Radius.circular(999.0)),
            ),
            const Flexible(
              child: FractionallySizedBox(
                heightFactor: 0.1,
              ),
            ),
            CupertinoButton(
              onPressed: () => Get.to(SetPasswordPage()),
              child: const Text('Create a new wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
