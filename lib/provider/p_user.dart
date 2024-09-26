import 'package:flutter/material.dart';
import 'package:absen_jogja/helper/api_call.dart';
import 'package:absen_jogja/konstan.dart';
import 'package:absen_jogja/model/m_user.dart';

class ProviderUser with ChangeNotifier {
  Future<LoginModel> login(
      {@required username,
      @required password,
      // @required token,
      @required context}) async {
    final Map<String, dynamic> postdata = {
      'username': username,
      'password': password,
      // 'token': token
    };
    // SharedPreferences pref = await SharedPreferences.getInstance();

    String reply = await apiCall(
      '${baseUrl}api/mobile/login',
      postdata,
      context,
      method: "post",
    );

    print(postdata);

    // Map decoded = jsonDecode(reply);
    // if (decoded['result'] == 1) {}
    return usersModelFromJson(reply);
  }
}
