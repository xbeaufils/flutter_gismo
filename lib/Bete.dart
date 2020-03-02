import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:intl/intl.dart';

import 'dart:developer' as debug;

class BetePage extends StatefulWidget {
  Bete _bete;
  BetePage(this._bete, {Key key}) : super(key: key);

  @override
  _BetePageState createState() => new _BetePageState(_bete);
}

class _BetePageState extends State<BetePage> {
  DateTime selectedDate = DateTime.now();
  final df = new DateFormat('dd/MM/yyyy');
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _dateEntreCtrl = new TextEditingController();
  Bete _bete;
  String _numBoucle;
  String _numMarquage;
  //String _dateEntree;
  Sex _sex ;
  //Motif_Entree _motif = Motif_Entree.achat;
  String _motif;

  _BetePageState(this._bete);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Bete'),
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
                  new TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: _numBoucle,
                      decoration: InputDecoration(labelText: 'Numero boucle', hintText: 'Boucle'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return "";
                      },
                      onSaved: (value) {
                          setState(() {
                            _numBoucle = value;
                        });
                      }
                  ),
                  new TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: _numMarquage,
                      decoration: InputDecoration(labelText: 'Numero marquage', hintText: 'Marquage'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return "";
                        },
                      onSaved: (value) {
                        setState(() {
                        _numMarquage = value;
                        });
                      }
                  ),
                  new Row(
                     children: <Widget>[
                      new Flexible (child:
                          RadioListTile<Sex>(
                            title: const Text('Male'),
                            selected: _sex == Sex.male,
                            value: Sex.male,
                            groupValue: _sex,
                            onChanged: (Sex value) { setState(() { _sex = value; }); },
                          ),
                      ),
                      new Flexible( child:
                          RadioListTile<Sex>(
                            title: const Text('Femelle'),
                            selected: _sex == Sex.femelle,
                            value: Sex.femelle,
                            groupValue: _sex,
                            onChanged: (Sex value) { setState(() { _sex = value; }); },
                          ),
                      ),]
                  ),
                    new RaisedButton(
                      child: new Text(
                        (_bete == null)?'Ajouter':'Enregistrer',
                        style: new TextStyle(color: Colors.white),
                      ),
                      onPressed: _save,
                      color: Colors.lightGreen[700],
                  ),
              ]
    ),
    )));

  }

  void _save() async {
    _formKey.currentState.save();
    if (_bete == null)
      _bete = new Bete(null, _numBoucle, _numMarquage, _dateEntreCtrl.text, _sex, _motif);
    else {
      _bete.numBoucle = _numBoucle;
      _bete.numMarquage = _numMarquage;
      _bete.dateEntree =  _dateEntreCtrl.text;
      _bete.sex = _sex;
      _bete.motifEntree = _motif;
      gismoBloc.saveBete(_bete);
    }

    Navigator
        .of(context)
        .pop(_bete);
  }

  void goodSaving(String message) {
    Navigator.pop(context, message);
  }

  void badSaving(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);

  }

  @override
  void initState() {
    super.initState();
    if (_bete == null )
      _dateEntreCtrl.text = df.format(selectedDate);
    else {
      _dateEntreCtrl.text = _bete.dateEntree;
      _numBoucle = _bete.numBoucle;
      _numMarquage = _bete.numMarquage;
      _sex = _bete.sex;
      _motif = _bete.motifEntree;
    }
  }
/*
  @override
  void dispose() {
    // other dispose methods
    cheptelCtrl.dispose();
    boucleCtrl.dispose();
    elevageCtrl.dispose();
    naissanceCtrl.dispose();
    super.dispose();
  }

   */
}