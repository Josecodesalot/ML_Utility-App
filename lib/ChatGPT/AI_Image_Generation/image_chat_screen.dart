import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ml_utility/ChatGPT/AI_Image_Generation/providers/image_provider.dart';
import 'package:ml_utility/ChatGPT/widgets/chat_widget.dart';
import 'package:ml_utility/ChatGPT/widgets/image_widget.dart';
import 'package:provider/provider.dart';

import '../chatbot/screens/error_screen.dart';
import '../constants/constants.dart';
import '../services/network_helper.dart';

class ImageChatScreen extends StatefulWidget {
  const ImageChatScreen({Key? key}) : super(key: key);

  @override
  State<ImageChatScreen> createState() => _ImageChatScreenState();
}

class _ImageChatScreenState extends State<ImageChatScreen> {
  bool _isLoading = false;
  late String url;
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
    return Scaffold(
      backgroundColor: chatGPTScaffoldColor,
      appBar: AppBar(
        backgroundColor: chatGPTAppBarColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20.0,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        elevation: 7.0,
        title: const Text("AI Image Generation"),
      ),
      body: Consumer<AI_ImageProvider>(
        builder: (context, imageProvider, child) => Scaffold(
          backgroundColor: chatGPTScaffoldColor,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ListView.builder(
                    controller: _listScrollController,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          imageProvider.getQuery(index).role == "user"
                              ? ChatWidget(
                                  message: imageProvider.getQuery(index).prompt,
                                  role: "user",
                                  animateIndex: 0)
                              : ImageWidget(
                                  url: imageProvider.getQuery(index).url),
                        ],
                      );
                    },
                    itemCount: imageProvider.chatList.length,
                  ),
                ),
                if (_isLoading) ...[
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
                              if (_textEditingController.text.isNotEmpty &&
                                  !_isLoading) {
                                await sendMessage(imageProvider: imageProvider);
                              }
                            },
                            decoration: const InputDecoration.collapsed(
                                hintText: "How can I help you?",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (_textEditingController.text.isNotEmpty &&
                                !_isLoading) {
                              await sendMessage(imageProvider: imageProvider);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendMessage({required AI_ImageProvider imageProvider}) async {
    bool status;
    try {
      String prompt = _textEditingController.text;
      setState(() {
        imageProvider.addImageMessage(prompt: prompt, url: "", role: "user");
        _isLoading = true;
        focusNode.unfocus();
        _textEditingController.clear();
      });

      log(_textEditingController.text);

      status = await NetworkHelper.requestImage(
          prompt: prompt, context: context, imageProvider: imageProvider);
      if (!status) {
        throw const HttpException("Error");
      }
    } catch (error) {
      log(error.toString());
      const ErrorScreen();
    } finally {
      setState(
        () {
          _isLoading = false;
        },
      );
    }
  }
}
