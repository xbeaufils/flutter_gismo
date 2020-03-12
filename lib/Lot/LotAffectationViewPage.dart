import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter_gismo/SearchPage.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:intl/intl.dart';

enum View {fiche, ewe, ram}

class LotAffectationViewPage extends StatefulWidget {
  LotModel _currentLot;

  LotAffectationViewPage(this._currentLot, {Key key}) : super(key: key);
  @override
  _LotAffectationViewPageState createState() => new _LotAffectationViewPageState();
}

class _LotAffectationViewPageState extends State<LotAffectationViewPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formFicheKey = GlobalKey<FormState>();
  TextEditingController _codeLotCtl = TextEditingController();
  TextEditingController _dateDebutCtl = TextEditingController();
  TextEditingController _dateFinCtl = TextEditingController();
  TextEditingController _dateMvtCtl = TextEditingController();
  TextEditingController _campagneCtrl = TextEditingController();
  final _df = new DateFormat('dd/MM/yyyy');
  int _curIndex=0;
  View _currentView;

  String _codeLot;

  LotModel get currentLot => this.widget._currentLot;

  @override
  void initState(){
    super.initState();
    _currentView = View.fiche;
    _codeLotCtl.text = currentLot.codeLotLutte;
    _dateDebutCtl.text = currentLot.dateDebutLutte;
    _dateFinCtl.text = currentLot.dateFinLutte;
    if (currentLot.campagne == null)
      _campagneCtrl.text = DateTime.now().year.toString();
    else
      _campagneCtrl.text = currentLot.campagne;
   }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
            bottomNavigationBar:
              BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.edit), title: Text("Edition")),
                    BottomNavigationBarItem(icon: Image.asset("assets/ram_inactif.png"), activeIcon: Image.asset("assets/ram_actif.png") , title: Text("Beliers")),
                    BottomNavigationBarItem(icon: Image.asset("assets/ewe_inactif.png"), activeIcon: Image.asset("assets/ewe_actif.png") , title: Text("Brebis")),
                  ],
                currentIndex: _curIndex,
                onTap: (index) =>{ _changePage(index)}
              ),
            appBar: new AppBar(
              title: new Text('Lot'),
            ),
            floatingActionButton: _curIndex == 0 ? null : FloatingActionButton(child: Icon(Icons.add), onPressed: _addBete),
            body:
              _getCurrentView()
    );
  }

  void _changePage(int index) {
    if (this.widget._currentLot.idb == null ) {
      final snackBar = SnackBar(
        content: Text("vous devez enregistrer le lot avant d'ajouter"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    setState(() {
      _curIndex = index;
      switch (_curIndex) {
        case 0:
          _currentView = View.fiche;
          break;
        case 1:
          _currentView = View.ram;
          break;
        case 2:
          _currentView = View.ewe;
          break;
      }
    });

  }

  Widget _getCurrentView() {
    switch (_currentView) {
      case View.fiche:
        return _getFiche();
        break;
      case View.ewe :
        return _listBrebisWidget();
        break;
      case View.ram:
        return _listBelierWidget();
        break;
    }
  }

  Widget _getFiche() {
    return new Container(
        child: new Form(
            key: _formFicheKey,
            child:
            new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                      controller: _codeLotCtl,
                      decoration: InputDecoration(labelText: 'Nom lot', hintText: 'Lot'),
                   ),

                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible( child:
                          TextFormField(
                            controller: _campagneCtrl,
                            decoration: InputDecoration(labelText: 'Campagne'),
                            enabled: false,
                          ),
                        )
                      ]
                  ),
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
                                _dateDebutCtl.text = _df.format(date);
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
                                _dateFinCtl.text = _df.format(date);
                            },
                          ),
                        )
                      ]

                  ),
                  RaisedButton(
                      color: Colors.lightGreen[700],
                      child: new Text("Enregistrer",style: TextStyle( color: Colors.white)),
                      onPressed: _save)
                ])
        ));

  }

  Widget _listBelierWidget() {
    return FutureBuilder(
      builder: (context, BelierSnap) {
        if (BelierSnap.connectionState == ConnectionState.none && BelierSnap.hasData == null) {
          return Container();
        }
        if (BelierSnap.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        return  _showList(BelierSnap);
      },
      future: _getBeliers(this.widget._currentLot.idb),
    );
  }

  Widget _listBrebisWidget() {
    return FutureBuilder(
        builder: (context, BrebisSnap) {
          if (BrebisSnap.connectionState == ConnectionState.none &&
              BrebisSnap.hasData == null) {
            return Container();
          }
          if (BrebisSnap.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          return _showList(BrebisSnap);
        },
      future: _getBrebis(this.widget._currentLot.idb),
    );
  }

  Widget _showList(AsyncSnapshot<List<Affectation>> snap) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snap.data.length,
      itemBuilder: (context, index) {
        Affectation bete = snap.data[index];
        return Column(
          children: <Widget>[
            Card(child:
              ListTile(
                  title:
                  Row(children:
                    <Widget>[
                      Text(bete.numBoucle, style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 20,),
                      Text(bete.numMarquage, style: TextStyle(fontStyle: FontStyle.italic),)],
                  ),
                  subtitle:
                      Row(children:
                        <Widget>[
                          bete.dateEntree == null? Text(this.widget._currentLot.dateDebutLutte):Text("Entrée le : " + bete.dateEntree,),
                          SizedBox(width: 20,),
                          bete.dateSortie == null? Text(this.widget._currentLot.dateFinLutte):Text("Sortie le : "  + bete.dateSortie)],
                        ),
                  trailing: IconButton(icon: Icon(Icons.launch), onPressed:() =>{ _removeBete(bete)}, )
            ))
          ],
        );
      },
    );
  }

  Future _addBete() async {
    //Future _openAddEntryDialog() async {
      Bete selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
          builder: (BuildContext context) {
            SearchPage search = new SearchPage(null, Page.lot);
            switch (_currentView ) {
              case View.ewe:
                search.searchSex = Sex.femelle;
                break;
              case View.ram:
                search.searchSex = Sex.male;
                break;
              default:
            }
            return search;
          },
          fullscreenDialog: true
      ));
      if (selectedBete != null) {
        //if (_dateEntreeCtl.text.isEmpty)
        //  _dateEntreeCtl.text = this.widget._currentLot.dateDebutLutte;
        String dateEntree = await _showDateDialog(this.context,
            "Date d'entrée",
            "Date d'entrée",
            "Saisir une date d'entrée si différente de la date de début de lot");
        if (dateEntree.isEmpty)
          dateEntree = null;
        String message = await gismoBloc.addBete(currentLot, selectedBete, dateEntree);
        final snackBar = SnackBar(
          content: Text(message),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);

        setState(() {

        });

      }
  }

  Future _removeBete(Affectation affect) async {
      String dateSortie = await _showDateDialog(this.context,
          "Date de sortie",
          "Date de sortie",
          "Saisir une date de sortie si différente de la date de fin de lot");
      String message = await gismoBloc.removeFromLot(affect, dateSortie);
      final snackBar = SnackBar(
        content: Text(message),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      setState(() {
      });
  }

  void _save() async {
   currentLot.dateDebutLutte = _dateDebutCtl.text;
    if (currentLot.dateDebutLutte == "") {
      final snackBar = SnackBar(
        content: Text(
            "La date de début est obligatoire"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    if (_df.parse(_dateDebutCtl.text).year.toString() != _campagneCtrl.text) {
      final snackBar = SnackBar(
         content: Text("L'année de la date de début doit être égale à la campagne"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    currentLot.dateFinLutte =  _dateFinCtl.text;
    if (currentLot.dateFinLutte == "") {
      final snackBar = SnackBar(
        content: Text(
            "La date de fin est obligatoire"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    currentLot.campagne = _campagneCtrl.text;
    currentLot.codeLotLutte = _codeLotCtl.text;
    if (currentLot.codeLotLutte == "") {
       final snackBar = SnackBar(
         content: Text(
             "Le nom du lot est obligatoire"),
       );
       _scaffoldKey.currentState.showSnackBar(snackBar);
       return;
     }
     currentLot.campagne = _campagneCtrl.text;
    this.widget._currentLot = await gismoBloc.saveLot(currentLot);
  }

  Future<List<Affectation>> _getBeliers(int idLot)  {
    return gismoBloc.getBeliersForLot(idLot);
  }

  Future<List<Affectation>> _getBrebis(int idLot)  {
    return gismoBloc.getBrebisForLot(idLot);
  }

  Future<String> _showDateDialog(BuildContext context, String title, String helpMessage, String label) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        // dialog is dismissible with a tap on the barrier
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(title),
                content:
                new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(helpMessage),
                    /* new Expanded(
                    child:*/
                    new TextFormField(
                      controller: _dateMvtCtl,
                      decoration: InputDecoration(
                        labelText: label,),
                      onTap: () async {
                        DateTime date = DateTime.now();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (date != null)
                          _dateMvtCtl.text = _df.format(date);
                        //dateEntree = _df.format(date);
                      },
                    ),
                    //)
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                          setState(() {
                            _dateMvtCtl.text="";
                          });
                      },
                      child: Text("Effacer")),
                  FlatButton(
                    child: Text('Enregistrer'),
                    onPressed: () {
                      Navigator.of(context).pop(_dateMvtCtl.text);
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  @override
  void dispose() {
    _campagneCtrl.dispose();
    _codeLotCtl.dispose();
    _dateFinCtl.dispose();
    _dateDebutCtl.dispose();
    _dateMvtCtl.dispose();
    super.dispose();
  }


}