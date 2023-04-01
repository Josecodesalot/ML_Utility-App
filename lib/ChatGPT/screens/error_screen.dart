import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: chatGPTScaffoldColor,
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
        title: const Text("ChatGPT"),
      ),
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
            Text(
              "Please try again later",
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'Raleway',
                textStyle: const TextStyle(
                    color: Colors.white30,
                    fontSize: 15,
                    fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            create: (_) => ChatProvider(),
                          )
                        ],
                        child: const ChatScreen(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10A37F),
                ),
                child: Text(
                  "Try Again",
                  style: GoogleFonts.getFont(
                    'Raleway',
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
