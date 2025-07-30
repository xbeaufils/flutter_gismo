import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @batch.
  ///
  /// In fr, this message translates to:
  /// **'Lot'**
  String get batch;

  /// No description provided for @sheep.
  ///
  /// In fr, this message translates to:
  /// **'Individu'**
  String get sheep;

  /// No description provided for @lambing.
  ///
  /// In fr, this message translates to:
  /// **'Agnelage'**
  String get lambing;

  /// No description provided for @lambs.
  ///
  /// In fr, this message translates to:
  /// **'Agneaux'**
  String get lambs;

  /// No description provided for @mating.
  ///
  /// In fr, this message translates to:
  /// **'Saillie'**
  String get mating;

  /// No description provided for @ultrasound.
  ///
  /// In fr, this message translates to:
  /// **'Echographie'**
  String get ultrasound;

  /// No description provided for @weighing.
  ///
  /// In fr, this message translates to:
  /// **'Pesée'**
  String get weighing;

  /// No description provided for @body_cond.
  ///
  /// In fr, this message translates to:
  /// **'Etat corp.'**
  String get body_cond;

  /// No description provided for @body_cond_full.
  ///
  /// In fr, this message translates to:
  /// **'Note d\'état corporel'**
  String get body_cond_full;

  /// No description provided for @treatment.
  ///
  /// In fr, this message translates to:
  /// **'Traitement'**
  String get treatment;

  /// No description provided for @input.
  ///
  /// In fr, this message translates to:
  /// **'Entrée'**
  String get input;

  /// No description provided for @output.
  ///
  /// In fr, this message translates to:
  /// **'Sortie'**
  String get output;

  /// No description provided for @localuser.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur local'**
  String get localuser;

  /// No description provided for @welcome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get welcome;

  /// No description provided for @memo.
  ///
  /// In fr, this message translates to:
  /// **'Memo'**
  String get memo;

  /// No description provided for @configuration.
  ///
  /// In fr, this message translates to:
  /// **'Configuration'**
  String get configuration;

  /// No description provided for @user_error.
  ///
  /// In fr, this message translates to:
  /// **'User error'**
  String get user_error;

  /// No description provided for @earring.
  ///
  /// In fr, this message translates to:
  /// **'Boucle'**
  String get earring;

  /// No description provided for @earring_search.
  ///
  /// In fr, this message translates to:
  /// **'Recherche boucle'**
  String get earring_search;

  /// No description provided for @place_earring.
  ///
  /// In fr, this message translates to:
  /// **'Poser la boucle'**
  String get place_earring;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get search;

  /// No description provided for @title_empty_list.
  ///
  /// In fr, this message translates to:
  /// **'Liste vide'**
  String get title_empty_list;

  /// No description provided for @text_empty_list.
  ///
  /// In fr, this message translates to:
  /// **'Pour saisir l\'effectif, veuillez faire une entrée depuis l\'écran principal.'**
  String get text_empty_list;

  /// No description provided for @herd_size.
  ///
  /// In fr, this message translates to:
  /// **'Effectif'**
  String get herd_size;

  /// No description provided for @not_connected.
  ///
  /// In fr, this message translates to:
  /// **'Non connecté'**
  String get not_connected;

  /// No description provided for @data_available.
  ///
  /// In fr, this message translates to:
  /// **'Données reçues'**
  String get data_available;

  /// No description provided for @no_earring_read.
  ///
  /// In fr, this message translates to:
  /// **'Pas de boucle lue'**
  String get no_earring_read;

  /// No description provided for @flock_number.
  ///
  /// In fr, this message translates to:
  /// **'Numero marquage'**
  String get flock_number;

  /// No description provided for @flock_number_hint.
  ///
  /// In fr, this message translates to:
  /// **'Marquage'**
  String get flock_number_hint;

  /// No description provided for @enter_flock_number.
  ///
  /// In fr, this message translates to:
  /// **'Entrez un numero de marquage'**
  String get enter_flock_number;

  /// No description provided for @flock_number_warn.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de marquage absent'**
  String get flock_number_warn;

  /// No description provided for @identity_number.
  ///
  /// In fr, this message translates to:
  /// **'Numero boucle'**
  String get identity_number;

  /// No description provided for @identity_number_hint.
  ///
  /// In fr, this message translates to:
  /// **'Boucle'**
  String get identity_number_hint;

  /// No description provided for @enter_identity_number.
  ///
  /// In fr, this message translates to:
  /// **'Entrez un numero de boucle'**
  String get enter_identity_number;

  /// No description provided for @identity_number_warn.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de boucle absent'**
  String get identity_number_warn;

  /// No description provided for @sex_warn.
  ///
  /// In fr, this message translates to:
  /// **'Sexe absent'**
  String get sex_warn;

  /// No description provided for @name.
  ///
  /// In fr, this message translates to:
  /// **'Petit nom'**
  String get name;

  /// No description provided for @name_hint.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get name_hint;

  /// No description provided for @identity_number_error.
  ///
  /// In fr, this message translates to:
  /// **'Numero de boucle déja présent'**
  String get identity_number_error;

  /// No description provided for @entree_select.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez une cause d\'entree'**
  String get entree_select;

  /// No description provided for @entree_reason_required.
  ///
  /// In fr, this message translates to:
  /// **'Cause d\'entrée obligatoire'**
  String get entree_reason_required;

  /// No description provided for @entree_birth.
  ///
  /// In fr, this message translates to:
  /// **'Naissance'**
  String get entree_birth;

  /// No description provided for @entree_creation.
  ///
  /// In fr, this message translates to:
  /// **'Creation'**
  String get entree_creation;

  /// No description provided for @entree_renewal.
  ///
  /// In fr, this message translates to:
  /// **'Renouvellement'**
  String get entree_renewal;

  /// No description provided for @entree_purchase.
  ///
  /// In fr, this message translates to:
  /// **'Achat'**
  String get entree_purchase;

  /// No description provided for @entree_reactivation.
  ///
  /// In fr, this message translates to:
  /// **'Reactivation'**
  String get entree_reactivation;

  /// No description provided for @entree_loan.
  ///
  /// In fr, this message translates to:
  /// **'Prêt ou pension'**
  String get entree_loan;

  /// No description provided for @entree_transfer.
  ///
  /// In fr, this message translates to:
  /// **'Transfert interne'**
  String get entree_transfer;

  /// No description provided for @entree_unknown.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu'**
  String get entree_unknown;

  /// No description provided for @dateEntry.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'entrée'**
  String get dateEntry;

  /// No description provided for @noEntryDate.
  ///
  /// In fr, this message translates to:
  /// **'Pas de date d\'entrée'**
  String get noEntryDate;

  /// No description provided for @dateDeparture.
  ///
  /// In fr, this message translates to:
  /// **'Date de sortie'**
  String get dateDeparture;

  /// No description provided for @noDateDeparture.
  ///
  /// In fr, this message translates to:
  /// **'Pas de date de sortie'**
  String get noDateDeparture;

  /// No description provided for @output_select.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez une cause de sortie'**
  String get output_select;

  /// No description provided for @output_reason_required.
  ///
  /// In fr, this message translates to:
  /// **'Cause de sortie obligatoire'**
  String get output_reason_required;

  /// No description provided for @output_death.
  ///
  /// In fr, this message translates to:
  /// **'Mort'**
  String get output_death;

  /// No description provided for @output_boucherie.
  ///
  /// In fr, this message translates to:
  /// **'Vente boucherie'**
  String get output_boucherie;

  /// No description provided for @output_reproducteur.
  ///
  /// In fr, this message translates to:
  /// **'Vente reproducteur'**
  String get output_reproducteur;

  /// No description provided for @output_mutation.
  ///
  /// In fr, this message translates to:
  /// **'Mutation interne'**
  String get output_mutation;

  /// No description provided for @output_error.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de numéro'**
  String get output_error;

  /// No description provided for @output_loan.
  ///
  /// In fr, this message translates to:
  /// **'Prêt ou pension'**
  String get output_loan;

  /// No description provided for @output_auto.
  ///
  /// In fr, this message translates to:
  /// **'Sortie Automatique'**
  String get output_auto;

  /// No description provided for @output_conso.
  ///
  /// In fr, this message translates to:
  /// **'Auto consommation'**
  String get output_conso;

  /// No description provided for @output_unknown.
  ///
  /// In fr, this message translates to:
  /// **'Inconnue'**
  String get output_unknown;

  /// No description provided for @empty_list.
  ///
  /// In fr, this message translates to:
  /// **'Liste des betes vide'**
  String get empty_list;

  /// No description provided for @tooltip_add_beast.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une bête'**
  String get tooltip_add_beast;

  /// No description provided for @batch_name.
  ///
  /// In fr, this message translates to:
  /// **'Nom lot'**
  String get batch_name;

  /// No description provided for @batch_campaign.
  ///
  /// In fr, this message translates to:
  /// **'Campagne'**
  String get batch_campaign;

  /// No description provided for @batch_warning.
  ///
  /// In fr, this message translates to:
  /// **'Vous devez enregistrer le lot avant d\'ajouter'**
  String get batch_warning;

  /// No description provided for @batch_date.
  ///
  /// In fr, this message translates to:
  /// **'Dates'**
  String get batch_date;

  /// No description provided for @batch_no_date_debut.
  ///
  /// In fr, this message translates to:
  /// **'Pas de date de début'**
  String get batch_no_date_debut;

  /// No description provided for @batch_no_date_fin.
  ///
  /// In fr, this message translates to:
  /// **'Pas de date de fin'**
  String get batch_no_date_fin;

  /// No description provided for @batch_no_code.
  ///
  /// In fr, this message translates to:
  /// **'Pas de nom de lot'**
  String get batch_no_code;

  /// No description provided for @weight.
  ///
  /// In fr, this message translates to:
  /// **'Poids'**
  String get weight;

  /// No description provided for @weighing_date.
  ///
  /// In fr, this message translates to:
  /// **'Date de pesée'**
  String get weighing_date;

  /// No description provided for @no_weighing_date.
  ///
  /// In fr, this message translates to:
  /// **'Pas de date de pesée'**
  String get no_weighing_date;

  /// No description provided for @weighing_error.
  ///
  /// In fr, this message translates to:
  /// **'Le poids n\'est pas au format numérique'**
  String get weighing_error;

  /// No description provided for @weighing_hint.
  ///
  /// In fr, this message translates to:
  /// **'Poids en Kg'**
  String get weighing_hint;

  /// No description provided for @no_weight_entered.
  ///
  /// In fr, this message translates to:
  /// **'Pas de poids saisi'**
  String get no_weight_entered;

  /// No description provided for @provisional_number.
  ///
  /// In fr, this message translates to:
  /// **'Numéro provisoire'**
  String get provisional_number;

  /// No description provided for @tooltip_search.
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get tooltip_search;

  /// No description provided for @lambing_date.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'agnelage'**
  String get lambing_date;

  /// No description provided for @enter_lambing_date.
  ///
  /// In fr, this message translates to:
  /// **'Entrer une date d\'agnelage'**
  String get enter_lambing_date;

  /// No description provided for @lambing_default.
  ///
  /// In fr, this message translates to:
  /// **'Défaut d\'agnelage'**
  String get lambing_default;

  /// No description provided for @lambing_quality.
  ///
  /// In fr, this message translates to:
  /// **'Qualité d\'agnelage'**
  String get lambing_quality;

  /// No description provided for @adoption_quality.
  ///
  /// In fr, this message translates to:
  /// **'Qualité adoption'**
  String get adoption_quality;

  /// No description provided for @observations.
  ///
  /// In fr, this message translates to:
  /// **'Observations'**
  String get observations;

  /// No description provided for @validate_lambing.
  ///
  /// In fr, this message translates to:
  /// **'Valider l\'agnelage'**
  String get validate_lambing;

  /// No description provided for @add_lamb.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un agneau'**
  String get add_lamb;

  /// No description provided for @no_lamb.
  ///
  /// In fr, this message translates to:
  /// **'Agnelage sans agneau ?'**
  String get no_lamb;

  /// No description provided for @breastfeeding_not_specified.
  ///
  /// In fr, this message translates to:
  /// **'Allaitement non spécifié'**
  String get breastfeeding_not_specified;

  /// No description provided for @health.
  ///
  /// In fr, this message translates to:
  /// **'Etat de santé'**
  String get health;

  /// No description provided for @alive.
  ///
  /// In fr, this message translates to:
  /// **'Vivant'**
  String get alive;

  /// No description provided for @stillborn.
  ///
  /// In fr, this message translates to:
  /// **'Mort-né'**
  String get stillborn;

  /// No description provided for @aborted.
  ///
  /// In fr, this message translates to:
  /// **'Avorté'**
  String get aborted;

  /// No description provided for @breastfeeding_mode.
  ///
  /// In fr, this message translates to:
  /// **'Mode d\'allaitement'**
  String get breastfeeding_mode;

  /// No description provided for @new_lamb.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel agneau'**
  String get new_lamb;

  /// No description provided for @edit_lamb.
  ///
  /// In fr, this message translates to:
  /// **'modification'**
  String get edit_lamb;

  /// No description provided for @all_ram.
  ///
  /// In fr, this message translates to:
  /// **'Tout béliers'**
  String get all_ram;

  /// No description provided for @no_ram_found.
  ///
  /// In fr, this message translates to:
  /// **'Pas de bélier trouvé avec les critères choisis'**
  String get no_ram_found;

  /// No description provided for @title_lambing_default.
  ///
  /// In fr, this message translates to:
  /// **'Defauts courants sur l\'agnelage'**
  String get title_lambing_default;

  /// No description provided for @text_lambing_default.
  ///
  /// In fr, this message translates to:
  /// **'Permet d\'évaluer les défauts sur l\'agnelage'**
  String get text_lambing_default;

  /// No description provided for @search_ram.
  ///
  /// In fr, this message translates to:
  /// **'Recherche du père'**
  String get search_ram;

  /// No description provided for @adoption_default_title.
  ///
  /// In fr, this message translates to:
  /// **'Défaut d\'adoption'**
  String get adoption_default_title;

  /// No description provided for @echelle_connasse.
  ///
  /// In fr, this message translates to:
  /// **'Echelle des connasses'**
  String get echelle_connasse;

  /// No description provided for @echelle_connasse_text.
  ///
  /// In fr, this message translates to:
  /// **'Permet d\'évaluer les qualités maternelles suivant les critères de Stéphanie Maubé'**
  String get echelle_connasse_text;

  /// No description provided for @adoption_leche.
  ///
  /// In fr, this message translates to:
  /// **'Lèche, appelle et se laisse téter'**
  String get adoption_leche;

  /// No description provided for @adoption_apathique.
  ///
  /// In fr, this message translates to:
  /// **'Apathique'**
  String get adoption_apathique;

  /// No description provided for @adoption_delaisse.
  ///
  /// In fr, this message translates to:
  /// **'Délaisse un des agneaux'**
  String get adoption_delaisse;

  /// No description provided for @adoption_abandon.
  ///
  /// In fr, this message translates to:
  /// **'Abandonne en fuyant'**
  String get adoption_abandon;

  /// No description provided for @adoption_tenir.
  ///
  /// In fr, this message translates to:
  /// **'Maintenir de force pour allaiter'**
  String get adoption_tenir;

  /// No description provided for @adoption_infanticide.
  ///
  /// In fr, this message translates to:
  /// **'Infanticide'**
  String get adoption_infanticide;

  /// No description provided for @agnelage_seul.
  ///
  /// In fr, this message translates to:
  /// **'Seule'**
  String get agnelage_seul;

  /// No description provided for @agnelage_aide.
  ///
  /// In fr, this message translates to:
  /// **'Aidée'**
  String get agnelage_aide;

  /// No description provided for @agnelage_replace.
  ///
  /// In fr, this message translates to:
  /// **'Agneau replacé'**
  String get agnelage_replace;

  /// No description provided for @agnelage_delivrance.
  ///
  /// In fr, this message translates to:
  /// **'Fouillée pour la délivrance'**
  String get agnelage_delivrance;

  /// No description provided for @agnelage_fouille.
  ///
  /// In fr, this message translates to:
  /// **'Fouillée pour l\'agneau'**
  String get agnelage_fouille;

  /// No description provided for @mort_mise_bas.
  ///
  /// In fr, this message translates to:
  /// **'Mise bas'**
  String get mort_mise_bas;

  /// No description provided for @mort_pas_de_contraction_dilatation.
  ///
  /// In fr, this message translates to:
  /// **'Pas de contraction/dilatation'**
  String get mort_pas_de_contraction_dilatation;

  /// No description provided for @mort_prolapsus.
  ///
  /// In fr, this message translates to:
  /// **'Prolapsus'**
  String get mort_prolapsus;

  /// No description provided for @mort_mal_place.
  ///
  /// In fr, this message translates to:
  /// **'Mal placé'**
  String get mort_mal_place;

  /// No description provided for @mort_noye.
  ///
  /// In fr, this message translates to:
  /// **'Noyé, pas respiré(dans poches)'**
  String get mort_noye;

  /// No description provided for @mort_trop_gros.
  ///
  /// In fr, this message translates to:
  /// **'Trop gros'**
  String get mort_trop_gros;

  /// No description provided for @mort_cesarienne.
  ///
  /// In fr, this message translates to:
  /// **'Césarienne'**
  String get mort_cesarienne;

  /// No description provided for @mort_brebis_malade_toxemie.
  ///
  /// In fr, this message translates to:
  /// **'Brebis malade/toxemie'**
  String get mort_brebis_malade_toxemie;

  /// No description provided for @mort_conformation.
  ///
  /// In fr, this message translates to:
  /// **'Conformation'**
  String get mort_conformation;

  /// No description provided for @mort_malforme.
  ///
  /// In fr, this message translates to:
  /// **'Malformé'**
  String get mort_malforme;

  /// No description provided for @mort_chetif_maigre.
  ///
  /// In fr, this message translates to:
  /// **'Très petit / chétif / maigre'**
  String get mort_chetif_maigre;

  /// No description provided for @mort_tetee.
  ///
  /// In fr, this message translates to:
  /// **'Tétée'**
  String get mort_tetee;

  /// No description provided for @mort_incapacite_a_teter.
  ///
  /// In fr, this message translates to:
  /// **'Incapacité à téter'**
  String get mort_incapacite_a_teter;

  /// No description provided for @mort_brebis_sans_lait.
  ///
  /// In fr, this message translates to:
  /// **'Brebis sans lait'**
  String get mort_brebis_sans_lait;

  /// No description provided for @mort_non_accepte.
  ///
  /// In fr, this message translates to:
  /// **'Non accepté'**
  String get mort_non_accepte;

  /// No description provided for @mort_sanitaire.
  ///
  /// In fr, this message translates to:
  /// **'Sanitaire'**
  String get mort_sanitaire;

  /// No description provided for @mort_mou.
  ///
  /// In fr, this message translates to:
  /// **'Mou'**
  String get mort_mou;

  /// No description provided for @mort_baveur_colibacilose.
  ///
  /// In fr, this message translates to:
  /// **'Baveur (colibacilose)'**
  String get mort_baveur_colibacilose;

  /// No description provided for @mort_trembleur_hirsute_border.
  ///
  /// In fr, this message translates to:
  /// **'Trembleur hirsute (border)'**
  String get mort_trembleur_hirsute_border;

  /// No description provided for @mort_ecthyma.
  ///
  /// In fr, this message translates to:
  /// **'Ecthyma'**
  String get mort_ecthyma;

  /// No description provided for @mort_respiratoire.
  ///
  /// In fr, this message translates to:
  /// **'Respiratoire'**
  String get mort_respiratoire;

  /// No description provided for @mort_arthrite_gros_nombril.
  ///
  /// In fr, this message translates to:
  /// **'Arthrite/gros nombril'**
  String get mort_arthrite_gros_nombril;

  /// No description provided for @mort_lithiase_urinaire.
  ///
  /// In fr, this message translates to:
  /// **'Lithiase urinaire'**
  String get mort_lithiase_urinaire;

  /// No description provided for @mort_nerveux_metabolique.
  ///
  /// In fr, this message translates to:
  /// **'Nerveux/metabolique'**
  String get mort_nerveux_metabolique;

  /// No description provided for @mort_raide.
  ///
  /// In fr, this message translates to:
  /// **'Raide'**
  String get mort_raide;

  /// No description provided for @mort_tetanos.
  ///
  /// In fr, this message translates to:
  /// **'Tetanos'**
  String get mort_tetanos;

  /// No description provided for @mort_necrose_cortex_cerebral.
  ///
  /// In fr, this message translates to:
  /// **'Necrose cortex cérébral'**
  String get mort_necrose_cortex_cerebral;

  /// No description provided for @mort_digestif.
  ///
  /// In fr, this message translates to:
  /// **'Digestif'**
  String get mort_digestif;

  /// No description provided for @mort_diarrhee.
  ///
  /// In fr, this message translates to:
  /// **'Diarrhée'**
  String get mort_diarrhee;

  /// No description provided for @mort_ballonne_enterotoxemie.
  ///
  /// In fr, this message translates to:
  /// **'Ballonné ou entérotoxémie'**
  String get mort_ballonne_enterotoxemie;

  /// No description provided for @mort_coccidiose.
  ///
  /// In fr, this message translates to:
  /// **'Coccidiose'**
  String get mort_coccidiose;

  /// No description provided for @mort_autres.
  ///
  /// In fr, this message translates to:
  /// **'Autres'**
  String get mort_autres;

  /// No description provided for @mort_ecrase.
  ///
  /// In fr, this message translates to:
  /// **'Ecrasé'**
  String get mort_ecrase;

  /// No description provided for @mort_maigre.
  ///
  /// In fr, this message translates to:
  /// **'Maigre'**
  String get mort_maigre;

  /// No description provided for @mort_accident.
  ///
  /// In fr, this message translates to:
  /// **'Accident'**
  String get mort_accident;

  /// No description provided for @mort_disparu.
  ///
  /// In fr, this message translates to:
  /// **'Disparu'**
  String get mort_disparu;

  /// No description provided for @mort_autre.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get mort_autre;

  /// No description provided for @mort_inconnue.
  ///
  /// In fr, this message translates to:
  /// **'Inconnue'**
  String get mort_inconnue;

  /// No description provided for @select_death_cause.
  ///
  /// In fr, this message translates to:
  /// **'Selectionnez une cause de décès'**
  String get select_death_cause;

  /// No description provided for @death_date.
  ///
  /// In fr, this message translates to:
  /// **'Date de décès'**
  String get death_date;

  /// No description provided for @no_death_date.
  ///
  /// In fr, this message translates to:
  /// **'Pas de date de décès'**
  String get no_death_date;

  /// No description provided for @death_cause_mandatory.
  ///
  /// In fr, this message translates to:
  /// **'Cause de décès obligatoire'**
  String get death_cause_mandatory;

  /// No description provided for @date_ultrasound.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'echographie'**
  String get date_ultrasound;

  /// No description provided for @estimated_mating_date.
  ///
  /// In fr, this message translates to:
  /// **'Date de saillie estimée'**
  String get estimated_mating_date;

  /// No description provided for @expected_lambing_date.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'agnelage prévu'**
  String get expected_lambing_date;

  /// No description provided for @result.
  ///
  /// In fr, this message translates to:
  /// **'Résultat'**
  String get result;

  /// No description provided for @empty.
  ///
  /// In fr, this message translates to:
  /// **'Vide'**
  String get empty;

  /// No description provided for @simple.
  ///
  /// In fr, this message translates to:
  /// **'Simple'**
  String get simple;

  /// No description provided for @double.
  ///
  /// In fr, this message translates to:
  /// **'Double'**
  String get double;

  /// No description provided for @triplet.
  ///
  /// In fr, this message translates to:
  /// **'Triplet et +'**
  String get triplet;

  /// No description provided for @number_fetuses_empty.
  ///
  /// In fr, this message translates to:
  /// **'Le nombre de foetus est vide'**
  String get number_fetuses_empty;

  /// No description provided for @no_ultrasound_date.
  ///
  /// In fr, this message translates to:
  /// **'Pas de date d\'écho'**
  String get no_ultrasound_date;

  /// No description provided for @male.
  ///
  /// In fr, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In fr, this message translates to:
  /// **'Femelle'**
  String get female;

  /// No description provided for @ram.
  ///
  /// In fr, this message translates to:
  /// **'Bélier'**
  String get ram;

  /// No description provided for @ewe.
  ///
  /// In fr, this message translates to:
  /// **'Brebis'**
  String get ewe;

  /// No description provided for @collective_treatment.
  ///
  /// In fr, this message translates to:
  /// **'Traitement collectif'**
  String get collective_treatment;

  /// No description provided for @prescription.
  ///
  /// In fr, this message translates to:
  /// **'Ordonnance'**
  String get prescription;

  /// No description provided for @medication.
  ///
  /// In fr, this message translates to:
  /// **'Medicament'**
  String get medication;

  /// No description provided for @route.
  ///
  /// In fr, this message translates to:
  /// **'Voie'**
  String get route;

  /// No description provided for @dose.
  ///
  /// In fr, this message translates to:
  /// **'Dose'**
  String get dose;

  /// No description provided for @rythme.
  ///
  /// In fr, this message translates to:
  /// **'Rythme'**
  String get rythme;

  /// No description provided for @contributor.
  ///
  /// In fr, this message translates to:
  /// **'Intervenant'**
  String get contributor;

  /// No description provided for @reason.
  ///
  /// In fr, this message translates to:
  /// **'Motif'**
  String get reason;

  /// No description provided for @treatment_explanation.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez tous les individus qui vont recevoir le traitement avant de continuer'**
  String get treatment_explanation;

  /// No description provided for @mating_date.
  ///
  /// In fr, this message translates to:
  /// **'Date de saillie'**
  String get mating_date;

  /// No description provided for @no_mating_date.
  ///
  /// In fr, this message translates to:
  /// **'Pas de date saisie'**
  String get no_mating_date;

  /// No description provided for @mating_male_text.
  ///
  /// In fr, this message translates to:
  /// **'Si vide, la saillie ne sera pas enregistrée ou sera supprimée'**
  String get mating_male_text;

  /// No description provided for @bt_cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get bt_cancel;

  /// No description provided for @bt_continue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get bt_continue;

  /// No description provided for @bt_save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get bt_save;

  /// No description provided for @bt_add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get bt_add;

  /// No description provided for @bt_delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get bt_delete;

  /// No description provided for @bt_edition.
  ///
  /// In fr, this message translates to:
  /// **'Edition'**
  String get bt_edition;

  /// No description provided for @bt_validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider la sélection'**
  String get bt_validate;

  /// No description provided for @record_saved.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement effectué'**
  String get record_saved;

  /// No description provided for @title_delete.
  ///
  /// In fr, this message translates to:
  /// **'Suppression'**
  String get title_delete;

  /// No description provided for @text_delete.
  ///
  /// In fr, this message translates to:
  /// **'Voulez vous supprimer cet enregistrement ?'**
  String get text_delete;

  /// No description provided for @date_debut.
  ///
  /// In fr, this message translates to:
  /// **'Date début'**
  String get date_debut;

  /// No description provided for @no_date_debut.
  ///
  /// In fr, this message translates to:
  /// **'Pas de date de début'**
  String get no_date_debut;

  /// No description provided for @date_fin.
  ///
  /// In fr, this message translates to:
  /// **'Date fin'**
  String get date_fin;

  /// No description provided for @note_label.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get note_label;

  /// No description provided for @note_hint.
  ///
  /// In fr, this message translates to:
  /// **'Information sur cette bête'**
  String get note_hint;

  /// No description provided for @no_note.
  ///
  /// In fr, this message translates to:
  /// **'Pas de note saisie'**
  String get no_note;

  /// No description provided for @warning.
  ///
  /// In fr, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @alert.
  ///
  /// In fr, this message translates to:
  /// **'Alerte'**
  String get alert;

  /// No description provided for @info.
  ///
  /// In fr, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @dateDeNotation.
  ///
  /// In fr, this message translates to:
  /// **'Date de notation'**
  String get dateDeNotation;

  /// No description provided for @connected_mode.
  ///
  /// In fr, this message translates to:
  /// **'Mode connecté'**
  String get connected_mode;

  /// No description provided for @connected_mode_text.
  ///
  /// In fr, this message translates to:
  /// **'Dans ce mode, les données seront enregistrées sur le serveur.\nCe mode nécesite un compte sur gismo'**
  String get connected_mode_text;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @connection.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get connection;

  /// No description provided for @alone_mode.
  ///
  /// In fr, this message translates to:
  /// **'Mode autonome'**
  String get alone_mode;

  /// No description provided for @alone_mode_text.
  ///
  /// In fr, this message translates to:
  /// **'Dans ce mode, les données seront enregistrés dans une base de données de votre téléphone.\nCopiez votre base de données locale pour la sauvegarder sur un PC et la restaurer en cas de besoin.'**
  String get alone_mode_text;

  /// No description provided for @data_null.
  ///
  /// In fr, this message translates to:
  /// **'Data null'**
  String get data_null;

  /// No description provided for @copy_base.
  ///
  /// In fr, this message translates to:
  /// **'Copier la base de données'**
  String get copy_base;

  /// No description provided for @empty_folder.
  ///
  /// In fr, this message translates to:
  /// **'Répertoire vide'**
  String get empty_folder;

  /// No description provided for @restore_bd.
  ///
  /// In fr, this message translates to:
  /// **'Restauration de la BD'**
  String get restore_bd;

  /// No description provided for @restore_bd_text.
  ///
  /// In fr, this message translates to:
  /// **'Les données actuelles seront remplacées.'**
  String get restore_bd_text;

  /// No description provided for @with_subscription.
  ///
  /// In fr, this message translates to:
  /// **'Avec abonnement'**
  String get with_subscription;

  /// No description provided for @save_config.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer la configuration'**
  String get save_config;

  /// No description provided for @bluetooth_autorisation.
  ///
  /// In fr, this message translates to:
  /// **'Autorisation bluetooth'**
  String get bluetooth_autorisation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
