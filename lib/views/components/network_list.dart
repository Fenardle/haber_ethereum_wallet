import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haber/classes/token.dart';
import '../../controller/network_controller.dart';
import '../screens/token_detail.dart';
import 'avatar.dart';

class networkListWidget extends StatelessWidget {
  final networkController = Get.find<NetworkController>();

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text('Select Network'),
      actions: [
        for (Network network in networkController.networks)
          CupertinoActionSheetAction(
            onPressed: () {
              networkController.selectNetwork(network);
              Navigator.pop(context);
            },
            child: _buildNetworkInfo(network),
          ),
        // CupertinoActionSheetAction(
        //   onPressed: () {
        //     // Do something with the selected network
        //     //Get.to(TokenDetailPage(network));
        //     Navigator.pop(context);
        //   },
        //   child: _buildAddNetwork(),
        // ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Cancel'),
        isDefaultAction: true,
      ),
    );
  }

  Widget _buildNetworkInfo(Network network) {
    return Row(
      children: [
        SizedBox(height: 30.0, width: 16),
        SvgPicture.asset(network.logo, height: 25),
        SizedBox(width: 10),
        Text(
          network.name,
          style: TextStyle(
              color:
                  network.name == networkController.selectedNetwork.value.name
                      ? CupertinoColors.activeBlue
                      : Colors.black),
        ),
      ],
    );
  }

  Widget _buildAddNetwork() {
    return Row(
      children: const [
        SizedBox(height: 30.0, width: 12),
        Icon(CupertinoIcons.add, color: Colors.black, size: 25),
        SizedBox(width: 10),
        Text(
          'New network',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
