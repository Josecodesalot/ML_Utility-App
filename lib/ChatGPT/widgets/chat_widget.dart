import 'package:flutter/material.dart';
import 'package:ml_utility/ChatGPT/services/assets_manager.dart';
import 'package:ml_utility/ChatGPT/widgets/text_widget.dart';

import '../constants/constants.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key, required this.message, required this.index})
      : super(key: key);

  final String message;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: index == 0 ? chatGPTScaffoldColor : chatGPTCardColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    index == 0
                        ? AssetsManager.userImage
                        : AssetsManager.botLogo,
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: TextWidget(
                      label: message,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
