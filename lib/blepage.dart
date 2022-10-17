import 'dart:developer';

import 'package:bledemo/ble_info.dart';
import 'package:bledemo/save_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlePage extends StatefulWidget {
  List<ScanResult> result;
  BlePage({super.key, required this.result});

  @override
  State<BlePage> createState() => _BlePageState();
}

class _BlePageState extends State<BlePage> {
  final prefs = SharedPreferences.getInstance();

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  bool _isScanning = false;
  bool isFav = false;
  bool isStar = false;
  List<String> favDataList = [];
  List<String> starDataList = [];
  List<String> bluetoothID = [];

  @override
  initState() {
    super.initState();
    initBle();
    bluetoothID = SharedPrefrenceModel.getStringList('bluetoothID');
    print('printing scan result lists');
    print(widget.result);
  }

  // saveItems() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   sharedPreferences.setString('bluetoothID', favDataList as String);
  // }

  // getSaveItems() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   sharedPreferences.getString('bluetoothID');
  // }

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
                          final SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          setState(() {
                            sharedPreferences.setStringList('bluetoothID',
                                [widget.result[index].device.id.id]);
                            log("+++++++++++++++++++++++++++++++++++");
                            log(bluetoothID.toString());
                            bluetoothID.isNotEmpty
                                ? bluetoothID.toSet().contains(
                                        widget.result[index].device.id.id)
                                    ? bluetoothID.toSet().remove(
                                        widget.result[index].device.id.id)
                                    : bluetoothID
                                        .toSet()
                                        .add(widget.result[index].device.id.id)
                                : [];
                            isFav = !isFav;
                          });
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: favDataList
                                  .contains(widget.result[index].device.id.id)
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            starDataList
                                    .contains(widget.result[index].device.id.id)
                                ? starDataList
                                    .remove(widget.result[index].device.id.id)
                                : starDataList
                                    .add(widget.result[index].device.id.id);
                            // isFav = !isFav;
                          });
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: starDataList
                                  .contains(widget.result[index].device.id.id)
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                      // StatefulBuilder(
                      //   builder: (BuildContext context,
                      //       void Function(void Function()) setState) {
                      //     return IconButton(
                      //       onPressed: () {
                      //         favDataList
                      //             .add(widget.result[index].device.id.id);
                      //         setState;
                      //         log(favDataList.toSet().toString());
                      //       },
                      //       icon: favDataList
                      //               .contains(widget.result[index].device.id.id)
                      //           ? const Icon(
                      //               Icons.favorite,
                      //               size: 35,
                      //               color: Colors.red,
                      //             )
                      //           : const Icon(
                      //               Icons.favorite_border,
                      //               size: 35,
                      //             ),
                      //     );
                      //   },
                      // ),
                      // StatefulBuilder(
                      //   builder: (BuildContext context,
                      //       void Function(void Function()) setState) {
                      //     return IconButton(
                      //       onPressed: () {
                      //         favDataList
                      //             .add(widget.result[index].device.id.id);
                      //         log(favDataList.toSet().toString());
                      //       },
                      //       icon: favDataList
                      //               .contains(widget.result[index].device.id.id)
                      //           ? const Icon(
                      //               Icons.favorite,
                      //               size: 35,
                      //               color: Colors.red,
                      //             )
                      //           : const Icon(
                      //               Icons.favorite_border,
                      //               size: 35,
                      //             ),
                      //     );
                      //   },
                      // ),
                      // FavoriteButton(
                      //   isFavorite: isFav,
                      //   valueChanged: (_favData) {
                      //     favDataList.add(widget.result[index]);
                      //     log(favDataList.toSet().toString());
                      //     print("fav data $_favData");
                      //   },
                      // ),
                      // StarButton(
                      //   isStarred: isStar,
                      //   valueChanged: (_starData) {
                      //     starDataList.add(widget.result[index]);
                      //     print("fav data $_starData");
                      //   },
                      // ),
                      // Switch(
                      //   value: isOn,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       isOn = value;
                      //     });
                      //   },
                      // ),
                      // Switch(
                      //   value: isOn,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       isOn = value;
                      //     });
                      //   },
                      // ),
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
