import 'dart:convert';

import 'package:absen_jogja/model/m_histori.dart';
import 'package:flutter/material.dart';
import 'package:absen_jogja/helper/api_call.dart';
import 'package:absen_jogja/konstan.dart';

class ProviderAbsen with ChangeNotifier {
  Future absen(
      {@required idToko,
      @required idUser,
      @required tipeAbsen,
      @required context}) async {
    final Map<String, dynamic> postdata = {
      'idUser': idUser,
      'idToko': idToko,
      'tipeAbsen': tipeAbsen
    };
    // SharedPreferences pref = await SharedPreferences.getInstance();

    String reply = await apiCall(
      '${baseUrl}api/user/attendance',
      postdata,
      context,
      method: "post",
    );

    // Map decoded = jsonDecode(reply);
    // if (decoded['result'] == 1) {}
    return json.decode(reply);
  }

  Future<List<ItemHistoriAbsen>> historiAbsen(
      {@required idUser,
      @required tglAwal,
      @required tglAkhir,
      @required context}) async {
    List<ItemHistoriAbsen> isi = [];
    final Map<String, dynamic> postdata = {
      'idUser': idUser,
      'tanggalAwal': tglAwal,
      'tanggalAkhir': tglAkhir
    };
    // SharedPreferences pref = await SharedPreferences.getInstance();

    String reply = await apiCall(
      '${baseUrl}api/user/attendance-history',
      postdata,
      context,
      method: "post",
    );

    json.decode(reply).forEach((element) {
      isi.add(ItemHistoriAbsen.fromJson(element));
    });

    // Map decoded = jsonDecode(reply);
    // if (decoded['result'] == 1) {}
    return isi;
  }
}
