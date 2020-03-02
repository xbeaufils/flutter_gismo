import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/SearchPage.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:intl/intl.dart';

class SortiePage extends StatefulWidget {
  SortiePage({Key key}) : super(key: key);
  @override
  _SortiePageState createState() => new _SortiePageState();
}

class _SortiePageState extends State<SortiePage> {

  TextEditingController _dateSortieCtl = TextEditingController();
  final _df = new DateFormat('dd/MM/yyyy');
  List<Bete> _sheeps;
  String _currentMotif;
  List<DropdownMenuItem<String>> _MotifSortieItems;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<DropdownMenuItem<String>> _getMotifSortieItems() {
    List<DropdownMenuItem<String>> items = new List();
    items.add( new DropdownMenuItem(value: 'MORT', child: new Text('Mort')));
    items.add( new DropdownMenuItem(value: 'VENTE_BOUCHERIE', child: new Text('Vente boucherie')));
    items.add( new DropdownMenuItem(value: 'VENTE_REPRODUCTEUR', child: new Text('Vente reproducteur')));
    items.add( new DropdownMenuItem(value: 'MUTATION_INTERNE', child: new Text('Mutation interne')));
    items.add( new DropdownMenuItem(value: 'ERREUR_DE_NUMERO', child: new Text('Erreur de numéro')));
    items.add( new DropdownMenuItem(value: 'PRET_OU_PENSION', child: new Text('Prêt ou pension')));
    items.add( new DropdownMenuItem(value: 'SORTIE_AUTOMATIQUE', child: new Text('Sortie Automatique')));
    items.add( new DropdownMenuItem(value: 'AUTO_CONSOMMATION', child: new Text('Auto consommation')));
    items.add( new DropdownMenuItem(value: 'INCONNUE', child: new Text('Inconnue')));
    return items;
  }

  void changedMotifSortieItem(String selectedMotif) {
    setState(() {
      _currentMotif= selectedMotif;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Sortie'),
      ),
      body:
      new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Card(key: null,
              child:Column(
                children: <Widget>[
                  new TextFormField(
                      keyboardType: TextInputType.datetime,
                      controller: _dateSortieCtl,
                      decoration: InputDecoration(
                          labelText: 'Date de sortie',
                          hintText: 'jj/mm/aaaa'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Pas de date de sortie';
                        }},
                      onSaved: (value) {
                        setState(() {
                          _dateSortieCtl.text = value;
                        });
                      },
                      onTap: () async{
                        DateTime date = DateTime.now();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        date = await showDatePicker(

                          locale: const Locale("fr","FR"),
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100));
                        if (date != null) {
                          setState(() {
                            _dateSortieCtl.text = _df.format(date);
                          });
                        }
                      }),
                  new DropdownButton<String>(
                    value: _currentMotif,
                    items: _MotifSortieItems,
                    hint: Text('Selectionnez une cause de sortie',style: TextStyle(color: Colors.lightGreen,)),
                    onChanged: changedMotifSortieItem,
                  )

                ],
              )),
          Expanded(
            child: Sheeps(this._sheeps, this)),
            RaisedButton(
                color: Colors.lightGreen[900],
                child: Text('Enregistrer',
                  style: new TextStyle(color: Colors.white, ),),
                onPressed: _saveSortie)
          ]

      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _openAddEntryDialog,
        tooltip: 'Ajouter une bête',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _saveSortie() {
    if (_dateSortieCtl.text.isEmpty) {
      showError("Pas de date de sortie");
      return;
    }

    if ( _currentMotif == null) {
      showError("Cause de sortie obligatoire");
      return;
    }
    if (_currentMotif.isEmpty) {
      showError("Cause de sortie obligatoire");
      return;
    }
    if (_sheeps.length == 0) {
      showError("Liste des betes vide");
      return;
    }

    var message  = gismoBloc.saveSortie(_dateSortieCtl.text, _currentMotif, this._sheeps);
    message
      .then( (message) {goodSaving(message);})
      .catchError( (message) {showError(message);});
  }

  void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void goodSaving(String message) {
    message = "Sortie : " + message;
    Navigator.pop(context, message);
  }

  Future _openAddEntryDialog() async {
      Bete selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
          builder: (BuildContext context) {
            return new SearchPage(gismoBloc, Page.sortie);
          },
          fullscreenDialog: true
      ));
      if (selectedBete != null) {
        setState(() {
          _sheeps.add(selectedBete);
        });
      }
  }

  @override
  void initState() {
    super.initState();
    _sheeps = new List();
    _MotifSortieItems = _getMotifSortieItems();
    _dateSortieCtl.text = _df.format(DateTime.now());
  }

  void removeBete(int index) {
    setState(() {
      _sheeps.removeAt(index);
    });

  }
}

class Sheeps extends StatelessWidget {
  final List<Bete> _sheeps;
  _SortiePageState _sortie;
  Sheeps(this._sheeps, this._sortie);

  Widget _buildLambItem(BuildContext context, int index) {
    return Card(
      child: ListTile(
            title: Text(_sheeps[index].numBoucle),
            subtitle: Text(_sheeps[index].numMarquage),
            trailing: IconButton(icon: Icon(Icons.clear), onPressed:() {  _sortie.removeBete(index);} ),
          ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildLambItem,
      itemCount: _sheeps.length,
    );
  }
}
