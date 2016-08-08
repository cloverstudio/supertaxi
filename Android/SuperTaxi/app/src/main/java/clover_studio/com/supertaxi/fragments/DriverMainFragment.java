package clover_studio.com.supertaxi.fragments;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.content.pm.PackageManager;
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
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.adapters.AddressAdapter;
import clover_studio.com.supertaxi.base.BaseFragment;
import clover_studio.com.supertaxi.dialog.BasicDialog;
import clover_studio.com.supertaxi.dialog.RequestSentDialog;
import clover_studio.com.supertaxi.dialog.SeatsNumberDialog;
import clover_studio.com.supertaxi.dialog.ShowMoreInMapDialog;
import clover_studio.com.supertaxi.utils.AnimationUtils;
import clover_studio.com.supertaxi.utils.LocationSourceListener;
import clover_studio.com.supertaxi.utils.Utils;
import clover_studio.com.supertaxi.view.touchable_map.MapStateListener;
import clover_studio.com.supertaxi.view.touchable_map.TouchableMapFragment;

/**
 * Created by ivoperic on 13/07/16.
 */
public class DriverMainFragment extends BaseFragment implements OnMapReadyCallback {

    GoogleMap googleMap;

    private FrameLayout layoutForMap;
    private ProgressBar loadingProgress;
    private TouchableMapFragment mapFragment;
    private RelativeLayout rlUserDetails;
    private LinearLayout llButtons;

    private Location myLocation = null;
    private LocationSourceListener locationSourceListener;
    private Geocoder geocoder;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_driver_main, container, false);

        initViews(rootView);

        mapFragment = new TouchableMapFragment();
        getFragmentManager().beginTransaction().add(layoutForMap.getId(), mapFragment, "TAG").commit();
        mapFragment.getMapAsync(DriverMainFragment.this);

        locationSourceListener = new LocationSourceListener(getActivity(), onMyLocationChangedListener);
        geocoder = new Geocoder(getActivity(), Locale.getDefault());

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                animateUserLayout();
            }
        }, 4000);

        return rootView;
    }

    @Override
    public void onResume() {
        super.onResume();
        locationSourceListener.getBestAvailableProvider();
        if(googleMap != null){
            googleMap.setLocationSource(locationSourceListener);
        }
    }

    private void initViews(View rootView){
        layoutForMap = (FrameLayout) rootView.findViewById(R.id.frameForMap);
        loadingProgress = (ProgressBar) rootView.findViewById(R.id.progressBarLoading);
        rlUserDetails = (RelativeLayout) rootView.findViewById(R.id.rlUserDetails);
        llButtons = (LinearLayout) rootView.findViewById(R.id.llButtons);

        ImageView avatar = (ImageView) rootView.findViewById(R.id.ivAvatar);
        int sizeForAvatar = getResources().getDisplayMetrics().widthPixels / 2;
        avatar.getLayoutParams().height = sizeForAvatar;
        avatar.getLayoutParams().width = sizeForAvatar;
    }

    private void animateUserLayout(){
        rlUserDetails.setVisibility(View.VISIBLE);

        AnimationUtils.translateY(rlUserDetails, -getResources().getDisplayMetrics().heightPixels / 2, 0, 300, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) layoutForMap.getLayoutParams();
                params.topMargin = rlUserDetails.getHeight();
                params.bottomMargin = llButtons.getHeight();
                layoutForMap.setLayoutParams(params);
            }
        });
        llButtons.setVisibility(View.VISIBLE);
        AnimationUtils.translateY(llButtons, TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 50, getResources().getDisplayMetrics()), 0, 300, null);
    }

    @SuppressWarnings("MissingPermission")
    @Override
    public void onMapReady(final GoogleMap googleMap) {
        loadingProgress.setVisibility(View.GONE);

        this.googleMap = googleMap;

        googleMap.setLocationSource(locationSourceListener);
        googleMap.setMyLocationEnabled(true);
        googleMap.getUiSettings().setMyLocationButtonEnabled(true);

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
            }

            @Override
            public void onMapSettled() {
                // Map settled
                Log.d("LOG", "MAP settled");
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

            }
        }

    }

    private LocationSourceListener.OnMyLocationChangedListener onMyLocationChangedListener = new LocationSourceListener.OnMyLocationChangedListener() {
        @Override
        public void onLocationChanged(Location myLocationNew) {
            myLocation = myLocationNew;
            Log.d("LOG_IVO", "MY LOCATION: " + myLocation.getLatitude() + ", " + myLocation.getLongitude());
        }
    };

}
