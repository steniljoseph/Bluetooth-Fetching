// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:bledemo/blepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;

  @override
  initState() {
    super.initState();
    initBle();
    scan();
  }

  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  scan() async {
    if (!_isScanning) {
      scanResultList.clear();
      flutterBlue.startScan(timeout: const Duration(seconds: 4));
      flutterBlue.scanResults.listen((results) {
        scanResultList = results;
        log('printing results within the function');
        log(scanResultList.toString());
        setState(() {});
      });
    } else {
      flutterBlue.stopScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Bluetooth"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final SharedPreferences sharedPref = await SharedPreferences.getInstance();
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );

            Future.delayed(const Duration(seconds: 3)).then(
              (value) {
                return Get.off(
                  BlePage(
                    sharedPref: sharedPref,
                    result: scanResultList,
                  ),
                );
              },
            );
          },
          child: const Text("Search"),
        ),
      ),
    );
  }
}
