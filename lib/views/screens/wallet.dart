import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './operations/send.dart';
import './portfolio.dart';

class PortfolioWithSendPage extends StatefulWidget {
  @override
  _PortfolioWithSendPageState createState() => _PortfolioWithSendPageState();
}

class _PortfolioWithSendPageState extends State<PortfolioWithSendPage> {
  bool _showSendPage = false;

  void _toggleSendPage() {
    setState(() {
      _showSendPage = !_showSendPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PortfolioPage(),
        if (_showSendPage)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context)
                .size
                .height, // Set the desired height for the SendPage
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.down,
              onDismissed: (direction) {
                _toggleSendPage(); // Hide the SendPage when dismissed
              },
              child: SendPage(),
            ),
          ),
      ],
    );
  }
}
