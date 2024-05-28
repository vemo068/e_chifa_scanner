import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String _scanBarcode = '';

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    try {
      var bdy = await json.decode(barcodeScanRes);
      try {
        DateTime dt = DateTime.parse(bdy['time']);
        int differ = dt.difference(DateTime.now()).inSeconds;

        if (differ.abs() < 60) {
          setState(() {
            _scanBarcode = "Valid QR";
          });
        } else {
          setState(() {
            _scanBarcode = "Expired QR";
          });
        }
      } catch (e) {
        setState(() {
          _scanBarcode = "Wrong QR";
        });
      }
    } catch (e) {
      setState(() {
        _scanBarcode = "Wrong QR";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('E-CHIFA Scanner')),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlinedButton(
                    onPressed: () => scanQR(),
                    child: const Text('Start E-CHIFA scan')),
                Text('Scan result : $_scanBarcode\n',
                    style: const TextStyle(fontSize: 20))
              ]),
        ),
      ),
    );
  }
}

class TrueResaultPage extends StatelessWidget {
  const TrueResaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("True"),
      ),
    );
  }
}
