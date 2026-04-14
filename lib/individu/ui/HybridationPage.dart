import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/individu/presenter/BetePresenter.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/generated/l10n.dart';

class HybridationPage extends StatefulWidget {
  Hybridation ? _hybridation;

  HybridationPage(Hybridation ? hybridation, {Key ? key}) : super(key: key){
    this._hybridation = hybridation;
  }

  @override
  _HybridationPageState createState() => new _HybridationPageState();

}
abstract class HybridationContract extends GismoContract {
  Hybridation ? get hybridation;
}

class _HybridationPageState extends GismoStatePage<HybridationPage> implements HybridationContract {
  late HybridationPresenter _presenter;

  Hybridation ? get hybridation => this.widget._hybridation;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(S.of(context).race),
      ),
      body:
        Column(
          children: <Widget> [
            Text(S.current.generation),
            SegmentedButton<Generation>(
              showSelectedIcon: false,
              segments: [
                const ButtonSegment(value: Generation.PURE, label: Text('Pur')),
                const ButtonSegment(value: Generation.F1, label: Text('F1')),
                const ButtonSegment(value: Generation.F2, label: Text('F2')),
                const ButtonSegment(value: Generation.F3, label: Text('F3')),
                const ButtonSegment(value: Generation.F4, label: Text('F4')),
                ButtonSegment(value: Generation.INDETERMINE, label: Text(S.current.race_indet)),
              ],
              selected: {_presenter.hybridation.niveau},
              onSelectionChanged: (Set<Generation> newSelection) {
                setState(() {
                  _presenter.hybridation.niveau = newSelection.first;
                });
              },
            ),
           Divider(),
           Text(S.current.race),
           Container(
             padding: const EdgeInsets.all(8.0),
             color:  Theme.of(context).colorScheme.surfaceContainerHighest,
             child:
               FutureBuilder(
                future: _presenter.getAllRaces(),
                builder: (BuildContext context, AsyncSnapshot SnpRaces) {
                  if (SnpRaces.connectionState == ConnectionState.none && SnpRaces.data == null)
                    return Text("Aucune race");
                  if (SnpRaces.connectionState == ConnectionState.waiting)
                    return CircularProgressIndicator();
                  List<Race> races = SnpRaces.data!;
                 return SearchAnchor (
                     isFullScreen: false,
                    builder: (BuildContext context, SearchController raceCtrl) {
                    return SearchBar(
                        controller: raceCtrl,
                        hintText: S.current.race_select,
                        padding: const WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        onTap: () {
                          raceCtrl.openView();
                        },onSubmitted: (strRace) {

                        },
                        onChanged: (_) {
                          raceCtrl.openView();
                        });
                  },
                  suggestionsBuilder:
                    (BuildContext context, SearchController controller) async {
                      if (races.length == 0)
                        return List<Container>.empty();
                      return races
                          .where( (race) => race.nom.startsWith(controller.text.toUpperCase()))
                          .map( (race)  {
                            return ListTile(
                              title: Text(race.nom),
                              onTap: () {
                                controller.closeView(race.nom);
                                setState(() {
                                  _presenter.add(race);
                                });
                              });
                          });
                      });
              }),),
           Expanded( child:
              ListView.builder(
                  itemCount: _presenter.hybridation.races.length,
                  itemBuilder:  (BuildContext context, int index) {
              if (_presenter.hybridation.races.length >0)
                return ListTile(
                  leading: (index == 0)?IconButton(onPressed: () {
                    setState(() {
                      _presenter.down(index);
                    });
                  }, icon: Icon(Icons.arrow_downward)):IconButton(onPressed: () {
                    setState(() {
                      _presenter.up(index);
                    });
                  }, icon: Icon(Icons.arrow_upward)),
                  title: Text(_presenter.hybridation.races[index].nom),
                  trailing: IconButton(icon: Icon(Icons.delete), onPressed: () =>{ setState(() {
                    this._presenter.remove(index);
                  }) },));
              else
                return Container();
            })),
           ElevatedButton(onPressed: this._presenter.save, child: Text(S.current.bt_validate),),
          ]));
  }

  @override
  void initState() {
    super.initState();
    _presenter = HybridationPresenter(this, this.widget._hybridation);
  }


}