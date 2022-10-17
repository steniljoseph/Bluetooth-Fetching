import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Widget deviceMacAddress(ScanResult r) {
  return Text(r.device.id.id);
}

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

Widget deviceSignal(ScanResult r) {
  return Text(r.rssi.toString());
}

  
// Widget listItem(ScanResult r) {
//   return ListTile(
//     // onTap: () => onTap(r),
//     onTap: () => log(r.advertisementData.localName),
//     // leading: leading(r),
//     title: deviceName(r),
//     subtitle: deviceMacAddress(r),
//     trailing: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Checkbox(
//           value: false,
//           onChanged: (value) {
//             value = true;
//           },
//         )
//       ],
//     ),
//     // trailing: deviceSignal(r),
//   );
// }
