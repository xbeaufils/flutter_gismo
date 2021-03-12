package nemesys.fr.flutter_gismo;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothClass;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothServerSocket;
import android.bluetooth.BluetoothSocket;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.Settings;
import android.util.Log;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import io.flutter.BuildConfig;
import io.sentry.Sentry;

public class BluetoothSerial {
    private static final boolean D = true;
    public static final String DEVICE_NAME = "device_name";
    public String deviceName;
    public static final String TOAST = "TOAST";
    private static final String NAME_INSECURE = "Gismo_insecure";
    private static final String NAME_SECURE = "Gismo_secure";

    public static final int STATE_CONNECTED = 3;
    public static final int STATE_CONNECTING = 2;
    public static final int STATE_LISTEN = 1;
    public static final int STATE_NONE = 0;

    public static final int MESSAGE_DEVICE_NAME = 4;
    public static final int MESSAGE_READ = 2;
    public static final int MESSAGE_READ_RAW = 6;
    public static final int MESSAGE_STATE_CHANGE = 1;
    public static final int MESSAGE_TOAST = 5;
    public static final int MESSAGE_WRITE = 3;
    public static final int MESSAGE_LOG= 7;
    public static final int MESSAGE_DEVICES = 8;

    private static final String TAG = "BluetoothSerialService";
    /* access modifiers changed from: private */
    public static final UUID UUID_SPP = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");
    /* access modifiers changed from: private */
    public final BluetoothAdapter mAdapter = BluetoothAdapter.getDefaultAdapter();
    /* access modifiers changed from: private */
    public ConnectThread mConnectThread;
    private ConnectedThread mConnectedThread;
    /* access modifiers changed from: private */
    public Handler mHandler;
    //private AcceptThread mInsecureAcceptThread;
    //private AcceptThread mSecureAcceptThread;
    /* access modifiers changed from: private */
    public int mState = 0;
    public boolean read = false;
    private BluetoothSocket mmSocket;

    public static final byte MAX_VALUE = -1;


    public BluetoothSerial(Handler handler) {
        this.mHandler = handler;
    }

    private synchronized void setState(int state) {
        Log.d(TAG, "setState() " + this.mState + " -> " + state);
        sendLog("[BluetoothSerial::connected] setState" );
        this.mState = state;
        this.mHandler.obtainMessage(MESSAGE_STATE_CHANGE, state, -1, this.deviceName ).sendToTarget();
    }

    public synchronized int getState() {
        return this.mState;
    }

    public synchronized void start() {
        Log.d(TAG, "start");
        if (this.mConnectThread != null) {
            this.mConnectThread.cancel();
            this.mConnectThread = null;
        }
        if (this.mConnectedThread != null) {
            this.mConnectedThread.cancel();
            this.mConnectedThread = null;
        }
        setState(STATE_NONE);
    }

    public synchronized  void connect(String address) {
        if (address != null) {
            BluetoothDevice device = this.mAdapter.getRemoteDevice(address);
            this.deviceName = device.getName();
            this.connect(device, false);
        }
    }

    public synchronized void connect(BluetoothDevice device, boolean secure) {
        Log.d(TAG, "connect to: " + device);
        sendLog("[BluetoothSerialService::connected] connect to: " + device);
        if (this.mState == 2 && this.mConnectThread != null) {
            this.mConnectThread.cancel();
            this.mConnectThread = null;
        }
        if (this.mConnectedThread != null) {
            this.mConnectedThread.cancel();
            this.mConnectedThread = null;
        }
        this.mConnectThread = new ConnectThread(device, secure);
        this.mConnectThread.start();
        setState(STATE_CONNECTING);
    }

    public synchronized void connected(BluetoothSocket socket, BluetoothDevice device, String socketType) {
        Log.d(TAG, "connected, Socket Type:" + socketType);
        sendLog("[BluetoothSerialService::connected] connected, Socket Type:" + socketType);
        if (this.mConnectThread != null) {
            this.mConnectThread.cancel();
            this.mConnectThread = null;
        }
        if (this.mConnectedThread != null) {
            this.mConnectedThread.cancel();
            this.mConnectedThread = null;
        }

        this.mConnectedThread = new ConnectedThread(socket, socketType);
        this.mConnectedThread.start();
        setState(STATE_CONNECTED);
    }

    public synchronized void stop() {
        if (mState == STATE_NONE)
            return;
        Log.d(TAG, "stop");
        if (this.mConnectThread != null) {
            this.mConnectThread.cancel();
            this.mConnectThread = null;
        }
        if (this.mConnectedThread != null) {
            this.mConnectedThread.cancel();
            this.mConnectedThread = null;
        }
        setState(STATE_NONE);
    }

