package nemesys.fr.gismo;

import android.bluetooth.BluetoothSocket;
import android.os.Handler;
import android.util.Log;


import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicBoolean;

import io.sentry.Sentry;

public class BluetoothReader extends Thread {
    private InputStream mmInStream;
    private OutputStream mmOutStream;
    private BluetoothSocket mmSocket;
    private Handler mHandler;
    private final static String TAG = "BluetoothRead" ;
    private AtomicBoolean reading = new AtomicBoolean(true);

    public BluetoothReader(BluetoothSocket socket, Handler handler) {
        Log.d(BluetoothReader.TAG, "create BluetoothRead: " );
        this.mHandler = handler;
        this.mmSocket = socket;
        InputStream tmpIn = null;
        OutputStream tmpOut = null;
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
        Log.i(BluetoothReader.TAG, "run");
        reading.set( true );
        ArrayList<Integer> arr_byte = new ArrayList<>();
        //byte[] buffer = new byte[1024];
        this.mHandler.obtainMessage(BluetoothMessage.STATE_CHANGE.ordinal(), MainActivity.State.LISTEN.ordinal() ).sendToTarget();
        while (reading.get()) {
             try {
                 if (this.mmInStream.available() > 0 ) {
                     int data = this.mmInStream.read();
                     Log.d(TAG, "run: " + data);
                     if (data != 10) {
                         if (data == 13) {
                             byte[] buffer = new byte[arr_byte.size()];
                             for (int i = 0; i < arr_byte.size(); i++) {
                                 buffer[i] = arr_byte.get(i).byteValue();
                             }
                             this.mHandler.obtainMessage(BluetoothMessage.READ.ordinal(), new String(buffer, 0, arr_byte.size())).sendToTarget();
                              arr_byte = new ArrayList<>();
                         } else {
                             if (data > 16)
                                 arr_byte.add(Integer.valueOf(data));
                         }
                     }
                 }
                 else
                     Thread.sleep(500);
             } catch (IOException e) {
                Log.e(BluetoothReader.TAG, "[ConnectedThead:run] disconnected", e);
                Sentry.captureException(e);
                return;
            } catch (InterruptedException e) {
                 e.printStackTrace();
             }
        }
        Log.d(TAG, "run: End of run : reading = " + reading.get());
    }

    public void write(byte[] buffer) {
        try {
            this.mmOutStream.write(buffer);
            this.mHandler.obtainMessage(BluetoothSerial.MESSAGE_WRITE, -1, -1, buffer).sendToTarget();
        } catch (IOException e) {
            Log.e(BluetoothReader.TAG, "Exception during write", e);
            Sentry.captureException(e);
        }
    }

    public void cancel() {
        reading.set( false );
    }
}
