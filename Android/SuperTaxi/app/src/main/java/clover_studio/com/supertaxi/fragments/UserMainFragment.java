package clover_studio.com.supertaxi.fragments;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.location.Address;
import android.location.Criteria;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.base.BaseFragment;
import clover_studio.com.supertaxi.utils.AnimationUtils;
import clover_studio.com.supertaxi.view.touchable_map.MapStateListener;
import clover_studio.com.supertaxi.view.touchable_map.TouchableMapFragment;

/**
 * Created by ivoperic on 13/07/16.
 */
public class UserMainFragment extends BaseFragment implements OnMapReadyCallback {

    GoogleMap googleMap;
    private LatLng activeLatLng = null;
    private FrameLayout layoutForMap;
    private ProgressBar loadingProgress;
    private ImageButton ibMyLocation;
    private RelativeLayout rlParentOfMyCurrent;
    private TextView tvTextViewInMyCurrent;
    private TouchableMapFragment mapFragment;
    private View viewTimer;
    private View smallPin;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_user_main, container, false);

        layoutForMap = (FrameLayout) rootView.findViewById(R.id.frameForMap);
        loadingProgress = (ProgressBar) rootView.findViewById(R.id.progressBarLoading);
        ibMyLocation = (ImageButton) rootView.findViewById(R.id.ibMyLocation);
        rlParentOfMyCurrent = (RelativeLayout) rootView.findViewById(R.id.rlParentOfMyCurrentLocation);
        tvTextViewInMyCurrent = (TextView) rootView.findViewById(R.id.tvInMarker);
        viewTimer = rootView.findViewById(R.id.viewTimer);
        smallPin = rootView.findViewById(R.id.smallPin);

        AnimationUtils.rotationInfinite(viewTimer, true, 2000);

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
//                SupportMapFragment mapFragment = SupportMapFragment.newInstance();
//
//                getFragmentManager().beginTransaction().add(layoutForMap.getId(), mapFragment, "TAG").commit();
//
//                mapFragment.getMapAsync(UserMainFragment.this);
            }
        }, 600);

        mapFragment = new TouchableMapFragment();

        getFragmentManager().beginTransaction().add(layoutForMap.getId(), mapFragment, "TAG").commit();

        mapFragment.getMapAsync(UserMainFragment.this);

        ibMyLocation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoMyLocation();
            }
        });

        return rootView;
    }


    @SuppressWarnings("MissingPermission")
    @Override
    public void onMapReady(final GoogleMap googleMap) {
        loadingProgress.setVisibility(View.GONE);

        this.googleMap = googleMap;

        new MapStateListener(googleMap, mapFragment, getActivity()) {
            @Override
            public void onMapTouched() {
                // Map touched
                Log.d("LOG", "MAP TOUCHED");
            }

            @Override
            public void onMapReleased() {
                // Map released
                Log.d("LOG", "MAP released");
            }

            @Override
            public void onMapUnsettled() {
                // Map unsettled
                Log.d("LOG", "MAP unsettled");
                rlParentOfMyCurrent.setVisibility(View.GONE);
                smallPin.setVisibility(View.VISIBLE);
            }

            @Override
            public void onMapSettled() {
                // Map settled
                Log.d("LOG", "MAP settled");
                LatLng current = googleMap.getCameraPosition().target;
                String address = getAddress(current.latitude, current.longitude);
//                tvTextViewInMyCurrent.setText("LAT: " + current.latitude + ", LNG: " + current.longitude);
                tvTextViewInMyCurrent.setText(address);
                rlParentOfMyCurrent.setVisibility(View.VISIBLE);
                smallPin.setVisibility(View.GONE);
            }

            @Override
            public void onMapChangeCamera(CameraPosition cameraPosition) {
                Log.d("LOG", "CAMERA CHANGE");
            }
        };

        gotoMyLocation();

    }

    /**
     * animate google map to my location and add marker to my location
     */
    private void gotoMyLocation() {

        rlParentOfMyCurrent.setVisibility(View.GONE);

        if(googleMap == null) return;

        LocationManager locationManager = (LocationManager) getActivity().getSystemService(Activity.LOCATION_SERVICE);

        Criteria criteria = new Criteria();
        String provider = locationManager.getBestProvider(criteria, true);

        if (Build.VERSION.SDK_INT >= 23 &&
                ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                ContextCompat.checkSelfPermission( getActivity(), android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {

        }else{
            Location myLocation = locationManager.getLastKnownLocation(provider);

            if(myLocation != null){
                LatLng latLng = new LatLng(myLocation.getLatitude(), myLocation.getLongitude());
                activeLatLng = latLng;
                googleMap.animateCamera(CameraUpdateFactory.newLatLngZoom(latLng, 15));
//                googleMap.addMarker(new MarkerOptions().position(latLng));

            }
        }

    }

    private String getAddress(double latitude, double longitude) {
        StringBuilder result = new StringBuilder();
        try {
            Geocoder geocoder = new Geocoder(getActivity(), Locale.getDefault());
            List<Address> addresses = geocoder.getFromLocation(latitude, longitude, 1);
            if (addresses.size() > 0) {
                Address address = addresses.get(0);
//                result.append(address.getLocality()).append("\n");
//                result.append(address.getCountryName());
                result.append(address.getAddressLine(0));
            }
        } catch (IOException e) {
            Log.e("tag", e.getMessage());
        }

        return result.toString();
    }
}