    public synchronized void read() {
        //this.connected(this.mmSocket, this.mmDevice, this.mSocketType);
    }

    public void write(byte[] out) {
        synchronized (this) {
            if (this.mState == 3) {
                ConnectedThread r = this.mConnectedThread;
                r.write(out);
            }
        }
    }

    /* access modifiers changed from: private */
    public void connectionFailed() {
        Message msg = this.mHandler.obtainMessage(MESSAGE_TOAST);
        Bundle bundle = new Bundle();
        bundle.putString(TOAST, "Unable to connect to device");
        msg.setData(bundle);
        this.mHandler.sendMessage(msg);
        start();
    }

    /* access modifiers changed from: private */
    public void connectionLost() {
        Message msg = this.mHandler.obtainMessage(MESSAGE_TOAST);
        Bundle bundle = new Bundle();
        bundle.putString(TOAST, "Device connection was lost");
        msg.setData(bundle);
        this.mHandler.sendMessage(msg);
        start();
    }

    private class ConnectThread extends Thread {

        private String mSocketType;
        private final BluetoothDevice mmDevice;
        private BluetoothSocket mmSocket;

        public ConnectThread(BluetoothDevice device, boolean secure) {
            BluetoothSerial.this.deviceName = device.getName();
            this.mmDevice = device;
            BluetoothSocket tmp = null;
            this.mSocketType = secure ? "Secure" : "Insecure";
            //if (! BuildConfig.DEBUG) {
                try {
                    if (secure) {
                        tmp = device.createRfcommSocketToServiceRecord( BluetoothSerial.UUID_SPP);
                    } else {
                        tmp = device.createInsecureRfcommSocketToServiceRecord(BluetoothSerial.UUID_SPP);
                    }
                } catch (IOException e) {
                    Log.e(BluetoothSerial.TAG, "Socket Type: " + this.mSocketType + "create() failed", e);
                    sendLog("[ConnectThread::ConnectThread] Socket Type: " + this.mSocketType + "create() failed" + this.mSocketType);
                    Sentry.captureException(e);
                }
            //}
            BluetoothSerial.this.mmSocket = tmp;
        }

        public void run() {
            Log.i(BluetoothSerial.TAG, "[ConnectThread::run]SocketType:" + this.mSocketType);
            sendLog("[ConnectThread::run] BEGIN mConnectThread SocketType:" + this.mSocketType);
            setName("ConnectThread" + this.mSocketType);
            if (BluetoothSerial.this.mmSocket == null)
                return;
            //if ( ! BuildConfig.DEBUG) {
                BluetoothSerial.this.mAdapter.cancelDiscovery();
                try {
                    Log.i(BluetoothSerial.TAG, "Connecting to socket...");
                    sendLog("[ConnectThread::run] Connecting to socket...");
                    BluetoothSerial.this.mmSocket.connect();
                    Log.i(BluetoothSerial.TAG, "Connected");
                    sendLog("[ConnectThread::run] Connected");
                    BluetoothSerial.this.setState(BluetoothSerial.STATE_CONNECTED);
                } catch (IOException e) {
                    Log.e(BluetoothSerial.TAG, e.toString());
                    Sentry.captureException(e);
                    try {
                        Log.i(BluetoothSerial.TAG, "Trying fallback...");
                        BluetoothSerial.this.mmSocket = (BluetoothSocket) this.mmDevice.getClass().getMethod("createRfcommSocket", new Class[]{Integer.TYPE}).invoke(this.mmDevice, new Object[]{1});
                        BluetoothSerial.this.mmSocket.connect();
                        BluetoothSerial.this.setState(BluetoothSerial.STATE_CONNECTED);
                        Log.i(BluetoothSerial.TAG, "Connected");
                        sendLog("[ConnectThread::run] Connected");
                    } catch (Exception e2) {
                        Log.e(BluetoothSerial.TAG, "Couldn't establish a Bluetooth connection.");
                        sendLog("[ConnectThread::run] Couldn't establish a Bluetooth connection.");
                        Sentry.captureException(e);
                        try {
                            BluetoothSerial.this.mmSocket.close();
                        } catch (IOException e3) {
                            Log.e(BluetoothSerial.TAG, "unable to close() " + this.mSocketType + " socket during connection failure", e3);
                            sendLog("[ConnectThread::run] unable to close() " + this.mSocketType + " socket during connection failure " + e3.getMessage() );
                            Sentry.captureException(e);
                        }
                        BluetoothSerial.this.connectionFailed();
                        return;
                    }
                }
            //}
            synchronized (BluetoothSerial.this) {
                BluetoothSerial.this.mConnectThread = null;
            }

            BluetoothSerial.this.connected(BluetoothSerial.this.mmSocket, this.mmDevice, this.mSocketType);
        }

