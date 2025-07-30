//import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:gismo/core/ui/SimpleGismoPage.dart';
import 'package:gismo/generated/l10n.dart';
import 'package:gismo/model/BeteModel.dart';
import 'package:gismo/model/LambModel.dart';
import 'package:gismo/model/TraitementModel.dart';
import 'package:gismo/traitement/presenter/TraitementPresenter.dart';
import 'package:intl/intl.dart';

class SanitairePage extends StatefulWidget {
  Bete ? _malade;
  List<Bete> ? _betes;
  LambModel ? _bebeMalade;
  TraitementModel ? _currentTraitement;

  SanitairePage( this._malade, this._bebeMalade, {Key ? key}) : super(key: key);
  SanitairePage.edit( this._currentTraitement, {Key ? key}) : super(key: key);
  SanitairePage.modify(this._currentTraitement, {Key ? key}) : super(key: key);
  SanitairePage.collectif(this._betes, {Key ? key}): super(key: key);

  @override
  _SanitairePageState createState() => new _SanitairePageState();
}

abstract class SanitaireContract extends GismoContract {
  Bete ? get malade;
  List<Bete> ? get betes;
  LambModel ? get bebeMalade;
  TraitementModel ? get currentTraitement;

}

class _SanitairePageState extends GismoStatePage<SanitairePage> implements SanitaireContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _SanitairePageState();
  late TraitementPresenter _presenter;

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


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                  Card( child:
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(child:
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              new TextFormField(
                                key: const Key("dateDebut"),
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
                                    _dateDebutCtl.text = DateFormat.yMd().format(date);
                                  },
                              ),
                            )),
                          Flexible(child:
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              new TextFormField(
                                key: const Key("dateFin"),
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
                                    _dateFinCtl.text = DateFormat.yMd().format(date);
                                },
                              ),
                          ))
                        ]

                    ),
                  ),
                  Card(child:
                      Column(
                        children: <Widget> [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                                child:
                                  TextFormField(
                                        controller: _ordonnanceCtl,
                                        decoration: InputDecoration(labelText: S.of(context).prescription,),
                                  )
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                              TextFormField(
                                  controller: _medicamentCtl,
                                  decoration: InputDecoration(labelText: S.of(context).medication,),
                                ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible( child:
                                Padding(padding: const EdgeInsets.all(8.0),
                                    child:
                                    TextFormField(
                                        controller: _voieCtl,
                                        decoration: InputDecoration(labelText: S.of(context).route,),
                                      ),
                                  )),
                              Flexible( child:
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                        TextFormField(
                                          controller: _doseCtl,
                                          decoration: InputDecoration(labelText: S.of(context).dose,),
                                        ),
                                  )),
                              Flexible( child:
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      TextFormField(
                                    controller: _rythmeCtl,
                                    decoration: InputDecoration(labelText: S.of(context).rythme,),
                                  ),
                                  )),
                                ]
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                              TextFormField(
                                controller: _intervenantCtl,
                                decoration: InputDecoration(labelText: S.of(context).contributor,),
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                TextFormField(
                                  controller: _motifCtl,
                                  decoration: InputDecoration(labelText: S.of(context).reason,),
                                ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                              TextFormField(
                                controller: _observationCtl,
                                decoration: InputDecoration(labelText: S.of(context).observations,),
                                keyboardType: TextInputType.multiline,
                                minLines: 3,
                                maxLines: null,
                              ),
                             ),
                          ]
                      )
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (this.widget._currentTraitement == null) ?
                          Container():
                      Padding(padding: const EdgeInsets.all(8.0),
                          child:
                          ElevatedButton(
                            onPressed: () => _showDialog(context),
                            child: Text(S.of(context).bt_delete))),
                        FilledButton(key:Key("Enregistrer"), onPressed: () =>
                          this._presenter.save(_dateDebutCtl.text, _dateFinCtl.text, _doseCtl.text,
                            _intervenantCtl.text, _observationCtl.text, _motifCtl.text, _medicamentCtl.text, _ordonnanceCtl.text,
                          _rythmeCtl.text, _voieCtl.text),
                        //color: Colors.lightGreen[700],
                        child: new Text(S.of(context).bt_save),)
                    ]
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
        this._presenter.delete();
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



  @override
  void initState() {
    DateTime selectedDate = DateTime.now();
    _presenter = TraitementPresenter(this);
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
      _dateDebutCtl.text = DateFormat.yMd().format(selectedDate);
      _dateFinCtl.text = DateFormat.yMd().format(selectedDate);
    }
  }

  @override
  TraitementModel ? get currentTraitement {
    return this.widget._currentTraitement;
  }

  @override
  LambModel ? get bebeMalade {
    return this.widget._bebeMalade;
  }

  @override
  List<Bete> ? get betes {
    return this.widget._betes;
  }

  @override
  Bete ? get malade {
    return this.widget._malade;
  }
}