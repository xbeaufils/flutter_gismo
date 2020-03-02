import 'package:flutter/material.dart';

import 'package:flutter_gismo/lamb/AddLamb.dart';
import 'package:flutter_gismo/lamb/Adoption.dart';
import 'package:flutter_gismo/lamb/AgnelageQualityPage.dart';
import 'package:flutter_gismo/lamb/LambList.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/AdoptionQualite.dart';
import 'package:flutter_gismo/model/AgnelageQualite.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as debug;

class LambPage extends StatefulWidget {
  Bete _mere;
  LambingModel _currentLambing;
  LambPage(this._mere, {Key key}) : super(key: key);
  LambPage.edit(this._currentLambing);

  @override
  _LambPageState createState() => new _LambPageState();
}

class _LambPageState extends State<LambPage> {
  //List<LambModel> _lambs = new List();
  LambingModel _lambing;

  DateTime selectedDate = DateTime.now();
  final df = new DateFormat('dd/MM/yyyy');
  Adoption _adoption = Adoption.level0;
  Agnelage _agnelage = Agnelage.level0;

  TextEditingController _dateAgnelageCtl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _LambPageState();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: (this.widget._mere != null) ? 
          new Text(this.widget._mere.numBoucle + " (" + this.widget._mere.numMarquage + ")") :
          new Text(this.widget._currentLambing.numBoucleMere + " (" + this.widget._currentLambing.numMarquageMere + ")"),
        key: _scaffoldKey,
      ),
      body: new Container(
        child: new Form(
        key: _formKey,
        child:
        new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Card(
                child:
                  new TextFormField(
                    keyboardType: TextInputType.datetime,
                    controller: _dateAgnelageCtl,
                    decoration: InputDecoration(
                                  labelText: 'Date Agnelage',
                                  hintText: 'jj/mm/aaaa'),
                    validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a name';
                                }},
                    onSaved: (value) {
                                setState(() {
                                  _dateAgnelageCtl.text = value;
                                });
                              },
                    onTap: () async{
                            DateTime date = DateTime.now();
                            FocusScope.of(context).requestFocus(new FocusNode());
                            date = await showDatePicker(
                                context: context,
                                initialDate:DateTime.now(),
                                firstDate:DateTime(1900),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              setState(() {
                                _dateAgnelageCtl.text = df.format(date);
                              });
                            }
                          })
              ),
              new Card(
                child:
                  new ListTile(
                    title: Text("Qualité d'agnelage") ,
                    subtitle: Text(_agnelage.key.toString() + " : " +_agnelage.value),
                    trailing: new IconButton(onPressed: _openAgnelageDialog, icon: new Icon(Icons.create)),),
              ),
              new Card(
                child:
                new ListTile(
                  title: Text("Qualité adoption") ,
                  subtitle: Text(_adoption.key.toString() + " : " +_adoption.value),
                  trailing: new IconButton(onPressed: _openAdoptionDialog, icon: new Icon(Icons.create)),),
              ),
              Expanded(
                child: LambsPage(this._lambing.lambs, _dateAgnelageCtl.text)
              ),
               new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(key:null,
                      onPressed:saveLambing,
                      color: Colors.lightGreen[700],
                      child:
                        new Text(
                        "Valider l'agnelage",
                        style: new TextStyle(color: Colors.white, ), )
                  )
                ]
              ),

          ])),

    ),
      floatingActionButton: (this._lambing.idBd == null)?
      new FloatingActionButton(
        onPressed: _openAddEntryDialog,
        tooltip: 'Ajouter un agneau',
        child: new Icon(Icons.add),
      ): null,
    );
  }

  void _addLamb(LambModel newLamb){
    setState(() {
      _lambing.lambs.add(newLamb);
      //_lambs.add(newLamb);
    });
  }

  Future _openAddEntryDialog() async {
    LambModel newLamb = await Navigator.of(context).push(new MaterialPageRoute<LambModel>(
        builder: (BuildContext context) {
          return new AddingLambDialog();
        },
        fullscreenDialog: true
    ));
    if (newLamb != null) {
      _addLamb(newLamb);
    }
  }

  Future _openAdoptionDialog() async {
    int qualiteAdoption = await Navigator.of(context).push(new MaterialPageRoute<int>(
        builder: (BuildContext context) {
          return new AdoptionDialog(this._adoption.key);
        },
        fullscreenDialog: true
    ));
    if (qualiteAdoption != null) {
      setState(() {
        _adoption = Adoption.getAdoption(qualiteAdoption);
      });
    }
  }

  Future _openAgnelageDialog() async {
    int qualiteAgnelage = await Navigator.of(context).push(new MaterialPageRoute<int>(
        builder: (BuildContext context) {
          return new AgnelageDialog(this._agnelage.key);
        },
        fullscreenDialog: true
    ));
    if (qualiteAgnelage != null) {
      setState(() {
        _agnelage = Agnelage.getAgnelage(qualiteAgnelage);
      });
    }
  }

  void saveLambing() {
    _lambing.setDateAgnelage(_dateAgnelageCtl.text);
    _lambing.adoption = _adoption.key;
    _lambing.qualite = _agnelage.key;

    var message  = gismoBloc.saveLambing(this._lambing);
    message
        .then( (message) {goodSaving(message);})
        .catchError( (message) {  _handleError(message); /*badSaving(message);*/});
  }

  void _handleError(Object obj) {
    debug.log("ERROR", name:"_LambPageState::_handleError", error: obj);
  }

  void badSaving(String message) {
    final snackBar = SnackBar(
      content: Text(message),

    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void goodSaving(String message) {
    message = "Agnelage : " + message;
    Navigator.pop(context, message);
  }
  //void radioChanged(double value) {}
  @override
  void initState() {
    super.initState();
    if (this.widget._currentLambing == null) {
      _lambing = new LambingModel(this.widget._mere.idBd);
      _dateAgnelageCtl.text = df.format(selectedDate);
      _adoption = Adoption.level0;
      _agnelage = Agnelage.level0;
    }
    else {
      _lambing = this.widget._currentLambing;
      _dateAgnelageCtl.text = _lambing.dateAgnelage;
      _adoption = Adoption.getAdoption(_lambing.adoption);
      _agnelage = Agnelage.getAgnelage(_lambing.qualite);
    }
  }

}



