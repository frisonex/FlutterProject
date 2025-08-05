class RegexUtils {
  static final RegExp dateRegex = RegExp(
      r'^\d{4}-(0?[1-9]|1[0-2])-(0?[1-9]|[1-2][0-9]|3[0-1])$'
  );

  static bool isValidDate(String value) {
    return dateRegex.hasMatch(value);
  }
}
