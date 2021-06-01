import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';

class BluetoothWidget extends StatefulWidget {

  final GismoBloc _bloc;
  String numBoucle;
  String numMarquage;
  BluetoothWidget(this._bloc);

  @override
  State createState() => new BluetoothWidgetPage();
}

class BluetoothWidgetPage extends State<BluetoothWidget> {
  String  _bluetoothState;

  @override
  Widget build(BuildContext context) {
    List<Widget> status = new List();
    switch (_bluetoothState) {
      case "NONE":
        status.add(Icon(Icons.bluetooth));
        status.add(Text("Non connecté"));
        break;
      case "WAITING":
        status.add(Icon(Icons.bluetooth));
        status.add(Expanded(child: LinearProgressIndicator(),));
        break;
      case "AVAILABLE":
        status.add(Icon(Icons.bluetooth));
        status.add(Text("Données reçues"));
    }
    return Row(children: status,);
  }

  @override
  void initState() {
    this.widget._bloc.streamBluetooth().listen(
    (BluetoothState event) {
      setState(() {
      _bluetoothState = event.status;
      if (event.status == 'AVAILABLE') {
        String _foundBoucle = event.data;
        this.widget.numBoucle = _foundBoucle.substring(_foundBoucle.length - 5);
        this.widget.numMarquage = _foundBoucle.substring(0, _foundBoucle.length - 5);
      }
  });
  });
  }

}