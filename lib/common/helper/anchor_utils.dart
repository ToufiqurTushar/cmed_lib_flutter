class Anchorify {
  static String anchorify(String text) {
    return " $text ".replaceAll("&nbsp;", " ").replaceAll(":http", ": http").replaceAllMapped(
        RegExp(r'(>|\s)+(https?.+?)(<|\s)',
            multiLine: true, caseSensitive: false), (match) {
      return '${match.group(1)}<a href="${match.group(2)}">${match.group(2)}</a>${match.group(3)}';
    });
  }
}