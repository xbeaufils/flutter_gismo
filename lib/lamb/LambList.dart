import 'package:flutter/material.dart';
import 'package:flutter_gismo/lamb/Bouclage.dart';
import 'package:flutter_gismo/lamb/Mort.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/CauseMort.dart';
import 'package:flutter_gismo/model/LambModel.dart';

class LambsPage extends StatefulWidget {
  final List<LambModel> _lambs;
  final String _dateNaissance;
  @override
  LambsPageState createState() => new LambsPageState(_lambs, _dateNaissance);

  LambsPage(this._lambs, this._dateNaissance);
}


class LambsPageState extends State<LambsPage> {
  final List<LambModel> _lambs;
  final String _dateNaissance;
  LambsPageState(this._lambs, this._dateNaissance);

  Widget _buildLambItem(BuildContext context, int index) {
    String sexe = (_lambs[index].sex == Sex.male) ?"Male" : "";
    sexe = (_lambs[index].sex == Sex.femelle) ?"Femelle" : sexe;
    return ListTile(
      leading: Image.asset('assets/lamb.png'),
      title: Text(sexe) ,
      subtitle: Text(_lambs[index].marquageProvisoire),
      trailing:  _buildTrailing(_lambs[index]),);
   }

  Widget _buildTrailing(LambModel lamb) {
    if (lamb.idBd == null)
      return null;
    if (lamb.idDevenir != null && lamb.dateDeces.isEmpty)
      return Column(
        children: <Widget>[
          Text(lamb.numBoucle),
          Text(lamb.numMarquage),
        ],
      );

    if (lamb.dateDeces != null)

      return Column(children: <Widget>[
        Text(CauseMortExtension.getValue(lamb.motifDeces).name),
        Text(lamb.dateDeces),
      ],);
      /*
      return ListTile(
        leading: Image.asset('assets/tomb.png'),
        title: Text(CauseMortExtension.getValue(lamb.motifDeces).name) ,
        subtitle: Text(lamb.dateDeces),
        );
    */
    return Flex(
      mainAxisSize: MainAxisSize.min,
      direction: Axis.horizontal,
      children: <Widget>[
      IconButton(
        icon: Image.asset("assets/tomb.png"),
        onPressed: () {_openDeath(lamb, this._dateNaissance);},),
      IconButton(
        icon: Image.asset("assets/bouclage.png"),
        onPressed: () {_openBoucle(lamb, this._dateNaissance);},)
      ],
    ) ;

  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildLambItem,
      itemCount: _lambs.length,
    );
  }

  void _openBoucle(LambModel lamb, String dateNaissance) {
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => BouclagePage(lamb, dateNaissance)),
    );

  }
  void _openDeath(LambModel lamb, String dateNaissance) async {
    var navigationResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MortPage(lamb)),
    );
    print (navigationResult);
  }

}