        public void cancel() {
            try {
                BluetoothSerial.this.mmSocket.close();
            } catch (IOException e) {
                Log.e(BluetoothSerial.TAG, "close() of connect " + this.mSocketType + " socket failed", e);
                sendLog("close() of connect " + this.mSocketType + " socket failed " + e.getMessage() );
                Sentry.captureException(e);
            }
        }
    }

    private class ConnectedThread extends Thread {
        private InputStream mmInStream;
        private OutputStream mmOutStream;
        private BluetoothSocket mmSocket;

        public ConnectedThread(BluetoothSocket socket, String socketType) {
            Log.d(BluetoothSerial.TAG, "create ConnectedThread: " + socketType);
            sendLog("create ConnectedThread: " + socketType);
            /*if ( socket.isConnected())
                throw  new IOException("Socket not connected");*/
            this.mmSocket = socket;
            InputStream tmpIn = null;
            OutputStream tmpOut = null;
           /* if (BuildConfig.DEBUG) {
                byte[] initialArray = {0x32,0x35,0x30, 0x30, 0x33,0x30,0x30,0x34,0x30,0x33, 0x34,0x30,0x30,0x32,0x30 };
                tmpIn = new MockInputStream(initialArray);
                tmpOut = new MockOutputStream();
            }
            else {*/
                try {
                    tmpIn = socket.getInputStream();
                    tmpOut = socket.getOutputStream();
                } catch (IOException e) {
                    Log.e(BluetoothSerial.TAG, "temp sockets not created", e);
                    sendLog("temp sockets not created " + e.getMessage());
                    Sentry.captureException(e);
                }
            //}
            this.mmInStream = tmpIn;
            this.mmOutStream = tmpOut;
        }

        public void run() {
            Log.i(BluetoothSerial.TAG, "[ConnectedThread:run]");
            sendLog("[ConnectedThread:run] ");
            byte[] buffer = new byte[1024];
            while (true) {
                try {
                    sendLog("[ConnectedThread:run] read");
                    int bytes = this.mmInStream.read(buffer); // TODO : Gérer le carriage return 0D
                    sendLog("[ConnectedThead:run] bytes size " + bytes);
                    BluetoothSerial.this.mHandler.obtainMessage(MESSAGE_READ, new String(buffer, 0, bytes)).sendToTarget();
                    if (bytes > 0) {
                        BluetoothSerial.this.mHandler.obtainMessage(MESSAGE_READ_RAW, new String(buffer, 0, bytes) /*Arrays.copyOf(buffer, bytes)*/).sendToTarget();
                        return;
                    }
                } catch (IOException e) {
                    Log.e(BluetoothSerial.TAG, "[ConnectedThead:run] disconnected", e);
                    sendLog("[ConnectedThead:run] disconnected " + e.getMessage());
                    Sentry.captureException(e);
                    BluetoothSerial.this.connectionLost();
                    BluetoothSerial.this.start();
                    return;
                }
            }
        }

        public void write(byte[] buffer) {
            try {
                this.mmOutStream.write(buffer);
                BluetoothSerial.this.mHandler.obtainMessage(MESSAGE_WRITE, -1, -1, buffer).sendToTarget();
                BluetoothSerial.this.stop();
            } catch (IOException e) {
                Log.e(BluetoothSerial.TAG, "Exception during write", e);
                Sentry.captureException(e);
                sendLog("Exception during write " + e.getMessage());
            }
        }

        public void cancel() {
            try {
                if (! BuildConfig.DEBUG)
                    this.mmSocket.close();
            } catch (IOException e) {
                sendLog("close() of connect socket failed " + e.getMessage() );
                Sentry.captureException(e);
                Log.e(BluetoothSerial.TAG, "close() of connect socket failed", e);
            }
        }
    }

    public static String byteArrayToHexString(byte[] bArr) {
        StringBuilder sb = new StringBuilder(bArr.length * 2);
        for (byte b : bArr) {
            byte b2 = (byte) (b & MAX_VALUE);
            if (b2 < 16) {
                sb.append('0');
            }
            sb.append(Integer.toHexString(b2));
        }
        return sb.toString().toUpperCase();
    }


    public List<BluetoothDevice> getBondedDevices() {
        Set<BluetoothDevice> bondedDevices = BluetoothAdapter.getDefaultAdapter().getBondedDevices();
        List<BluetoothDevice> lstDevices = new ArrayList<>(bondedDevices);
        return lstDevices;
    }

    private void sendLog(String message) {
        mHandler.obtainMessage(MESSAGE_LOG, message).sendToTarget();
    }

}