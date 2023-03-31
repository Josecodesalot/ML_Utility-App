import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ml_utility/ChatGPT/providers/models_provider.dart';
import 'package:ml_utility/ChatGPT/services/assets_manager.dart';
import 'package:ml_utility/ChatGPT/services/network_helper.dart';
import 'package:ml_utility/ChatGPT/widgets/chat_widget.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/chat_model.dart';

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

  List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelsProvider>(context, listen: false);
    return FutureBuilder(
      future: modelProvider.testConnection(),
      builder: (context, snapshot) {
        if (snapshot.data == false || snapshot.hasError) {
          return Scaffold(
            backgroundColor: chatGPTScaffoldColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset("assets/images/error_illustrate.png"),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text("Whoops! ChatGPT threw us an error",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'Raleway',
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      )),
                  Text("Please try again later",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'Raleway',
                        textStyle: const TextStyle(
                            color: Colors.white30,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      )),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data == true) {
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
                      controller: _listScrollController,
                      itemBuilder: (context, index) {
                        return ChatWidget(
                          message: chatList[index].message,
                          index: chatList[index].chatIndex,
                        );
                      },
                      itemCount: chatList.length,
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
                                  await sendMessage(
                                      modelProvider: modelProvider);
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
                                await sendMessage(modelProvider: modelProvider);
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
          );
        }

        return Scaffold(
          backgroundColor: chatGPTScaffoldColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Colors.white),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Powering Up ChatGPT",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Raleway',
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> sendMessage({required ModelsProvider modelProvider}) async {
    try {
      setState(() {
        _isTyping = true;
        chatList
            .add(ChatModel(message: _textEditingController.text, chatIndex: 0));
        focusNode.unfocus();
      });

      log(_textEditingController.text);

      chatList.addAll(await NetworkHelper.postQuery(
        prompt: _textEditingController.text,
        modelId: modelProvider.getCurrentModel,
      ));
    } catch (error) {
      log(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        scrollListToEnd();
        _textEditingController.clear();
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
