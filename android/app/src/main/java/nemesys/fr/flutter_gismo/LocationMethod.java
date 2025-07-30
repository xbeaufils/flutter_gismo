package nemesys.fr.gismo;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Handler;
import android.os.Message;
import android.util.Log;


import androidx.core.app.ActivityCompat;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class LocationMethod extends MethodChannel {

    private static final long MIN_DISTANCE_CHANGE_FOR_UPDATES = 10;
    private static final long MIN_TIME_BW_UPDATES = 1000 * 5;

    protected LocationManager locationManager;
    protected LocationListener locationListener;
    Location loc;
    LocationTrack myTrack;

    public LocationMethod(BinaryMessenger messenger, String name, Context context) {
        super(messenger, name);
        this.setMethodCallHandler(new LocationMethodHandler(context));
    }
    
    
    public class LocationMethodHandler implements MethodChannel.MethodCallHandler {
        private Context mContext;
        public String TAG = "LocationMethodHandler";

        public LocationMethodHandler(Context context){
            this.mContext = context;
        }
        @Override
        public void onMethodCall(MethodCall call, MethodChannel.Result result) {
            locationManager = (LocationManager) this.mContext.getSystemService(Context.LOCATION_SERVICE);

            if (call.method.contentEquals("startLocation")) {
                if (ActivityCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
                        && ActivityCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                    result.error("NoRight", "Autorisez l'acces au GPS", null);
                } else {
                    myTrack = new LocationTrack(this.mContext, new LocationHandler());
                    locationManager.requestLocationUpdates(
                            LocationManager.GPS_PROVIDER,
                            MIN_TIME_BW_UPDATES,
                            MIN_DISTANCE_CHANGE_FOR_UPDATES, myTrack);
                    loc = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
                    result.success("Localisation en cours");
                }
            }
            if (call.method.contentEquals("getLocation")) {
                if (loc != null) {
                    Log.d(TAG, "onMethodCall::getLocation Latitude" + loc.getLatitude() + " Long " + loc.getLongitude() );
                    result.success("{\"Latitude\" : \"" + loc.getLatitude() + "\", \"Longitude\" : \"" + loc.getLongitude() + "\"}");
                }
                else {
                    loc = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
                    if (loc != null){
                        Log.d(TAG, "onMethodCall::getLocation Latitude" + loc.getLatitude() + " Long " + loc.getLongitude() );
                        result.success("{\"Latitude\" : \"" + loc.getLatitude() + "\", \"Longitude\" : \"" + loc.getLongitude() + "\"}");
                    }
                    else
                        result.error("NoLocation", "Non localisation", null);
                }
            }
            if (call.method.contentEquals("stopLocation")) {
                locationManager.removeUpdates(myTrack);
            }

        }
    }
    
    public class LocationHandler extends Handler {

        @Override
        public void handleMessage(Message msg) {

        }
    }


    public class LocationTrack implements LocationListener {

        private final Context mContext;
        private final Handler mHandler;

        boolean checkGPS = false;


        boolean checkNetwork = false;

        boolean canGetLocation = false;


        private static final long MIN_DISTANCE_CHANGE_FOR_UPDATES = 10;


        private static final long MIN_TIME_BW_UPDATES = 1000 * 60 * 1;
        protected LocationManager locationManager;

        public LocationTrack(Context mContext, Handler handler) {
            this.mContext = mContext;
            this.mHandler = handler;
            //getLocation();
        }

        private Location getLocation() {

            try {
                locationManager = (LocationManager) mContext.getSystemService(Context.LOCATION_SERVICE);

                // get GPS status
                checkGPS = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);

                // get network provider status
                checkNetwork = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);

                if (!checkGPS && !checkNetwork) {
                    //Toast.makeText(mContext, "No Service Provider is available", Toast.LENGTH_SHORT).show();
                } else {
                    this.canGetLocation = true;

                    // if GPS Enabled get lat/long using GPS Services
                    if (checkGPS) {

                        if (ActivityCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
                                && ActivityCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                            // TODO: Consider calling
                            //    ActivityCompat#requestPermissions
                            // here to request the missing permissions, and then overriding
                            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                            //                                          int[] grantResults)
                            // to handle the case where the user grants the permission. See the documentation
                            // for ActivityCompat#requestPermissions for more details.
                        }
                        locationManager.requestLocationUpdates(
                                LocationManager.GPS_PROVIDER,
                                MIN_TIME_BW_UPDATES,
                                MIN_DISTANCE_CHANGE_FOR_UPDATES, this);
                        if (locationManager != null) {
                            loc = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
                        }


                    }


                    /*if (checkNetwork) {


                        if (ActivityCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                            // TODO: Consider calling
                            //    ActivityCompat#requestPermissions
                            // here to request the missing permissions, and then overriding
                            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                            //                                          int[] grantResults)
                            // to handle the case where the user grants the permission. See the documentation
                            // for ActivityCompat#requestPermissions for more details.
                        }
                        locationManager.requestLocationUpdates(
                                LocationManager.NETWORK_PROVIDER,
                                MIN_TIME_BW_UPDATES,
                                MIN_DISTANCE_CHANGE_FOR_UPDATES, this);

                        if (locationManager != null) {
                            loc = locationManager
                                    .getLastKnownLocation(LocationManager.NETWORK_PROVIDER);

                        }

                        if (loc != null) {
                            latitude = loc.getLatitude();
                            longitude = loc.getLongitude();
                        }
                    }*/

                }


            } catch (Exception e) {
                e.printStackTrace();
            }

            return loc;
        }

        public boolean canGetLocation() {
            return this.canGetLocation;
        }

        public void stopListener() {
            if (locationManager != null) {

                if (ActivityCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                    // TODO: Consider calling
                    //    ActivityCompat#requestPermissions
                    // here to request the missing permissions, and then overriding
                    //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                    //                                          int[] grantResults)
                    // to handle the case where the user grants the permission. See the documentation
                    // for ActivityCompat#requestPermissions for more details.
                    return;
                }
                locationManager.removeUpdates(LocationTrack.this);
            }
        }

        @Override
        public void onLocationChanged(Location location) {
            loc = location;
        }

        @Override
        public void onProviderEnabled(String s) {

        }

        @Override
        public void onProviderDisabled(String s) {

        }
    }
}