# LangTr

`LangTr` is a Flutter generator package designed to simplify the management of translation files in your Flutter applications.

## Installation

Add `lang_tr` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  lang_tr: <latest>
```

## Usage

### Configuration

To use `LangTr`, you can create a `lang_tr.yaml` configuration file in the root of your project or anywhere. Here's an example format for the configuration file:

```yaml
lang_dir: lib/lang_tr
output_file: lib/lang_tr.dart
default_lang: en
```

- `lang_dir`: The path to the directory containing your translation files.
- `output_file`: The path and name of the generated translation file.
- `default_lang`: The default language to use if no language is specified.

### Generating Translation Files

To generate the translation file from the configuration file, run the following command in your terminal:

```bash
flutter pub run lang_tr:generate path_to_lang_tr.yaml
```

This will generate the translation file `lang_tr.dart` according to the settings specified in your `lang_tr.yaml` file.

### Using in Code

You can now use the translations in your application by importing the `lang_tr.dart` file and accessing methods and fields of the `LangTr` class.

```dart
import 'path_to_generated/lang_tr.dart';

void main() {
  // Using translations
  String greeting = LangTr.greetMessage; // Accessing a specific translation
  print(greeting); // Prints the greeting message
}
```

## Contribution

Contributions are welcome! If you have any improvement ideas, suggestions, or issues to report, feel free to open an issue or submit a pull request on [GitHub](https://github.com/D3R50N/lang_tr.git).

## License

This package is distributed under the MIT License. See the [LICENSE](LICENSE) file for more information.
