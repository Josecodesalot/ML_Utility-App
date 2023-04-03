import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ml_utility/ChatGPT/chatbot/screens/chat_screen.dart';
import 'package:ml_utility/ChatGPT/providers/chat_provider.dart';
import 'package:ml_utility/QRScanner/screens/qr_code_scanner.dart';
import 'package:ml_utility/utilities/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../ChatGPT/AI_Image_Generation/image_chat_screen.dart';
import '../ChatGPT/AI_Image_Generation/providers/image_provider.dart';
import '../Text_Recognition/screen/text_recognition_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Color(0xFF000000),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Utility App",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Raleway',
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 30.sp),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TextRecognition()));
                      },
                      child: Container(
                        height: containerDim,
                        width: containerDim,
                        margin: containerMargin,
                        padding: containerPadding,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          boxShadow: containerShadow,
                          color: containerColor,
                        ),
                        child: Center(
                          child: Text("Text Recognition",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.getFont(
                                'Raleway',
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QRCodeScanner(),
                        ),
                      ),
                      child: Container(
                        height: containerDim,
                        width: containerDim,
                        margin: containerMargin,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          boxShadow: containerShadow,
                          color: containerColor,
                        ),
                        child: Center(
                          child: Text("QR Code Scanner",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.getFont(
                                'Raleway',
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiProvider(providers: [
                        ChangeNotifierProvider(
                          create: (_) => ChatProvider(),
                        )
                      ], child: const ChatScreen()),
                    ),
                  ),
                  child: Container(
                    height: containerDim - 25,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      boxShadow: containerShadow,
                      color: containerColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/chatgpt_logo.png",
                            scale: 5.3,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            "ChatGPT",
                            style: GoogleFonts.getFont(
                              'Raleway',
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiProvider(providers: [
                        ChangeNotifierProvider(
                          create: (_) => AI_ImageProvider(),
                        )
                      ], child: const ImageChatScreen()),
                    ),
                  ),
                  child: Container(
                    height: containerDim - 25,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      boxShadow: containerShadow,
                      color: containerColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/chatgpt_logo.png",
                            scale: 5.3,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Flexible(
                            child: Text(
                              "AI Image Generation",
                              style: GoogleFonts.getFont(
                                'Raleway',
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
