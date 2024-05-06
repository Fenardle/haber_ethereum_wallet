import 'package:flutter/cupertino.dart';

Future<String?> showPasswordInputDialog(BuildContext context) async {
  String? password;
  return showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Enter Password'),
        content: CupertinoTextField(
          obscureText: true,
          placeholder: 'Password',
          onChanged: (value) {
            password = value;
          },
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, null),
            child: Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, password),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
