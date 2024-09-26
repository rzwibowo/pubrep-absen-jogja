import 'package:absen_jogja/provider/p_absen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late ProviderAbsen pAbsen;

  TextEditingController tglCtrl = TextEditingController();
  DateFormat fmt = DateFormat('dd-MM-yyyy');
  DateFormat fmtDb = DateFormat('yyyy-MM-dd');
  DateFormat fmtBulanTahun = DateFormat('MMMM yyyy');
  List<Widget> _listHistori = [];
  bool _isLoadingList = false;

  DateTime tgl = DateTime.now();
  late DateTime tglAwal, tglAkhir;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pAbsen = Provider.of<ProviderAbsen>(context, listen: false);

    tglCtrl.text = fmtBulanTahun.format(tgl);

    setState(() {
      tglAwal = DateTime(tgl.year, tgl.month, 1);
      tglAkhir = DateTime(tgl.year, tgl.month + 1, 0);
    });

    _getListHistori();
  }

  void _getListHistori() async {
    setState(() {
      _isLoadingList = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getInt('id_user');
    var getHistori = pAbsen.historiAbsen(
        idUser: idUser,
        tglAwal: fmtDb.format(tglAwal),
        tglAkhir: fmtDb.format(tglAkhir),
        context: context);
    _listHistori.clear();

    getHistori.then((value) {
      if (mounted) {
        setState(() {
          for (var element in value) {
            _listHistori.add(_listItem(element));
          }
        });
      }
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          _isLoadingList = false;
        });
      }
    });
  }

  Widget _listItem(item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        //set border radius more than 50% of height and width to make circle
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 5),
            child: Text(fmt.format(DateTime.parse(item.tanggal)),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          ),
          const Divider(),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(
                    FontAwesomeIcons.arrowRightToBracket,
                    size: 14,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    item.jamMasuk,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Icon(
                    FontAwesomeIcons.arrowRightFromBracket,
                    size: 14,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    item.jamPulang,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  )
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration textfieldDecoration(hint) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      hintText: hint,
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: InkWell(
            onTap: () async {
              final selectedDate =
                  await SimpleMonthYearPicker.showMonthYearPickerDialog(
                      context: context,
                      titleTextStyle: const TextStyle(),
                      monthTextStyle: const TextStyle(),
                      yearTextStyle: const TextStyle(),
                      disableFuture:
                          true // This will disable future years. it is false by default.
                      );
              // Use the selected date as needed
              tgl = selectedDate;
              tglAwal = DateTime(tgl.year, tgl.month, 1);
              tglAkhir = DateTime(tgl.year, tgl.month + 1, 0);
              tglCtrl.text = fmtBulanTahun.format(selectedDate);

              _getListHistori();
              print('Selected date: $selectedDate');
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                color: Colors.white,
                child: TextField(
                  enabled: false,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  controller: tglCtrl,
                  decoration: textfieldDecoration('Periode Absen'),
                ),
              ),
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: _isLoadingList
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _listHistori.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            FontAwesomeIcons.fileCircleXmark,
                            color: Colors.grey,
                            size: 100,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Tidak ada data.',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ),
                          TextButton.icon(
                              onPressed: () => _getListHistori(),
                              icon: const Icon(FontAwesomeIcons.arrowsRotate),
                              label: const Text('Reload'))
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: ListBody(children: [..._listHistori])),
        ))
      ],
    );
  }
}
