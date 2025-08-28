package nemesys.fr.flutter_gismo;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.ParcelUuid;
import android.util.Log;

import androidx.annotation.RequiresPermission;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicBoolean;

import io.sentry.Sentry;

public class BluetoothConnect extends  Thread{
    private final static String TAG = "gismo::BluetoothConnect" ;
    private String address;
    private Handler handlerStatus;
    public final BluetoothAdapter mAdapter = BluetoothAdapter.getDefaultAdapter();
    public String deviceName;

    BluetoothReader reader;
    private BluetoothDevice mmDevice;

    public BluetoothSocket getSocket() {
        return mmSocket;
    }

    private BluetoothSocket mmSocket;

    @RequiresPermission(allOf = {Manifest.permission.BLUETOOTH_CONNECT, Manifest.permission.BLUETOOTH_SCAN})
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
             if (reader != null)
                reader.cancel();
        } catch (Exception e) {
            Log.e(BluetoothConnect.TAG, "Erreur cancel", e);
            Sentry.captureException(e);
        }      //latch.countDown();
    }

    @RequiresPermission(allOf = {Manifest.permission.BLUETOOTH_CONNECT, Manifest.permission.BLUETOOTH_SCAN})
    public void connect() {
         this.mmSocket = null;
        try {
            /*
             ParcelUuid [] uuids = mmDevice.getUuids();
             for (int i =0; i< uuids.length; i++)
                Log.d(BluetoothConnect.TAG, "UUID " + uuids[i]);*/
             this.mmSocket  = mmDevice.createRfcommSocketToServiceRecord( BluetoothSerial.UUID_SPP);
             //this.mmSocket  = mmDevice.createInsecureRfcommSocketToServiceRecord( BluetoothSerial.UUID_SPP);
        } catch (IOException e) {
             this.mmSocket = null;
            Log.e(BluetoothConnect.TAG, "Socket create() failed", e);
            Sentry.captureException(e);
        }
        //}
        if (this.mmSocket == null) {
            Log.d(BluetoothConnect.TAG, "Socket is null");
            handlerStatus.obtainMessage(BluetoothMessage.STATE_CHANGE.ordinal(), MainActivity.State.NONE.ordinal()).sendToTarget();
            //stateBluetooth = MainActivity.State.NONE;
            return;
        }
        try {
            this.mAdapter.cancelDiscovery();
            Log.i(BluetoothConnect.TAG, "Connecting to socket...");
            Log.i(BluetoothConnect.TAG, "Socket already connected ..." + this.mmSocket.isConnected());
            this.mmSocket.connect();
            Log.i(BluetoothConnect.TAG, "Connected");
            handlerStatus.obtainMessage(BluetoothMessage.STATE_CHANGE.ordinal(), MainActivity.State.CONNECTED.ordinal(), -1, null).sendToTarget();
            //stateBluetooth = MainActivity.State.CONNECTED;
        } catch (IOException e) {
            Log.e(BluetoothConnect.TAG, "Connection failed", e);
            Sentry.captureException(e);
            handlerStatus.obtainMessage(BluetoothMessage.STATE_CHANGE.ordinal(), MainActivity.State.ERROR.ordinal(), -1, null).sendToTarget();
        }
    }

    @Override
    @RequiresPermission(allOf = {Manifest.permission.BLUETOOTH_CONNECT, Manifest.permission.BLUETOOTH_SCAN})
    public void run() {
        Log.d(BluetoothConnect.TAG, "debut");
        handlerStatus.obtainMessage(BluetoothMessage.STATE_CHANGE.ordinal(), MainActivity.State.CONNECTING.ordinal(), -1, null).sendToTarget();
        this.connect();
        Log.d(BluetoothConnect.TAG, "End ");
    }

    @RequiresPermission(allOf = {Manifest.permission.BLUETOOTH_CONNECT, Manifest.permission.BLUETOOTH_SCAN})
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
