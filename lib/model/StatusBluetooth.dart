class StatusBlueTooth {
 static String CONNECTED="CONNECTED";

  late String connectionStatus;
  late String dataStatus;
  //\" : \"" +stateBluetooth + "\", "
  late String data;
  //\" : \"" + stateData + "\"}");

  StatusBlueTooth.fromResult(result) {
    connectionStatus= result["connectionStatus"] ;
    dataStatus= result["dataStatus"] ;
    if (result["data"] != null)
      data = result["data"];
  }

}