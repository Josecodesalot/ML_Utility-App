import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ml_utility/pages/text_recognition_page.dart';
import 'package:ml_utility/utilities/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isPermissionGranted = false;

  late final Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Color(0xFFFC96FF),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                    Container(
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
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: containerDim,
                      width: containerDim,
                      margin: containerMargin,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        boxShadow: containerShadow,
                        color: containerColor,
                      ),
                      child: Text(_isPermissionGranted.toString()),
                    ),
                    Container(
                      height: containerDim,
                      width: containerDim,
                      margin: containerMargin,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        boxShadow: containerShadow,
                        color: containerColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
