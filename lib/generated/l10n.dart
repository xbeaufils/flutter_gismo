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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Batch`
  String get batch {
    return Intl.message(
      'Batch',
      name: 'batch',
      desc: '',
      args: [],
    );
  }

  /// `Sheep`
  String get sheep {
    return Intl.message(
      'Sheep',
      name: 'sheep',
      desc: '',
      args: [],
    );
  }

  /// `Lambing`
  String get lambing {
    return Intl.message(
      'Lambing',
      name: 'lambing',
      desc: '',
      args: [],
    );
  }

  /// `Lambs`
  String get lambs {
    return Intl.message(
      'Lambs',
      name: 'lambs',
      desc: '',
      args: [],
    );
  }

  /// `Ultrasound`
  String get ultrasound {
    return Intl.message(
      'Ultrasound',
      name: 'ultrasound',
      desc: '',
      args: [],
    );
  }

  /// `Mating`
  String get mating {
    return Intl.message(
      'Mating',
      name: 'mating',
      desc: '',
      args: [],
    );
  }

  /// `Weighing`
  String get weighing {
    return Intl.message(
      'Weighing',
      name: 'weighing',
      desc: '',
      args: [],
    );
  }

  /// `Body cond.`
  String get body_cond {
    return Intl.message(
      'Body cond.',
      name: 'body_cond',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Treatment',
      name: 'treatment',
      desc: '',
      args: [],
    );
  }

  /// `Entry`
  String get input {
    return Intl.message(
      'Entry',
      name: 'input',
      desc: '',
      args: [],
    );
  }

  /// `Departure`
  String get output {
    return Intl.message(
      'Departure',
      name: 'output',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Memo`
  String get memo {
    return Intl.message(
      'Memo',
      name: 'memo',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Local user',
      name: 'localuser',
      desc: '',
      args: [],
    );
  }

  /// `Earring`
  String get earring {
    return Intl.message(
      'Earring',
      name: 'earring',
      desc: '',
      args: [],
    );
  }

  /// `Search earring`
  String get earring_search {
    return Intl.message(
      'Search earring',
      name: 'earring_search',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
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

  /// `To seize lifestock, make an entry from the main screen.`
  String get text_empty_list {
    return Intl.message(
      'To seize lifestock, make an entry from the main screen.',
      name: 'text_empty_list',
      desc: '',
      args: [],
    );
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

  /// `No earring read`
  String get no_earring_read {
    return Intl.message(
      'No earring read',
      name: 'no_earring_read',
      desc: '',
      args: [],
    );
  }

  /// `Birth`
  String get birth {
    return Intl.message(
      'Birth',
      name: 'birth',
      desc: '',
      args: [],
    );
  }

  /// `Creation`
  String get creation {
    return Intl.message(
      'Creation',
      name: 'creation',
      desc: '',
      args: [],
    );
  }

  /// `Renewal`
  String get renewal {
    return Intl.message(
      'Renewal',
      name: 'renewal',
      desc: '',
      args: [],
    );
  }

  /// `Purchase`
  String get purchase {
    return Intl.message(
      'Purchase',
      name: 'purchase',
      desc: '',
      args: [],
    );
  }

  /// `Reactivation`
  String get reactivation {
    return Intl.message(
      'Reactivation',
      name: 'reactivation',
      desc: '',
      args: [],
    );
  }

  /// `Loan or pension`
  String get loan {
    return Intl.message(
      'Loan or pension',
      name: 'loan',
      desc: '',
      args: [],
    );
  }

  /// `Internal transfer`
  String get transfer {
    return Intl.message(
      'Internal transfer',
      name: 'transfer',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Date of entry`
  String get dateEntry {
    return Intl.message(
      'Date of entry',
      name: 'dateEntry',
      desc: '',
      args: [],
    );
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

  /// `Weight`
  String get weight {
    return Intl.message(
      'Weight',
      name: 'weight',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Search',
      name: 'tooltip_search',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get bt_cancel {
    return Intl.message(
      'Cancel',
      name: 'bt_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get bt_continue {
    return Intl.message(
      'Continue',
      name: 'bt_continue',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get bt_save {
    return Intl.message(
      'Save',
      name: 'bt_save',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get bt_add {
    return Intl.message(
      'Add',
      name: 'bt_add',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get title_delete {
    return Intl.message(
      'Delete',
      name: 'title_delete',
      desc: '',
      args: [],
    );
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
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
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
