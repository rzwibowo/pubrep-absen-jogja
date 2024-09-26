import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:absen_jogja/helper/api_call.dart';
import 'package:absen_jogja/konstan.dart';
import 'package:absen_jogja/model/m_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderSetting with ChangeNotifier {
  Future bssid({@required context}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? idToko = pref.getInt('id_toko');

    String reply = await apiCall(
      '${baseUrl}api/general/setting/attendance-bssid/$idToko',
      {},
      context,
      method: "get",
    );

    // Map decoded = jsonDecode(reply);
    // if (decoded['result'] == 1) {}
    return jsonDecode(reply);
  }
}
