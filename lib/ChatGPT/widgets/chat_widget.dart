import 'package:flutter/material.dart';
import 'package:ml_utility/ChatGPT/services/assets_manager.dart';
import 'package:ml_utility/utilities/constants.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: chatGPTCardColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  AssetsManager.userImage,
                  height: 35,
                  width: 35,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
