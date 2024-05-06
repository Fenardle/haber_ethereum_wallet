import 'package:get/get.dart';

import '../services/token_info_service.dart';

import '../classes/token.dart';
import './network_controller.dart';
import './account_controller.dart';

class CurrentTokenController extends GetxController {
  final networkController = Get.find<NetworkController>();
  final Rx<FungibleToken> _currentToken = FungibleToken(
          contractAddress: '',
          tokenBalance: 0,
          tokenDecimals: 0,
          tokenName: '',
          tokenSymbol: '',
          tokenLogoURL: '')
      .obs;

  late TokenInfoService tokenInfoService;

  @override
  void onInit() {
    super.onInit();
    tokenInfoService =
        TokenInfoServiceImpl(uri: networkController.selectedNetwork.value.url);
  }

  FungibleToken get currentToken => _currentToken.value;

  set currentToken(FungibleToken value) {
    // Update the accountController.currentAccount variable and trigger a refresh of the token list data
    _currentToken.value = value;
  }
}
