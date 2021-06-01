abstract class Libelle {
  String get appName;
  String get entreeLibelle => "Entree";
  String get sortieLibelle => "Sortie";
  String get traitementLibelle =>"Traitement";
  String get necLibelle => "Etat corp.";
  String get poidLibelle => "Poids";
  String get echoLibelle => "Echographie";
  String get miseBasLibelle; // ("Agnelage", 'assets/lamb.png', ),
  String get enfantLibelle; // ("Agneaux", 'assets/jumping_lambs.png', ),
  String get maleLibelle;
  String get femelleLibelle;
  String get parcelleLibelle => "Parcelles";
  String get lotLibelle => "Lot";
  String get indivivduLibelle => "Individu";
}