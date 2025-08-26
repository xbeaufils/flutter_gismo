import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/individu/ui/EventPage.dart';
import 'package:flutter_gismo/individu/ui/TimeLine.dart';
import 'package:flutter_gismo/lamb/presenter/LambPresenter.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:intl/intl.dart';

class LambTimeLinePage extends StatefulWidget {
  final CompleteLambModel _lamb;

  CompleteLambModel get lamb => _lamb;

  LambTimeLinePage(this._lamb, {Key ? key}) : super(key: key);
  @override
  LambTimeLinePageState createState() => new LambTimeLinePageState();
}

abstract class LambTimelineContract extends  TimelineContract {
  CompleteLambModel get lamb;
}

class LambTimeLinePageState extends GismoStatePage<LambTimeLinePage> with SingleTickerProviderStateMixin implements LambTimelineContract {
  late LambTimeLinePresenter _presenter;

  @override
  Future<String?> editPage(StatefulWidget page) async {
    String ? message = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).lambs),
        actions: _getActionButton(),
      ),
      body:
      Column (
        children: <Widget>[
          Card(child:
            ListTile(
              title: Text(lamb.marquageProvisoire!),
               subtitle: (lamb.dateAgnelage!= null) ? Text( DateFormat.yMd().format(lamb.dateAgnelage)): null,
              leading: Image.asset("assets/lamb.png") ,
              trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () => this._presenter.view(lamb), ),)
              ,),
          Card(child:
            ListTile(
              leading: Image.asset("assets/sheep_lamb.png"),
              title: Text(lamb.numBoucleMere + " " + lamb.numMarquageMere),
          )),

          Expanded(child: _getEvents()),
        ],),
    );

  }
  List<Widget> _getActionButton() {
    List <Widget> actionButtons = [];
    if (this.widget._lamb == null)
      actionButtons.add(Container());
    else {
      if (this.widget._lamb.sante != Sante.VIVANT)
        actionButtons.add(Container());
      else {
        if (this.widget._lamb!.dateDeces != null ||
            this.widget._lamb!.numBoucle != null)
          actionButtons.add(Container());
        else {
          actionButtons.add(
            IconButton(
              icon: Image.asset("assets/peseur.png"),
              onPressed: () {
                this._presenter.peser(this.widget._lamb!);
              },),);
          actionButtons.add(
            IconButton(
              icon: Image.asset("assets/syringe.png"),
              onPressed: () {
                this._presenter.traitement(this.widget._lamb!);
              },),);
          actionButtons.add(
            IconButton(
              icon: Image.asset("assets/tomb.png"),
              onPressed: () {
                this._presenter.mort(this.widget._lamb!);
              },),);
          actionButtons.add(
              IconButton(
                icon: Image.asset("assets/bouclage.png"),
                onPressed: () {
                  this._presenter.boucle(this.widget._lamb!);
                },));
        }
      }
    }
    return actionButtons;
  }

  Widget _getEvents() {
    return EventLambPage(this, this.widget._lamb);
  }


  @override
  void initState() {
    super.initState();
    this._presenter  = LambTimeLinePresenter(this);
  }

  CompleteLambModel get lamb => this.widget._lamb;
}