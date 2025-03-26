import 'package:flutter_gismo/flavor/Flavor.dart';
import 'package:flutter_gismo/generated/l10n.dart';

class FlavorOvin extends Flavor {
  @override
  Espece get espece => Espece.ovin;

  @override
  // TODO: implement appName
  String get appName => "Gismo";

  @override
  // TODO: implement enfantLibelle
  String get enfantLibelle =>  S.current.lambs; //"Agneaux";
  String get enfantAsset => "assets/jumping_lambs.png";
  @override
  // TODO: implement miseBasLibelle
  String get miseBasLibelle => "Agnelage";
  String get miseBasAsset => "assets/lamb.png";
  @override
  // TODO: implement femelleLibelle
  String get femelleLibelle => "Brebis";

  @override
  // TODO: implement maleLibelle
  String get maleLibelle => "Bélier";

  @override
  String get individuAsset => "assets/brebis.png";

  String get parentAsset => "sheep_lamb.png";
  String get lotAsset => "assets/Lot.png";

  String get splashAsset => "gismo.png";
}