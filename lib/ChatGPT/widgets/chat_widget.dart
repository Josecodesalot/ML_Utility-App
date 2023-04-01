import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ml_utility/ChatGPT/services/assets_manager.dart';
import 'package:ml_utility/ChatGPT/widgets/text_widget.dart';

import '../constants/constants.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {Key? key,
      required this.message,
      required this.role,
      required this.animateIndex})
      : super(key: key);

  final String message;
  final String role;
  final int animateIndex;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: role == "user" ? chatGPTScaffoldColor : chatGPTCardColor,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 4.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          role == "user"
                              ? AssetsManager.userImage
                              : AssetsManager.botLogo,
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: (role == "user" || animateIndex == 0)
                              ? TextWidget(
                                  label: message,
                                )
                              : DefaultTextStyle(
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  child: AnimatedTextKit(
                                    displayFullTextOnTap: true,
                                    isRepeatingAnimation: false,
                                    totalRepeatCount: 1,
                                    animatedTexts: [
                                      TyperAnimatedText(message.trim())
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.topRight,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: message)).then(
                        (value) => Fluttertoast.showToast(
                          msg: "Copied to Clipboard",
                          gravity: ToastGravity.BOTTOM,
                          textColor: Colors.white,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.copy_outlined,
                      color: Colors.white,
                      size: 20,
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
