class StatusBlueTooth {
  late String connect;
  //\" : \"" +stateBluetooth + "\", "
  late String data;
  //\" : \"" + stateData + "\"}");

  StatusBlueTooth.fromResult(result) {
    connect= result["connect"] ;
    data = result["data"];
  }

}