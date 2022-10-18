import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


Widget deviceName(ScanResult r) {
  String name = '';

  if (r.device.name.isNotEmpty) {
    name = r.device.name;
  } else if (r.advertisementData.localName.isNotEmpty) {
    name = r.advertisementData.localName;
  } else {
    name = 'Unknown';
  }
  return Text(name);
}



  
