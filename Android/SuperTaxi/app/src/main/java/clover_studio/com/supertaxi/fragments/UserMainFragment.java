package clover_studio.com.supertaxi.fragments;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.app.Dialog;
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
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
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
import clover_studio.com.supertaxi.utils.Utils;
import clover_studio.com.supertaxi.view.touchable_map.MapStateListener;
import clover_studio.com.supertaxi.view.touchable_map.TouchableMapFragment;

/**
 * Created by ivoperic on 13/07/16.
 */
public class UserMainFragment extends BaseFragment implements OnMapReadyCallback {

    public static final int WAIT_FOR_SEARCH_WHILE_TYPING = 500;

    GoogleMap googleMap;
    private LatLng currentLocation = null;
    private String currentAddress = null;
    private LatLng destinationLocation = null;
    private String destinationAddress = null;

    private FrameLayout layoutForMap;
    private ProgressBar loadingProgress;
    private ImageButton ibMyLocation;
    private RelativeLayout rlParentOfMyCurrent;
    private TextView tvTextViewInMyCurrent;
    private RelativeLayout rlFromTo;
    private EditText etFrom;
    private EditText etTo;
    private TouchableMapFragment mapFragment;
    private View viewTimer;
    private View smallPin;

    private RecyclerView rvFromSearch;
    private RelativeLayout rlForListFrom;
    private RecyclerView rvToSearch;
    private RelativeLayout rlForListTo;
    private RelativeLayout rlTo;
    private RelativeLayout rlFrom;
    private View viewBlackedOut;

