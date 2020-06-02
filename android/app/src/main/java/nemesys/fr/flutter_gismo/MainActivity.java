package nemesys.fr.flutter_gismo;

import android.os.Bundle;

//import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "serial.native/rts500";

  @Override
  public void configureFlutterEngine( FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    /*
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
              if (call.method.equals("powerManage")) {
                boolean deviceStatus = getDeviceStatus();

                String myMessage =  Boolean.toString(deviceStatus);
                result.success(myMessage);


              }

            });

     */
  }

}
