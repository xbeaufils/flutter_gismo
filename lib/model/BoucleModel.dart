class BoucleModel {
  late String _ordre;
  late String _marquage;

  String get ordre => _ordre;
  String get marquage => _marquage;

  BoucleModel(String numBoucle) {
    if (numBoucle.length >15) {
      this._marquage = numBoucle.substring(8, 18);
      this._ordre = numBoucle.substring(18, 23);
    }
    else {
      this._marquage = numBoucle.substring(0, 10);
      this._ordre = numBoucle.substring(10);
    }
  }

 }