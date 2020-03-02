class AgnelageNotFoundException implements Exception {}

class Agnelage {
  int _key;
  String _value;

  int get key => _key;
  String get value => _value;

  Agnelage(this._key, this._value);

  static Agnelage level0 = Agnelage(0, "Seule");
  static Agnelage level1 = Agnelage(1, "Aidée");
  static Agnelage level2 = Agnelage(2, "Agneau replacé");
  static Agnelage level3 = Agnelage(3, "Fouillée pour la délivrance");
  static Agnelage level4 = Agnelage(4, "Fouillée pour l'agneau");

  static Agnelage getAgnelage(int value) {
    switch (value) {
      case 0: return level0;
      case 1: return level1;
      case 2: return level2;
      case 3: return level3;
      case 4: return level4;
    }
    throw new AgnelageNotFoundException();
  }
}