    private boolean isUserSetLocationFromWithPin = false;
    private boolean isUserSetLocationToWithPin = false;
    private int nowCharacterFromLength = 0;
    private int nowCharacterToLength = 0;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_user_main, container, false);

        initViews(rootView);
        configureRecycler();
        addListeners(rootView);

        AnimationUtils.rotationInfinite(viewTimer, true, 2000);

        mapFragment = new TouchableMapFragment();
        getFragmentManager().beginTransaction().add(layoutForMap.getId(), mapFragment, "TAG").commit();
        mapFragment.getMapAsync(UserMainFragment.this);

        return rootView;
    }

    private void initViews(View rootView){
        layoutForMap = (FrameLayout) rootView.findViewById(R.id.frameForMap);
        loadingProgress = (ProgressBar) rootView.findViewById(R.id.progressBarLoading);
        ibMyLocation = (ImageButton) rootView.findViewById(R.id.ibMyLocation);
        rlParentOfMyCurrent = (RelativeLayout) rootView.findViewById(R.id.rlParentOfMyCurrentLocationInside);
        tvTextViewInMyCurrent = (TextView) rootView.findViewById(R.id.tvInMarker);
        viewTimer = rootView.findViewById(R.id.viewTimer);
        smallPin = rootView.findViewById(R.id.smallPin);
        rlFromTo = (RelativeLayout) rootView.findViewById(R.id.textViews);
        etFrom = (EditText) rootView.findViewById(R.id.etFrom);
        etTo = (EditText) rootView.findViewById(R.id.etTo);
        rvFromSearch = (RecyclerView) rootView.findViewById(R.id.rvFromSearch);
        rlForListFrom = (RelativeLayout) rootView.findViewById(R.id.rlForListFrom);
        rvToSearch = (RecyclerView) rootView.findViewById(R.id.rvToSearch);
        rlForListTo = (RelativeLayout) rootView.findViewById(R.id.rlToListFrom);
        rlTo = (RelativeLayout) rootView.findViewById(R.id.rlTo);
        rlFrom = (RelativeLayout) rootView.findViewById(R.id.rlFrom);
        viewBlackedOut = rootView.findViewById(R.id.allBlackedOut);
    }

    private void configureRecycler(){
        rvFromSearch.setLayoutManager(new LinearLayoutManager(getActivity()));
        rvFromSearch.setAdapter(new AddressAdapter(new ArrayList<Address>()));
        ((AddressAdapter)rvFromSearch.getAdapter()).setListener(onFromAddressListener);
        rvToSearch.setLayoutManager(new LinearLayoutManager(getActivity()));
        rvToSearch.setAdapter(new AddressAdapter(new ArrayList<Address>()));
        ((AddressAdapter)rvToSearch.getAdapter()).setListener(onToAddressListener);
    }

    private void addListeners(View rootView){
        rootView.findViewById(R.id.ibCloseFrom).setOnClickListener(onCloseFromClicked);
        rootView.findViewById(R.id.buttonShowMore).setOnClickListener(onShowMoreClicked);
        rlParentOfMyCurrent.setOnClickListener(onCurrentPinListener);
        ibMyLocation.setOnClickListener(onMyLocationClicked);
        etFrom.addTextChangedListener(onEtFromTextWatchListener);
        etTo.addTextChangedListener(onEtToTextWatchListener);
        rootView.findViewById(R.id.requestTaxi).setOnClickListener(onRequestClicked);
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
//                rlParentOfMyCurrent.setVisibility(View.GONE);
                hideElements(true);
            }

            @Override
            public void onMapSettled() {
                // Map settled
                Log.d("LOG", "MAP settled");
                LatLng current = googleMap.getCameraPosition().target;
                showElements();
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

        hideElements(false);

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
                googleMap.animateCamera(CameraUpdateFactory.newLatLngZoom(latLng, 15));

            }
        }

    }

    private View.OnClickListener onCurrentPinListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {

            if(currentLocation == null){
                isUserSetLocationFromWithPin = true;
                LatLng current = googleMap.getCameraPosition().target;
                String address = getAddress(current.latitude, current.longitude);
                etFrom.setText(address);
                currentLocation = current;
                currentAddress = address;

                tvTextViewInMyCurrent.setText(getString(R.string.set_destination_location_capital));
            }else{
                isUserSetLocationToWithPin = true;
                LatLng current = googleMap.getCameraPosition().target;
                String address = getAddress(current.latitude, current.longitude);
                etTo.setText(address);
                destinationLocation = current;
                destinationAddress = address;
            }

        }
    };

    private View.OnClickListener onMyLocationClicked = new View.OnClickListener() {
        @Override
        public void onClick(View v) {

            gotoMyLocation();

        }
    };

    private View.OnClickListener onCloseFromClicked = new View.OnClickListener() {
        @Override
        public void onClick(View v) {

            etFrom.setText("");
            etTo.setText("");
            currentLocation = null;
            currentAddress = null;
            destinationLocation = null;
            destinationAddress = null;
            tvTextViewInMyCurrent.setText(getString(R.string.set_pickup_location_capital));
            hideRlFromList();
            hideRlToList();

        }
    };

    private View.OnClickListener onShowMoreClicked = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            ShowMoreInMapDialog.startDialog(getActivity(), googleMap.getCameraPosition().target);
        }
    };

    private TextWatcher onEtFromTextWatchListener = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {}

        @Override
        public void afterTextChanged(final Editable s) {
            if(isUserSetLocationFromWithPin){
                isUserSetLocationFromWithPin = false;
                return;
            }
            nowCharacterFromLength = s.toString().length();
            if(s.toString().length() > 3){
                final int lastCharacterLength = s.toString().length();
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        if(lastCharacterLength == nowCharacterFromLength){
                            if(nowCharacterFromLength <= 3){
                                hideRlFromList();
                            }else{
                                showRlFromList(s.toString());
                            }
                        }
                    }
                }, WAIT_FOR_SEARCH_WHILE_TYPING);

            }else{
                hideRlFromList();
            }
        }
    };

    private TextWatcher onEtToTextWatchListener = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {}

        @Override
        public void afterTextChanged(final Editable s) {
            if(isUserSetLocationToWithPin){
                isUserSetLocationToWithPin = false;
                return;
            }
            nowCharacterToLength = s.toString().length();
            if(s.toString().length() > 3){
                final int lastCharacterLength = s.toString().length();
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        if(lastCharacterLength == nowCharacterToLength){
                            if(nowCharacterToLength <= 3){
                                hideRlToList();
                            }else{
                                showRlToList(s.toString());
                            }
                        }
                    }
                }, WAIT_FOR_SEARCH_WHILE_TYPING);

            }else{
                hideRlToList();
            }
        }
    };

    private View.OnClickListener onRequestClicked = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            requestTaxi();
        }
    };

    private AddressAdapter.OnAddressItemClicked onFromAddressListener = new AddressAdapter.OnAddressItemClicked() {
        @Override
        public void onAddressClicked(Address item) {
            isUserSetLocationFromWithPin = true;
            String addressString = Utils.formatAddress(item);
            etFrom.setText(addressString);
            currentLocation = new LatLng(item.getLatitude(), item.getLongitude());
            currentAddress = addressString;
            tvTextViewInMyCurrent.setText(getString(R.string.set_destination_location_capital));
            hideRlFromList();
            Utils.hideKeyboard(etFrom, getActivity());
        }
    };

    private AddressAdapter.OnAddressItemClicked onToAddressListener = new AddressAdapter.OnAddressItemClicked() {
        @Override
        public void onAddressClicked(Address item) {
            isUserSetLocationToWithPin = true;
            String addressString = Utils.formatAddress(item);
            etTo.setText(addressString);
            destinationLocation = new LatLng(item.getLatitude(), item.getLongitude());
            destinationAddress = addressString;
            hideRlToList();
            Utils.hideKeyboard(etTo, getActivity());
        }
    };

    private String getAddress(double latitude, double longitude) {
        StringBuilder result = new StringBuilder();
        try {
            Geocoder geocoder = new Geocoder(getActivity(), Locale.getDefault());
            List<Address> addresses = geocoder.getFromLocation(latitude, longitude, 1);
            if (addresses.size() > 0) {
                Address address = addresses.get(0);
                result.append(Utils.formatAddress(address));
            }
        } catch (IOException e) {
            Log.e("tag", e.getMessage());
        }

        return result.toString();
    }

    private void showRlToList(String search){
        ((AddressAdapter)rvToSearch.getAdapter()).setData(searchAddresses(search));
        rlForListTo.setVisibility(View.VISIBLE);
        viewBlackedOut.setVisibility(View.VISIBLE);
        rlFrom.setVisibility(View.INVISIBLE);
    }

    private void hideRlToList(){
        ((AddressAdapter)rvToSearch.getAdapter()).clearData();
        rlForListTo.setVisibility(View.GONE);
        viewBlackedOut.setVisibility(View.GONE);
        rlFrom.setVisibility(View.VISIBLE);
    }

    private void showRlFromList(String search){
        ((AddressAdapter)rvFromSearch.getAdapter()).setData(searchAddresses(search));
        rlForListFrom.setVisibility(View.VISIBLE);
        viewBlackedOut.setVisibility(View.VISIBLE);
        rlTo.setVisibility(View.GONE);
    }

    private void hideRlFromList(){
        ((AddressAdapter)rvFromSearch.getAdapter()).clearData();
        rlForListFrom.setVisibility(View.GONE);
        viewBlackedOut.setVisibility(View.GONE);
        rlTo.setVisibility(View.VISIBLE);
    }

    private List<Address> searchAddresses(String search) {
        Geocoder geoCoder = new Geocoder(getActivity(), Locale.getDefault());
        try {
            List<Address> addresses = geoCoder.getFromLocationName(search, 5);
            return addresses;
        } catch (IOException e) {
            e.printStackTrace();
        }

        return new ArrayList<>();
    }

    private void hideElements(boolean showSmallPin){
        if(showSmallPin) smallPin.setVisibility(View.VISIBLE);
        AnimationUtils.fade(rlParentOfMyCurrent, 1, 0, 300, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                rlParentOfMyCurrent.setVisibility(View.GONE);
            }
        });
        AnimationUtils.fadeThenGoneOrVisible(rlFromTo, 1, 0, 300);
    }

    private void showElements(){
        rlParentOfMyCurrent.setVisibility(View.VISIBLE);
        AnimationUtils.fade(rlParentOfMyCurrent, 0, 1, 300, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                smallPin.setVisibility(View.GONE);
            }
        });
        AnimationUtils.fadeThenGoneOrVisible(rlFromTo, 0, 1, 300);
    }

    private void requestTaxi(){
        if(currentLocation == null || currentAddress == null){
            BasicDialog.startOneButtonDialog(getActivity(), getString(R.string.error), getString(R.string.please_set_pick_up_location));
            return;
        }
        if(destinationLocation == null || destinationAddress == null){
            BasicDialog.startOneButtonDialog(getActivity(), getString(R.string.error), getString(R.string.please_set_destination_location));
            return;
        }

        SeatsNumberDialog.startDialog(getActivity(), new SeatsNumberDialog.OnItemClickedListener() {
            @Override
            public void onClicked(SeatsNumberDialog dialog, int numberOfSeats) {
                dialog.dismiss();
                RequestSentDialog.startDialog(getActivity(), currentLocation, destinationLocation, currentAddress, destinationAddress, numberOfSeats);
            }
        });

    }

}
