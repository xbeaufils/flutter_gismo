import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/traitement/presenter/TraitementPresenter.dart';
import 'package:intl/intl.dart';



class ModifySanitairePage extends StatefulWidget {
  Bete ? _malade;
  LambModel ? _bebeMalade;

  Bete ? get malade => _malade;
  final TraitementModel _currentTraitement;

  ModifySanitairePage(this._currentTraitement);

  @override
  SanitairePageState createState() => new ModifySanitairePageState();

  LambModel ? get bebeMalade => _bebeMalade;

  TraitementModel ? get currentTraitement => _currentTraitement;
}

class LambSanitairePage extends StatefulWidget {
  final LambModel _bebeMalade;
  LambSanitairePage(this._bebeMalade);

  @override
  State<StatefulWidget> createState() => new LambSanitairePageState();
}

class MultipleSanitairePage extends  StatefulWidget {
  List<Bete> _betes;

  List<Bete> get betes => _betes;

  MultipleSanitairePage(this._betes);

  @override
  SanitairePageState createState() => new MultipleSanitairePageState();
}

abstract class SanitaireContract extends GismoContract {
 /* Bete ? get malade;
  List<Bete> ? get betes;
  LambModel ? get bebeMalade;
  TraitementModel ? get currentTraitement;*/
}

abstract class ModifySanitaireContract extends SanitaireContract {
  TraitementModel ? get currentTraitement;
}

class ModifySanitairePageState extends SanitairePageState<ModifySanitairePage> implements ModifySanitaireContract {

  Widget _buildMedic() {
    return Column(children: [
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
    )]);
  }

  Widget _buildButtons() {
    return Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(8.0),
              child:
              ElevatedButton(
                  onPressed: () => _showDialog(context),
                  child: Text(S.of(context).bt_delete))),
          FilledButton(key:Key("Enregistrer"), onPressed: () =>
              this._presenter.saveModify(_dateDebutCtl.text, _dateFinCtl.text, _doseCtl.text,
                  _intervenantCtl.text, _observationCtl.text, _motifCtl.text, _medicamentCtl.text, _ordonnanceCtl.text,
                  _rythmeCtl.text, _voieCtl.text),
            //color: Colors.lightGreen[700],
            child: new Text(S.of(context).bt_save),)
        ]
    );
  }

  void initState() {
    super.initState();
    _dateDebutCtl.text =
        DateFormat.yMd().format(this.currentTraitement!.debut);
    _doseCtl.text = this.currentTraitement?.medic!.dose as String;
    _dateFinCtl.text = DateFormat.yMd().format(this.currentTraitement!.fin);
    _intervenantCtl.text = this.currentTraitement?.intervenant as String;
    _observationCtl.text = this.currentTraitement?.observation as String;
    _motifCtl.text = this.currentTraitement?.motif as String;
    _medicamentCtl.text = this.currentTraitement?.medic!.medicament as String;
    _ordonnanceCtl.text = this.currentTraitement?.ordonnance as String;
    _rythmeCtl.text = this.currentTraitement?.medic!.rythme as String;
    _voieCtl.text = this.currentTraitement?.medic!.voie as String;
  }

  @override
  TraitementModel? get currentTraitement => this.widget._currentTraitement;
}

abstract class MultipleSanitaireContract extends SanitaireContract {
  List<Bete> ? get betes;
  List<MedicModel> ? get medics;

  void add(MedicModel medic);
}

class MultipleSanitairePageState extends SanitairePageState<MultipleSanitairePage> implements MultipleSanitaireContract {
  List<MedicModel> _medics = [];

  List<MedicModel> get medics => _medics;

  @override
  List<Bete>? get betes => this.widget._betes;

  MultipleSanitairePageState();

  Widget _buildMedic() {
    return SizedBox(
        height: 200,
        child:
            Column(children: [
              Flexible(
                child: ListView.builder(
                  itemCount: this._medics.length,
                  itemBuilder: (context, index) {
                    MedicModel medic = this._medics[index];
                    return ListTile(
                      //leading: _getImageType(event.type),
                      title: Text(medic.medicament),
                      subtitle: Text((medic.dose == null) ? medic.dose! : ""),
                      trailing: IconButton(icon: Icon(Icons.edit),
                          onPressed: () => _presenter.edit(medic)),
                    );
                  })
              ),
              ElevatedButton(
                child: Text(S.current.add_medication),
                onPressed: () => this._presenter.add(context),
              ),
            ])
    );
  }

  Widget _buildButtons() {
    return Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FilledButton(key: Key("Enregistrer"), onPressed: () =>
              this._presenter.saveMultiple(
                  _dateDebutCtl.text,
                  _dateFinCtl.text,
                  _doseCtl.text,
                  _intervenantCtl.text,
                  _observationCtl.text,
                  _motifCtl.text,
                  _medicamentCtl.text,
                  _ordonnanceCtl.text,
                  _rythmeCtl.text,
                  _voieCtl.text),
            //color: Colors.lightGreen[700],
            child: new Text(S
                .of(context)
                .bt_save),)
        ]
    );
  }

  void add(MedicModel medic) {
    setState(() {
      _medics.add(medic);
    });
  }

}

abstract class LambSanitaireContract extends SanitaireContract {
  LambModel ? get bebeMalade;
}

class LambSanitairePageState extends SanitairePageState<LambSanitairePage> implements LambSanitaireContract{
  @override
  Widget _buildMedic() {
    // TODO: implement _buildMedic
    throw UnimplementedError();
  }

  Widget _buildButtons() {
    return Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FilledButton(key:Key("Enregistrer"), onPressed: () =>
              this._presenter.saveLamb(_dateDebutCtl.text, _dateFinCtl.text, _doseCtl.text,
                  _intervenantCtl.text, _observationCtl.text, _motifCtl.text, _medicamentCtl.text, _ordonnanceCtl.text,
                  _rythmeCtl.text, _voieCtl.text),
            //color: Colors.lightGreen[700],
            child: new Text(S.of(context).bt_save),)
        ]
    );
  }

  @override
  LambModel ? get bebeMalade => this.widget._bebeMalade;
}

// class _SanitairePageState extends GismoStatePage<SanitairePage> implements SanitaireContract {
abstract class SanitairePageState<T extends StatefulWidget> extends GismoStatePage<T> implements SanitaireContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SanitairePageState();
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

  Widget _buildMedic();

  Widget _buildButtons();

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
                  Card(child:  this._buildMedic(),),
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
                          //this._buildMedic(),
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
                  this._buildButtons(),
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
      child: Text(S.current.bt_continue),
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
      _dateDebutCtl.text = DateFormat.yMd().format(selectedDate);
      _dateFinCtl.text = DateFormat.yMd().format(selectedDate);
  }

}