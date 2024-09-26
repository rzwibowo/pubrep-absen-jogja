import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:absen_jogja/konstan.dart';
import 'package:absen_jogja/main_about.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avatars/avatars.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String nama = '';
  String namaToko = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void _gotoLogin() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _gotoAbout() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const About();
    }));
  }

  void getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama')!;
      namaToko = prefs.getString('nama_toko')!;
    });
  }

  Future<void> logout() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: SingleChildScrollView(
                  child: ListBody(children: const <Widget>[
                Text('Akun Anda akan dikeluarkan.')
              ])),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Batal"),
                ),
                TextButton(
                  onPressed: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    _gotoLogin();
                  },
                  child: const Text("Ya"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: tWhite,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(1),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: tViewColor),
                    child: Avatar(
                      name: nama,
                      shape: AvatarShape.circle(30),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            namaToko,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ]),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ListBody(
          children: [
            ...ListTile.divideTiles(context: context, tiles: [
              ListTile(
                tileColor: tWhite,
                leading: const Icon(FontAwesomeIcons.info),
                title: const Text('Tentang Aplikasi'),
                onTap: () => {_gotoAbout()},
              ),
              ListTile(
                tileColor: tWhite,
                leading: const Icon(FontAwesomeIcons.arrowRightFromBracket),
                title: const Text('Logout'),
                onTap: () => {logout()},
              ),
            ]).toList(),
          ],
        ),
      ],
    );
  }
}
