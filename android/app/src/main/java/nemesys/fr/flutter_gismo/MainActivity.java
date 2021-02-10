package nemesys.fr.flutter_gismo;


import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.util.Log;

import androidx.annotation.NonNull;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

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
    protected void onStart() {
        super.onStart();
        Intent intent = new Intent();
        //intent.setComponent(new ComponentName("fr.nemesys.allflex", "fr.nemesys.allflex.RFIDService"));
        intent.setClassName("fr.nemesys.allflex", "fr.nemesys.allflex.RFIDService");
        boolean launched = bindService(intent, mConnection, Context.BIND_AUTO_CREATE);
        Log.d(TAG, "onStart: " + launched);

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
        BluetoothSerial bluetooth = new BluetoothSerial(mHandler);

        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if (call.method.contentEquals("readBlueTooth")) {
                String address = (String) call.argument("address");
                //address = "08:DF:1F:A8:3D:7E";
                MainActivity.this.latch = new CountDownLatch(1);
                bluetooth.connect(address);
                try {
                    boolean completed  = latch.await(10, TimeUnit.SECONDS);
                    if (completed)
                        result.success(MainActivity.this.bluetoothData);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                result.error("Failed", "Pas de boucle lue", "Pas de boucle lue");
                /*Bundle bundleAdress = new Bundle();
                bundleAdress.putString("address", address);
                Message msg = Message.obtain(null, 3, bundleAdress);
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
                }*/
            } else if (call.method.contentEquals("listBlueTooth")) {
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
                result.success(devicesJson.toString());/*
                Message msg = Message.obtain(null, 10);
                msg.replyTo = replyMessenger;
                try {
                    devicelist = "";
                    latch = new CountDownLatch(1);
                    mService.send(msg);
                    latch.await(10, TimeUnit.SECONDS);
                    Log.d(TAG, "onMethodCall: send devices list "+devicelist);
                    result.success(devicelist);
                } catch (RemoteException | InterruptedException e) {
                    Log.e(TAG, "onServiceConnected: ",e );
                    e.printStackTrace();
                }*/
            }
        }
    }

    public enum State {
        NONE,
        LISTEN,
        CONNECTING,
        CONNECTED;
    }

    private final Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case BluetoothState.MESSAGE_STATE_CHANGE:
                    Log.i(TAG, "MESSAGE_STATE_CHANGE: " + msg.arg1);
                    switch (msg.arg1) {
                        case BluetoothState.STATE_NONE:
                            Log.i(TAG, "BluetoothSerialService.STATE_NONE");
                            stateBluetooth = State.NONE;
                            break;
                        case BluetoothState.STATE_LISTEN:
                            Log.i(TAG, "BluetoothSerialService.STATE_LISTEN");
                            stateBluetooth = State.LISTEN;
                            break;
                        case BluetoothState.STATE_CONNECTING:
                            stateBluetooth = State.CONNECTING;
                            Log.i(TAG, "BluetoothSerialService.STATE_CONNECTING");
                            break;
                        case BluetoothState.STATE_CONNECTED:
                            stateBluetooth = State.CONNECTED;
                            Log.i(TAG, "BluetoothSerialService.STATE_CONNECTED");
                            break;
                        default:
                            break;
                    }
                     break;
                case BluetoothState.MESSAGE_READ:
                    dataBluetoooth = (String) msg.obj;
                    MainActivity.this.latch.countDown();
                    break;
                case BluetoothState.MESSAGE_DEVICE_NAME:
                    Log.i(TAG, msg.getData().getString(BluetoothState.DEVICE_NAME));
                    return;
                /*case BluetoothState.MESSAGE_TOAST:
                    try {
                        notifyToast(msg);
                    } catch (RemoteException e) {
                        e.printStackTrace();
                        Sentry.captureException(e);
                    }
                    return;*/
                case BluetoothState.MESSAGE_READ_RAW:
                    dataBluetoooth = (String) msg.obj;
                    break;
               /*case BluetoothState.MESSAGE_LOG:
                    try {
                        sendLog(msg);
                    } catch (RemoteException e) {
                        e.printStackTrace();
                        Sentry.captureException(e);
                    }
                    break;*/
                default:
                    return;
            }
        }
    };

    Messenger mService = null;
    boolean mBound = false;
    String bluetoothData = null;
    CountDownLatch latch;
    String devicelist;
    String dataBluetoooth;
    State stateBluetooth;
    /**
     * Defines callbacks for service binding, passed to bindService()
     */
    private ServiceConnection mConnection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName className,
                                       IBinder service) {
            Log.i(TAG, "onServiceConnected: connected to service");
            mService = new Messenger(service);
            mBound = true;/*
            Message msg = Message.obtain(null, 10);
            msg.replyTo = replyMessenger;
            try {
                mService.send(msg);
            } catch (RemoteException e) {
                e.printStackTrace();
            }*/
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
            } else if (msg.what == 6) {
                MainActivity.this.bluetoothData = msg.getData().getString("StringData") + "\n";
                //txtRecep.append("READ_RAW:" + msg.getData().getString("hexData") + "\n");
            } else if (msg.what == 8) {
                Bundle bundleJson = (Bundle) msg.obj;
                MainActivity.this.devicelist = bundleJson.getString("devicelist");
                Log.d(TAG, "handleMessage: device list " + MainActivity.this.devicelist);
                MainActivity.this.latch.countDown();
            }

        }
    }

    private void showDevices() {

    }
 }
