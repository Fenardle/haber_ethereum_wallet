import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haber/views/screens/operations/send.dart';
import './operations/issue.dart';
import './operations/propose.dart';
import '../components/network_list.dart';
import '../components/account_list.dart';
import '../components/erc20_list.dart';
import '../components/transaction_list.dart';
import '../../controller/current_token_controller.dart';
import '../../controller/account_controller.dart';
import '../../controller/network_controller.dart';
import '../components/avatar.dart';

class PortfolioPage extends StatefulWidget {
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final accountController = Get.find<AccountController>();
  final networkController = Get.find<NetworkController>();
  int segmentedControlGroupValue = Get.arguments ?? 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.bars,
              color: Color.fromRGBO(75, 124, 146, 1.0)),
          onPressed: () {
            // Add your menu button's functionality here
          },
        ),
        middle: FittedBox(
          fit: BoxFit.scaleDown,
          child: _buildNetworkButton(context),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.qrcode,
              color: Color.fromRGBO(75, 124, 146, 1.0)),
          onPressed: () {
            // Add your QR button's functionality here
          },
        ),
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildNetworkButton(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        // Show a modal bottom sheet with a list of networks
        await showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return networkListWidget();
          },
        );
      },
      child: _buildNetworkIcon(),
    );
  }

  Widget _buildNetworkIcon() {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 240, 240, 247),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                networkController.selectedNetwork.value.logo,
                height: 18, // Adjust the size as needed
              ),
              SizedBox(width: 8), // Add some space between the logo and text
              Text(
                networkController.selectedNetwork.value.name + ' ',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (accountController.currentAccount.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                await accountController.fetchTokens();
              },
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _buildAccountButton(context),
                  SizedBox(height: 10),
                  _buildAccountInfo(),
                  _buildOperationMenu(),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildMenu(),
                    SizedBox(height: 10),
                    segmentedControlGroupValue == 0
                        ? ERC20ListWidget()
                        : TransactionList()
                  ],
                ),
              ),
            ),
          ],
        );
      }
    });
  }

  Widget _buildMenu() {
    return CupertinoSlidingSegmentedControl<int>(
      children: const {
        0: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Token'),
        ),
        1: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('History'),
        ),
      },
      onValueChanged: (int? value) {
        if (value != null) {
          setState(() {
            segmentedControlGroupValue = value;
          });
        }
      },
      groupValue: segmentedControlGroupValue,
      thumbColor: CupertinoColors.lightBackgroundGray,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildAccountButton(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        // Show a modal bottom sheet with a list of networks
        await showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return accountListWidget();
          },
        );
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
            color: CupertinoColors.lightBackgroundGray,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: buildAccountAvatar(accountController)),
    );
  }

  Widget _buildAccountInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () => Text(
            '${accountController.nativeTokenBalance} ${networkController.selectedNetwork.value.symbol}',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 2.0),
        _buildPublicKeyButton(),
      ],
    );
  }

  Widget _buildPublicKeyButton() {
    String truncateText(String text) {
      if (text.length <= 10) {
        return text;
      }
      return text.substring(0, 6) + '...' + text.substring(text.length - 4);
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Clipboard.setData(
            ClipboardData(text: accountController.currentAccount));
        Get.snackbar(
          'Copied',
          'Public key has been copied',
          backgroundColor: CupertinoColors.activeGreen,
          colorText: CupertinoColors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          truncateText(accountController.currentAccount),
          style: const TextStyle(
              fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildIconButton(
      IconData iconData, String text, void Function() onPressed) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 0,
        onPressed: onPressed,
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(75, 124, 146, 1.0)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      iconData,
                      color: Colors.white,
                      size: 20,
                    )),
              ),
            ),
            Text(
              text,
              style: TextStyle(
                  color: Color.fromRGBO(75, 124, 146, 1.0), fontSize: 12),
            )
          ],
        ));
  }

  Widget _buildOperationMenu() {
    double indent = 20;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconButton(
              CupertinoIcons.arrow_up_right, 'Send', () => Get.to(SendPage())),
          SizedBox(width: indent),
          _buildIconButton(
              CupertinoIcons.add, 'Issue', () => Get.to(IssuePage())),
          SizedBox(width: indent),
          _buildIconButton(
              CupertinoIcons.arrow_up, 'Propose', () => Get.to(ProposePage())),
        ],
      ),
    );
  }
}
