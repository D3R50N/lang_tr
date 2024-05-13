import 'package:lang_tr/lang_tr_generator.dart';

void main(List<String> args) {
  LangTrGenerator.generate(args.isNotEmpty ? args[0] : null);
}
