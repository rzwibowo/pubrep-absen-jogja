import 'package:flutter/material.dart';
import 'package:absen_jogja/konstan.dart';

void showToast(BuildContext context, String caption) {
  final scf = ScaffoldMessenger.of(context);
  scf.showSnackBar(SnackBar(
      action: SnackBarAction(
        label: 'Tutup',
        textColor: tTextColorThird,
        onPressed: () {
          scf.removeCurrentSnackBar();
        },
      ),
      content: Text(caption, style: const TextStyle(color: tWhite))));
}
