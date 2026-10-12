import 'package:async_json/async_json.dart';

Future<void> main(List<String> arguments) async {
  final books = await loadBooks(arguments.isEmpty ? defaultDataPath : arguments.single);
  print(summarize(books));
}
