import 'package:flutter/cupertino.dart';

class BlankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        // Customize the navigation bar if needed
        middle: Text('Test Only'),
      ),
      child: SafeArea(
        child: Container(
            // Add your page content here
            ),
      ),
    );
  }
}
