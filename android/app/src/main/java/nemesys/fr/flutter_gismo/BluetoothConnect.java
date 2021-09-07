package nemesys.fr.flutter_gismo;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.os.Handler;
import android.os.HandlerThread;
import android.util.Log;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicBoolean;

import io.sentry.Sentry;

public class BluetoothConnect extends  Thread{
    private final static String TAG = "BluetoothConnect" ;
    private String address;
    private Handler handlerStatus;
    public final BluetoothAdapter mAdapter = BluetoothAdapter.getDefaultAdapter();
    public String deviceName;
    private AtomicBoolean connecting = new AtomicBoolean(true);

    BluetoothReader reader;
    private BluetoothDevice mmDevice;
    private BluetoothSocket mmSocket;

    public BluetoothConnect(String address, Handler handlerStatus) {
        this.address = address;
        this.handlerStatus = handlerStatus;
        mmDevice = this.mAdapter.getRemoteDevice(address);
        this.deviceName = mmDevice.getName();
    }

    public void cancel() {
        this.connecting.set(false);
        if (reader != null)
            reader.cancel();
        //latch.countDown();
    }

    public void connect() {
        BluetoothSocket tmp = null;
        try {
            tmp = mmDevice.createRfcommSocketToServiceRecord( BluetoothSerial.UUID_SPP);
        } catch (IOException e) {
            Log.e(BluetoothConnect.TAG, "Socket create() failed", e);
            Sentry.captureException(e);
        }
        //}
        this.mmSocket = tmp;
        if (this.mmSocket == null) {
            handlerStatus.obtainMessage(BluetoothMessage.STATE_CHANGE.ordinal(), MainActivity.State.NONE.ordinal()).sendToTarget();
            //stateBluetooth = MainActivity.State.NONE;
            return;
        }
        this.mAdapter.cancelDiscovery();
        try {
            Log.i(BluetoothConnect.TAG, "Connecting to socket...");
            this.mmSocket.connect();
            Log.i(BluetoothConnect.TAG, "Connected");
            handlerStatus.obtainMessage(BluetoothMessage.STATE_CHANGE.ordinal(), MainActivity.State.CONNECTED.ordinal()).sendToTarget();
            //stateBluetooth = MainActivity.State.CONNECTED;
        } catch (IOException e) {
            Log.e(BluetoothConnect.TAG, e.toString());
            Sentry.captureException(e);
        }
    }

    @Override
    public void run() {
        Log.d("BluetoothRun", "debut");
        //MainActivity.this.latch = new CountDownLatch(1);
        handlerStatus.obtainMessage(BluetoothMessage.DATA_CHANGE.ordinal(), MainActivity.DataState.WAITING.ordinal()).sendToTarget();
        //dataState = MainActivity.DataState.WAITING;
        boolean completed = false;
        while (connecting.get()) {
            CountDownLatch latch = new CountDownLatch(1);
            this.connect();
            try {
                HandlerThread btHandlerThread = new HandlerThread("read");
                btHandlerThread.start();
                MainActivity.BluetoothHandler handler = new MainActivity.BluetoothHandler(btHandlerThread.getLooper());
                reader = new BluetoothReader(this.mmSocket, handler);
                handler.post(reader);
                latch.await();//10, TimeUnit.SECONDS);
//                Log.d(TAG, "run: Wait end " + LocalTime.now().toString());
            } catch (Exception e) {
                e.printStackTrace();
                completed = false;
                Sentry.captureException(e);
            }
        }
        Log.d(BluetoothConnect.TAG, "End : completed = " + completed);
        //if (completed)
        //    dataState = DataState.AVAILABLE;
        //else
        handlerStatus.obtainMessage(BluetoothMessage.DATA_CHANGE.ordinal(), MainActivity.DataState.NONE.ordinal()).sendToTarget();
        //dataState = MainActivity.DataState.NONE;
    }

    public List<BluetoothDevice> getBondedDevices() {
        Set<BluetoothDevice> bondedDevices = BluetoothAdapter.getDefaultAdapter().getBondedDevices();
        List<BluetoothDevice> lstDevices = new ArrayList<>(bondedDevices);
        return lstDevices;
    }

}
