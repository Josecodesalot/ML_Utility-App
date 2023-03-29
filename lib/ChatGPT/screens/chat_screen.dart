import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ml_utility/ChatGPT/constants/api_constants.dart';
import 'package:ml_utility/ChatGPT/services/assets_manager.dart';
import 'package:ml_utility/ChatGPT/services/network_helper.dart';
import 'package:ml_utility/ChatGPT/widgets/chat_widget.dart';

import '../constants/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final bool _isTyping = true;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    NetworkHelper.getModels();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: chatGPTScaffoldColor,
      appBar: AppBar(
        backgroundColor: chatGPTAppBarColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Image.asset(AssetsManager.chatgptLogo),
        ),
        elevation: 7.0,
        title: const Text("ChatGPT"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ChatWidget(
                    message: chatMessages[index]["msg"].toString(),
                    index:
                        int.parse(chatMessages[index]["chatIndex"].toString()),
                  );
                },
                itemCount: chatMessages.length,
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18.0,
              )
            ],
            const SizedBox(
              height: 8.0,
            ),
            Material(
              color: chatGPTCardColor,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, top: 10, bottom: 10.0, right: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        style: const TextStyle(color: Colors.white),
                        onSubmitted: (value) {
                          //TODO On Submit
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you?",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        print(models);
                      },
                      icon: const Icon(
                        Icons.send_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
