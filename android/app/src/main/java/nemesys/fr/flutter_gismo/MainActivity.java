package nemesys.fr.flutter_gismo;


import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.util.Log;

import androidx.annotation.NonNull;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.CountDownLatch;

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
        //BluetoothHandlerThread btHandlerThread = new BluetoothHandlerThread("bluetooth");
        HandlerThread  btHandlerThread = new HandlerThread("bluetoothConnect");
        HandlerThread  btReadHandlerThread = new HandlerThread("bluetoothRead");

        BluetoothRun runBluetooth;
        BluetoothConnect bluetoothConnect;
        BluetoothReader reader;

        public MethodChannelHdlBlueTooth() {
            //this.btHandlerThread = new BluetoothHandlerThread("bluetooth");
            this.btHandlerThread.start();
            this.btReadHandlerThread.start();
        }

        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if (call.method.contentEquals("connectBlueTooth")) {
                String address = (String) call.argument("address");
                // BluetoothHandler handler = new BluetoothHandler(btHandlerThread.getLooper());
                BluetoothHandler handler = new BluetoothHandler();
                bluetoothConnect = new BluetoothConnect(address, handler);
                bluetoothConnect.start();
                //handler.post(bluetoothConnect);
                result.success("{ \"status\" : \"STARTED\"}");
            }
            else if (call.method.contentEquals("readBlueTooth")) {
                if (bluetoothConnect == null)
                    result.success("{ \"status\" : \"NONE\"}");
                else if (bluetoothConnect.getSocket() == null)
                    result.success("{ \"status\" : \"NONE\"}");
                else {
                    if (bluetoothConnect.getSocket().isConnected()) {
                        //BluetoothHandler handler = new BluetoothHandler(btReadHandlerThread.getLooper());
                        BluetoothHandler handler = new BluetoothHandler();
                        reader = new BluetoothReader(bluetoothConnect.getSocket(), handler);
                        reader.start();
                        //runBluetooth = new BluetoothRun(address, handler);
                        //handler.post(reader);
                        result.success("{ \"status\" : \"STARTED\"}");
                    } else result.success("{ \"status\" : \"NONE\"}");

                }
                //address = "08:DF:1F:A8:3D:7E";
            }
            else if (call.method.contentEquals("dataBlueTooth")) {
                switch (stateData) {
                    case  AVAILABLE :
                        result.success("{\"status\": \"AVAILABLE\", \"data\" : \"" + dataBluetoooth + "\"}");
                        stateData = DataState.NONE;
                        //btHandlerThread.quit();
                        break;
                    case WAITING:
                        result.success("{\"status\": \"WAITING\"}");
                        break;
                    case ERROR:
                        result.error("Error", "Error", "Error");
                        //btHandlerThread.quit();
                        break;
                    case NONE:
                        result.success("{\"status\": \"NONE\"}");
                        //btHandlerThread.quit();
                        break;
                }

            }
            else if (call.method.contentEquals("stopBlueTooth")) {
                if (this.bluetoothConnect != null)
                    this.bluetoothConnect.cancel();
                /*
                if (this.runBluetooth != null)
                    this.runBluetooth.cancel();
                 */
            }
            else if (call.method.contentEquals("stopReadBlueTooth")){
                if (this.reader != null)
                    this.reader.cancel();
            }
            else if (call.method.contentEquals("listBlueTooth")) {
                BluetoothSerial bluetooth = new BluetoothSerial(null);
                List<BluetoothDevice> devices = bluetooth.getBondedDevices();
                JSONArray devicesJson = new JSONArray();
                for (BluetoothDevice device : devices) {
                    try {
                        JSONObject deviceJson = new JSONObject();
                        deviceJson.put("address", device.getAddress());
                        deviceJson.put("name", device.getName());
                        devicesJson.put(deviceJson);
                    }
                    catch (JSONException e) {
                        Sentry.captureException(e);
                    }
                }
                result.success(devicesJson.toString());
            }
        }
    }

    public enum State {
        NONE,
        LISTEN,
        CONNECTING,
        CONNECTED;

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

    CountDownLatch latch;
    String dataBluetoooth;
    State stateBluetooth;
    DataState stateData = DataState.NONE;

    public class BluetoothHandlerThread extends HandlerThread {


        public BluetoothHandlerThread(String name) {
            super(name);
        }

        @Override
        public boolean quit() {
            return super.quit();
        }

        @Override
        protected void onLooperPrepared() {
            //initHandler();
        }

    }

    public class BluetoothRun extends  Thread {

        private final static String TAG = "BluetoothRun" ;
        private String address;
        private Handler handler;
        private BluetoothSerial bluetooth;
        public final BluetoothAdapter mAdapter = BluetoothAdapter.getDefaultAdapter();
        public String deviceName;

        BluetoothReader reader;
        private BluetoothDevice mmDevice;
        private BluetoothSocket mmSocket;

        public BluetoothRun(String address, Handler handler) {
            this.address = address;
            this.handler = handler;
            mmDevice = this.mAdapter.getRemoteDevice(address);
            this.deviceName = mmDevice.getName();
        }

        public void cancel() {
            if (reader != null)
                reader.cancel();
            //latch.countDown();
        }

        public void connect() {
            BluetoothSocket tmp = null;
            try {
                tmp = mmDevice.createRfcommSocketToServiceRecord( BluetoothSerial.UUID_SPP);
            } catch (IOException e) {
                Log.e(BluetoothRun.TAG, "Socket create() failed", e);
                Sentry.captureException(e);
            }
            //}
            this.mmSocket = tmp;
            if (this.mmSocket == null) {
                stateBluetooth = MainActivity.State.NONE;
                return;
            }
            this.mAdapter.cancelDiscovery();
            try {
                Log.i(BluetoothRun.TAG, "Connecting to socket...");
                this.mmSocket.connect();
                Log.i(BluetoothRun.TAG, "Connected");
                stateBluetooth = MainActivity.State.CONNECTED;
            } catch (IOException e) {
                Log.e(BluetoothRun.TAG, e.toString());
                Sentry.captureException(e);
            }
        }

        @Override
        public void run() {
            Log.d("BluetoothRun", "debut");
            MainActivity.this.latch = new CountDownLatch(1);
            stateData = DataState.WAITING;
            this.connect();
            boolean completed = false;
            try {
                HandlerThread  btHandlerThread = new HandlerThread("read");
                btHandlerThread.start();
                BluetoothHandler handler = new BluetoothHandler(btHandlerThread.getLooper());
                reader = new BluetoothReader(this.mmSocket, handler);
                handler.post(reader);
                latch.await();//10, TimeUnit.SECONDS);
//                Log.d(TAG, "run: Wait end " + LocalTime.now().toString());
            } catch (Exception e) {
                e.printStackTrace();
                completed  = false;
                Sentry.captureException(e);
            }
            Log.d("BluetoothRun", "End : completed = " + completed);
            //if (completed)
            //    dataState = DataState.AVAILABLE;
            //else
                stateData = DataState.NONE;
        }
    }


    public class BluetoothHandler extends Handler {
        public BluetoothHandler(Looper looper) {
            super(looper);
        }
        public BluetoothHandler() {
            super();
        }

        //= new Handler(getLooper()) {
        @Override
        public void handleMessage(Message msg) {
            BluetoothMessage message = BluetoothMessage.getEnum(msg.what);
            switch (message) {
                case STATE_CHANGE:
                    Log.i(TAG, "MESSAGE_STATE_CHANGE: " + msg.arg1);
                    stateBluetooth = State.getEnum(msg.arg1);
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

    public class DataHandler extends  Handler {
        @Override
        public void handleMessage(Message msg) {
            DataState curentState = DataState.getEnum(msg.what);
            switch (curentState) {
                case AVAILABLE:
                    stateBluetooth = State.CONNECTED;
                    break;
                case WAITING:
                    stateBluetooth = State.CONNECTING;
                    break;
                case NONE:
                    stateBluetooth = State.NONE;
                    break;
                case ERROR:
                    stateBluetooth = State.LISTEN;
                    break;
                default:
            }
        }
    }
 }
