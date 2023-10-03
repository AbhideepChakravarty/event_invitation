import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FontProvider extends ChangeNotifier {
  String? primaryFontFamily;
  String? secondaryFontFamily;
  String? descriptionFontFamily;

  FontProvider({
    this.primaryFontFamily,
    this.secondaryFontFamily,
    this.descriptionFontFamily,
  });

  TextStyle get primaryTextFont => GoogleFonts.getFont(
        primaryFontFamily ?? 'Lovers Quarrel',
      );

  TextStyle get secondaryTextFont => GoogleFonts.getFont(
        secondaryFontFamily ?? 'Inknut Antiqua',
      );

  TextStyle get descriptionTextFont => GoogleFonts.getFont(
        descriptionFontFamily ?? 'Playfair Display',
      );

  MarkdownStyleSheet get getMarkdownSheet => MarkdownStyleSheet(
        p: descriptionTextFont.copyWith(
          fontSize: 16.0, // Customize heading 1 font size
        ),
        h1: descriptionTextFont.copyWith(
          fontSize: 24.0, // Customize heading 1 font size
        ),
        h2: descriptionTextFont.copyWith(
          fontSize: 20.0, // Customize heading 2 font size
        ),
        h3: descriptionTextFont.copyWith(
          fontSize: 18.0, // Customize heading 3 font size
        ),
        strong: descriptionTextFont.copyWith(
          fontWeight: FontWeight.bold, // Make bold text
        ),
        em: descriptionTextFont.copyWith(
          fontStyle: FontStyle.italic, // Make italic text
        ),
        // Custom styling for hyperlinks
        a: descriptionTextFont.copyWith(
          color: Colors.blue, // Change link color
          decoration: TextDecoration.underline, // Underline links
        ),
      );

  static FontProvider of(BuildContext context) {
    return context.read<FontProvider>();
  }
}
