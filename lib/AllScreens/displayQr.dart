import 'package:flutter/material.dart';
import "./generateQrCode.dart";

class DisplayQr extends StatelessWidget {
  const DisplayQr({super.key});

  @override
  Widget build(BuildContext context) {
    var arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text("display"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
        height: 500,
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          QRCode(qrData: arguments["name"]),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () => {Navigator.pushNamed(context, "scanQr")},
              child: Text("Expand Network"))
        ]),
        alignment: Alignment.center,
      ),
    );
  }
}
