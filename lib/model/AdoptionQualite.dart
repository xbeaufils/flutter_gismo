
import 'package:flutter/widgets.dart';
import 'package:flutter_gismo/generated/l10n.dart';

class AdoptionNotFoundException implements Exception {}

enum AdoptionEnum {
  level0(0),
  level1(1),
  level2(2),
  level3(3),
  level4(4),
  level5(5);

  const AdoptionEnum(this._key);
  final int _key;
  int get key => this._key;

}

class AdoptionHelper {
  //int _key;
  //String _value;
  BuildContext context;

  AdoptionHelper(this.context);
  //Adoption(this._key, this._value);


  String translate(AdoptionEnum adopt) {
    switch (adopt) {
      case AdoptionEnum.level0 :
        return S
            .of(context)
            .adoption_leche;
      case AdoptionEnum.level1 :
        return S
            .of(context)
            .adoption_apathique;
      case AdoptionEnum.level2 :
        return S
            .of(context)
            .adoption_delaisse;
      case AdoptionEnum.level3:
        return S
            .of(context)
            .adoption_abandon;
      case AdoptionEnum.level4:
        return S
            .of(context)
            .adoption_tenir;
      case AdoptionEnum.level5:
        return S
            .of(context)
            .adoption_infanticide;
    }
    throw new AdoptionNotFoundException();
  }

  static AdoptionEnum getAdoption(int value) {
    switch (value) {
      case 0: return AdoptionEnum.level0;
      case 1: return AdoptionEnum.level1;
      case 2: return AdoptionEnum.level2;
      case 3: return AdoptionEnum.level3;
      case 4: return AdoptionEnum.level4;
      case 5: return AdoptionEnum.level5;
    }
    throw new AdoptionNotFoundException();
  }
}
