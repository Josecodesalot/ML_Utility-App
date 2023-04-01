import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ml_utility/ChatGPT/providers/chat_provider.dart';
import 'package:ml_utility/ChatGPT/screens/error_screen.dart';
import 'package:ml_utility/ChatGPT/services/assets_manager.dart';
import 'package:ml_utility/ChatGPT/services/network_helper.dart';
import 'package:ml_utility/ChatGPT/widgets/chat_widget.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController _textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _listScrollController = ScrollController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _listScrollController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) => Scaffold(
        backgroundColor: chatGPTScaffoldColor,
        appBar: AppBar(
          backgroundColor: chatGPTAppBarColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image.asset(AssetsManager.chatgptLogo),
          ),
          elevation: 7.0,
          title: const Text("ChatGPT"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  controller: _listScrollController,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      message: chatProvider.getQuery(index).content,
                      role: chatProvider.getQuery(index).role,
                    );
                  },
                  itemCount: chatProvider.getChatList.length,
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
                          focusNode: focusNode,
                          controller: _textEditingController,
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: (value) async {
                            if (_textEditingController.text.isNotEmpty) {
                              await sendMessage(chatProvider);
                            }
                          },
                          decoration: const InputDecoration.collapsed(
                              hintText: "How can I help you?",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (_textEditingController.text.isNotEmpty) {
                            await sendMessage(chatProvider);
                          }
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
      ),
    );
  }

  Future<void> sendMessage(ChatProvider chatProvider) async {
    try {
      String content = _textEditingController.text;
      chatProvider.addMessage(
        message: content,
        role: "user",
      );
      setState(() {
        _isTyping = true;
        focusNode.unfocus();
        _textEditingController.clear();
      });

      log(_textEditingController.text);

      bool status =
          await NetworkHelper.chatQuery(chatProvider.getChatList, chatProvider);
      if (!status) {
        throw const HttpException("Error");
      }
    } catch (error) {
      log(error.toString());
      const ErrorScreen();
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
    }
  }

  void scrollListToEnd() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeIn,
    );
  }
}
