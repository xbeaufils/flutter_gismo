//import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:intl/intl.dart';

class SanitairePage extends StatefulWidget {
  final GismoBloc _bloc;
  Bete ? _malade;
  List<Bete> ? _betes;
  LambModel ? _bebeMalade;
  TraitementModel ? _currentTraitement;

  SanitairePage(this._bloc, this._malade, this._bebeMalade, {Key ? key}) : super(key: key);
  SanitairePage.edit(this._bloc, this._currentTraitement, {Key ? key}) : super(key: key);
  SanitairePage.collectif(this._bloc, this._betes, {Key ? key}): super(key: key);

  @override
  _SanitairePageState createState() => new _SanitairePageState(_bloc);
}

class _SanitairePageState extends State<SanitairePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GismoBloc _bloc;
  _SanitairePageState(this._bloc);

  TextEditingController _dateDebutCtl = TextEditingController();
  TextEditingController _dateFinCtl = TextEditingController();
  TextEditingController _medicamentCtl = TextEditingController();
  TextEditingController _voieCtl = TextEditingController();
  TextEditingController _doseCtl = TextEditingController();
  TextEditingController _rythmeCtl = TextEditingController();
  TextEditingController _ordonnanceCtl = TextEditingController();
  TextEditingController _intervenantCtl = TextEditingController();
  TextEditingController _motifCtl = TextEditingController();
  TextEditingController _observationCtl = TextEditingController();

  final df = new DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.lightGreen,
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(S.of(context).treatment),
      ),
      body:
          SingleChildScrollView (
            child:
            new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Card( child:
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Flexible(
                            child:
                            new TextFormField(
                              controller: _dateDebutCtl,
                              decoration: InputDecoration(
                                labelText: S.of(context).date_debut,),
                              onTap: () async{
                                DateTime ? date = DateTime.now();
                                FocusScope.of(context).requestFocus(new FocusNode());

                                date = await showDatePicker(
                                    context: context,
                                    initialDate:DateTime.now(),
                                    firstDate:DateTime(1900),
                                    lastDate: DateTime(2100));
                                if (date != null)
                                  _dateDebutCtl.text = df.format(date);
                                },
                            ),
                          ),
                          new Flexible(
                            child:
                            new TextFormField(
                              controller: _dateFinCtl,
                              decoration: InputDecoration(
                                labelText: S.of(context).date_fin,),
                              onTap: () async{
                                DateTime ? date = DateTime.now();
                                FocusScope.of(context).requestFocus(new FocusNode());

                                date = await showDatePicker(
                                    context: context,
                                    initialDate:DateTime.now(),
                                    firstDate:DateTime(1900),
                                    lastDate: DateTime(2100));
                                if (date != null)
                                  _dateFinCtl.text = df.format(date);
                              },
                            ),
                          )
                        ]

                    ),
                    ),
                  new Card(child:
                      new Column(
                          children: <Widget> [
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(
                                      child:
                                      new TextFormField(
                                        controller: _ordonnanceCtl,
                                        decoration: InputDecoration(labelText: S.of(context).prescription,),
                                      ))
                                ]
                            ),
                            new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child:
                                new TextFormField(
                                  controller: _medicamentCtl,
                                  decoration: InputDecoration(labelText: S.of(context).medication,),
                                ),
                              )
                            ]

                        ),
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Flexible( child:
                                    new TextFormField(
                                      controller: _voieCtl,
                                      decoration: InputDecoration(labelText: S.of(context).route,),
                                    ),
                                  ),
                                  new Flexible( child:
                                  new TextFormField(
                                    controller: _doseCtl,
                                    decoration: InputDecoration(labelText: S.of(context).dose,),
                                  ),
                                  ),
                                  new Flexible( child:
                                  new TextFormField(
                                    controller: _rythmeCtl,
                                    decoration: InputDecoration(labelText: S.of(context).rythme,),
                                  ),
                                  ),
                                ]
                            ),

                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child:
                                  new TextFormField(
                                    controller: _intervenantCtl,
                                    decoration: InputDecoration(labelText: S.of(context).contributor,),
                                ))
                            ]
                        ),
                    ])),
                  new Card(child:
                    new Column(
                        children: <Widget> [
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(
                                      child:
                                      new TextFormField(
                                        controller: _motifCtl,
                                        decoration: InputDecoration(labelText: S.of(context).reason,),
                                      ),
                                    ),
                            ]),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child:
                              new TextFormField(
                                controller: _observationCtl,
                                decoration: InputDecoration(labelText: S.of(context).observations,),
                                keyboardType: TextInputType.multiline,
                                minLines: 3,
                                maxLines: null,
                              ),
                             )
                            ]),
                          ]
                      )
                  ),
                  new Card(
                    child:
                        Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            (this.widget._currentTraitement == null) ?
                                Container():
                                TextButton(
                                  onPressed: () => _showDialog(context),
                                  child: Text(S.of(context).bt_delete)),
                            new ElevatedButton(key:null, onPressed:_save,
                              //color: Colors.lightGreen[700],
                              child: new Text(S.of(context).bt_save,style: TextStyle( color: Colors.white)),)
                          ]
                        )
                  )
                  ])

          )
    );
  }
  // set up the buttons
  Widget _cancelButton() {
    return TextButton(
      child: Text(S.of(context).bt_cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _continueButton() {
    return TextButton(
      child: Text(S.of(context).bt_continue),
      onPressed: () {
        _delete();
        Navigator.of(context).pop();
      },
    );
  }

  Future _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).title_delete),
          content: Text(S.of(context).text_delete),
          actions: [
            _cancelButton(),
            _continueButton(),
          ],
        );
      },
    );
  }

  void _delete () async {
    if (this.widget._currentTraitement != null) {
      var message  = await _bloc.deleteTraitement(this.widget._currentTraitement!.idBd!);
      Navigator.pop(context, message);
    }
    else
      Navigator.of(context).pop();
  }

  void _save() async {
    TraitementModel traitement = new TraitementModel();
    if (this.widget._currentTraitement != null) {
      traitement.idBete = this.widget._currentTraitement?.idBete;
      traitement.idBd = this.widget._currentTraitement?.idBd;
    }
    else {
      if (this.widget._malade != null)
        traitement.idBete = this.widget._malade?.idBd;
      if (this.widget._bebeMalade != null)
        traitement.idLamb = this.widget._bebeMalade?.idBd;
    }
    traitement.debut = DateFormat.yMd().parse(_dateDebutCtl.text);
    traitement.dose = _doseCtl.text;
    traitement.fin = DateFormat.yMd().parse(_dateFinCtl.text);
    traitement.intervenant= _intervenantCtl.text;
    traitement.observation = _observationCtl.text;
    traitement.motif =_motifCtl.text;
    traitement.medicament = _medicamentCtl.text;
    traitement.ordonnance = _ordonnanceCtl.text;
    traitement.rythme = _rythmeCtl.text;
    traitement.voie = _voieCtl.text;
    var message = "";
    if (this.widget._betes != null)
      message = await _bloc.saveTraitementCollectif(traitement, this.widget._betes!);
    else
      message  = await _bloc.saveTraitement(traitement);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)))
        .closed
        .then((e) => {Navigator.of(context).pop()});

  }


  @override
  void initState() {
    DateTime selectedDate = DateTime.now();
    super.initState();
    if (this.widget._currentTraitement != null) {
      _dateDebutCtl.text = DateFormat.yMd().format(this.widget._currentTraitement!.debut);
      _doseCtl.text = this.widget._currentTraitement?.dose  as String;
      _dateFinCtl.text = DateFormat.yMd().format(this.widget._currentTraitement!.fin);
      _intervenantCtl.text = this.widget._currentTraitement?.intervenant as String;
      _observationCtl.text = this.widget._currentTraitement?.observation  as String;
      _motifCtl.text = this.widget._currentTraitement?.motif as String;
      _medicamentCtl.text = this.widget._currentTraitement?.medicament  as String;
      _ordonnanceCtl.text = this.widget._currentTraitement?.ordonnance  as String;
      _rythmeCtl.text = this.widget._currentTraitement?.rythme as String;
      _voieCtl.text = this.widget._currentTraitement?.voie  as String;
    }
    else {
      _dateDebutCtl.text = df.format(selectedDate);
      _dateFinCtl.text = df.format(selectedDate);
    }
  }
}