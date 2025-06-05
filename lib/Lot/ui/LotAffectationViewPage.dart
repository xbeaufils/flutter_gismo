
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/SearchPage.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/Lot/presenter/LotAffectationPresenter.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum View {fiche, ewe, ram}

class LotAffectationViewPage extends StatefulWidget {
  LotModel  _currentLot;
  final GismoBloc _bloc;

  LotAffectationViewPage(this._bloc, this._currentLot, {Key? key}) : super(key: key) ;

  @override
  _LotAffectationViewPageState createState() => new _LotAffectationViewPageState(this._bloc);
}

abstract class LotAffectationContract {
  Future<Bete?> selectBete();
  Future<String?> selectDateEntree();

}

class _LotAffectationViewPageState extends State<LotAffectationViewPage> implements LotAffectationContract {
  final GismoBloc _bloc;
  late final LotAffectionPresenter _presenter ;
  _LotAffectationViewPageState(this._bloc);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formFicheKey = GlobalKey<FormState>();
  TextEditingController _codeLotCtl = TextEditingController();
  TextEditingController _dateDebutCtl = TextEditingController();
  TextEditingController _dateFinCtl = TextEditingController();
  TextEditingController _dateMvtCtl = TextEditingController();
  TextEditingController _campagneCtrl = TextEditingController();
  final _df = new DateFormat('dd/MM/yyyy');
  int _curIndex=0;
  late View _currentView;

  LotModel get currentLot => this.widget._currentLot;

