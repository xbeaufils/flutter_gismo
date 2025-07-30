import 'package:flutter/widgets.dart';
import 'package:gismo/generated/l10n.dart';

class AgnelageNotFoundException implements Exception {}

enum AgnelageEnum {
  level0(0),
  level1(1),
  level2(2),
  level3(3),
  level4(4);

  final int _key;

  int get key => _key;
  const AgnelageEnum(this._key);
}

class AgnelageHelper {
  BuildContext context;
  AgnelageHelper(this.context);

  String translate(AgnelageEnum agne) {
    switch (agne) {
      case AgnelageEnum.level0:
        return S.of(context).agnelage_seul;
      case AgnelageEnum.level1 :
        return S.of(context).agnelage_aide;
      case AgnelageEnum.level2:
        return S.of(context).agnelage_replace;
      case AgnelageEnum.level3 :
        return S.of(context).agnelage_delivrance;
      case AgnelageEnum.level4 :
        return S.of(context).agnelage_fouille;
    }
    throw new AgnelageNotFoundException();
  }

  static AgnelageEnum getAgnelage(int value) {
    switch (value) {
      case 0: return AgnelageEnum.level0;
      case 1: return AgnelageEnum.level1;
      case 2: return AgnelageEnum.level2;
      case 3: return AgnelageEnum.level3;
      case 4: return AgnelageEnum.level4;
    }
    throw new AgnelageNotFoundException();
  }
}
