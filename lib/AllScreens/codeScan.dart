import 'dart:developer';
import 'dart:io';
import 'package:puppeteer/puppeteer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  _connect() async {
    var name = "Manju Hangaragi";
    var email = "jiiroueeda@gmail.com";
    var pass = "Save@1234";
    var id = "h-saini";
    var note = 'Hi! I want to connect with you.' + 'a';

    print("here1");

    var browser = await puppeteer.launch();

    print("here2");

    // Open a new tab
    var page = await browser.newPage();

    print("here3");

    // Go to a page and wait to be fully loaded
    await page.goto('https://www.linkedin.com/login', wait: Until.networkIdle);

    print("here4");

    // Do something... See other examples
    await page.evaluate(r'''(email) => {
      return document.getElementById("username").value = email;
  }''', args: [email]);

    await page.evaluate(r'''(pass) => {
    return document.getElementById("password").value = pass;
  }''', args: [pass]);

    // await page.$eval('".btn__primary--large", elem => elem.click()');

    await page.evaluate(r'''() => {
    const data = document.getElementsByClassName("btn__primary--large");
    data.click();
    return "";
  }''');

    print("here5");

    await Future.delayed(const Duration(seconds: 3));

    await page.goto("https://www.linkedin.com/in/$id");

    await page.evaluate(r'''(name) => {
    try {
      const str = "Invite " + name.split(" ")[0];
      let dt = 0;
      const data = document.querySelectorAll('button');
    
      for (let i=0; i<data.length; i++) {
        let d = data[i].ariaLabel === null? "" : data[i].ariaLabel.split(" ")[0] + " " + data[i].ariaLabel.split(" ")[1];
        console.log(d+" "+str);
        if ((d === str) && (dt!=0)) {
          data[i].click();
          return "";
        } else if (d === str) {
          dt = 1;
        }
      }
      return "";
    } catch(err) {
      console.log("Error is "+err);
      return "";
    }
  }''', args: [name]);

    print("here6");

    await page.evaluate(r'''() => {
    const data = document.querySelectorAll('button')[2];
    data.click();
    return "";
  }''');

    await page.evaluate(r'''() => {
    const data = document.querySelectorAll('button')[2];
    data.click();
    return "";
  }''');

    print("here7");

    // Gracefully close the browser's process
    await browser.close();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan")),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(onPressed: _connect, child: Text("Connect"))
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
