import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeHepler {
  InputDecoration textInputDecoration([
    String lableText = "",
    String hintText = "",
  ]) {
    return InputDecoration(
      labelStyle: GoogleFonts.notoSansThai(),
      labelText: lableText,
      hintText: hintText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintStyle: GoogleFonts.notoSansThai(
          color: const Color(0xFF8C5BF4).withOpacity(0.4)),
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white)),
    );
  }
}
