import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/lamb/Bouclage.dart';
import 'package:flutter_gismo/lamb/Mort.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';

class LambPage extends StatefulWidget {
  final GismoBloc _bloc;
  LambModel _lamb;


  @override
  LambPageState createState() => LambPageState();

  LambPage.edit(this._bloc, this._lamb);
  LambPage(this._bloc);
}

class LambPageState extends State<LambPage> {
  TextEditingController _marquageCtrl = TextEditingController();
  Sex _sex = Sex.male;
  List<DropdownMenuItem<MethodeAllaitement>> _dropDownMenuItems;
  MethodeAllaitement _currentAllaitement;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: _mainTitle(),
        ),
        body:
        new Column(
            children: <Widget>[
              new TextField(
                decoration: InputDecoration(labelText: 'Marquage provisoire'),
                controller: _marquageCtrl,
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Flexible (child:
                      RadioListTile<Sex>(
                        title: const Text('Male'),
                        value: Sex.male,
                        groupValue: _sex,
                        onChanged: (Sex value) { setState(() { _sex = value; }); },
                      ),
                    ),
                    new Flexible( child:
                      RadioListTile<Sex>(
                        title: const Text('Femelle'),
                        value: Sex.femelle,
                        groupValue: _sex,
                        onChanged: (Sex value) { setState(() { _sex = value; }); },
                      ),
                    ),]

              ),
               new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("Mode d'allaitement: "),
                  new Container(
                    padding: new EdgeInsets.all(16.0),
                  ),
                  new DropdownButton(
                    value: _currentAllaitement,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem,
                  )
                ],
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    this._mainButton()
                  ]
              ),
            ]
        )
    );
  }

  void _addLamb() {
    Navigator
        .of(context)
        .pop(new LambModel(this._marquageCtrl.text, this._sex, this._currentAllaitement));
  }

  void _saveLamb() {
    this.widget._lamb.marquageProvisoire = this._marquageCtrl.text;
    this.widget._lamb.sex = this._sex;
    this.widget._lamb.allaitement = this._currentAllaitement;
    Navigator
        .of(context)
        .pop(this.widget._lamb);

    //this.widget._bloc.saveLamb(this.widget._lamb);
  }

  void changedDropDownItem(MethodeAllaitement selectedAllaitement) {
    setState(() {
      _currentAllaitement = selectedAllaitement;
    });
  }

  @override
  void initState() {
    List<DropdownMenuItem<MethodeAllaitement>> items = new List();
    items.add(new DropdownMenuItem( value: MethodeAllaitement.ALLAITEMENT_MATERNEL, child: new Text(MethodeAllaitement.ALLAITEMENT_MATERNEL.libelle)));
    items.add(new DropdownMenuItem( value: MethodeAllaitement.ALLAITEMENT_ARTIFICIEL, child: new Text(MethodeAllaitement.ALLAITEMENT_ARTIFICIEL.libelle)));
    items.add(new DropdownMenuItem( value: MethodeAllaitement.ADOPTE, child: new Text(MethodeAllaitement.ADOPTE.libelle)));
    items.add(new DropdownMenuItem( value: MethodeAllaitement.BIBERONNE, child: new Text(MethodeAllaitement.BIBERONNE.libelle)));
    _dropDownMenuItems = items;
    if (this.widget._lamb != null) {
      _currentAllaitement = this.widget._lamb.allaitement;
      this._marquageCtrl.text = this.widget._lamb.marquageProvisoire;
      this._sex = this.widget._lamb.sex;
    }
    else {
      _currentAllaitement = _dropDownMenuItems[0].value;
    }
    super.initState();
  }

  Widget _mainTitle() {
    if (this.widget._lamb == null)
      return Text('Nouvel agneau');
    return Text("Modification agneau");
  }

  Widget _mainButton() {
    if (this.widget._lamb == null)
      return new RaisedButton(
          onPressed:_addLamb,
          color: Colors.lightGreen[900],
          child:
          new Text(
            "Ajouter",
            style: new TextStyle(color: Colors.white),
          )
      );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
      ButtonBar(
        mainAxisSize: MainAxisSize.max,
      children: <Widget>[
         IconButton(
          icon: Image.asset("assets/tomb.png"),
          onPressed: () {_openDeath(this.widget._lamb);},),
        IconButton(
          icon: Image.asset("assets/bouclage.png"),
          onPressed: () {_openBoucle(this.widget._lamb);},)
      ],
      ),
      new RaisedButton.icon(
        onPressed:_saveLamb,
      //color: Colors.lightGreen[900],
        icon: Icon(Icons.save),
        label: Text("Enregistrer"),
      ),
    ],);
  }

  void _openBoucle(LambModel lamb) async {
    Bete bete = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BouclagePage(lamb)),
    );
    Navigator
        .of(context)
        .pop(bete);


  }
  void _openDeath(LambModel lamb) async {
    var navigationResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MortPage(lamb)),
    );
    print (navigationResult);
  }

}

