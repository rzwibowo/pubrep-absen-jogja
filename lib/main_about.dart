import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:absen_jogja/konstan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => AboutState();
}

class AboutState extends State<About> {
  String _versi = '0.0.0';
  bool showToken = false;
  TextEditingController tToken = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getVersi();
    // _getToken();
  }

  void _getVersi() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _versi = info.version;
      });
    }
  }

  // void _getToken() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   tToken.text = prefs.getString('fcm') ?? '-';
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("About"),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height - 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_square.png',
                  width: 200,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    'Absen Yogyakarta',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: tColorPrimary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    'Versi $_versi',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                InkWell(
                  // onLongPress: () => setState(() {
                  //   showToken = !showToken;
                  // }),
                  child: Text(
                    '© 2023 - ${DateFormat('yyyy').format(DateTime.now()) == "2023" ? "Now" : DateFormat('yyyy').format(DateTime.now())} kanca.dev',
                    style:
                        const TextStyle(fontSize: 12, color: tTextColorThird),
                  ),
                ),
                // Visibility(
                //     visible: showToken,
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: TextField(
                //         controller: tToken,
                //         keyboardType: TextInputType.multiline,
                //         maxLines: 3,
                //         readOnly: true,
                //       ),
                //     ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
