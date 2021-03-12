package nemesys.fr.flutter_gismo;

import android.bluetooth.BluetoothSocket;
import android.os.Handler;
import android.util.Log;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import io.flutter.BuildConfig;
import io.sentry.Sentry;

public class BluetoothReader extends Thread {
    private InputStream mmInStream;
    private OutputStream mmOutStream;
    private BluetoothSocket mmSocket;
    private Handler mHandler;
    private final static String TAG = "BluetoothRead" ;
    protected volatile boolean reading = true;

    public BluetoothReader(BluetoothSocket socket, Handler handler) {
        Log.d(BluetoothReader.TAG, "create BluetoothRead: " );
        /*if ( socket.isConnected())
            throw  new IOException("Socket not connected");*/
        this.mHandler = handler;
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
            Log.e(BluetoothReader.TAG, "temp sockets not created", e);
            Sentry.captureException(e);
        }
        //}
        this.mmInStream = tmpIn;
        this.mmOutStream = tmpOut;
    }

    public void run() {
        Log.i(BluetoothReader.TAG, "[ConnectedThread:run]");
        byte[] buffer = new byte[1024];
        while (reading) {
            try {
                int bytes = this.mmInStream.read(buffer); // TODO : Gérer le carriage return 0D
                this.mHandler.obtainMessage(BluetoothSerial.MESSAGE_READ, new String(buffer, 0, bytes)).sendToTarget();
                if (bytes > 0) {
                    this.mHandler.obtainMessage(BluetoothSerial.MESSAGE_READ_RAW, new String(buffer, 0, bytes) /*Arrays.copyOf(buffer, bytes)*/).sendToTarget();
                    //return;
                }
            } catch (IOException e) {
                Log.e(BluetoothReader.TAG, "[ConnectedThead:run] disconnected", e);
                Sentry.captureException(e);
                //BluetoothSerial.this.connectionLost();
                //BluetoothSerial.this.start();
                return;
            }
        }
    }

    public void write(byte[] buffer) {
        try {
            this.mmOutStream.write(buffer);
            this.mHandler.obtainMessage(BluetoothSerial.MESSAGE_WRITE, -1, -1, buffer).sendToTarget();
            //BluetoothSerial.this.stop();
        } catch (IOException e) {
            Log.e(BluetoothReader.TAG, "Exception during write", e);
            Sentry.captureException(e);
        }
    }

    public void cancel() {
        reading = false;
        try {
            if (! BuildConfig.DEBUG)
                this.mmSocket.close();
        } catch (IOException e) {
            Sentry.captureException(e);
            Log.e(BluetoothReader.TAG, "close() of connect socket failed", e);
        }
    }
}
