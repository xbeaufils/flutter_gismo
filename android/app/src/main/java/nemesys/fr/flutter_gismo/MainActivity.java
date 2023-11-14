package nemesys.fr.flutter_gismo;


import android.Manifest;
import android.bluetooth.BluetoothDevice;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.sentry.Sentry;

public class MainActivity extends FlutterActivity  implements  MethodChannel.MethodCallHandler, PluginRegistry.PluginRegistrantCallback{
    private static final String CHANNEL_RT610 = "nemesys.rfid.RT610";
    private static final String CHANNEL_GPS = "nemesys.GPS";
    private static final String CHANNEL_BLUETOOTH = "nemesys.rfid.bluetooth";

    public Context context;
    public String TAG = "MAinActivity";
    public String id;
    public String nation;
    public String boucle;
    public String marquage;
    private volatile boolean newValue;
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
                newValue = false;
                int tentative = 0;
                while (! newValue && tentative<5  ) {
                    Thread.sleep(1000);
                    tentative++;
                }
                result.success("Waiting data");
            } catch (InterruptedException e2) {
                e2.printStackTrace();
                Sentry.captureException(e2);
            }
        } else if (call.method.contentEquals("data")) {
            Log.d(TAG, "onMethodCall: data");
            try {
                JSONObject jSONObject = new JSONObject();
                jSONObject.put("id", id);
                jSONObject.put("nation", nation);
                jSONObject.put("boucle", boucle);
                jSONObject.put("marquage", marquage);
                Log.d(TAG, "onMethodCall: obj " + jSONObject.toString());
                result.success(jSONObject.toString());
            }
            catch (JSONException e) {
                result.error("JSON", "Exception JSON", "Exception JSON");
                Sentry.captureException(e);
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
                Sentry.captureException(e3);
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
        new LocationMethod(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL_GPS, this.getContext());
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
                newValue = true;
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

    public class MethodChannelHdlBlueTooth implements   MethodChannel.MethodCallHandler {

        BluetoothConnect bluetoothConnect;
        BluetoothReader reader;

        public MethodChannelHdlBlueTooth() {
            Log.d(TAG, "MethodChannelHdlBlueTooth: constructor");
        }

        @Override
        public void onMethodCall(MethodCall call, MethodChannel.Result result) {
            if (this.isConnected())
                stateBluetooth =  State.CONNECTED;
            else
                stateBluetooth = State.NONE;
            if (call.method.contentEquals("stateBlueTooth")) {
                result.success("{\"connect\" : \"" +stateBluetooth + "\", \"data\" : \"" + stateData + "\"}");
            }
            else if (call.method.contentEquals("connectBlueTooth")) {
                String address = (String) call.argument("address");
                BluetoothHandler handler = new BluetoothHandler();
                bluetoothConnect = new BluetoothConnect(address, handler);
                bluetoothConnect.start();
                result.success("{ \"status\" : \"CONNECTING\"}");
            }
            else if (call.method.contentEquals("readBlueTooth")) {
                if (bluetoothConnect == null) {
                    Log.d(TAG, "onMethodCall: bluetoothConnect is null");
                    result.success("{ \"status\" : \"NONE\"}");
                }
                else if (bluetoothConnect.getSocket() == null) {
                    Log.d(TAG, "onMethodCall: socket is null");
                    result.success("{ \"status\" : \"NONE\"}");
                }
                else {
                    if (bluetoothConnect.getSocket().isConnected()) {
                        BluetoothHandler handler = new BluetoothHandler();
                        reader = new BluetoothReader(bluetoothConnect.getSocket(), handler);
                        reader.start();
                        stateData = DataState.WAITING;
                        result.success("{ \"status\" : \"STARTED\"}");
                    } else {
                        Log.d(TAG, "onMethodCall: socket is not connected");
                        result.success("{ \"status\" : \"NONE\"}");
                    }

                }
             }
            else if (call.method.contentEquals("dataBlueTooth")) {
                switch (stateData) {
                    case  AVAILABLE :
                        result.success("{\"status\": \"AVAILABLE\", \"data\" : \"" + dataBluetoooth + "\"}");
                        stateData = DataState.WAITING;
                        break;
                    case WAITING:
                        result.success("{\"status\": \"WAITING\"}");
                        stateData = DataState.WAITING;
                        break;
                    case ERROR:
                        result.error("Error", "Error", "Error");
                         break;
                    case NONE:
                        result.success("{\"status\": \"NONE\"}");
                        stateData = DataState.NONE;
                        break;
                }

            }
            else if (call.method.contentEquals("stopBlueTooth")) {
                if (this.bluetoothConnect != null)
                    this.bluetoothConnect.cancel();
                stateBluetooth = State.NONE;
            }
            else if (call.method.contentEquals("stopReadBlueTooth")){
                if (this.reader != null)
                    this.reader.cancel();
            }
            else if (call.method.contentEquals("listBlueTooth")) {
                if (ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_DENIED)
                {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
                    {
                        ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.BLUETOOTH_CONNECT}, 2);
                        return;
                    }
                }
                if (ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_DENIED)
                {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
                    {
                        ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.BLUETOOTH_SCAN}, 2);
                        return;
                    }
                }
                BluetoothSerial bluetooth = new BluetoothSerial(null);
                List<BluetoothDevice> devices = bluetooth.getBondedDevices();
                JSONArray devicesJson = new JSONArray();
                boolean checkConnection = BluetoothConnect.checkState(bluetoothConnect);
                for (BluetoothDevice device : devices) {
                    boolean connected = false;
                    if (checkConnection && bluetoothConnect.deviceName.equalsIgnoreCase(device.getName())) {
                        connected = true;
                        stateBluetooth = State.CONNECTED;
                    }
                    try {
                        JSONObject deviceJson = new JSONObject();
                        deviceJson.put("address", device.getAddress());
                        deviceJson.put("name", device.getName());
                        deviceJson.put("connected", connected);
                        devicesJson.put(deviceJson);
                    }
                    catch (JSONException e) {
                        Sentry.captureException(e);
                    }
                }
                result.success(devicesJson.toString());
            }
        }

        private boolean isConnected() {
            if (bluetoothConnect == null) {
                Log.d(TAG, "onMethodCall: bluetoothConnect is null");
                return false;
            }
            if (bluetoothConnect.getSocket() == null) {
                Log.d(TAG, "onMethodCall: socket is null");
                return false;
            }
            return bluetoothConnect.getSocket().isConnected();
        }
    }


    public enum State {
        NONE,
        LISTEN,
        CONNECTING,
        CONNECTED,
        ERROR;

        public static State getEnum(int i ) {
            for (State state : State.values()) {
                if (state.ordinal() == i)
                    return state;
            }
            throw new UnsupportedOperationException();
        }
    }

    public enum  DataState {
        NONE,
        WAITING,
        ERROR,
        AVAILABLE;

        public static DataState getEnum(int i ) {
            for (DataState state : DataState.values()) {
                if (state.ordinal() == i)
                    return state;
            }
            throw new UnsupportedOperationException();
        }
    }

    String dataBluetoooth;
    State stateBluetooth = State.NONE;
    DataState stateData = DataState.NONE;

    public class BluetoothHandler extends Handler {
        public BluetoothHandler() {
            super();
        }

        @Override
        public void handleMessage(Message msg) {
            BluetoothMessage message = BluetoothMessage.getEnum(msg.what);
            switch (message) {
                case STATE_CHANGE:
                    stateBluetooth = State.getEnum(msg.arg1);
                    Log.i(TAG, "MESSAGE_STATE_CHANGE: " + stateBluetooth);
                    break;
                case DATA_CHANGE:
                    stateData = DataState.getEnum( (Integer) msg.obj);
                case READ:
                    dataBluetoooth = (String) msg.obj;
                    Log.d(TAG, "handleMessage: data " + dataBluetoooth);
                    stateData = DataState.AVAILABLE;
 //                   MainActivity.this.latch.countDown();
 //                   Log.d(TAG, "handleMessage: countDown = " + MainActivity.this.latch.getCount());
                    break;
                case ERROR:
                    Log.d(TAG, "handleMessage: MESSAGE_TOAST");
                    stateData = DataState.ERROR;
                    Bundle bundle = msg.getData();
                    String errorMessage = bundle.getString("TOAST");
                    return;
                default:
                    Log.d(TAG, "handleMessage: Unknown " + msg.what);
                    return;
            }
        }
    }
 }
