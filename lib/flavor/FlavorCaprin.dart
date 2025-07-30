import 'package:gismo/flavor/Flavor.dart';

class FlavorCaprin extends Flavor {
  @override
  // TODO: implement appName
  String get appName => "Amalthé";

  @override
  // TODO: implement enfantLibelle
  String get enfantLibelle => "Chevreaux";
  String get enfantAsset => "jumping_lambs.png";
  @override
  // TODO: implement miseBasLibelle
  String get miseBasLibelle => "Chevrotage";
  String get miseBasAsset => "chevreau.png";
  @override
  // TODO: implement femelleLibelle
  String get femelleLibelle => "Chèvre";

  @override
  // TODO: implement maleLibelle
  String get maleLibelle => "Bouc";

  @override
  String get individuAsset => "chevre.png";

  String get parentAsset => "chevre_chevreau.png";
  String get lotAsset => "lot_chevre.png";

  String get splashAsset => "amalthe.png";
}