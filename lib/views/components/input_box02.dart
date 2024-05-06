import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class InputBox extends StatefulWidget {
  final String placeholder;
  final TextEditingController textEditingController;

  InputBox({required this.placeholder, required this.textEditingController});

  @override
  _InputBoxState createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
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
    return Obx(
      () => Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: _isFocused.value
                ? CupertinoColors.activeBlue
                : CupertinoColors.inactiveGray,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: CupertinoTextField(
          padding: EdgeInsets.all(10.0),
          placeholder: widget.placeholder,
          keyboardType: TextInputType.text,
          focusNode: _focusNode,
          controller: widget.textEditingController,
        ),
      ),
    );
  }
}
