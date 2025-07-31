import 'package:flutter_gismo/flavor/Flavor.dart';

class FlavorOvin extends Flavor {
  @override
  // TODO: implement appName
  String get appName => "Gismo";

  @override
  // TODO: implement enfantLibelle
  String get enfantLibelle => "Agneaux";
  String get enfantAsset => "jumping_lambs.png";
  @override
  // TODO: implement miseBasLibelle
  String get miseBasLibelle => "Agnelage";
  String get miseBasAsset => "lamb.png";
  @override
  // TODO: implement femelleLibelle
  String get femelleLibelle => "Brebis";

  @override
  // TODO: implement maleLibelle
  String get maleLibelle => "Bélier";

  @override
  String get individuAsset => "brebis.png";

  String get parentAsset => "sheep_lamb.png";
  String get lotAsset => "Lot.png";

  String get splashAsset => "gismo.png";
}