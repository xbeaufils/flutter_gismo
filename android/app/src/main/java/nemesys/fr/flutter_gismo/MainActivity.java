package nemesys.fr.flutter_gismo;


import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity  implements  MethodChannel.MethodCallHandler, PluginRegistry.PluginRegistrantCallback{
    private static final String CHANNEL_RT610 = "nemesys.rfid.RT610";
    private static final String CHANNEL_BLUETOOTH = "nemesys.rfid.bluetooth";

    public Context context;
    public String TAG = "MAinActivity";
    public String id;
    public String nation;
    public String boucle;
    public String marquage;
    public BroadcastReceiver receiver = new RFIDReceiver();

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        ComponentName componentName;
        Log.d(TAG, "onMethodCall: " + call.method);
        if (call.method.contentEquals("startRead")) {
            Intent intent = new Intent();
            intent.setAction("nemesys.rfid.LF134.read");
            context.sendBroadcast(intent);
            try {
                Thread.sleep(2000);
                JSONObject jSONObject = new JSONObject();
                jSONObject.put("id", id);
                jSONObject.put("nation", nation);
                jSONObject.put("boucle", boucle);
                jSONObject.put("marquage", marquage);
                Log.d(TAG, "onMethodCall: obj " + jSONObject.toString());
                result.success(jSONObject.toString());
            } catch (InterruptedException | JSONException e2) {
                e2.printStackTrace();
            }
        } else if (call.method.contentEquals("start")) {
            try {
                Intent intent2 = new Intent();
                intent2.setComponent(new ComponentName("fr.nemesys.service.rfid", "fr.nemesys.service.rfid.RFIDService"));
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O ) {
                    Log.d(TAG, "Build version " + Build.VERSION.SDK_INT + " " + 26);
                    componentName = context.startForegroundService(intent2);
                } else {
                    componentName = context.startService(intent2);
                }
                if (componentName != null) {
                    result.success("start");
                    Log.d(TAG, "onMethodCall: service should be started");
                } else {
                    result.success("No service");
                }
            } catch (Exception e3) {
                e3.printStackTrace();
                Log.e(TAG, "onMethodCall: ", e3);
                result.error("Start failed", "Start failed","Start failed");
            }
            Log.d(TAG, "onMethodCall: end start");
        } else if (call.method.contentEquals("stopRead") || call.method.equals("stop")) {
            Intent intent3 = new Intent();
            intent3.setComponent(new ComponentName("fr.nemesys.service.rfid", "fr.nemesys.service.rfid.RFIDService"));
            context.stopService(intent3);
        }

    }

    @Override
    public void onCreate(Bundle  bundle) {
        super.onCreate(bundle);
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL_RT610)
                .setMethodCallHandler(this::onMethodCall);
        new MethodChannelBlueTooth(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL_BLUETOOTH);
        Intent intent = getIntent();
        intent.getAction();
        intent.getType();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("nemesys.rfid.LF134.result");
        registerReceiver(this.receiver, intentFilter);
        this.context = this.getContext();
    }

    public void onDestroy() {
        super.onDestroy();
        if (receiver != null) {
            unregisterReceiver(receiver);
        }
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith((FlutterEngine) registry);
    }

    public class RFIDReceiver extends BroadcastReceiver {
        public RFIDReceiver() {
        }

        public void onReceive(Context context, Intent intent) {
            Bundle extras;
            String action = intent.getAction();
            Log.d("boucleReceiver", "action " + action);
            if (action.equals("nemesys.rfid.LF134.result") && (extras = intent.getExtras()) != null) {
                id = extras.getString("id");
                nation = extras.getString("nation");
                boucle = extras.getString("boucle");
                marquage = extras.getString("marquage");
                Log.d("boucleReceiver", "id " + id + " boucle " + boucle + " marquage " + marquage);
            }
        }
    }

    public class MethodChannelBlueTooth extends  MethodChannel {

        public MethodChannelBlueTooth(BinaryMessenger messenger, String name) {
            super(messenger, name);
            this.setMethodCallHandler(new MethodChannelHdlBlueTooth());
        }

    }

    public class MethodChannelHdlBlueTooth implements  MethodChannel.MethodCallHandler {

        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if (call.method.contentEquals("readBlueTooth")) {
                final String address = call.argument("address");
                Message msg = Message.obtain(null, 3, address);
                msg.replyTo = replyMessenger;
                try {
                    mService.send(msg);
                    Thread.sleep(2000);
                    JSONObject jSONObject = new JSONObject();
                    jSONObject.put("id", id);
                    jSONObject.put("nation", nation);
                    jSONObject.put("boucle", boucle);
                    jSONObject.put("marquage", marquage);
                    Log.d(TAG, "onMethodCall: obj " + jSONObject.toString());
                    result.success(jSONObject.toString());
                } catch (InterruptedException | JSONException | RemoteException e2) {
                    e2.printStackTrace();
                }
            }
        }
    }

    Messenger mService = null;
    boolean mBound = false;
    String bluetoothData = null;

    /**
     * Defines callbacks for service binding, passed to bindService()
     */
    private ServiceConnection mConnection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName className,
                                       IBinder service) {

            Toast.makeText(MainActivity.this, "connected to service", Toast.LENGTH_SHORT).show();
            mService = new Messenger(service);
            mBound = true;
            Message msg = Message.obtain(null, 10);
            msg.replyTo = replyMessenger;
            try {
                mService.send(msg);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName arg0) {
            mService = null;
            mBound = false;
        }
    };

    Messenger replyMessenger = new Messenger(new HandlerReplyMsg());

    // handler for message from service
    class HandlerReplyMsg extends Handler {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            Log.d(TAG, "HandlerReplyMsg: " + msg );
            /*if (msg.what == BluetoothSerialService.MESSAGE_LOG) {
                txtLog.append(msg.obj.toString() + "\n");
            }
            else if (msg.what == BluetoothSerialService.MESSAGE_TOAST) {
                Toast.makeText(MainActivity.this,  msg.getData().getString(BluetoothSerialService.TOAST), Toast.LENGTH_LONG).show();
            }
            else*/
            if (msg.what ==2) {
                MainActivity.this.bluetoothData = msg.obj.toString();
                //txtRecep.append("READ:" + recdMessage + "\n");
            }
            else if (msg.what == 6) {
                MainActivity.this.bluetoothData = msg.getData().getString("StringData") + "\n";
                //txtRecep.append("READ_RAW:" + msg.getData().getString("hexData") + "\n");
            }
           }
    }
 }
