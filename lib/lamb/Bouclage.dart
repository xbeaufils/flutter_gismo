import 'package:flutter/material.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:intl/intl.dart';


class BouclagePage extends StatefulWidget {
  LambModel _currentLamb ;
  //String _dateNaissance;
  BouclagePage( this._currentLamb, /*this._dateNaissance,*/ {Key key}) : super(key: key);

  @override
  _BouclagePageState createState() => new _BouclagePageState();
}

class _BouclagePageState extends State<BouclagePage> {
  final df = new DateFormat('dd/MM/yyyy');
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _numBoucle;
  String _numMarquage;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Bouclage'),
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
                    new RaisedButton(
                      child: new Text(
                        'Poser la boucle',
                        style: new TextStyle(color: Colors.white),
                      ),
                      onPressed: _createBete,
                      color: Colors.lightGreen[900],
                    ),
                  ]
              ),
            )));

  }

  void _createBete() async {
    _formKey.currentState.save();
    this.widget._currentLamb.numMarquage = _numMarquage;
    this.widget._currentLamb.numBoucle = _numBoucle;
    Bete bete = new Bete(null, _numBoucle, _numMarquage, null, null, null, this.widget._currentLamb.sex, 'NAISSANCE');
    /*
    Bete bete = new Bete(null, _numBoucle, _numMarquage, null, this.widget._dateNaissance, this.widget._currentLamb.sex, 'NAISSANCE');
    gismoBloc.boucler(this.widget._currentLamb,bete);
     */
    Navigator.pop(context, bete);
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

}