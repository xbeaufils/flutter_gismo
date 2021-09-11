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

    public BluetoothSocket getSocket() {
        return mmSocket;
    }

    private BluetoothSocket mmSocket;

    public BluetoothConnect(String address, Handler handlerStatus) {
        this.address = address;
        this.handlerStatus = handlerStatus;
        mmDevice = this.mAdapter.getRemoteDevice(address);
        Log.d(TAG, "Connect: " + mmDevice.getName());
        this.deviceName = mmDevice.getName();
    }

    public void cancel() {
        try {
            if (this.mmSocket != null)
                this.mmSocket.close();
            this.connecting.set(false);
            if (reader != null)
                reader.cancel();
        } catch (Exception e) {
            e.printStackTrace();
            Sentry.captureException(e);
        }      //latch.countDown();
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
            Log.d(BluetoothConnect.TAG, "Socket is null");
            handlerStatus.obtainMessage(BluetoothMessage.STATE_CHANGE.ordinal(), MainActivity.State.NONE.ordinal()).sendToTarget();
            //stateBluetooth = MainActivity.State.NONE;
            return;
        }
        this.mAdapter.cancelDiscovery();
        try {
            Log.i(BluetoothConnect.TAG, "Connecting to socket...");
            this.mmSocket.connect();
            Log.i(BluetoothConnect.TAG, "Connected");
            handlerStatus.obtainMessage(BluetoothMessage.STATE_CHANGE.ordinal(), MainActivity.State.CONNECTED.ordinal(), -1, null).sendToTarget();
            //stateBluetooth = MainActivity.State.CONNECTED;
        } catch (IOException e) {
            Log.e(BluetoothConnect.TAG, e.toString());
            Sentry.captureException(e);
        }
    }

    @Override
    public void run() {
        Log.d(BluetoothConnect.TAG, "debut");
        this.connect();
        Log.d(BluetoothConnect.TAG, "End ");
    }

    public List<BluetoothDevice> getBondedDevices() {
        Set<BluetoothDevice> bondedDevices = BluetoothAdapter.getDefaultAdapter().getBondedDevices();
        List<BluetoothDevice> lstDevices = new ArrayList<>(bondedDevices);
        return lstDevices;
    }

    public static boolean checkState(BluetoothConnect connection) {
        if (connection != null)
            if (connection.getSocket() != null)
                return connection.getSocket().isConnected();
        return false;
    }
}
