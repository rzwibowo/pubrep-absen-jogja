import 'package:absen_jogja/provider/p_user.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absen_jogja/component/buttondeco.dart';
import 'package:absen_jogja/component/snackbar.dart';
import 'package:absen_jogja/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'konstan.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late ProviderUser pUser;
  late DateTime backButtonPressTime;

  String username = '';
  String password = '';
  String _baseUrl = '';

  // bool _isLoading = true;
  bool _isProcess = false;
  bool _isHidden = true;

  final TextEditingController _txtBaseUrl = TextEditingController();

  @override
  initState() {
    super.initState();
    pUser = Provider.of<ProviderUser>(context, listen: false);
    setBaseUrl();
    // _cekLogin();
  }

  setBaseUrl() {
    _baseUrl = baseUrl;
    _txtBaseUrl.text = _baseUrl;
  }

  changeBaseUrl() {
    baseUrl = _baseUrl;
  }

  Future<void> _login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    // prefs.setString('fcm', fcmToken!);

    setState(() {
      _isProcess = true;
    });

    pUser
        .login(
            username: username,
            password: password,
            // token: 'x',
            context: context)
        .then((value) {
      if (value.idUser != 0) {
        prefs.setInt('id_user', value.idUser);
        prefs.setString('username', value.username);
        prefs.setString('nama', value.nama);
        prefs.setInt('id_toko', value.idToko);
        prefs.setString('nama_toko', value.namaToko);

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return const MyHomePage(
            title: 'Sepatu Yogyakarta',
          );
        }));
      } else {
        showToast(context, 'Username atau password salah');
      }
    }).whenComplete(() {
      setState(() {
        _isProcess = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/kantor.jpg"),
              fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body:
              // _isLoading
              //     ? const Center(child: CircularProgressIndicator())
              //     :
              Center(
            child: BlurryContainer(
                blur: 5,
                width: width - 50,
                height: kReleaseMode ? 260 : 400,
                // height: 260,
                color: const Color.fromARGB(100, 236, 240, 241),
                elevation: 3,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'SEPATU YOGYAKARTA',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const Divider(
                      height: 16,
                      color: tShadowColor,
                    ),
                    if (!kReleaseMode)
                      TextField(
                        decoration: inputDeco('baseurl', null),
                        controller: _txtBaseUrl,
                        onChanged: (val) {
                          setState(() {
                            _baseUrl = val;
                          });
                        },
                      ),
                    if (!kReleaseMode) const SizedBox(height: 16),
                    if (!kReleaseMode)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50), // NEW
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                        onPressed: () {
                          _baseUrl.isEmpty
                              ? showToast(context, 'baseurl kosong')
                              : changeBaseUrl();
                        },
                        child: const Text('setbaseurl'),
                      ),
                    if (!kReleaseMode)
                      const Divider(
                        height: 16,
                        color: tShadowColor,
                      ),
                    TextField(
                      decoration: inputDeco('Username', null),
                      onChanged: (val) {
                        setState(() {
                          username = val;
                        });
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      obscureText: _isHidden,
                      decoration: inputDeco(
                          'Password',
                          GestureDetector(
                              child: Icon(_isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onTap: () {
                                setState(() {
                                  _isHidden = !_isHidden;
                                });
                              })),
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50), // NEW
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                        onPressed: () {
                          username.isEmpty || password.isEmpty
                              ? showToast(
                                  context, 'Username dan password harus diisi')
                              : _login();
                        },
                        child: _isProcess
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(tWhite))
                            : const Text('Login'))
                  ],
                )),
          )),
    );
  }
}
