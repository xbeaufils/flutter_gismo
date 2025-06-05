import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/SearchPage.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:intl/intl.dart';

class SortiePage extends StatefulWidget {
  final GismoBloc _bloc;

  SortiePage(this._bloc,{Key ? key}) : super(key: key);
  @override
  _SortiePageState createState() => new _SortiePageState(this._bloc);
}

class _SortiePageState extends State<SortiePage> {
  final GismoBloc _bloc;
  _SortiePageState(this._bloc);
  TextEditingController _dateSortieCtl = TextEditingController();
  //final _df = new DateFormat('dd/MM/yyyy');
  late List<Bete> _sheeps;
  String ? _currentMotif;
  late List<DropdownMenuItem<String>> _motifSortieItems;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<DropdownMenuItem<String>> _getMotifSortieItems() {
    List<DropdownMenuItem<String>> items = [];
    items.add( new DropdownMenuItem(value: 'MORT', child: new Text(S.of(context).output_death)));
    items.add( new DropdownMenuItem(value: 'VENTE_BOUCHERIE', child: new Text( S.of(context).output_boucherie)));
    items.add( new DropdownMenuItem(value: 'VENTE_REPRODUCTEUR', child: new Text(S.of(context).output_reproducteur)));
    items.add( new DropdownMenuItem(value: 'MUTATION_INTERNE', child: new Text(S.of(context).output_mutation)));
    items.add( new DropdownMenuItem(value: 'ERREUR_DE_NUMERO', child: new Text(S.of(context).output_error)));
    items.add( new DropdownMenuItem(value: 'PRET_OU_PENSION', child: new Text(S.of(context).output_loan)));
    items.add( new DropdownMenuItem(value: 'SORTIE_AUTOMATIQUE', child: new Text(S.of(context).output_auto)));
    items.add( new DropdownMenuItem(value: 'AUTO_CONSOMMATION', child: new Text(S.of(context).output_conso)));
    items.add( new DropdownMenuItem(value: 'INCONNUE', child: new Text(S.of(context).output_unknown)));
    return items;
  }

  void changedMotifSortieItem(String ? selectedMotif) {
    setState(() {
      _currentMotif= selectedMotif!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(S.of(context).output),
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
                          labelText: S.of(context).dateDeparture),
                          //hintText: 'jj/mm/aaaa'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return S.of(context).noDateDeparture;
                        }},
                      onSaved: (value) {
                        setState(() {
                          _dateSortieCtl.text = value!;
                        });
                      },
                      onTap: () async{
                        DateTime date = DateTime.now();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        date = await showDatePicker(
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100)) as DateTime;
                        if (date != null) {
                          setState(() {
                            _dateSortieCtl.text =  DateFormat.yMd().format(date);
                          });
                        }
                      }),
                  new DropdownButton<String>(
                    value: _currentMotif,
                    items: _motifSortieItems,
                    hint: Text(S.of(context).output_select,style: TextStyle(color: Colors.lightGreen,)),
                    onChanged: changedMotifSortieItem,
                  )

                ],
              )),
          Expanded(
            child: Sheeps(this._sheeps, this)),
            ElevatedButton(
                //color: Colors.lightGreen[900],
                child: Text(S.of(context).bt_save,
                  style: new TextStyle(color: Colors.white, ),),
                onPressed: _saveSortie)
          ]

      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _openAddEntryDialog,
        tooltip: S.of(context).tooltip_add_beast,
        child: new Icon(Icons.add),
      ),
    );
  }

  void _saveSortie() {
    if (_dateSortieCtl.text.isEmpty) {
      showError(S.of(context).noDateDeparture);
      return;
    }

    if ( _currentMotif == null) {
      showError(S.of(context).output_reason_required);
      return;
    }
    if (_currentMotif!.isEmpty) {
      showError(S.of(context).output_reason_required);
      return;
    }
    if (_sheeps.length == 0) {
      showError(S.of(context).empty_list);
      return;
    }

    var message  = this._bloc.saveSortie(DateFormat.yMd().parse(_dateSortieCtl.text), _currentMotif!, this._sheeps);
    message
      .then( (message) {goodSaving(message);})
      .catchError( (message) {showError(message);});
  }

  void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //_scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void goodSaving(String message) {
    message = S.of(context).output + " : " + message;
    Navigator.pop(context, message);
  }

  Future _openAddEntryDialog() async {
      Bete selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
          builder: (BuildContext context) {
            return new SearchPage(GismoPage.sortie);
          },
          fullscreenDialog: true
      )) as Bete;
      if (selectedBete != null) {
        setState(() {
          _sheeps.add(selectedBete);
        });
      }
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _motifSortieItems = _getMotifSortieItems();
  }

  @override
  void initState() {
    super.initState();
    _sheeps = [];
    _dateSortieCtl.text =  DateFormat.yMd().format(DateTime.now());
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
