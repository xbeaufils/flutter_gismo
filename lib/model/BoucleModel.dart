class BoucleModel {
  late String _ordre;
  late String _marquage;

  String get ordre => _ordre;
  String get marquage => _marquage;

  BoucleModel(String numBoucle) {
    this._marquage = numBoucle.substring(8, 18);
    this._ordre = numBoucle.substring(18,23);
  }

 }