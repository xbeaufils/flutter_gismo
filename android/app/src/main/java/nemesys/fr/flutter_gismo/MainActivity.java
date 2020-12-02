package nemesys.fr.flutter_gismo;


import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "nemesys.rfid.LF134";
    String id;
    private BroadcastReceiver myRFIDReceiver = new RFIDReceiver();


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    /*
    @Override
    public void configureFlutterEngine( FlutterEngine flutterEngine) {
        Log.d("MainActivity", "configureFlutterEngine: ");
    */
    /*
        FlutterEngine flutterEngine = this.getFlutterEngine();
        GeneratedPluginRegistrant.registerWith(flutterEngine);
     */
        Intent intent = getIntent();
        String action = intent.getAction();
        String type = intent.getType();

        IntentFilter mFilter = new IntentFilter();
        mFilter.addAction("nemesys.rfid.LF134.result");

        super.registerReceiver(myRFIDReceiver, mFilter);
        this.handleSendText(intent);
        ;
    /*
        new MethodChannel( flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                    if (call.method.contentEquals("read")) {
                        Intent toRead = new Intent();
                        toRead.setAction("nemesys.rfid.LF134.read");
                        MainActivity.this.sendBroadcast(toRead);
                    }
                    else if (call.method.contentEquals("result")) {
                        result.success(id);
                        id = null;
                    }
                }
            });
     */
    }

    void handleSendText(Intent intent) {
        id = intent.getStringExtra("id");
        String nation = intent.getStringExtra("nation");
        String type = intent.getStringExtra("type");
        Log.d("boucleReceiver", "id " + id);
    }
    /*
        MethodChannel methodChannel = new MethodChannel(getFlutterView(), CHANNEL);
        RFIDReceiver receiver = new RFIDReceiver(methodChannel);
        IntentFilter mTime = new IntentFilter("nemesys.rfid.LF134.result");
        registerReceiver(receiver, mTime);
         */
 }
