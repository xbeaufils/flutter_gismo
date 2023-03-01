import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
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
    items.add( new DropdownMenuItem(value: 'Mise_bas', child: new Text('Mise bas')));
    items.add( new DropdownMenuItem(value: 'Pas_de_contraction_dilatation', child: new Text('Pas de contraction/dilatation')));
    items.add( new DropdownMenuItem(value: 'Prolapsus', child: new Text('Prolapsus')));
    items.add( new DropdownMenuItem(value: 'Mal_place', child: new Text('Mal placé')));
    items.add( new DropdownMenuItem(value: 'Noye', child: new Text('Noyé, pas respiré(dans poches)')));
    items.add( new DropdownMenuItem(value: 'Trop_gros', child: new Text('Trop gros')));
    items.add( new DropdownMenuItem(value: 'Cesarienne', child: new Text('Césarienne')));
    items.add( new DropdownMenuItem(value: 'Brebis_malade_toxemie', child: new Text('Brebis malade/toxemie')));
    items.add( new DropdownMenuItem(value: 'Conformation', child: new Text('Conformation')));
    items.add( new DropdownMenuItem(value: 'Malforme', child: new Text('Malformé')));
    items.add( new DropdownMenuItem(value: 'chetif_maigre', child: new Text('Très petit / chétif / maigre')));
    items.add( new DropdownMenuItem(value: 'Tetee', child: new Text('Tétée')));
    items.add( new DropdownMenuItem(value: 'Incapacite_a_teter', child: new Text('Incapacité à téter')));
    items.add( new DropdownMenuItem(value: 'Brebis_sans_lait', child: new Text('Brebis sans lait')));
    items.add( new DropdownMenuItem(value: 'Non_accepte', child: new Text('Non accepté')));
    items.add( new DropdownMenuItem(value: 'Sanitaire', child: new Text('Sanitaire')));
    items.add( new DropdownMenuItem(value: 'Mou', child: new Text('Mou')));
    items.add( new DropdownMenuItem(value: 'Baveur_colibacilose', child: new Text('Baveur (colibacilose)')));
    items.add( new DropdownMenuItem(value: 'Trembleur_hirsute_border', child: new Text('Trembleur hirsute (border)')));
    items.add( new DropdownMenuItem(value: 'Ecthyma', child: new Text('Ecthyma')));
    items.add( new DropdownMenuItem(value: 'Respiratoire', child: new Text('Respiratoire')));
    items.add( new DropdownMenuItem(value: 'Arthrite_gros_nombril', child: new Text('Arthrite/gros nombril')));
    items.add( new DropdownMenuItem(value: 'Lithiase_urinaire', child: new Text('Lithiase urinaire')));
    items.add( new DropdownMenuItem(value: 'Nerveux_metabolique', child: new Text('Nerveux/metabolique')));
    items.add( new DropdownMenuItem(value: 'Raide', child: new Text('Raide')));
    items.add( new DropdownMenuItem(value: 'Tetanos', child: new Text('Tetanos')));
    items.add( new DropdownMenuItem(value: 'Necrose_cortex_cerebral', child: new Text('Necrose cortex cérébral')));
    items.add( new DropdownMenuItem(value: 'Digestif', child: new Text('Digestif')));
    items.add( new DropdownMenuItem(value: 'Diarrhee', child: new Text('Diarrhée')));
    items.add( new DropdownMenuItem(value: 'Ballonne_enterotoxemie', child: new Text('Ballonné ou entérotoxémie')));
    items.add( new DropdownMenuItem(value: 'Coccidiose', child: new Text('Coccidiose')));
    items.add( new DropdownMenuItem(value: 'Autres', child: new Text('Autres')));
    items.add( new DropdownMenuItem(value: 'Ecrase', child: new Text('Ecrasé')));
    items.add( new DropdownMenuItem(value: 'Maigre', child: new Text('Maigre')));
    items.add( new DropdownMenuItem(value: 'Accident', child: new Text('Accident')));
    items.add( new DropdownMenuItem(value: 'Disparu', child: new Text('Disparu')));
    items.add( new DropdownMenuItem(value: 'Autre', child: new Text('Autre')));
    items.add( new DropdownMenuItem(value: 'Inconnue', child: new Text('Inconnue')));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
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
                            labelText: appLocalizations!.death_date,
                            hintText: 'jj/mm/aaaa'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return appLocalizations.no_death_date;
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
                      hint: Text(appLocalizations.select_death_cause,style: TextStyle(color: Colors.lightGreen,)),
                      onChanged: _changedCauseDecesItem,
                    )

                  ],
                )),
            ElevatedButton (
                child: Text(appLocalizations.bt_save,
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
    this.widget._currentLamb.dateDeces =  _dateMortCtl.text;
    Navigator.pop(context, this.widget._currentLamb);
  }

  @override
  void initState() {
    super.initState();
    _dateMortCtl.text = _df.format(DateTime.now());
  }

}