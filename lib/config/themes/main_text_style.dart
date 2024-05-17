import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// An abstract class that provides text styles using specific font types with various font weights that may be used in the layout and appearance of the application.
/// Each member of the class is a TextStyle object that can be directly used in text creation on Flutter widgets.
abstract class MainTextStyle {
  static final poppinsW400 = GoogleFonts.poppins(fontWeight: FontWeight.w400);
  static final poppinsW500 = GoogleFonts.poppins(fontWeight: FontWeight.w500);
  static final poppinsW600 = GoogleFonts.poppins(fontWeight: FontWeight.w600);
  static final poppinsW700 = GoogleFonts.poppins(fontWeight: FontWeight.w700);
}
