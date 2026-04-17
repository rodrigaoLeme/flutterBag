enum GcStyles {
  poppins,
  notoSerif,
}

class TypographyHelper {
  static String getFontFamily(GcStyles typography) {
    switch (typography) {
      case GcStyles.poppins:
        return 'Poppins';
      case GcStyles.notoSerif:
        return 'NotoSerif';
    }
  }
}
