import 'dart:async';

import 'package:absen_jogja/component/snackbar.dart';
import 'package:absen_jogja/login.dart';
import 'package:absen_jogja/main_history.dart';
import 'package:absen_jogja/main_profile.dart';
import 'package:absen_jogja/provider/p_absen.dart';
import 'package:absen_jogja/provider/p_setting.dart';
import 'package:absen_jogja/provider/p_user.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderAbsen>(create: (_) => ProviderAbsen()),
        ChangeNotifierProvider<ProviderUser>(create: (_) => ProviderUser()),
        ChangeNotifierProvider<ProviderSetting>(
            create: (_) => ProviderSetting()),
      ],
      child: MaterialApp(
        title: 'ABSENSI YOGYAKARTA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'ABSENSI YOGYAKARTA'),
        routes: {
          '/home': (BuildContext context) =>
              const MyHomePage(title: 'SEPATU YOGYAKARTA'),
          '/login': (BuildContext context) => const Login(),
          // '/daftar_produk': (BuildContext context) => const DaftarProduk(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ProviderAbsen pAbsen;
  late ProviderSetting pSet;
  late StreamSubscription<ConnectivityResult> _subscription;

  int selectedIndex = 0;
  double gap = 10;
  final padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12);

  bool _isLoading = true;
  String? _nama = '';
  String? _namaToko = '';
  String? bssid = '';
  bool _isConnected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cekLogin();
    pAbsen = Provider.of<ProviderAbsen>(context, listen: false);
    pSet = Provider.of<ProviderSetting>(context, listen: false);

    _getBssid();
    // _cekKoneksi();
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      _cekKoneksi();
    });
  }

  @override
  dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _cekLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getInt('id_user');

    if (idUser != 0 && idUser != null) {
      if (mounted) {
        setState(() {
          _nama = prefs.getString('nama');
          _namaToko = prefs.getString('nama_toko');
          _isLoading = false;
        });
      }
    } else {
      _gotoLogin();
    }
  }

  void _cekKoneksi() async {
    Map<ph.Permission, ph.PermissionStatus> statuses =
        await [ph.Permission.location].request();
    Location location = Location();
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      // if (!_serviceEnabled) {
      //   debugPrint('Location Denied once');
      // }
    }

    print(statuses);

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      final info = NetworkInfo();
      // I am connected to a wifi network.
      String? bssidx = await info.getWifiBSSID();
      print("--------------------------BSSID");
      print(bssid);
      print(bssidx);
      print('-------------------------------');

      if (bssidx == bssid) {
        setState(() {
          _isConnected = true;
        });
      } else {
        setState(() {
          _isConnected = false;
        });
      }
    } else {
      // I am connected to a ethernet network.
      setState(() {
        _isConnected = false;
      });
    }
  }

  Future<void> _getBssid() async {
    pSet.bssid(context: context).then((value) {
      print('---------------------bssidserver');
      print(value);
      print('--------------------------------');
      setState(() {
        bssid = value['value'];
      });

      _cekKoneksi();
    });
  }

  void _absen(String tipeAbsen) async {
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getInt('id_user');
    var idToko = prefs.getInt('id_toko');
    var res = pAbsen
        .absen(
            idToko: idToko,
            idUser: idUser,
            tipeAbsen: tipeAbsen,
            context: context)
        .then((value) {
      print(value);
      if (value['status'] == 'error') {
        showToast(context, value['msg']);
      } else {
        showToast(context, 'Berhasil Absen');
      }
    }).onError((error, stackTrace) {
      showToast(context, "Terjadi kesalahan $error");
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _gotoLogin() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Widget _home() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: Center(
              child: Text(
            _isConnected ? "Connected" : "Connecting...",
            style: const TextStyle(fontSize: 25),
          )),
        ),
        Expanded(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                child: InkWell(
                  onTap: () => _cekKoneksi(),
                  child: Image(
                      image: AssetImage(_isConnected
                          // <a href="https://lovepik.com/images/png-wireless.html">Wireless Png vectors by Lovepik.com</a>
                          ? "assets/images/connected.png"
                          : "assets/images/signal.gif")),
                )),
          ),
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Visibility(
            visible: _isLoading,
            child: const LinearProgressIndicator(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _isConnected
                          ? _absen("in")
                          : showToast(
                              context, "Belum terkoneksi dengan absen point");
                    },
                    child: const SizedBox(
                      height: 80,
                      width: 100,
                      child: Center(
                        child: Text(
                          "Masuk",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _isConnected
                          ? _absen("out")
                          : showToast(
                              context, "Belum terkoneksi dengan absen point");
                    },
                    child: const SizedBox(
                      height: 80,
                      width: 100,
                      child: Center(
                        child: Text(
                          "Pulang",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                    ),
                  ),
                ],
              )),
        )

        // ElevatedButton(
        //     onPressed: () => _gotoLogin(), child: const Text('Login'))
      ],
    );
  }

  Widget _content() {
    Widget content = Container();

    switch (selectedIndex) {
      case 0:
        content = _home();
        break;
      case 1:
        content = const History();
        break;
      case 2:
        content = const Profile();
        break;
      default:
        content = _home();
        break;
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        statusBarIconBrightness: Brightness.light));

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
        ),
        body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
                content: Text("Tekan sekali lagi untuk keluar"),
                duration: Duration(seconds: 3)),
            child: Container(
              width: double.infinity,
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Container(
                    child: _content(),
                    color: Colors.grey[100],
                  )),
              color: Colors.blue,
            )),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                spreadRadius: -10,
                blurRadius: 60,
                color: Colors.black.withOpacity(.4),
                offset: const Offset(0, 25),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
            child: GNav(
              tabs: const [
                GButton(
                  icon: FontAwesomeIcons.house,
                  text: 'Home',
                ),
                GButton(
                  icon: FontAwesomeIcons.clockRotateLeft,
                  text: 'Riwayat',
                ),
                GButton(
                  icon: FontAwesomeIcons.person,
                  text: 'Profil',
                )
              ],
              selectedIndex: selectedIndex,
              tabBackgroundColor: Colors.lightBlue,
              activeColor: Colors.grey[300],
              color: Colors.grey[700],
              padding: padding,
              gap: gap,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
