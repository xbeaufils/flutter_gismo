class BluetoothState {
  late String _status;
  late String _data;

  BluetoothState.fromResult(result) {
    _status = result["status"];
    _data = result["data"];
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }
}