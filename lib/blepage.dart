// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:bledemo/ble_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlePage extends StatefulWidget {
  List<ScanResult> result;
  SharedPreferences sharedPref;
  BlePage({super.key, required this.result, required this.sharedPref});

  @override
  State<BlePage> createState() => _BlePageState();
}

class _BlePageState extends State<BlePage> {
  final prefs = SharedPreferences.getInstance();

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  bool _isScanning = false;

  @override
  initState() {
    super.initState();
    initBle();
    log('printing scan result lists');
    log(widget.result.toString());
  }

  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Founded Results"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              if (!_isScanning) {
                widget.result.clear();
                flutterBlue.startScan(timeout: const Duration(seconds: 4));
                flutterBlue.scanResults.listen((results) {
                  widget.result = results;
                  // setState(() {});
                });
              } else {
                flutterBlue.stopScan();
              }
            },
            child: const Text("Refresh"),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: widget.result.length,
              itemBuilder: (context, index) {
                bool redButton =
                    widget.sharedPref.getBool('${widget.result[index].device.id.id}+RED') ?? false;
                bool greenButton =
                    widget.sharedPref.getBool('${widget.result[index].device.id.id}+GREEN') ??
                        false;
                return ListTile(
                  onTap: () {
                    log(widget.result[index].toString());
                    Get.to(() => BleInfoPage(result: widget.result[index]));
                  },
                  title: Text(
                    widget.result[index].device.name.isEmpty
                        ? 'Unknown'
                        : widget.result[index].device.name,
                  ),
                  subtitle: Text(widget.result[index].device.id.id),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        onPressed: () async {
                          setState(
                            () {
                              redButton
                                  ? widget.sharedPref
                                      .setBool('${widget.result[index].device.id.id}+RED', false)
                                  : widget.sharedPref
                                      .setBool('${widget.result[index].device.id.id}+RED', true);
                            },
                          );
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: redButton ? Colors.red[900] : Colors.red[200],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(
                            () {
                              greenButton
                                  ? widget.sharedPref
                                      .setBool('${widget.result[index].device.id.id}+GREEN', false)
                                  : widget.sharedPref
                                      .setBool('${widget.result[index].device.id.id}+GREEN', true);
                            },
                          );
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: greenButton ? Colors.green[900] : Colors.green[200],
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}
