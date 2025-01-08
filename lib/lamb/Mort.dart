import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MortPage extends StatefulWidget {
  final LambModel _currentLamb ;
  final GismoBloc _bloc;
  MortPage( this._currentLamb, this._bloc, {Key ? key}) : super(key: key);

  @override
  _MortPageState createState() => new _MortPageState();
}

class _MortPageState extends State<MortPage> {
  String ? _currentMotif;
  TextEditingController _dateMortCtl = TextEditingController();
  final _df = new DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<DropdownMenuItem<String>> _getCauseMortItems() {
    List<DropdownMenuItem<String>> items = [];
    items.add( new DropdownMenuItem(value: 'Mise_bas', child: new Text( S.of(context).mort_mise_bas)));
    items.add( new DropdownMenuItem(value: 'Pas_de_contraction_dilatation', child: new Text(S.of(context).mort_pas_de_contraction_dilatation)));
    items.add( new DropdownMenuItem(value: 'Prolapsus', child: new Text(S.of(context).mort_prolapsus)));
    items.add( new DropdownMenuItem(value: 'Mal_place', child: new Text(S.of(context).mort_mal_place)));
    items.add( new DropdownMenuItem(value: 'Noye', child: new Text(S.of(context).mort_noye)));
    items.add( new DropdownMenuItem(value: 'Trop_gros', child: new Text(S.of(context).mort_trop_gros)));
    items.add( new DropdownMenuItem(value: 'Cesarienne', child: new Text(S.of(context).mort_cesarienne)));
    items.add( new DropdownMenuItem(value: 'Brebis_malade_toxemie', child: new Text(S.of(context).mort_brebis_malade_toxemie)));
    items.add( new DropdownMenuItem(value: 'Conformation', child: new Text(S.of(context).mort_conformation)));
    items.add( new DropdownMenuItem(value: 'Malforme', child: new Text(S.of(context).mort_malforme)));
    items.add( new DropdownMenuItem(value: 'chetif_maigre', child: new Text(S.of(context).mort_chetif_maigre)));
    items.add( new DropdownMenuItem(value: 'Tetee', child: new Text(S.of(context).mort_tetee)));
    items.add( new DropdownMenuItem(value: 'Incapacite_a_teter', child: new Text(S.of(context).mort_incapacite_a_teter)));
    items.add( new DropdownMenuItem(value: 'Brebis_sans_lait', child: new Text(S.of(context).mort_brebis_sans_lait)));
    items.add( new DropdownMenuItem(value: 'Non_accepte', child: new Text(S.of(context).mort_non_accepte)));
    items.add( new DropdownMenuItem(value: 'Sanitaire', child: new Text(S.of(context).mort_sanitaire)));
    items.add( new DropdownMenuItem(value: 'Mou', child: new Text(S.of(context).mort_mou)));
    items.add( new DropdownMenuItem(value: 'Baveur_colibacilose', child: new Text(S.of(context).mort_baveur_colibacilose)));
    items.add( new DropdownMenuItem(value: 'Trembleur_hirsute_border', child: new Text(S.of(context).mort_trembleur_hirsute_border)));
    items.add( new DropdownMenuItem(value: 'Ecthyma', child: new Text(S.of(context).mort_ecthyma)));
    items.add( new DropdownMenuItem(value: 'Respiratoire', child: new Text(S.of(context).mort_respiratoire)));
    items.add( new DropdownMenuItem(value: 'Arthrite_gros_nombril', child: new Text(S.of(context).mort_arthrite_gros_nombril)));
    items.add( new DropdownMenuItem(value: 'Lithiase_urinaire', child: new Text(S.of(context).mort_lithiase_urinaire)));
    items.add( new DropdownMenuItem(value: 'Nerveux_metabolique', child: new Text(S.of(context).mort_nerveux_metabolique)));
    items.add( new DropdownMenuItem(value: 'Raide', child: new Text(S.of(context).mort_raide)));
    items.add( new DropdownMenuItem(value: 'Tetanos', child: new Text(S.of(context).mort_tetanos)));
    items.add( new DropdownMenuItem(value: 'Necrose_cortex_cerebral', child: new Text(S.of(context).mort_necrose_cortex_cerebral)));
    items.add( new DropdownMenuItem(value: 'Digestif', child: new Text(S.of(context).mort_digestif)));
    items.add( new DropdownMenuItem(value: 'Diarrhee', child: new Text(S.of(context).mort_diarrhee)));
    items.add( new DropdownMenuItem(value: 'Ballonne_enterotoxemie', child: new Text(S.of(context).mort_ballonne_enterotoxemie)));
    items.add( new DropdownMenuItem(value: 'Coccidiose', child: new Text(S.of(context).mort_coccidiose)));
    items.add( new DropdownMenuItem(value: 'Autres', child: new Text(S.of(context).mort_autres)));
    items.add( new DropdownMenuItem(value: 'Ecrase', child: new Text(S.of(context).mort_ecrase)));
    items.add( new DropdownMenuItem(value: 'Maigre', child: new Text(S.of(context).mort_maigre)));
    items.add( new DropdownMenuItem(value: 'Accident', child: new Text(S.of(context).mort_accident)));
    items.add( new DropdownMenuItem(value: 'Disparu', child: new Text(S.of(context).mort_disparu)));
    items.add( new DropdownMenuItem(value: 'Autre', child: new Text(S.of(context).mort_autres)));
    items.add( new DropdownMenuItem(value: 'Inconnue', child: new Text(S.of(context).mort_inconnue)));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
        title: new Text('Mort'),
    ),
    body:
      new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Card(key: null,
                child:Column(
                  children: <Widget>[
                    new TextFormField(
                        keyboardType: TextInputType.datetime,
                        controller: _dateMortCtl,
                        decoration: InputDecoration(
                            labelText: S.of(context).death_date,
                            hintText: 'jj/mm/aaaa'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return S.of(context).no_death_date;
                          }},
                        onSaved: (value) {
                          setState(() {
                            _dateMortCtl.text = value!;
                          });
                        },
                        onTap: () async{
                          DateTime ? date = DateTime.now();
                          FocusScope.of(context).requestFocus(new FocusNode());
                          date = await showDatePicker(
                              locale: const Locale("fr","FR"),
                              context: context,
                              initialDate:DateTime.now(),
                              firstDate:DateTime(1900),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            setState(() {
                              _dateMortCtl.text = _df.format(date!);
                            });
                          }
                        }),
                    new DropdownButton<String>(
                      value: _currentMotif,
                      items: _getCauseMortItems(),
                      hint: Text(S.of(context).select_death_cause,style: TextStyle(color: Colors.lightGreen,)),
                      onChanged: _changedCauseDecesItem,
                    )

                  ],
                )),
            ElevatedButton (
                child: Text(S.of(context).bt_save,
                  style: new TextStyle(color: Colors.white, ),),

                // color: Colors.lightGreen[700],
                onPressed: _saveDeath)
          ]

      ),
    );
  }

  void _changedCauseDecesItem(String ? selectedMotif) {
    setState(() {
      _currentMotif= selectedMotif!;
    });
  }

  void _saveDeath() {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    if (_dateMortCtl.text.isEmpty) {
      showError(appLocalizations!.no_death_date);
      return;
    }

    if ( _currentMotif == null) {
      showError(appLocalizations!.death_cause_mandatory);
      return;
    }
    if (_currentMotif!.isEmpty) {
      showError(appLocalizations!.death_cause_mandatory);
      return;
    }

    var message  = this.widget._bloc.mort(this.widget._currentLamb, _currentMotif!, _dateMortCtl.text);
    message
        .then( (message) {goodSaving(message);})
        .catchError( (message) {showError(message);});
  }

  void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void goodSaving(String message) {
    message = "Décès : " + message;
    this.widget._currentLamb.motifDeces = _currentMotif;
    this.widget._currentLamb.dateDeces = DateFormat.yMd().parse( _dateMortCtl.text );
    Navigator.pop(context, this.widget._currentLamb);
  }

  @override
  void initState() {
    super.initState();
    _dateMortCtl.text = _df.format(DateTime.now());
  }

}