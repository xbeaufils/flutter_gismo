class AdoptionNotFoundException implements Exception {}


class Adoption {
  int _key;
  String _value;

  int get key => _key;
  String get value => _value;

  Adoption(this._key, this._value);

  static Adoption level0 = Adoption(0, "Lèche, appelle et se laisse téter");
  static Adoption level1 = Adoption(1, "Apathique");
  static Adoption level2 = Adoption(2, "Délaisse un des agneaux");
  static Adoption level3 = Adoption(3, "Abandonne en fuyant");
  static Adoption level4 = Adoption(4, "Maintenir de force pour allaiter");
  static Adoption level5 = Adoption(5, "Infanticide");

  static Adoption getAdoption(int value) {
    switch (value) {
      case 0: return level0;
      case 1: return level1;
      case 2: return level2;
      case 3: return level3;
      case 4: return level4;
      case 5: return level5;
    }
    throw new AdoptionNotFoundException();
  }
}
