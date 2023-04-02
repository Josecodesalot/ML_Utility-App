import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/src/objects/barcode.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanResult extends StatelessWidget {
  final List<Barcode> barcodes;

  const ScanResult({Key? key, required this.barcodes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F3E3E),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(50.0),
          height: 550,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueGrey, width: 3.0),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: barcodes[0].rawValue.toString(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, elevation: 1.9),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.copy_outlined,
                          color: Colors.black,
                          size: 20.0,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Copy Text",
                          style: GoogleFonts.getFont('Raleway',
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              SelectableLinkify(
                text: barcodes[0].rawValue.toString(),
                textAlign: TextAlign.start,
                options: const LinkifyOptions(humanize: false),
                onOpen: (link) async {
                  try {
                    await launchUrl(Uri.parse(link.url));
                  } catch (error) {
                    Fluttertoast.showToast(msg: "Failed to launch");
                    log('Could not launch $link');
                    log(error.toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
