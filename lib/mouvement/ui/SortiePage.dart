import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/mouvement/presenter/SortiePresenter.dart';
import 'package:intl/intl.dart';

class SortiePage extends StatefulWidget {

  @override
  _SortiePageState createState() => new _SortiePageState();
}
abstract class SortieContract extends GismoContract {
  List<Bete> get sheeps;
  set sheeps(List<Bete> value);
  onAddBete(Bete bete);
}

class _SortiePageState extends GismoStatePage<SortiePage> implements SortieContract {
  TextEditingController _dateSortieCtl = TextEditingController();
  late SortiePresenter _presenter;
  //final _df = new DateFormat('dd/MM/yyyy');
  late List<Bete> _sheeps;

  List<Bete> get sheeps => _sheeps;

  set sheeps(List<Bete> value) {
    setState(() {
      _sheeps = value;
    });
  }

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
                onPressed:() => this._presenter.save(_dateSortieCtl.text, _currentMotif) )
          ]

      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: this._presenter.add,
        tooltip: S.of(context).tooltip_add_beast,
        child: new Icon(Icons.add),
      ),
    );
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _motifSortieItems = _getMotifSortieItems();
  }

  @override
  void initState() {
    super.initState();
    this._presenter = SortiePresenter(this);
    _sheeps = [];
    _dateSortieCtl.text =  DateFormat.yMd().format(DateTime.now());
  }

  void removeBete(int index) {
    setState(() {
      _sheeps.removeAt(index);
    });

  }

  void onAddBete(Bete bete) {
    setState(() {
      _sheeps.add(bete);
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
