import 'package:flutter/material.dart';
import 'package:absen_jogja/konstan.dart';

InputDecoration inputDeco(String label, var suffix) {
  return InputDecoration(
      filled: true,
      fillColor: tWhite,
      contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      hintText: label,
      // hintStyle: const TextStyle(color: tTextColorThird),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: tViewColor, width: 0.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: tViewColor, width: 1),
      ),
      suffix: suffix);
}
