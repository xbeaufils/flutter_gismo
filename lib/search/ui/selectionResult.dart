import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/search/presenter/SelectionPresenter.dart';
import 'package:flutter_gismo/traitement/presenter/SelectionPresenter.dart';

enum View {fiche, ewe, ram}

class SelectionResultPage extends StatefulWidget {
  String _explanation;
  String _title;

  List<Bete> _lstBete;

  SelectionResultPage(this._lstBete, this._explanation, this._title, {Key ? key}) : super(key: key);
  @override
  SelectionResultPageState createState() => new SelectionResultPageState();
}

abstract class SelectionContract extends GismoContract {
  List<Bete> get betes;
  set betes (List<Bete> value);
}

class SelectionResultPageState extends GismoStatePage<SelectionResultPage> implements SelectionContract {
  SelectionResultPageState();
  late SelectionPresenter _presenter;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  SelectionPresenter get presenter => _presenter;

  set presenter(SelectionPresenter value) {
    _presenter = value;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(this.widget._title),
       ),
      floatingActionButton: Column (
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(child: Icon(Icons.check_box), onPressed: this._presenter.addMultipleBete, heroTag: null,),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(child: Icon(Icons.settings_remote), onPressed: this._presenter.addBete, heroTag: null,),
        ],),
      body: _listBeteWidget(),
    );
  }

  Widget _fullListBeteWidget() {
    return Column(children: [
      Expanded(child:
          this._listBeteBuilder()
      ),
      Container(
        padding: const EdgeInsets.all(10.0),
        child:
          Center(
            child: Text(this.widget._explanation),)),
      Center(child:
        FilledButton(
            child: Text( S.of(context).bt_continue,),
            onPressed: this._presenter.nextPage),
      ),
    ],
    );
  }

  Widget _listBeteWidget() {
    if (this.betes.length == 0)
      return Container(
          padding: const EdgeInsets.all(10.0),
          child:
          Center(child: Text(S.current.treatment_explanation),));
    return _fullListBeteWidget();
  }

  Widget _listBeteBuilder() {
    return ListView.builder(
        itemCount: this.betes.length,
        itemBuilder: (context, index) {
          Bete bete = this.betes[index];
          return
            ListTile(
                title:
                Text(bete.numBoucle,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle:
                Text(bete.numMarquage,
                  style: TextStyle(fontStyle: FontStyle.italic),),
                trailing: IconButton(
                  icon: Icon(Icons.cancel), onPressed: () =>
                    { setState(() {
                      this._presenter.removeBete(bete);
                    }) },
                )
            );
        }
    );

  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Bete> get betes {
    return this.widget._lstBete;
  }

  set betes (List<Bete> value) {
    setState(() {
      this.widget._lstBete = value;
    });
  }

}