import 'package:flutter_app/AllScreens/FormScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'aNT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FormScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        "qrPage": (context) => DisplayQr(),
        "scanQr": (context) => QRScan()
      },
    );
  }
}
