import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ml_utility/ChatGPT/providers/models_provider.dart';
import 'package:ml_utility/ChatGPT/services/assets_manager.dart';
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
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ModelsProvider provider = ModelsProvider();
    return FutureBuilder(
      future: provider.getAllModels(),
      builder: (context, snapshot) {
        if (snapshot.data == [] ||
            snapshot.hasError ||
            (snapshot.hasData && snapshot.data!.isEmpty)) {
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
        if (snapshot.hasData && snapshot.data != []) {
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
                          index: int.parse(
                              chatMessages[index]["chatIndex"].toString()),
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
                              print(provider.getModelList);
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
                Text("Powering Up ChatGPT",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      'Raleway',
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
