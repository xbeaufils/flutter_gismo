import 'package:flutter_gismo/flavor/Flavor.dart';
import 'package:flutter_gismo/generated/l10n.dart';

class FlavorCaprin extends Flavor {
  Espece get espece => Espece.caprins;
  @override
  // TODO: implement appName
  String get appName => "Amalthé";

  @override
  // TODO: implement enfantLibelle
  String get enfantLibelle =>  S.current.kids;
  String get enfantAsset => "assets/jumping_lambs.png";
  @override
  // TODO: implement miseBasLibelle
  String get miseBasLibelle => S.current.kidding;
  String get miseBasAsset => "assets/chevreau.png";
  @override
  // TODO: implement femelleLibelle
  String get femelleLibelle => "Chèvre";

  @override
  // TODO: implement maleLibelle
  String get maleLibelle => "Bouc";

  @override
  String get individuAsset => "assets/chevre.png";

  String get parentAsset => "chevre_chevreau.png";
  String get lotAsset => "assets/lot_chevre.png";

  String get splashAsset => "amalthe.png";
}