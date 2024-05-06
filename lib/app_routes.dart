import 'package:get/get.dart';

import './blank.dart';

import 'views/screens/setup_wallet/intro.dart';
import 'views/screens/setup_wallet/set_password.dart';
import 'views/screens/setup_wallet/show_mnemonic.dart';
import 'views/screens/setup_wallet/import_mnemonic.dart';

import './views/screens/home/home.dart';
import 'views/screens/portfolio.dart';

import './views/screens/operations/send.dart';

class AppRoutes {
  static const String BLANK = '/blank';

  static const String INTRO = '/intro';
  static const String SET_PASSWORD = '/intro/set_password';
  static const String SHOW_MNEMONIC = '/intro/show_mnemonic';
  static const String IMPORT_MNEMONIC = '/intro/import_mnemonic';

  static const String HOME = '/home';
  static const String ERC20_PORTFOLIO = '/portfolio/erc20_portfolio';
  static const String SEND = '/operations/send';

  static final routes = [
    GetPage(name: BLANK, page: () => BlankPage()),
    GetPage(name: INTRO, page: () => IntroPage()),
    GetPage(name: SET_PASSWORD, page: () => SetPasswordPage()),
    GetPage(name: SHOW_MNEMONIC, page: () => MnemonicPage()),
    GetPage(name: IMPORT_MNEMONIC, page: () => importMnemonicPage()),
    GetPage(name: HOME, page: () => HomePage()),
    GetPage(name: ERC20_PORTFOLIO, page: () => PortfolioPage()),
    GetPage(name: SEND, page: () => SendPage()),
  ];
}
