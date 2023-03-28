import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ml_utility/ChatGPT/services/assets_manager.dart';
import 'package:ml_utility/ChatGPT/widgets/chat_widget.dart';
import 'package:ml_utility/utilities/constants.dart';

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
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF444654),
      appBar: AppBar(
        backgroundColor: chatGPTAppBarColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Image.asset(AssetsManager.chatgptLogo),
        ),
        elevation: 7.0,
        title: Text("ChatGPT"),
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
                  return const ChatWidget();
                },
                itemCount: 6,
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18.0,
              )
            ],
            SizedBox(
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
                      onPressed: () {},
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