  @override
  void initState(){
    super.initState();
    _presenter = LotAffectionPresenter(this, this._bloc, this.currentLot);
    _currentView = View.fiche;
    if (currentLot.codeLotLutte != null)
      _codeLotCtl.text = currentLot.codeLotLutte!;
    if (currentLot.dateDebutLutte != null)
      _dateDebutCtl.text = DateFormat.yMd().format(currentLot.dateDebutLutte!);
    if (currentLot.dateFinLutte != null)
      _dateFinCtl.text = DateFormat.yMd().format(currentLot.dateFinLutte!);
    if (currentLot.campagne == null)
      _campagneCtrl.text = DateTime.now().year.toString();
    else
      _campagneCtrl.text = currentLot.campagne!;
   }

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<ConfigProvider>(context);
    return new Scaffold(
      key: _scaffoldKey,
            bottomNavigationBar:
              BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.edit),label: S.of(context).bt_edition),
                    BottomNavigationBarItem(icon: Image.asset("assets/ram_inactif.png"), activeIcon: Image.asset("assets/ram_actif.png") ,label: S.of(context).ram),
                    BottomNavigationBarItem(icon: Image.asset("assets/ewe_inactif.png"), activeIcon: Image.asset("assets/ewe_actif.png") , label: S.of(context).ewe),
                  ],
                currentIndex: _curIndex,
                onTap: (index) =>{ _changePage(index)}
              ),
            appBar: new AppBar(
              title:
              (this.currentLot.codeLotLutte == null) ? Text("Nouveau lot") : Text('Lot ' + this.currentLot.codeLotLutte!),
            ),
            floatingActionButton: _curIndex == 0 ? null : FloatingActionButton(child: Icon(Icons.add), onPressed: _addBete),
            body:
              _getCurrentView()
    );
  }

  void _changePage(int index) {
    if (this.widget._currentLot.idb == null ) {
      final snackBar = SnackBar(
        content: Text(S.of(context).batch_warning),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      case View.ewe :
        return _listBrebisWidget();
      case View.ram:
        return _listBelierWidget();
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
                      decoration: InputDecoration(labelText: S.of(context).batch_name, hintText: S.of(context).batch),
                   ),

                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible( child:
                          TextFormField(
                            controller: _campagneCtrl,
                            decoration: InputDecoration(labelText: S.of(context).batch_campaign),
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
                                _dateDebutCtl.text = _df.format(date);
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
                                _dateFinCtl.text = _df.format(date);
                            },
                          ),
                        )
                      ]

                  ),
                  ElevatedButton(
                      //color: Colors.lightGreen[700],
                      child: new Text(S.of(context).bt_save,style: TextStyle( color: Colors.white)),
                      onPressed: _save)
                ])
        ));

  }

  Widget _listBelierWidget() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<List<Affectation>> belierSnap) {
        if (belierSnap.connectionState == ConnectionState.none && belierSnap.hasData == null) {
          return Container();
        }
        if (belierSnap.connectionState == ConnectionState.waiting)
          return Center(child:CircularProgressIndicator());
        return  Column(
            mainAxisSize: MainAxisSize.max,
            children:  [
          _showCount( (belierSnap.data == null? "0 ": belierSnap.data!.length.toString()) + " béliers"),
          Expanded(child: _showList(belierSnap))
            ]);
      },
      future: _getBeliers(this.widget._currentLot.idb!),
    );
  }

  Widget _listBrebisWidget() {
    return FutureBuilder(
        builder: (context, AsyncSnapshot<List<Affectation>> brebisSnap) {
          if (brebisSnap.connectionState == ConnectionState.none &&
              brebisSnap.hasData == null) {
            return Container();
          }
          if (brebisSnap.connectionState == ConnectionState.waiting)
            return Center(child:  CircularProgressIndicator(),);
          return
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
              _showCount((brebisSnap.data == null? "0 ": brebisSnap.data!.length.toString()) + " brebis"),
              Expanded(child: _showList(brebisSnap))
            ],);
        },
      future: _getBrebis(this.widget._currentLot.idb!),
    );
  }

  Widget _showCount(String libelle) {
    return Row(children: <Widget>[
      Expanded(child:
        Card( color: Theme.of(context).primaryColor,  child:
          Center(child:
            Text( libelle, style: TextStyle(fontSize: 16.0, color: Colors.white),),),
        ),
      ),
    ],);
  }

  Widget _showList(AsyncSnapshot<List<Affectation>> snap) {
    if (snap.data == null)
      return Container();
    return ListView.builder(
      itemCount: snap.data!.length,
      itemBuilder: (context, index) {
        Affectation bete = snap.data![index];
       return //Card(child:
        ListTile(
            title:
              Row(children: <Widget>[
                Text(bete.numBoucle!,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 20,),
                Text(bete.numMarquage!,
                  style: TextStyle(fontStyle: FontStyle.italic),)
              ],),
            subtitle:
              Column(children: <Widget>[
                bete.dateEntree == null ? Text(
                    DateFormat.yMd().format(this.widget._currentLot.dateDebutLutte!)) : Text(
                  "Entrée le : " + DateFormat.yMd().format(bete.dateEntree!),),
                SizedBox(width: 20,),
                bete.dateSortie == null ? Text(
                    DateFormat.yMd().format(this.widget._currentLot.dateFinLutte!)) : Text(
                    "Sortie le : " + DateFormat.yMd().format(bete.dateSortie!))
              ], ),
            trailing:
            Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.delete), onPressed: () => { _showDialog(context, bete) } ),
                  IconButton(icon: Icon(Icons.launch), onPressed: () => { _removeBete(bete)},)
        ])
        );
      }
    );
  }

  Future<Bete?> selectBete() async {
    Bete ? selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
        builder: (BuildContext context) {
          SearchPage search = new SearchPage(GismoPage.lot);
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
    return selectedBete;
  }

  Future<String?> selectDateEntree() async {
    String ? dateEntree = await _showDateDialog(this.context,
        S.of(context).dateEntry,
        "Saisir une date d'entrée si différente de la date de début de lot",
        S.of(context).dateEntry);
    return dateEntree;
  }

  void _addBete() async {
    String ? message  = await _presenter.addBete();
    setState(() {
      if (message != null) {
        final snackBar = SnackBar(
          content: Text(message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  Future _removeBete(Affectation affect) async {
      String ? dateSortie = await _showDateDialog(this.context,
          S.of(context).dateDeparture,
          "Saisir une date de sortie si différente de la date de fin de lot",
          S.of(context).dateDeparture);
      if (dateSortie != null ) {
        String ? message = await this._presenter.removeBete(affect, dateSortie);
        if (message != null) {
          final snackBar = SnackBar(
            content: Text(message),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        setState(() {});
      }
  }

  void _save() async {
   currentLot.dateDebutLutte = DateFormat.yMd().parse(_dateDebutCtl.text);
    if (currentLot.dateDebutLutte == "") {
      this._showMessage("La date de début est obligatoire");
      return;
    }
    if (_df.parse(_dateDebutCtl.text).year.toString() != _campagneCtrl.text) {
      this._showMessage("L'année de la date de début doit être égale à la campagne");
      return;
    }
    currentLot.dateFinLutte =  DateFormat.yMd().parse(_dateFinCtl.text);
    if (currentLot.dateFinLutte == "") {
      this._showMessage("La date de fin est obligatoire");
      return;
    }
    currentLot.campagne = _campagneCtrl.text;
    currentLot.codeLotLutte = _codeLotCtl.text;
    if (currentLot.codeLotLutte == "") {
      this._showMessage( "Le nom du lot est obligatoire");
      return;
    }
    currentLot.campagne = _campagneCtrl.text;
    this.widget._currentLot = (await this._bloc.saveLot(currentLot))!;
    //Navigator.pop(context, "Lot enregistré");
    this._showMessage("Lot enregistré");
  }

  Future<List<Affectation>> _getBeliers(int idLot)  {
    return this._bloc.getBeliersForLot(idLot);
  }

  Future<List<Affectation>> _getBrebis(int idLot)  {
    return this._bloc.getBrebisForLot(idLot);
  }

  Future _showDialog(BuildContext context, Affectation affect) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).title_delete),
          content: Text(S.of(context).text_delete),
          actions: [
            _cancelButton(),
            _deleteButton(affect),
          ],
        );
      },
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

  Widget _deleteButton(Affectation affectation) {
    return TextButton(
      child: Text(S.of(context).bt_delete),
      onPressed: () {
          this._presenter.deleteAffectation(affectation);
        Navigator.of(context).pop();
      },
    );
  }

  Future<String?> _showDateDialog(BuildContext context, String title, String helpMessage, String label) async {
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
                        DateTime ? date = DateTime.now();
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
                  TextButton(
                      onPressed: () {
                          setState(() {
                            _dateMvtCtl.text="";
                          });
                      },
                      child: Text("Effacer")),
                  TextButton(
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

  void _showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //_scaffoldKey.currentState.showSnackBar(snackBar);
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

