import 'dart:io';

import 'core.dart';

/// The configuration class for managing language settings.
abstract class LangConfig {
  /// The default configuration file name.
  static const String _configFileName = "lang_tr.yaml";

  /// The output file name for generated language files.
  static String outputDirName = "lib";

  /// The directory name where language files are located.
  static String langDirName = "lib/lang_tr";

  /// The default language.
  static String defaultLang = "en";

  /// The current language.
  static String currentLang = "";

  /// Initializes the language configuration.
  ///
  /// [configFileName] is an optional parameter that specifies the name of the
  /// configuration file. If not provided, the default configuration file name
  /// ("lang_tr.yaml") will be used.
  static void init([String? configFileName]) {
    File configFile = File(configFileName ?? _configFileName);
    if (configFile.existsSync()) {
      String config = configFile.readAsStringSync();
      List<String> lines = config.split("\n");
      for (var line in lines) {
        if (line.contains("output_file:")) {
          outputDirName = line.split(":").last.trim();
          if (outputDirName.endsWith("/") || outputDirName.endsWith("\\")) {
            outputDirName =
                outputDirName.substring(0, outputDirName.length - 1);
          }
        } else if (line.contains("lang_dir:")) {
          langDirName = line.split(":").last.trim();
          if (langDirName.endsWith("/") || langDirName.endsWith("\\")) {
            langDirName = langDirName.substring(0, langDirName.length - 1);
          }
        } else if (line.contains("default_lang:")) {
          defaultLang = line.split(":").last.trim();
        } else if (line.contains("current_lang:")) {
          currentLang = line.split(":").last.trim();
        }
      }
      if (currentLang.trim().isEmpty) {
        currentLang = defaultLang; // set default language
      }
    } else {
      printWarning(
          "Config ${configFile.path} file not found. Using default values.");
    }
  }
}
