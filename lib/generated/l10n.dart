// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Batch`
  String get batch {
    return Intl.message('Batch', name: 'batch', desc: '', args: []);
  }

  /// `Sheep`
  String get sheep {
    return Intl.message('Sheep', name: 'sheep', desc: '', args: []);
  }

  /// `Lambing`
  String get lambing {
    return Intl.message('Lambing', name: 'lambing', desc: '', args: []);
  }

  /// `Lambs`
  String get lambs {
    return Intl.message('Lambs', name: 'lambs', desc: '', args: []);
  }

  /// `Ultrasound`
  String get ultrasound {
    return Intl.message('Ultrasound', name: 'ultrasound', desc: '', args: []);
  }

  /// `Mating`
  String get mating {
    return Intl.message('Mating', name: 'mating', desc: '', args: []);
  }

  /// `Weighing`
  String get weighing {
    return Intl.message('Weighing', name: 'weighing', desc: '', args: []);
  }

  /// `Body cond.`
  String get body_cond {
    return Intl.message('Body cond.', name: 'body_cond', desc: '', args: []);
  }

  /// `Body condition note`
  String get body_cond_full {
    return Intl.message(
      'Body condition note',
      name: 'body_cond_full',
      desc: '',
      args: [],
    );
  }

  /// `Treatment`
  String get treatment {
    return Intl.message('Treatment', name: 'treatment', desc: '', args: []);
  }

  /// `Entry`
  String get input {
    return Intl.message('Entry', name: 'input', desc: '', args: []);
  }

  /// `Departure`
  String get output {
    return Intl.message('Departure', name: 'output', desc: '', args: []);
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Memo`
  String get memo {
    return Intl.message('Memo', name: 'memo', desc: '', args: []);
  }

  /// `Configuration`
  String get configuration {
    return Intl.message(
      'Configuration',
      name: 'configuration',
      desc: '',
      args: [],
    );
  }

  /// `Local user`
  String get localuser {
    return Intl.message('Local user', name: 'localuser', desc: '', args: []);
  }

  /// `User error`
  String get user_error {
    return Intl.message('User error', name: 'user_error', desc: '', args: []);
  }

  /// `Ear tag`
  String get earring {
    return Intl.message('Ear tag', name: 'earring', desc: '', args: []);
  }

  /// `Search ear tag`
  String get earring_search {
    return Intl.message(
      'Search ear tag',
      name: 'earring_search',
      desc: '',
      args: [],
    );
  }

  /// `Place the ear tag`
  String get place_earring {
    return Intl.message(
      'Place the ear tag',
      name: 'place_earring',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Empty list`
  String get title_empty_list {
    return Intl.message(
      'Empty list',
      name: 'title_empty_list',
      desc: '',
      args: [],
    );
  }

  /// `To enter lifestock, make an entry from the main screen.`
  String get text_empty_list {
    return Intl.message(
      'To enter lifestock, make an entry from the main screen.',
      name: 'text_empty_list',
      desc: '',
      args: [],
    );
  }

  /// `Herd size`
  String get herd_size {
    return Intl.message('Herd size', name: 'herd_size', desc: '', args: []);
  }

  /// `Not connected`
  String get not_connected {
    return Intl.message(
      'Not connected',
      name: 'not_connected',
      desc: '',
      args: [],
    );
  }

  /// `Data available`
  String get data_available {
    return Intl.message(
      'Data available',
      name: 'data_available',
      desc: '',
      args: [],
    );
  }

  /// `No ear tag read`
  String get no_earring_read {
    return Intl.message(
      'No ear tag read',
      name: 'no_earring_read',
      desc: '',
      args: [],
    );
  }

  /// `Flock number`
  String get flock_number {
    return Intl.message(
      'Flock number',
      name: 'flock_number',
      desc: '',
      args: [],
    );
  }

  /// `Flock`
  String get flock_number_hint {
    return Intl.message('Flock', name: 'flock_number_hint', desc: '', args: []);
  }

  /// `Enter a flock number`
  String get enter_flock_number {
    return Intl.message(
      'Enter a flock number',
      name: 'enter_flock_number',
      desc: '',
      args: [],
    );
  }

  /// `Flock number missing`
  String get flock_number_warn {
    return Intl.message(
      'Flock number missing',
      name: 'flock_number_warn',
      desc: '',
      args: [],
    );
  }

  /// `Identity number`
  String get identity_number {
    return Intl.message(
      'Identity number',
      name: 'identity_number',
      desc: '',
      args: [],
    );
  }

  /// `Identity`
  String get identity_number_hint {
    return Intl.message(
      'Identity',
      name: 'identity_number_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter an identity number`
  String get enter_identity_number {
    return Intl.message(
      'Enter an identity number',
      name: 'enter_identity_number',
      desc: '',
      args: [],
    );
  }

  /// `Identity number missing`
  String get identity_number_warn {
    return Intl.message(
      'Identity number missing',
      name: 'identity_number_warn',
      desc: '',
      args: [],
    );
  }

  /// `Sex missing`
  String get sex_warn {
    return Intl.message('Sex missing', name: 'sex_warn', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Name`
  String get name_hint {
    return Intl.message('Name', name: 'name_hint', desc: '', args: []);
  }

  /// `Identity number is already present`
  String get identity_number_error {
    return Intl.message(
      'Identity number is already present',
      name: 'identity_number_error',
      desc: '',
      args: [],
    );
  }

  /// `Select an entry reason`
  String get entree_select {
    return Intl.message(
      'Select an entry reason',
      name: 'entree_select',
      desc: '',
      args: [],
    );
  }

  /// `Entry reason is required`
  String get entree_reason_required {
    return Intl.message(
      'Entry reason is required',
      name: 'entree_reason_required',
      desc: '',
      args: [],
    );
  }

  /// `Birth`
  String get entree_birth {
    return Intl.message('Birth', name: 'entree_birth', desc: '', args: []);
  }

  /// `Creation`
  String get entree_creation {
    return Intl.message(
      'Creation',
      name: 'entree_creation',
      desc: '',
      args: [],
    );
  }

  /// `Renewal`
  String get entree_renewal {
    return Intl.message('Renewal', name: 'entree_renewal', desc: '', args: []);
  }

  /// `Purchase`
  String get entree_purchase {
    return Intl.message(
      'Purchase',
      name: 'entree_purchase',
      desc: '',
      args: [],
    );
  }

  /// `Reactivation`
  String get entree_reactivation {
    return Intl.message(
      'Reactivation',
      name: 'entree_reactivation',
      desc: '',
      args: [],
    );
  }

  /// `Loan or pension`
  String get entree_loan {
    return Intl.message(
      'Loan or pension',
      name: 'entree_loan',
      desc: '',
      args: [],
    );
  }

  /// `Internal transfer`
  String get entree_transfer {
    return Intl.message(
      'Internal transfer',
      name: 'entree_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get entree_unknown {
    return Intl.message('Unknown', name: 'entree_unknown', desc: '', args: []);
  }

  /// `Date of entry`
  String get dateEntry {
    return Intl.message('Date of entry', name: 'dateEntry', desc: '', args: []);
  }

  /// `No entry date`
  String get noEntryDate {
    return Intl.message(
      'No entry date',
      name: 'noEntryDate',
      desc: '',
      args: [],
    );
  }

  /// `Date of departure`
  String get dateDeparture {
    return Intl.message(
      'Date of departure',
      name: 'dateDeparture',
      desc: '',
      args: [],
    );
  }

  /// `No date of departure`
  String get noDateDeparture {
    return Intl.message(
      'No date of departure',
      name: 'noDateDeparture',
      desc: '',
      args: [],
    );
  }

  /// `Select a departure reason`
  String get output_select {
    return Intl.message(
      'Select a departure reason',
      name: 'output_select',
      desc: '',
      args: [],
    );
  }

  /// `Departure reason is required`
  String get output_reason_required {
    return Intl.message(
      'Departure reason is required',
      name: 'output_reason_required',
      desc: '',
      args: [],
    );
  }

  /// `Death`
  String get output_death {
    return Intl.message('Death', name: 'output_death', desc: '', args: []);
  }

  /// `Butchery shop sale`
  String get output_boucherie {
    return Intl.message(
      'Butchery shop sale',
      name: 'output_boucherie',
      desc: '',
      args: [],
    );
  }

  /// `Breeder sale`
  String get output_reproducteur {
    return Intl.message(
      'Breeder sale',
      name: 'output_reproducteur',
      desc: '',
      args: [],
    );
  }

  /// `Internal mutation`
  String get output_mutation {
    return Intl.message(
      'Internal mutation',
      name: 'output_mutation',
      desc: '',
      args: [],
    );
  }

  /// `Number error`
  String get output_error {
    return Intl.message(
      'Number error',
      name: 'output_error',
      desc: '',
      args: [],
    );
  }

  /// `Loan or pension`
  String get output_loan {
    return Intl.message(
      'Loan or pension',
      name: 'output_loan',
      desc: '',
      args: [],
    );
  }

  /// `Automatic output`
  String get output_auto {
    return Intl.message(
      'Automatic output',
      name: 'output_auto',
      desc: '',
      args: [],
    );
  }

  /// `Self-consumption`
  String get output_conso {
    return Intl.message(
      'Self-consumption',
      name: 'output_conso',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get output_unknown {
    return Intl.message('Unknown', name: 'output_unknown', desc: '', args: []);
  }

  /// `Empty beast list`
  String get empty_list {
    return Intl.message(
      'Empty beast list',
      name: 'empty_list',
      desc: '',
      args: [],
    );
  }

  /// `Add a beast`
  String get tooltip_add_beast {
    return Intl.message(
      'Add a beast',
      name: 'tooltip_add_beast',
      desc: '',
      args: [],
    );
  }

  /// `Batch name`
  String get batch_name {
    return Intl.message('Batch name', name: 'batch_name', desc: '', args: []);
  }

  /// `Campaign`
  String get batch_campaign {
    return Intl.message('Campaign', name: 'batch_campaign', desc: '', args: []);
  }

  /// `You must save the batch before add`
  String get batch_warning {
    return Intl.message(
      'You must save the batch before add',
      name: 'batch_warning',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight {
    return Intl.message('Weight', name: 'weight', desc: '', args: []);
  }

  /// `Weighing date`
  String get weighing_date {
    return Intl.message(
      'Weighing date',
      name: 'weighing_date',
      desc: '',
      args: [],
    );
  }

  /// `No weighing date`
  String get no_weighing_date {
    return Intl.message(
      'No weighing date',
      name: 'no_weighing_date',
      desc: '',
      args: [],
    );
  }

  /// `weighing has not a number format`
  String get weighing_error {
    return Intl.message(
      'weighing has not a number format',
      name: 'weighing_error',
      desc: '',
      args: [],
    );
  }

  /// `Weight in Kg`
  String get weighing_hint {
    return Intl.message(
      'Weight in Kg',
      name: 'weighing_hint',
      desc: '',
      args: [],
    );
  }

  /// `No weight entered`
  String get no_weight_entered {
    return Intl.message(
      'No weight entered',
      name: 'no_weight_entered',
      desc: '',
      args: [],
    );
  }

  /// `Provisional number`
  String get provisional_number {
    return Intl.message(
      'Provisional number',
      name: 'provisional_number',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get tooltip_search {
    return Intl.message('Search', name: 'tooltip_search', desc: '', args: []);
  }

  /// `Lambing date`
  String get lambing_date {
    return Intl.message(
      'Lambing date',
      name: 'lambing_date',
      desc: '',
      args: [],
    );
  }

  /// `Enter a lambing date`
  String get enter_lambing_date {
    return Intl.message(
      'Enter a lambing date',
      name: 'enter_lambing_date',
      desc: '',
      args: [],
    );
  }

  /// `Lambing default`
  String get lambing_default {
    return Intl.message(
      'Lambing default',
      name: 'lambing_default',
      desc: '',
      args: [],
    );
  }

  /// `Lambing quality`
  String get lambing_quality {
    return Intl.message(
      'Lambing quality',
      name: 'lambing_quality',
      desc: '',
      args: [],
    );
  }

  /// `Adoption quality`
  String get adoption_quality {
    return Intl.message(
      'Adoption quality',
      name: 'adoption_quality',
      desc: '',
      args: [],
    );
  }

  /// `Observations`
  String get observations {
    return Intl.message(
      'Observations',
      name: 'observations',
      desc: '',
      args: [],
    );
  }

  /// `Validate lambing`
  String get validate_lambing {
    return Intl.message(
      'Validate lambing',
      name: 'validate_lambing',
      desc: '',
      args: [],
    );
  }

  /// `Add a lamb`
  String get add_lamb {
    return Intl.message('Add a lamb', name: 'add_lamb', desc: '', args: []);
  }

  /// `Breastfeeding not specified`
  String get breastfeeding_not_specified {
    return Intl.message(
      'Breastfeeding not specified',
      name: 'breastfeeding_not_specified',
      desc: '',
      args: [],
    );
  }

  /// `Health`
  String get health {
    return Intl.message('Health', name: 'health', desc: '', args: []);
  }

  /// `Alive`
  String get alive {
    return Intl.message('Alive', name: 'alive', desc: '', args: []);
  }

  /// `Stillborn`
  String get stillborn {
    return Intl.message('Stillborn', name: 'stillborn', desc: '', args: []);
  }

  /// `Aborted`
  String get aborted {
    return Intl.message('Aborted', name: 'aborted', desc: '', args: []);
  }

  /// `Breastfeeding mode`
  String get breastfeeding_mode {
    return Intl.message(
      'Breastfeeding mode',
      name: 'breastfeeding_mode',
      desc: '',
      args: [],
    );
  }

  /// `New lamb`
  String get new_lamb {
    return Intl.message('New lamb', name: 'new_lamb', desc: '', args: []);
  }

  /// `edit`
  String get edit_lamb {
    return Intl.message('edit', name: 'edit_lamb', desc: '', args: []);
  }

  /// `All ram`
  String get all_ram {
    return Intl.message('All ram', name: 'all_ram', desc: '', args: []);
  }

  /// `No ram found with this criteria`
  String get no_ram_found {
    return Intl.message(
      'No ram found with this criteria',
      name: 'no_ram_found',
      desc: '',
      args: [],
    );
  }

  /// `Common faults in lambing`
  String get title_lambing_default {
    return Intl.message(
      'Common faults in lambing',
      name: 'title_lambing_default',
      desc: '',
      args: [],
    );
  }

  /// `Allows to evaluate faults on lambing`
  String get text_lambing_default {
    return Intl.message(
      'Allows to evaluate faults on lambing',
      name: 'text_lambing_default',
      desc: '',
      args: [],
    );
  }

  /// `Search ram`
  String get search_ram {
    return Intl.message('Search ram', name: 'search_ram', desc: '', args: []);
  }

  /// `Lack of adoption`
  String get adoption_default_title {
    return Intl.message(
      'Lack of adoption',
      name: 'adoption_default_title',
      desc: '',
      args: [],
    );
  }

  /// `Scale of bitches`
  String get echelle_connasse {
    return Intl.message(
      'Scale of bitches',
      name: 'echelle_connasse',
      desc: '',
      args: [],
    );
  }

  /// `Allows to evaluate the maternal qualities according to the criteria of Stéphanie Maubé`
  String get echelle_connasse_text {
    return Intl.message(
      'Allows to evaluate the maternal qualities according to the criteria of Stéphanie Maubé',
      name: 'echelle_connasse_text',
      desc: '',
      args: [],
    );
  }

  /// `Lick, call and let itself be suckled`
  String get adoption_leche {
    return Intl.message(
      'Lick, call and let itself be suckled',
      name: 'adoption_leche',
      desc: '',
      args: [],
    );
  }

  /// `Apathetic`
  String get adoption_apathique {
    return Intl.message(
      'Apathetic',
      name: 'adoption_apathique',
      desc: '',
      args: [],
    );
  }

  /// `leave one of the lambs`
  String get adoption_delaisse {
    return Intl.message(
      'leave one of the lambs',
      name: 'adoption_delaisse',
      desc: '',
      args: [],
    );
  }

  /// `Abandoned while fleeing`
  String get adoption_abandon {
    return Intl.message(
      'Abandoned while fleeing',
      name: 'adoption_abandon',
      desc: '',
      args: [],
    );
  }

  /// `Hold for breastfeeding`
  String get adoption_tenir {
    return Intl.message(
      'Hold for breastfeeding',
      name: 'adoption_tenir',
      desc: '',
      args: [],
    );
  }

  /// `Kill one`
  String get adoption_infanticide {
    return Intl.message(
      'Kill one',
      name: 'adoption_infanticide',
      desc: '',
      args: [],
    );
  }

  /// `Alone`
  String get agnelage_seul {
    return Intl.message('Alone', name: 'agnelage_seul', desc: '', args: []);
  }

  /// `Helped`
  String get agnelage_aide {
    return Intl.message('Helped', name: 'agnelage_aide', desc: '', args: []);
  }

  /// `Agneau replacé`
  String get agnelage_replace {
    return Intl.message(
      'Agneau replacé',
      name: 'agnelage_replace',
      desc: '',
      args: [],
    );
  }

  /// `Manual remove of retained placenta`
  String get agnelage_delivrance {
    return Intl.message(
      'Manual remove of retained placenta',
      name: 'agnelage_delivrance',
      desc: '',
      args: [],
    );
  }

  /// `Fouillée pour l'agneau`
  String get agnelage_fouille {
    return Intl.message(
      'Fouillée pour l\'agneau',
      name: 'agnelage_fouille',
      desc: '',
      args: [],
    );
  }

  /// `Farrowing`
  String get mort_mise_bas {
    return Intl.message('Farrowing', name: 'mort_mise_bas', desc: '', args: []);
  }

  /// `No contraction/dilation`
  String get mort_pas_de_contraction_dilatation {
    return Intl.message(
      'No contraction/dilation',
      name: 'mort_pas_de_contraction_dilatation',
      desc: '',
      args: [],
    );
  }

  /// `Prolapsus`
  String get mort_prolapsus {
    return Intl.message(
      'Prolapsus',
      name: 'mort_prolapsus',
      desc: '',
      args: [],
    );
  }

  /// `Misplaced`
  String get mort_mal_place {
    return Intl.message(
      'Misplaced',
      name: 'mort_mal_place',
      desc: '',
      args: [],
    );
  }

  /// `Drowned, not breathed (in pockets)`
  String get mort_noye {
    return Intl.message(
      'Drowned, not breathed (in pockets)',
      name: 'mort_noye',
      desc: '',
      args: [],
    );
  }

  /// `Too fat`
  String get mort_trop_gros {
    return Intl.message('Too fat', name: 'mort_trop_gros', desc: '', args: []);
  }

  /// `Caesarean `
  String get mort_cesarienne {
    return Intl.message(
      'Caesarean ',
      name: 'mort_cesarienne',
      desc: '',
      args: [],
    );
  }

  /// `Sick sheep/toxaemia`
  String get mort_brebis_malade_toxemie {
    return Intl.message(
      'Sick sheep/toxaemia',
      name: 'mort_brebis_malade_toxemie',
      desc: '',
      args: [],
    );
  }

  /// `Conformation`
  String get mort_conformation {
    return Intl.message(
      'Conformation',
      name: 'mort_conformation',
      desc: '',
      args: [],
    );
  }

  /// `Malformed`
  String get mort_malforme {
    return Intl.message('Malformed', name: 'mort_malforme', desc: '', args: []);
  }

  /// `Very small / skinny / thin`
  String get mort_chetif_maigre {
    return Intl.message(
      'Very small / skinny / thin',
      name: 'mort_chetif_maigre',
      desc: '',
      args: [],
    );
  }

  /// `Breastfeeding`
  String get mort_tetee {
    return Intl.message(
      'Breastfeeding',
      name: 'mort_tetee',
      desc: '',
      args: [],
    );
  }

  /// `Inability to breastfeed`
  String get mort_incapacite_a_teter {
    return Intl.message(
      'Inability to breastfeed',
      name: 'mort_incapacite_a_teter',
      desc: '',
      args: [],
    );
  }

  /// `Ewe without milk`
  String get mort_brebis_sans_lait {
    return Intl.message(
      'Ewe without milk',
      name: 'mort_brebis_sans_lait',
      desc: '',
      args: [],
    );
  }

  /// `Not accepted`
  String get mort_non_accepte {
    return Intl.message(
      'Not accepted',
      name: 'mort_non_accepte',
      desc: '',
      args: [],
    );
  }

  /// `Sanitary`
  String get mort_sanitaire {
    return Intl.message('Sanitary', name: 'mort_sanitaire', desc: '', args: []);
  }

  /// `Mou`
  String get mort_mou {
    return Intl.message('Mou', name: 'mort_mou', desc: '', args: []);
  }

  /// `Baveur (colibacilose)`
  String get mort_baveur_colibacilose {
    return Intl.message(
      'Baveur (colibacilose)',
      name: 'mort_baveur_colibacilose',
      desc: '',
      args: [],
    );
  }

  /// `Trembleur hirsute (border)`
  String get mort_trembleur_hirsute_border {
    return Intl.message(
      'Trembleur hirsute (border)',
      name: 'mort_trembleur_hirsute_border',
      desc: '',
      args: [],
    );
  }

  /// `Ecthyma`
  String get mort_ecthyma {
    return Intl.message('Ecthyma', name: 'mort_ecthyma', desc: '', args: []);
  }

  /// `Respiratory`
  String get mort_respiratoire {
    return Intl.message(
      'Respiratory',
      name: 'mort_respiratoire',
      desc: '',
      args: [],
    );
  }

  /// `Arthritis/Big navel`
  String get mort_arthrite_gros_nombril {
    return Intl.message(
      'Arthritis/Big navel',
      name: 'mort_arthrite_gros_nombril',
      desc: '',
      args: [],
    );
  }

  /// `Urolithiasis`
  String get mort_lithiase_urinaire {
    return Intl.message(
      'Urolithiasis',
      name: 'mort_lithiase_urinaire',
      desc: '',
      args: [],
    );
  }

  /// `nervous/metabolic`
  String get mort_nerveux_metabolique {
    return Intl.message(
      'nervous/metabolic',
      name: 'mort_nerveux_metabolique',
      desc: '',
      args: [],
    );
  }

  /// `Raide`
  String get mort_raide {
    return Intl.message('Raide', name: 'mort_raide', desc: '', args: []);
  }

  /// `Tetanos`
  String get mort_tetanos {
    return Intl.message('Tetanos', name: 'mort_tetanos', desc: '', args: []);
  }

  /// `Cerebral cortex necrosis`
  String get mort_necrose_cortex_cerebral {
    return Intl.message(
      'Cerebral cortex necrosis',
      name: 'mort_necrose_cortex_cerebral',
      desc: '',
      args: [],
    );
  }

  /// `Digestive`
  String get mort_digestif {
    return Intl.message('Digestive', name: 'mort_digestif', desc: '', args: []);
  }

  /// `Diarrhea`
  String get mort_diarrhee {
    return Intl.message('Diarrhea', name: 'mort_diarrhee', desc: '', args: []);
  }

  /// `Bloating or enterotoxemia`
  String get mort_ballonne_enterotoxemie {
    return Intl.message(
      'Bloating or enterotoxemia',
      name: 'mort_ballonne_enterotoxemie',
      desc: '',
      args: [],
    );
  }

  /// `Coccidiose`
  String get mort_coccidiose {
    return Intl.message(
      'Coccidiose',
      name: 'mort_coccidiose',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get mort_autre {
    return Intl.message('Other', name: 'mort_autre', desc: '', args: []);
  }

  /// `Crushed`
  String get mort_ecrase {
    return Intl.message('Crushed', name: 'mort_ecrase', desc: '', args: []);
  }

  /// `Thin`
  String get mort_maigre {
    return Intl.message('Thin', name: 'mort_maigre', desc: '', args: []);
  }

  /// `Accident`
  String get mort_accident {
    return Intl.message('Accident', name: 'mort_accident', desc: '', args: []);
  }

  /// `Missing`
  String get mort_disparu {
    return Intl.message('Missing', name: 'mort_disparu', desc: '', args: []);
  }

  /// `Unknown`
  String get mort_inconnue {
    return Intl.message('Unknown', name: 'mort_inconnue', desc: '', args: []);
  }

  /// `Others`
  String get mort_autres {
    return Intl.message('Others', name: 'mort_autres', desc: '', args: []);
  }

  /// `Select a death cause`
  String get select_death_cause {
    return Intl.message(
      'Select a death cause',
      name: 'select_death_cause',
      desc: '',
      args: [],
    );
  }

  /// `Death date`
  String get death_date {
    return Intl.message('Death date', name: 'death_date', desc: '', args: []);
  }

  /// `No death date`
  String get no_death_date {
    return Intl.message(
      'No death date',
      name: 'no_death_date',
      desc: '',
      args: [],
    );
  }

  /// `Death cause requiered`
  String get death_cause_mandatory {
    return Intl.message(
      'Death cause requiered',
      name: 'death_cause_mandatory',
      desc: '',
      args: [],
    );
  }

  /// `Date of ultrasound`
  String get date_ultrasound {
    return Intl.message(
      'Date of ultrasound',
      name: 'date_ultrasound',
      desc: '',
      args: [],
    );
  }

  /// `Estimated mating date`
  String get estimated_mating_date {
    return Intl.message(
      'Estimated mating date',
      name: 'estimated_mating_date',
      desc: '',
      args: [],
    );
  }

  /// `Expected lambing date`
  String get expected_lambing_date {
    return Intl.message(
      'Expected lambing date',
      name: 'expected_lambing_date',
      desc: '',
      args: [],
    );
  }

  /// `Result`
  String get result {
    return Intl.message('Result', name: 'result', desc: '', args: []);
  }

  /// `Empty`
  String get empty {
    return Intl.message('Empty', name: 'empty', desc: '', args: []);
  }

  /// `Simple`
  String get simple {
    return Intl.message('Simple', name: 'simple', desc: '', args: []);
  }

  /// `Double`
  String get double {
    return Intl.message('Double', name: 'double', desc: '', args: []);
  }

  /// `Triplet and +`
  String get triplet {
    return Intl.message('Triplet and +', name: 'triplet', desc: '', args: []);
  }

  /// `The number of fetuses is empty`
  String get number_fetuses_empty {
    return Intl.message(
      'The number of fetuses is empty',
      name: 'number_fetuses_empty',
      desc: '',
      args: [],
    );
  }

  /// `No ultrasound date`
  String get no_ultrasound_date {
    return Intl.message(
      'No ultrasound date',
      name: 'no_ultrasound_date',
      desc: '',
      args: [],
    );
  }

  /// `Mating date`
  String get mating_date {
    return Intl.message('Mating date', name: 'mating_date', desc: '', args: []);
  }

  /// `No mating date`
  String get no_mating_date {
    return Intl.message(
      'No mating date',
      name: 'no_mating_date',
      desc: '',
      args: [],
    );
  }

  /// `If empty, the mating won't be saved or will be deleted`
  String get mating_male_text {
    return Intl.message(
      'If empty, the mating won\'t be saved or will be deleted',
      name: 'mating_male_text',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Ram`
  String get ram {
    return Intl.message('Ram', name: 'ram', desc: '', args: []);
  }

  /// `Ewe`
  String get ewe {
    return Intl.message('Ewe', name: 'ewe', desc: '', args: []);
  }

  /// `Collective treatment`
  String get collective_treatment {
    return Intl.message(
      'Collective treatment',
      name: 'collective_treatment',
      desc: '',
      args: [],
    );
  }

  /// `Prescription`
  String get prescription {
    return Intl.message(
      'Prescription',
      name: 'prescription',
      desc: '',
      args: [],
    );
  }

  /// `Medication`
  String get medication {
    return Intl.message('Medication', name: 'medication', desc: '', args: []);
  }

  /// `Route`
  String get route {
    return Intl.message('Route', name: 'route', desc: '', args: []);
  }

  /// `Dose`
  String get dose {
    return Intl.message('Dose', name: 'dose', desc: '', args: []);
  }

  /// `Rhythm`
  String get rythme {
    return Intl.message('Rhythm', name: 'rythme', desc: '', args: []);
  }

  /// `Contributor`
  String get contributor {
    return Intl.message('Contributor', name: 'contributor', desc: '', args: []);
  }

  /// `Reason`
  String get reason {
    return Intl.message('Reason', name: 'reason', desc: '', args: []);
  }

  /// `Add all individuals who will receive treatment before continuing`
  String get treatment_explanation {
    return Intl.message(
      'Add all individuals who will receive treatment before continuing',
      name: 'treatment_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get bt_cancel {
    return Intl.message('Cancel', name: 'bt_cancel', desc: '', args: []);
  }

  /// `Continue`
  String get bt_continue {
    return Intl.message('Continue', name: 'bt_continue', desc: '', args: []);
  }

  /// `Save`
  String get bt_save {
    return Intl.message('Save', name: 'bt_save', desc: '', args: []);
  }

  /// `Add`
  String get bt_add {
    return Intl.message('Add', name: 'bt_add', desc: '', args: []);
  }

  /// `Delete`
  String get bt_delete {
    return Intl.message('Delete', name: 'bt_delete', desc: '', args: []);
  }

  /// `Edit`
  String get bt_edition {
    return Intl.message('Edit', name: 'bt_edition', desc: '', args: []);
  }

  /// `Delete`
  String get title_delete {
    return Intl.message('Delete', name: 'title_delete', desc: '', args: []);
  }

  /// `Do you want to delete this record ?`
  String get text_delete {
    return Intl.message(
      'Do you want to delete this record ?',
      name: 'text_delete',
      desc: '',
      args: [],
    );
  }

  /// `Begin date`
  String get date_debut {
    return Intl.message('Begin date', name: 'date_debut', desc: '', args: []);
  }

  /// `No begin date`
  String get no_date_debut {
    return Intl.message(
      'No begin date',
      name: 'no_date_debut',
      desc: '',
      args: [],
    );
  }

  /// `End date`
  String get date_fin {
    return Intl.message('End date', name: 'date_fin', desc: '', args: []);
  }

  /// `Memo`
  String get note_label {
    return Intl.message('Memo', name: 'note_label', desc: '', args: []);
  }

  /// `Information about this beast`
  String get note_hint {
    return Intl.message(
      'Information about this beast',
      name: 'note_hint',
      desc: '',
      args: [],
    );
  }

  /// `No entered memo`
  String get no_note {
    return Intl.message('No entered memo', name: 'no_note', desc: '', args: []);
  }

  /// `Warning`
  String get warning {
    return Intl.message('Warning', name: 'warning', desc: '', args: []);
  }

  /// `Alert`
  String get alert {
    return Intl.message('Alert', name: 'alert', desc: '', args: []);
  }

  /// `Info`
  String get info {
    return Intl.message('Info', name: 'info', desc: '', args: []);
  }

  /// `Body cond date`
  String get dateDeNotation {
    return Intl.message(
      'Body cond date',
      name: 'dateDeNotation',
      desc: '',
      args: [],
    );
  }

  /// `Connected mode`
  String get connected_mode {
    return Intl.message(
      'Connected mode',
      name: 'connected_mode',
      desc: '',
      args: [],
    );
  }

  /// `In this mode, the data will be saved on the server.\nThis mode requires an account on gismo`
  String get connected_mode_text {
    return Intl.message(
      'In this mode, the data will be saved on the server.\nThis mode requires an account on gismo',
      name: 'connected_mode_text',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Connection`
  String get connection {
    return Intl.message('Connection', name: 'connection', desc: '', args: []);
  }

  /// `Alone mode`
  String get alone_mode {
    return Intl.message('Alone mode', name: 'alone_mode', desc: '', args: []);
  }

  /// `In this mode, the data will be saved in a database on your phone.\nCopy your local database to back it up on a PC and restore it when needed.`
  String get alone_mode_text {
    return Intl.message(
      'In this mode, the data will be saved in a database on your phone.\nCopy your local database to back it up on a PC and restore it when needed.',
      name: 'alone_mode_text',
      desc: '',
      args: [],
    );
  }

  /// `Data null`
  String get data_null {
    return Intl.message('Data null', name: 'data_null', desc: '', args: []);
  }

  /// `Copy database`
  String get copy_base {
    return Intl.message('Copy database', name: 'copy_base', desc: '', args: []);
  }

  /// `Empty folder`
  String get empty_folder {
    return Intl.message(
      'Empty folder',
      name: 'empty_folder',
      desc: '',
      args: [],
    );
  }

  /// `Restore database`
  String get restore_bd {
    return Intl.message(
      'Restore database',
      name: 'restore_bd',
      desc: '',
      args: [],
    );
  }

  /// `Current data will be overwritten.`
  String get restore_bd_text {
    return Intl.message(
      'Current data will be overwritten.',
      name: 'restore_bd_text',
      desc: '',
      args: [],
    );
  }

  /// `With subscription`
  String get with_subscription {
    return Intl.message(
      'With subscription',
      name: 'with_subscription',
      desc: '',
      args: [],
    );
  }

  /// `save configuration`
  String get save_config {
    return Intl.message(
      'save configuration',
      name: 'save_config',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth authorization`
  String get bluetooth_autorisation {
    return Intl.message(
      'Bluetooth authorization',
      name: 'bluetooth_autorisation',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
