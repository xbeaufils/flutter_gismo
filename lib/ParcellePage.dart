import 'dart:async';
import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ParcellePage extends StatefulWidget {
  ParcellePage({Key key}) : super(key: key);
  @override
  _ParcellePageState createState() => new _ParcellePageState();
}

class _ParcellePageState extends State<ParcellePage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  //LocationData _locationData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wikipedia Explorer'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      body: new FutureBuilder(
          future: _getLocation(),
          builder:  (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
            if (! snapshot.hasData)
              return Container();
            LocationData loc = snapshot.data;
            String url = "https://cadastre.data.gouv.fr/map?style=ortho#15/" +loc.latitude.toString() + "/"+loc.longitude.toString();
            debug.log("Location " + url);
            return WebView(
              debuggingEnabled: true,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: url,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            );
          }
            //floatingActionButton: _bookmarkButton(),
        )
    );
  }

  _bookmarkButton() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return FloatingActionButton(
            onPressed: () async {
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Saved for later reading.')),
              );
            },
            child: Icon(Icons.favorite),
          );
        }
        return Container();
      },
    );
  }

  @override
  void initState() {

  }


  Future<LocationData> _getLocation() async{
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    debug.log("Service enabled " + _serviceEnabled.toString(), name:"_ParcellePageState::_getLocation");
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    debug.log("permission Granted " + _permissionGranted.toString(), name:"_ParcellePageState::_getLocation");

    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return null;
      }
    }
    debug.log("permission  " + _permissionGranted.toString(), name:"_ParcellePageState::_getLocation");
    return location.getLocation();
  }


}