import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constants.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
