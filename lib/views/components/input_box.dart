import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class _InputBox extends StatefulWidget {
  final String hintText;
  final TextEditingController textEditingController;

  _InputBox({required this.hintText, required this.textEditingController});

  @override
  _InputBoxState createState() => _InputBoxState();
}

class _InputBoxState extends State<_InputBox> {
  final RxBool _isFocused = false.obs;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      _isFocused.value = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    Row hint = Row(
      children: [
        Text(
          widget.hintText,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );

    return Column(
      children: [
        hint,
        SizedBox(height: screenHeight * 0.005),
        Obx(() {
          return CupertinoTextField(
            controller: widget.textEditingController,
            focusNode: _focusNode,
            obscureText: true,
            decoration: BoxDecoration(
              border: Border.all(
                color: _isFocused.value
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.inactiveGray,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            onTap: () => _focusNode.requestFocus(),
          );
        }),
      ],
    );
  }
}

Widget buildInputBox(
    String hintText, TextEditingController textEditingController) {
  return _InputBox(
    hintText: hintText,
    textEditingController: textEditingController,
  );
}
