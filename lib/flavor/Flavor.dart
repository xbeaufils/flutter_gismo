enum Espece {
  ovin, caprins
}

abstract class Flavor {
  Espece get espece;
  String get appName;
  String get entreeLibelle => "Entree";
  String get sortieLibelle => "Sortie";
  String get traitementLibelle =>"Traitement";
  String get necLibelle => "Etat corp.";
  String get poidLibelle => "Poids";
  String get echoLibelle => "Echographie";
  String get miseBasLibelle; // ("Agnelage", 'assets/lamb.png', ),
  String get miseBasAsset;
  String get enfantLibelle; // ("Agneaux", 'assets/jumping_lambs.png', ),
  String get enfantAsset;
  String get maleLibelle;
  String get femelleLibelle;
  String get parcelleLibelle => "Parcelles";
  String get lotLibelle => "Lot";
  String get lotAsset;
  String get individuLibelle => "Individu";
  String get individuAsset ;
  String get parentAsset;
  String get splashAsset;
}