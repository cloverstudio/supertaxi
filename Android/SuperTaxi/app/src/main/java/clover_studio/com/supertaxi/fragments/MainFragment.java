package clover_studio.com.supertaxi.fragments;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ProgressBar;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.UserRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseFragment;
import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.models.post_models.PostLatLngModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.LocationSourceListener;
import clover_studio.com.supertaxi.view.touchable_map.TouchableMapFragment;
import retrofit2.Call;

/**
 * Created by ivoperic on 13/07/16.
 */
public class MainFragment extends BaseFragment implements OnMapReadyCallback {

    protected GoogleMap googleMap;

    protected FrameLayout layoutForMap;
    protected ProgressBar loadingProgress;
    protected TouchableMapFragment mapFragment;
    protected Location myLocation = null;
    protected LocationSourceListener locationSourceListener;
    protected Handler handlerForCheck = new Handler();
    protected boolean stopChecking = false;

    protected Marker myLocationTempMarker;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        locationSourceListener = new LocationSourceListener(getActivity(), onMyLocationChangedListener);
    }

    @Override
    public void onResume() {
        super.onResume();
        locationSourceListener.getBestAvailableProvider();
        if(googleMap != null){
            googleMap.setLocationSource(locationSourceListener);
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        locationSourceListener.deactivate();
        stopChecking = true;
        handlerForCheck.removeCallbacksAndMessages(null);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        stopChecking = true;
    }

    @SuppressWarnings("MissingPermission")
    @Override
    public void onMapReady(final GoogleMap googleMap) {
        loadingProgress.setVisibility(View.GONE);

        this.googleMap = googleMap;

        googleMap.setLocationSource(locationSourceListener);

        onMapReadyForOverride();

        gotoMyLocation();

    }

    //override this
    protected void onMapReadyForOverride(){}

    /**
     * animate google map to my location and add marker to my location
     */
    protected void gotoMyLocation() {

        if(googleMap == null) return;

        LocationManager locationManager = (LocationManager) getActivity().getSystemService(Activity.LOCATION_SERVICE);

        Criteria criteria = new Criteria();
        String provider = locationManager.getBestProvider(criteria, true);

        if (Build.VERSION.SDK_INT >= 23 &&
                ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                ContextCompat.checkSelfPermission( getActivity(), android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {

        }else{

            if(myLocation == null){
                myLocation = locationManager.getLastKnownLocation(provider);
            }

            if(myLocation != null){
                LatLng latLng = new LatLng(myLocation.getLatitude(), myLocation.getLongitude());
                googleMap.animateCamera(CameraUpdateFactory.newLatLngZoom(latLng, 15));
                updateCoordinates(new LatLng(myLocation.getLatitude(), myLocation.getLongitude()));

                if(myLocationTempMarker == null){
                    myLocationTempMarker = googleMap.addMarker(new MarkerOptions().position(latLng).icon(BitmapDescriptorFactory.fromResource(R.drawable.ic_my_location)));
                }
            }

            if(myLocation != null){
                onMyLocationFound();
            }

        }

    }

    protected void onMyLocationFound(){}

    private LocationSourceListener.OnMyLocationChangedListener onMyLocationChangedListener = new LocationSourceListener.OnMyLocationChangedListener() {
        @Override
        public void onLocationChanged(Location myLocationNew) {
            onMyLocationChanged(myLocationNew);
        }
    };

    // Override this
    protected void onMyLocationChanged(Location myLocationNew){
        boolean isMyLocationAlreadyFound = true;
        if(myLocation == null){
            isMyLocationAlreadyFound = false;
        }
        myLocation = myLocationNew;
        Log.d("LOG_IVO", "MY LOCATION: " + myLocation.getLatitude() + ", " + myLocation.getLongitude());
        updateCoordinates(new LatLng(myLocation.getLatitude(), myLocationNew.getLongitude()));

        if(myLocationTempMarker != null){
            myLocationTempMarker.remove();
        }

        if(!isMyLocationAlreadyFound){
            onMyLocationFound();
        }
    }

    private void updateCoordinates(LatLng newLocation){
        PostLatLngModel postModel = new PostLatLngModel(newLocation.latitude, newLocation.longitude);

        UserRetroApiInterface retroApiInterface = getRetrofit().create(UserRetroApiInterface.class);
        Call<BaseModel> call = retroApiInterface.updateCoordinates(postModel, UserSingleton.getInstance().getUser().token_new);
        call.enqueue(new CustomResponse<BaseModel>(getActivity(), false, false) {});
    }

}
