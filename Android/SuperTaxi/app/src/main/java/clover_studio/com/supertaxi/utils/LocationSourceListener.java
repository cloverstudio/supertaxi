package clover_studio.com.supertaxi.utils;

import android.content.Context;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.LocationSource;
import com.google.android.gms.maps.model.LatLng;

/**
 * Created by ivoperic on 22/07/16.
 */
@SuppressWarnings("MissingPermission")
public class LocationSourceListener implements LocationSource, LocationListener {

    private LocationSource.OnLocationChangedListener mListener;
    private OnMyLocationChangedListener myListener;
    private LocationManager locationManager;
    private final Criteria criteria = new Criteria();
    private String bestAvailableProvider;
    /* Updates are restricted to one every 10 seconds, and only when
     * movement of more than 10 meters has been detected.*/
    private final int minTime = 10000;     // minimum time interval between location updates, in milliseconds
    private final int minDistance = 10;    // minimum distance between location updates, in meters

    public LocationSourceListener(Context context, OnMyLocationChangedListener lis) {
        // Get reference to Location Manager
        locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);

        // Specify Location Provider criteria
        criteria.setAccuracy(Criteria.ACCURACY_FINE);
        criteria.setPowerRequirement(Criteria.POWER_LOW);
        criteria.setAltitudeRequired(true);
        criteria.setBearingRequired(true);
        criteria.setSpeedRequired(true);
        criteria.setCostAllowed(true);

        myListener = lis;
    }

    public void getBestAvailableProvider() {
            /* The preffered way of specifying the location provider (e.g. GPS, NETWORK) to use
             * is to ask the Location Manager for the one that best satisfies our criteria.
             * By passing the 'true' boolean we ask for the best available (enabled) provider. */
        bestAvailableProvider = locationManager.getBestProvider(criteria, true);
    }

    /* Activates this provider. This provider will notify the supplied listener
     * periodically, until you call deactivate().
     * This method is automatically invoked by enabling my-location layer. */
    @Override
    public void activate(OnLocationChangedListener listener) {
        // We need to keep a reference to my-location layer's listener so we can push forward
        // location updates to it when we receive them from Location Manager.
        mListener = listener;

        // Request location updates from Location Manager
        if (bestAvailableProvider != null) {
            locationManager.requestLocationUpdates(bestAvailableProvider, minTime, minDistance, this);
        } else {
            // (Display a message/dialog) No Location Providers currently available.
        }
    }

    /* Deactivates this provider.
     * This method is automatically invoked by disabling my-location layer. */
    @Override
    public void deactivate() {
        // Remove location updates from Location Manager
        locationManager.removeUpdates(this);

        mListener = null;
    }

    @Override
    public void onLocationChanged(Location location) {
            /* Push location updates to the registered listener..
             * (this ensures that my-location layer will set the blue dot at the new/received location) */
        if (mListener != null) {
            mListener.onLocationChanged(location);
        }

        if(myListener != null){
            myListener.onLocationChanged(location);
        }

    }

    @Override
    public void onStatusChanged(String s, int i, Bundle bundle) {

    }

    @Override
    public void onProviderEnabled(String s) {

    }

    @Override
    public void onProviderDisabled(String s) {

    }

    public interface OnMyLocationChangedListener{
        void onLocationChanged(Location myLocation);
    }

}
