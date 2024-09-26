import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:absen_jogja/component/snackbar.dart';
import 'package:absen_jogja/konstan.dart';

apiCall(String url, Map<String, dynamic> postdata, context,
    {method = "post", propName = ''}) async {
  String reply;

  HttpClient client = HttpClient();
  client.userAgent = "Flutter_";
  HttpClientRequest request;

  try {
    if (method == "post") {
      request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      // if (tokenHeader != "")
      //   request.headers.set('Authorization', 'Bearer $tokenHeader');
      request.add(utf8.encode(json.encode(postdata)));
    } else if (method == "patch") {
      request = await client.patchUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      // if (tokenHeader != "")
      //   request.headers.set('Authorization', 'Bearer $tokenHeader');
      request.add(utf8.encode(json.encode(postdata)));
    } else {
      request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      // if (tokenHeader != "")
      //   request.headers.set('Authorization', 'Bearer $tokenHeader');
    }

    log("full url $url");
    log(request.headers.toString());
    HttpClientResponse response =
        await request.close().timeout(timeoutDuration);
    reply = await response.transform(utf8.decoder).join();
    log("$url ${json.encode(postdata)}");
    log("$url $reply");
    return reply;
  } on TimeoutException catch (_) {
    showToast(
        context, 'Terjadi kesalahan $propName, mohon periksa jaringan Anda');
  } on SocketException catch (_) {
    showToast(context,
        'Terjadi kesalahan $propName, pastikan Anda terhubung ke internet');
  } on Exception catch (e) {
    showToast(context, 'Terjadi kesalahan di server');
    log(e.toString());
  }
}
