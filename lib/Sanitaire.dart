//import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
//import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:intl/intl.dart';

class SanitairePage extends StatefulWidget {
  final GismoBloc _bloc;
  Bete _malade;
  LambModel _bebeMalade;
  TraitementModel _currentTraitement;

  SanitairePage(this._bloc, this._malade, this._bebeMalade, {Key key}) : super(key: key);
  SanitairePage.edit(this._bloc, this._currentTraitement, {Key key}) : super(key: key);

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
        title: new Text('Traitement'),
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
                                labelText: "Date de début",),
                              onTap: () async{
                                DateTime date = DateTime.now();
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
                                labelText: "Date de Fin",),
                              onTap: () async{
                                DateTime date = DateTime.now();
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
                                        decoration: InputDecoration(labelText: "Ordonnance",),
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
                                  decoration: InputDecoration(labelText: "Medicament",),
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
                                      decoration: InputDecoration(labelText: "Voie",),
                                    ),
                                  ),
                                  new Flexible( child:
                                  new TextFormField(
                                    controller: _doseCtl,
                                    decoration: InputDecoration(labelText: "Dose",),
                                  ),
                                  ),
                                  new Flexible( child:
                                  new TextFormField(
                                    controller: _rythmeCtl,
                                    decoration: InputDecoration(labelText: "Rythme",),
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
                                    decoration: InputDecoration(labelText: "Intervenant",),
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
                                        decoration: InputDecoration(labelText: "Motif",),
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
                                decoration: InputDecoration(labelText: "Observation",),
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
                          new RaisedButton(key:null, onPressed:_save,
                              color: Colors.lightGreen[700],
                              child: new Text("Enregistrer",style: TextStyle( color: Colors.white)),)
                          ]
                        )
                  )
                  ])

          )
    );
  }

  void _save() async {
    TraitementModel traitement = new TraitementModel();
    if (this.widget._currentTraitement != null) {
      traitement.idBete = this.widget._currentTraitement.idBete;
      traitement.idBd = this.widget._currentTraitement.idBd;
    }
    else {
      if (this.widget._malade != null)
        traitement.idBete = this.widget._malade.idBd;
      if (this.widget._bebeMalade != null)
        traitement.idLamb = this.widget._bebeMalade.idBd;
    }
    traitement.debut = _dateDebutCtl.text;
    traitement.dose = _doseCtl.text;
    traitement.fin = _dateFinCtl.text;
    traitement.intervenant= _intervenantCtl.text;
    traitement.observation = _observationCtl.text;
    traitement.motif =_motifCtl.text;
    traitement.medicament = _medicamentCtl.text;
    traitement.ordonnance = _ordonnanceCtl.text;
    traitement.rythme = _rythmeCtl.text;
    traitement.voie = _voieCtl.text;
    var message  = await _bloc.saveTraitement(traitement);
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(message)))
        .closed
        .then((e) => {Navigator.of(context).pop()});

  }


  @override
  void initState() {
    super.initState();
    if (this.widget._currentTraitement != null) {
      _dateDebutCtl.text = this.widget._currentTraitement.debut ;
      _doseCtl.text = this.widget._currentTraitement.dose  ;
      _dateFinCtl.text = this.widget._currentTraitement.fin  ;
      _intervenantCtl.text = this.widget._currentTraitement.intervenant ;
      _observationCtl.text = this.widget._currentTraitement.observation  ;
      _motifCtl.text = this.widget._currentTraitement.motif ;
      _medicamentCtl.text = this.widget._currentTraitement.medicament  ;
      _ordonnanceCtl.text = this.widget._currentTraitement.ordonnance  ;
      _rythmeCtl.text = this.widget._currentTraitement.rythme ;
      _voieCtl.text = this.widget._currentTraitement.voie  ;
    }
  }
/*
  void badSaving(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void goodSaving(String message) {
    message = "Traitement : " + message;
    Navigator.pop(context, message);
  }

 */
}