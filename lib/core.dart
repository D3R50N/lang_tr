// ignore_for_file: avoid_print

/// Prints [text] to the console.
void printText(String text) {
  print(text);
}

/// Prints [text] to the console as a warning message with yellow color.
void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

/// Prints [text] to the console as a success message with green color.
void printSuccess(String text) {
  print('\x1B[32m$text\x1B[0m');
}

/// Prints [text] to the console as an error message with red color.
void printError(String text) {
  print('\x1B[31m$text\x1B[0m');
}
