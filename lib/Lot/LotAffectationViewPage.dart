
import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/SearchPage.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:intl/intl.dart';

enum View {fiche, ewe, ram}

class LotAffectationViewPage extends StatefulWidget {
  LotModel  _currentLot;
  final GismoBloc _bloc;

  LotAffectationViewPage(this._bloc, this._currentLot, {Key? key}) : super(key: key);
  @override
  _LotAffectationViewPageState createState() => new _LotAffectationViewPageState(this._bloc);
}

class _LotAffectationViewPageState extends State<LotAffectationViewPage> {
  final GismoBloc _bloc;
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
  int _nbBrebis = -1;
  int _nbBeliers = -1;
  late View _currentView;

  LotModel get currentLot => this.widget._currentLot;

  @override
  void initState(){
    super.initState();
    _currentView = View.fiche;
    if (currentLot.codeLotLutte != null)
      _codeLotCtl.text = currentLot.codeLotLutte!;
    if (currentLot.dateDebutLutte != null)
      _dateDebutCtl.text = currentLot.dateDebutLutte!;
    if (currentLot.dateFinLutte != null)
    _dateFinCtl.text = currentLot.dateFinLutte!;
    if (currentLot.campagne == null)
      _campagneCtrl.text = DateTime.now().year.toString();
    else
      _campagneCtrl.text = currentLot.campagne!;
   }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
            bottomNavigationBar:
              BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.edit),label:"Edition"),
                    BottomNavigationBarItem(icon: Image.asset("assets/ram_inactif.png"), activeIcon: Image.asset("assets/ram_actif.png") ,label: "Beliers"),
                    BottomNavigationBarItem(icon: Image.asset("assets/ewe_inactif.png"), activeIcon: Image.asset("assets/ewe_actif.png") , label: "Brebis"),
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

  Widget _getTitle() {
    switch (_currentView) {
      case View.fiche :
        return  new Text( currentLot.codeLotLutte! );
      case View.ewe :
        return new Text(_nbBrebis.toString());
      case View.ram :
        return new Text(_nbBeliers.toString());
    }
  }

  void _changePage(int index) {
    if (this.widget._currentLot.idb == null ) {
      final snackBar = SnackBar(
        content: Text("vous devez enregistrer le lot avant d'ajouter"),
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
                              labelText: "Date de Fin",),
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
                  RaisedButton(
                      color: Colors.lightGreen[700],
                      child: new Text("Enregistrer",style: TextStyle( color: Colors.white)),
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
          _showCount(belierSnap.data!.length.toString() + " béliers"),
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
              _showCount(brebisSnap.data!.length.toString() + " brebis"),
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
                    this.widget._currentLot.dateDebutLutte!) : Text(
                  "Entrée le : " + bete.dateEntree!,),
                SizedBox(width: 20,),
                bete.dateSortie == null ? Text(
                    this.widget._currentLot.dateFinLutte!) : Text(
                    "Sortie le : " + bete.dateSortie!)
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

  Future _addBete() async {
    //Future _openAddEntryDialog() async {
      Bete ? selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
          builder: (BuildContext context) {
            SearchPage search = new SearchPage(this._bloc, GismoPage.lot);
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
        String ? dateEntree = await _showDateDialog(this.context,
            "Date d'entrée",
            "Saisir une date d'entrée si différente de la date de début de lot",
            "Date d'entrée");
        if (dateEntree != null) {
          String message = await this._bloc.addBete(
              currentLot, selectedBete, dateEntree);
          final snackBar = SnackBar(
            content: Text(message),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          setState(() {

          });
        }
      }
  }

  Future _removeBete(Affectation affect) async {
      String ? dateSortie = await _showDateDialog(this.context,
          "Date de sortie",
          "Saisir une date de sortie si différente de la date de fin de lot",
          "Date de sortie");
      if (dateSortie != null ) {
        String message = await this._bloc.removeFromLot(affect, dateSortie);
        final snackBar = SnackBar(
          content: Text(message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {});
      }
  }

  void _save() async {
   currentLot.dateDebutLutte = _dateDebutCtl.text;
    if (currentLot.dateDebutLutte == "") {
      final snackBar = SnackBar(
        content: Text(
            "La date de début est obligatoire"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (_df.parse(_dateDebutCtl.text).year.toString() != _campagneCtrl.text) {
      final snackBar = SnackBar(
         content: Text("L'année de la date de début doit être égale à la campagne"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    currentLot.dateFinLutte =  _dateFinCtl.text;
    if (currentLot.dateFinLutte == "") {
      final snackBar = SnackBar(
        content: Text(
            "La date de fin est obligatoire"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    currentLot.campagne = _campagneCtrl.text;
    currentLot.codeLotLutte = _codeLotCtl.text;
    if (currentLot.codeLotLutte == "") {
       final snackBar = SnackBar(
         content: Text(
             "Le nom du lot est obligatoire"),
       );
       ScaffoldMessenger.of(context).showSnackBar(snackBar);
       return;
     }
     currentLot.campagne = _campagneCtrl.text;
    this.widget._currentLot = (await this._bloc.saveLot(currentLot))!;
  }

  Future<List<Affectation>> _getBeliers(int idLot)  {
    return this._bloc.getBeliersForLot(idLot);
  }

  Future<List<Affectation>> _getBrebis(int idLot)  {
    return this._bloc.getBrebisForLot(idLot);
  }

  Future _showDialog(BuildContext context, Affectation affect) {
    String message ="Voulez vous supprimer ";
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Suppression"),
          content: Text(
              message),
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
      child: Text("Annuler"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _deleteButton(Affectation affectation) {
    return TextButton(
      child: Text("Supprimer"),
      onPressed: () {
          _deleteAffectation(affectation);
        Navigator.of(context).pop();
      },
    );
  }

  void _deleteAffectation(Affectation event) async {
    String message = await this.widget._bloc.deleteAffectation(event);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    /*_scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(message)));*/
    setState(() {

    });
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