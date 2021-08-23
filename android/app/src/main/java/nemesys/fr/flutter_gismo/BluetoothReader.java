package nemesys.fr.flutter_gismo;

import android.bluetooth.BluetoothSocket;
import android.os.Handler;
import android.util.Log;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;

import io.flutter.BuildConfig;
import io.sentry.Sentry;

public class BluetoothReader extends Thread {
    private InputStream mmInStream;
    private OutputStream mmOutStream;
    private BluetoothSocket mmSocket;
    private Handler mHandler;
    private final static String TAG = "BluetoothRead" ;
    private boolean reading = true;

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
        reading = true;
        ArrayList<Integer> arr_byte = new ArrayList<>();
        //byte[] buffer = new byte[1024];
        while (reading) {
             try {
                int data = this.mmInStream.read();
                Log.d(TAG, "run: " + data);
                if (data != 10) {
                    if (data == 13) {
                        byte[] buffer = new byte[arr_byte.size()];
                        for (int i = 0; i < arr_byte.size(); i++) {
                            buffer[i] = arr_byte.get(i).byteValue();
                        }
                        this.mHandler.obtainMessage(BluetoothSerial.MESSAGE_READ, new String(buffer, 0, arr_byte.size())).sendToTarget();
                        //BluetoothService.this.mHandler.obtainMessage(2, buffer.length, -1, buffer).sendToTarget();
                        arr_byte = new ArrayList<>();
                        //reading = false;
                    } else {
                        if (data > 16)
                        arr_byte.add(Integer.valueOf(data));
                    }
                }
                else {
                    reading = false;
                }
                /*
                int bytes = this.mmInStream.read(buffer); // TODO : Gérer le carriage return 0D

                Log.d("BluetoothReader.TAG", "buffer " + new String(buffer, 0, bytes));
                //this.mHandler.obtainMessage(BluetoothSerial.MESSAGE_READ, new String(buffer, 0, bytes)).sendToTarget();
                if (bytes > 0) {
                    this.mHandler.obtainMessage(BluetoothSerial.MESSAGE_READ_RAW, new String(buffer, 0, bytes) ).sendToTarget();
                    //return;
                }*/
            } catch (IOException e) {
                Log.e(BluetoothReader.TAG, "[ConnectedThead:run] disconnected", e);
                Sentry.captureException(e);
                //BluetoothSerial.this.connectionLost();
                //BluetoothSerial.this.start();
                return;
            }
        }
        Log.d(TAG, "run: End of run : reading = " + reading);
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
            //if (! BuildConfig.DEBUG)
                this.mmSocket.close();
        } catch (IOException e) {
            Sentry.captureException(e);
            Log.e(BluetoothReader.TAG, "close() of connect socket failed", e);
        }
    }
}
