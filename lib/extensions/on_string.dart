extension StringToList on String{
  List<String> get stringToList => replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '').replaceAll("'", '').replaceAll('"', '').split(',');
  String get urlToFileName => split('/').last;
}