import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:random_avatar/random_avatar.dart';

class WalletController extends GetxController {
  final RxString toAddress = ''.obs;
  final RxBool isAddressValid = false.obs;

  bool validateAddress(String address) {
    try {
      EthereumAddress.fromHex(address);
      return true;
    } catch (e) {
      return false;
    }
  }

  void updateToAddress(String newAddress) {
    isAddressValid.value = validateAddress(newAddress);
    if (isAddressValid.value) {
      toAddress.value = newAddress;
    } else {
      Get.snackbar('Invalid Address', 'Please enter a valid Ethereum address');
    }
  }

  void clearAddress() {
    toAddress.value = '';
    isAddressValid.value = false;
  }
}

class ToInputBox extends StatelessWidget {
  final WalletController walletController = Get.put(WalletController());
  final RxBool _isFocused = false.obs;
  final TextEditingController textEditingController;

  ToInputBox({super.key, required this.textEditingController});

  Widget _buildAddressInfo(FocusNode _focusNode) {
    return Row(
      children: [
        SizedBox(width: 8),
        RandomAvatar(walletController.toAddress.value, height: 30),
        SizedBox(width: 10),
        Text(
          truncateText(walletController.toAddress.value),
          style: TextStyle(fontSize: 18),
        ),
        Spacer(),
        Icon(
          CupertinoIcons.check_mark_circled_solid,
          color: CupertinoColors.systemGreen,
          size: 20,
        ),
        CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              CupertinoIcons.xmark,
              size: 20,
              color: CupertinoColors.inactiveGray,
            ),
            onPressed: () {
              walletController.clearAddress();
              _focusNode.requestFocus();
            }),
      ],
    );
  }

  String truncateText(String text) {
    if (text.length <= 14) {
      return text;
    }
    return text.substring(0, 10) + '...' + text.substring(text.length - 4);
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _focusNode = FocusNode();
    _focusNode.addListener(() {
      _isFocused.value = _focusNode.hasFocus;
    });

    return Obx(() {
      if (walletController.isAddressValid.value) {
        return Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: CupertinoColors.inactiveGray,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: _buildAddressInfo(_focusNode));
      } else {
        return Container(
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
            placeholder: 'Ethereum address(0x)',
            keyboardType: TextInputType.text,
            focusNode: _focusNode,
            controller: textEditingController,
            onChanged: (value) => walletController.updateToAddress(value),
          ),
        );
      }
    });
  }
}
