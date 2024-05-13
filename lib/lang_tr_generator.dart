/// A library for generating and managing language translations.
library lang_tr;

import 'dart:convert';
import 'dart:io';

import 'package:lang_tr/config.dart';

import 'core.dart';
export 'core.dart';

/// A class responsible for generating language translation methods.
class LangTrGenerator {
  /// List of keys used for translation.
  static final List<String> _keys = [];

  /// Generates the language translation methods.
  ///
  /// [configFileName] is an optional parameter that specifies the name of the
  /// configuration file to initialize the language configuration.
  static void generate([String? configFileName]) async {
    LangConfig.init(configFileName);
    Directory dir = Directory(LangConfig.langDirName);
    if (!await dir.exists()) {
      printError('${LangConfig.langDirName} folder not found!');
      return;
    }

    List<FileSystemEntity> files = dir.listSync();

    StringBuffer classBuffer = StringBuffer('abstract class LangTr {\n');

    _generateDefaultLangString(classBuffer);
    _generateLangGetter(classBuffer, files);
    _generateTrForJsonFiles(files, classBuffer);
    _generateSetLangMethod(classBuffer);
    _generateKeys(classBuffer);

    // end of class
    classBuffer.write('}');

    File outputFile = File(LangConfig.outputFileName);
    outputFile.writeAsStringSync(classBuffer.toString());

    printSuccess('lang_tr.dart generated successfully!');
  }

  /// Generates the default language string.
  static void _generateDefaultLangString(StringBuffer classBuffer) {
    classBuffer.write(
        "  static String defaultLang = '${LangConfig.defaultLang}';\n\n");
  }

  /// Generates the keys used for translation.
  static void _generateKeys(StringBuffer classBuffer) {
    classBuffer.write(_keysGetter());
  }

  /// Generates the method for setting the default language.
  static void _generateSetLangMethod(StringBuffer classBuffer) {
    classBuffer.write('  static void setLang(String lang){\n');
    classBuffer.write('    defaultLang = lang;\n');
    classBuffer.write('  }\n\n');
  }

  /// Generates the translation methods for JSON files.
  static void _generateTrForJsonFiles(
      List<FileSystemEntity> files, StringBuffer classBuffer) {
    for (var file in files) {
      if (file is File && file.path.endsWith('.json')) {
        String fileName = file.path
            .split(Platform.pathSeparator)
            .last
            .split('.')
            .first
            .toLowerCase();
        classBuffer.write(_generateTranslationMethod(fileName, file));
      }
    }
  }

  /// Generates the getter for accessing the language map.
  static void _generateLangGetter(
      StringBuffer classBuffer, List<FileSystemEntity> files) {
    classBuffer
        .write('  static Map<String, Map<String, String>> get lang => {\n');
    for (var file in files) {
      if (file is File && file.path.endsWith('.json')) {
        String fileName = file.path
            .split(Platform.pathSeparator)
            .last
            .split('.')
            .first
            .toLowerCase();
        classBuffer.write('    "$fileName": _$fileName,\n');
      }
    }
    classBuffer.write('  };\n\n');
  }

  /// Generates the translation method for a specific language file.
  static String _generateTranslationMethod(String fileName, File file) {
    String content = file.readAsStringSync();
    final List<String> keys = [];

    Map<String, dynamic> translations = json.decode(content);
    StringBuffer methodBuffer =
        StringBuffer('  static Map<String, String> get _$fileName => {\n');
    translations.forEach((k, value) {
      final key = toKey(k);
      if (!_keys.contains(key)) {
        _keys.add(key);
      }
      if (keys.contains(key)) {
        return;
      }

      methodBuffer
          .write('    "$key": "${value.toString().replaceAll('"', r'\"')}",\n');
      keys.add(key);
    });
    methodBuffer.write('  };\n\n');
    return methodBuffer.toString();
  }

  /// Generates the getter methods for accessing translations.
  static String _keysGetter() {
    StringBuffer keysBuffer = StringBuffer();
    for (var key in _keys) {
      keysBuffer.write(
          '  static String get $key => lang[defaultLang]?["$key"] ?? "$key";\n');
    }
    return keysBuffer.toString();
  }

  /// Converts a string into a valid Dart key format.
  static String toKey(String key) {
    List keyParts = key.trim().split(' ');
    String result = keyParts[0].toLowerCase();
    for (int i = 1; i < keyParts.length; i++) {
      result += keyParts[i][0].toUpperCase() + keyParts[i].substring(1);
    }
    return result;
  }
}
