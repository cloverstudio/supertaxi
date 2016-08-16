package clover_studio.com.supertaxi.fragments;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
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
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polyline;
import com.squareup.picasso.Callback;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.DriverRetroApiInterface;
import clover_studio.com.supertaxi.api.retrofit.UserRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseFragment;
import clover_studio.com.supertaxi.base.SuperTaxiApp;
import clover_studio.com.supertaxi.dialog.BasicDialog;
import clover_studio.com.supertaxi.dialog.DialogUserRequestDetails;
import clover_studio.com.supertaxi.dialog.RateUserDialog;
import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.models.CheckOrderStatusModel;
import clover_studio.com.supertaxi.models.DriverListResponse;
import clover_studio.com.supertaxi.models.GetOpenOrderModel;
import clover_studio.com.supertaxi.models.OrderModel;
import clover_studio.com.supertaxi.models.post_models.PostAcceptOrderModel;
import clover_studio.com.supertaxi.models.post_models.PostCancelTripModel;
import clover_studio.com.supertaxi.models.post_models.PostCheckOrderStatusModel;
import clover_studio.com.supertaxi.models.post_models.PostLatLngModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.AnimationUtils;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.ImageUtils;
import clover_studio.com.supertaxi.utils.LocationSourceListener;
import clover_studio.com.supertaxi.utils.LogCS;
import clover_studio.com.supertaxi.utils.MapsUtils;
import clover_studio.com.supertaxi.utils.Utils;
import clover_studio.com.supertaxi.view.cropper.cropwindow.handle.Handle;
import clover_studio.com.supertaxi.view.touchable_map.MapStateListener;
import clover_studio.com.supertaxi.view.touchable_map.TouchableMapFragment;
import retrofit2.Call;
import retrofit2.Response;

/**
 * Created by ivoperic on 13/07/16.
 */
public class DriverMainFragment extends BaseFragment implements OnMapReadyCallback, GoogleMap.OnMarkerClickListener {

    GoogleMap googleMap;

    private FrameLayout layoutForMap;
    private ProgressBar loadingProgress;
    private TouchableMapFragment mapFragment;
    private RelativeLayout rlUserDetails;
    private LinearLayout llButtons;
    private RelativeLayout rlStartEndTripLayout;
    private TextView tvDistance;

    private Location myLocation = null;
    private List<Marker> otherTaxiMarkers = new ArrayList<>();
    private LocationSourceListener locationSourceListener;
    private Geocoder geocoder;

    private int screenStatus = Const.MainDriverStatus.PENDING;
    private OrderModel acceptedOrder = null;

    private Polyline lastPolyline = null;
    private List<Polyline> alternativesPolyline = null;
    private Marker driverMarker = null;
    private Marker driverDestinationMarker = null;
    private Polyline onAcceptLastPolyline = null;
    private Marker onAcceptDriverMarker = null;
    private Marker onAcceptDestinationMarker = null;

    private Handler handlerForCheck = new Handler();

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

        checkForOpenOrder();
        checkForOtherTaxi();

        return rootView;
    }

    @Override
    public void onResume() {
        super.onResume();
        locationSourceListener.getBestAvailableProvider();
        if(googleMap != null){
            googleMap.setLocationSource(locationSourceListener);
        }
        if(stopChecking == true){
            stopChecking = false;
            checkAfterFiveSeconds();
            if(acceptedOrder != null){
                checkOrderStatus(acceptedOrder);
            }
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

    private void initViews(View rootView){
        layoutForMap = (FrameLayout) rootView.findViewById(R.id.frameForMap);
        loadingProgress = (ProgressBar) rootView.findViewById(R.id.progressBarLoading);
        rlUserDetails = (RelativeLayout) rootView.findViewById(R.id.rlUserDetails);
        llButtons = (LinearLayout) rootView.findViewById(R.id.llButtons);
        rlStartEndTripLayout = (RelativeLayout) rootView.findViewById(R.id.rlButtonsStartEndTrip);
        tvDistance = (TextView) rootView.findViewById(R.id.tvDistance);

        ImageView avatar = (ImageView) rootView.findViewById(R.id.ivAvatar);
        int sizeForAvatar = getResources().getDisplayMetrics().widthPixels / 2;
        avatar.getLayoutParams().height = sizeForAvatar;
        avatar.getLayoutParams().width = sizeForAvatar;
    }

    private void fillWithUserRequestInfo(OrderModel model){
        TextView tvName = (TextView) rlUserDetails.findViewById(R.id.tvName);
        TextView tvAddressFrom = (TextView) rlUserDetails.findViewById(R.id.tvAddressFrom);
        TextView tvAddressTo = (TextView) rlUserDetails.findViewById(R.id.tvAddressTo);

        tvName.setText(model.user.user.name);
        tvAddressFrom.setText(getString(R.string.from_) + " " + model.from.address);
        tvAddressTo.setText(getString(R.string.to_) + " " + model.to.address);

        ImageView ivAvatar = (ImageView) rlUserDetails.findViewById(R.id.ivAvatar);
        String url = Utils.getAvatarUrl(model.user);
        ImageUtils.setImageWithPicasso(ivAvatar, url);

        animateUserLayout();
    }

    private void animateUserLayout(){
        rlUserDetails.setVisibility(View.VISIBLE);

        AnimationUtils.translateY(rlUserDetails, -getResources().getDisplayMetrics().heightPixels / 2, 0, 300, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                MapsUtils.setMapParentLayoutParams(rlUserDetails.getHeight(), llButtons.getHeight(), layoutForMap);
            }
        });
        llButtons.setVisibility(View.VISIBLE);
        AnimationUtils.translateY(llButtons, TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 50, getResources().getDisplayMetrics()), 0, 300, null);
    }

    private void animateBackUserLayout(boolean returnToPendingScreen){

        if(returnToPendingScreen){
            screenStatus = Const.MainDriverStatus.PENDING;
        }

        MapsUtils.setMapParentLayoutParams(0, 0, layoutForMap);

        googleMap.clear();
        gotoMyLocation();

        AnimationUtils.translateY(rlUserDetails, 0, -getResources().getDisplayMetrics().heightPixels / 2, 300, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);

                llButtons.setVisibility(View.GONE);
                rlUserDetails.setVisibility(View.GONE);
                ImageView ivAvatar = (ImageView) rlUserDetails.findViewById(R.id.ivAvatar);
                ivAvatar.setImageDrawable(null);
            }
        });
        AnimationUtils.translateY(llButtons, 0, TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 50, getResources().getDisplayMetrics()), 300, null);
    }

    private void acceptOrderLayoutInteract(OrderModel model){
        screenStatus = Const.MainDriverStatus.ORDER_ACCEPTED;

        MapsUtils.setMapParentLayoutParams(0, 0, layoutForMap);

        AnimationUtils.translateY(rlUserDetails, 0, -getResources().getDisplayMetrics().heightPixels / 2, 300, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);

                llButtons.setVisibility(View.GONE);
                rlUserDetails.setVisibility(View.GONE);
                ImageView ivAvatar = (ImageView) rlUserDetails.findViewById(R.id.ivAvatar);
                ivAvatar.setImageDrawable(null);

                setStartTripLayout();
            }
        });
        AnimationUtils.translateY(llButtons, 0, TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 50, getResources().getDisplayMetrics()), 300, null);

        drawRoute(Const.DrawRouteDriverTypes.ON_ACCEPTED_ORDER, model, 100);
    }

    private void setStartTripLayout(){
        rlStartEndTripLayout.setVisibility(View.VISIBLE);
        AnimationUtils.translateY(rlStartEndTripLayout, TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 50, getResources().getDisplayMetrics()), 0, 300, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                MapsUtils.setMapParentLayoutParams(null, rlStartEndTripLayout.getHeight(), layoutForMap);
            }
        });

        Button startTrip = (Button) rlStartEndTripLayout.findViewById(R.id.buttonStartTrip);
        startTrip.setOnClickListener(onStartTripButtonClicked);

        TextView tvDistanceLabel = (TextView) rlStartEndTripLayout.findViewById(R.id.tvDistanceLabel);
        tvDistanceLabel.setText(getString(R.string.distance_between__user_and_you_));
    }

    private void animateBackStartTrip(){

        MapsUtils.setMapParentLayoutParams(null, 0, layoutForMap);

        AnimationUtils.translateY(rlStartEndTripLayout, 0, TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 50, getResources().getDisplayMetrics()), 300, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                rlStartEndTripLayout.setVisibility(View.GONE);
                Button endTrip = (Button) rlStartEndTripLayout.findViewById(R.id.buttonEndTrip);
                Button startTrip = (Button) rlStartEndTripLayout.findViewById(R.id.buttonStartTrip);
                startTrip.setVisibility(View.VISIBLE);
                AnimationUtils.fade(startTrip, 1, 1, 0, null);
                endTrip.setVisibility(View.GONE);
            }
        });
    }

    private void setEndTripButton(){
        final Button endTrip = (Button) rlStartEndTripLayout.findViewById(R.id.buttonEndTrip);
        final Button startTrip = (Button) rlStartEndTripLayout.findViewById(R.id.buttonStartTrip);
        AnimationUtils.fade(startTrip, 1, 0, 150, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                startTrip.setVisibility(View.INVISIBLE);
                endTrip.setVisibility(View.VISIBLE);
                AnimationUtils.fade(endTrip, 0, 1, 150, null);
            }
        });
        endTrip.setOnClickListener(onEndClickListener);

        TextView tvDistanceLabel = (TextView) rlStartEndTripLayout.findViewById(R.id.tvDistanceLabel);
        tvDistanceLabel.setText(getString(R.string.mileage_));

        tvDistance.setText("0 km");
    }

    private View.OnClickListener onStartTripButtonClicked = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            manageOrder(Const.ManageOrderType.ARRIVED_TIME, acceptedOrder);
            manageOrder(Const.ManageOrderType.STARTED_TIME, acceptedOrder);
        }
    };

    private View.OnClickListener onEndClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            manageOrder(Const.ManageOrderType.FINISHED_TIME, acceptedOrder);
        }
    };

    @SuppressWarnings("MissingPermission")
    @Override
    public void onMapReady(final GoogleMap googleMap) {
        loadingProgress.setVisibility(View.GONE);

        this.googleMap = googleMap;

        googleMap.setLocationSource(locationSourceListener);
        googleMap.setMyLocationEnabled(true);
        googleMap.getUiSettings().setMyLocationButtonEnabled(true);
        googleMap.setOnMarkerClickListener(this);

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

    @Override
    public boolean onMarkerClick(Marker marker) {
        if(acceptedOrder != null){
            if(marker.getSnippet() != null && marker.getSnippet().equals(acceptedOrder._id)){
                DialogUserRequestDetails.startDialog(getActivity(), acceptedOrder, screenStatus);
            }
        }
        return false;
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
                updateCoordinates(new LatLng(myLocation.getLatitude(), myLocation.getLongitude()));
            }
        }

    }

    private LocationSourceListener.OnMyLocationChangedListener onMyLocationChangedListener = new LocationSourceListener.OnMyLocationChangedListener() {
        @Override
        public void onLocationChanged(Location myLocationNew) {
            myLocation = myLocationNew;
            Log.d("LOG_IVO", "MY LOCATION: " + myLocation.getLatitude() + ", " + myLocation.getLongitude());
            updateCoordinates(new LatLng(myLocation.getLatitude(), myLocationNew.getLongitude()));

            if(screenStatus == Const.MainDriverStatus.START_TRIP){
                LogCS.i("LOG", "UPDATE START TRIP");
                drawRoute(Const.DrawRouteDriverTypes.STARTED_DRIVE_WITHOUT_ALTERNATIVES, acceptedOrder, 100);
            }if(screenStatus == Const.MainDriverStatus.ORDER_ACCEPTED){
                LogCS.i("LOG", "UPDATE ORDER ACCEPTED");
                drawRoute(Const.DrawRouteDriverTypes.ON_ACCEPTED_ORDER, acceptedOrder, 100);
            }
        }
    };

    private boolean stopChecking = false;
    private void checkForOpenOrder(){
        if(screenStatus != Const.MainDriverStatus.PENDING){
            checkAfterFiveSeconds();
            return;
        }
        if(stopChecking){
            return;
        }

        if(myLocation == null){
            checkAfterFiveSeconds();
            return;
        }

        PostLatLngModel postModel = new PostLatLngModel(myLocation.getLatitude(), myLocation.getLongitude());
        DriverRetroApiInterface retroApiInterface = getRetrofit().create(DriverRetroApiInterface.class);
        Call<GetOpenOrderModel> call = retroApiInterface.getOpenOrder(postModel, UserSingleton.getInstance().getUser().token_new);
        call.enqueue(new CustomResponse<GetOpenOrderModel>(getActivity(), false, false) {

            @Override
            public void onCustomSuccess(Call<GetOpenOrderModel> call, Response<GetOpenOrderModel> response) {
                super.onCustomSuccess(call, response);

                final GetOpenOrderModel model = response.body();

                LogCS.i("LOG", "Get open order: " + model.data.order);

                if(model.data.order != null){

                    screenStatus = Const.MainDriverStatus.OPEN_ORDER_SHOWED;

                    fillWithUserRequestInfo(model.data.order);
                    drawRoute(Const.DrawRouteDriverTypes.ON_OPEN_ORDER_SHOWED, model.data.order, 50);

                    checkOrderStatus(model.data.order);

                    Button ignore = (Button) llButtons.findViewById(R.id.buttonIgnore);
                    Button accept = (Button) llButtons.findViewById(R.id.buttonAccept);

                    ignore.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            manageOrder(Const.ManageOrderType.IGNORE_ORDER, model.data.order);
                            googleMap.clear();
                        }
                    });

                    accept.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            manageOrder(Const.ManageOrderType.ACCEPT_ORDER, model.data.order);;
                        }
                    });

                }

                checkAfterFiveSeconds();

            }

            @Override
            public void onCustomFailed(Call<GetOpenOrderModel> call, Response<GetOpenOrderModel> response) {
                super.onCustomFailed(call, response);
                checkAfterFiveSeconds();
            }
        });
    }

    private void checkForOtherTaxi(){
        if(screenStatus != Const.MainDriverStatus.PENDING){
            return;
        }
        if(stopChecking){
            return;
        }

        if(myLocation == null){
            return;
        }

        PostLatLngModel postModel = new PostLatLngModel(myLocation.getLatitude(), myLocation.getLongitude());
        DriverRetroApiInterface retroApiInterface = getRetrofit().create(DriverRetroApiInterface.class);
        Call<DriverListResponse> call = retroApiInterface.getDriverList(postModel, UserSingleton.getInstance().getUser().token_new);
        call.enqueue(new CustomResponse<DriverListResponse>(getActivity(), false, false) {

            @Override
            public void onCustomSuccess(Call<DriverListResponse> call, Response<DriverListResponse> response) {
                super.onCustomSuccess(call, response);

                LogCS.i("LOG", "Get other taxi");

                for(Marker item : otherTaxiMarkers){
                    item.remove();
                }

                for(DriverListResponse.DriverData item : response.body().data.drivers){
                    if(item.currentLocation != null && item.currentLocation.length > 1){

                        if(!item._id.equals(Utils.getMyId())){
                            Marker newMarker = googleMap.addMarker(new MarkerOptions()
                                    .icon(BitmapDescriptorFactory.fromResource(R.drawable.map_car)).rotation(90).position(new LatLng(item.currentLocation[1], item.currentLocation[0])));
                            otherTaxiMarkers.add(newMarker);
                        }
                    }
                }

            }

            @Override
            public void onCustomFailed(Call<DriverListResponse> call, Response<DriverListResponse> response) {
                super.onCustomFailed(call, response);
                checkForOtherTaxi();
            }
        });
    }

    private void checkOrderStatus(final OrderModel orderModel){
        if(screenStatus == Const.MainDriverStatus.PENDING){
            return;
        }
        if(stopChecking){
            return;
        }
        PostCheckOrderStatusModel postModel = new PostCheckOrderStatusModel(orderModel._id);
        UserRetroApiInterface retroApiInterface = getRetrofit().create(UserRetroApiInterface.class);
        Call<CheckOrderStatusModel> call = retroApiInterface.checkOrderStatus(postModel, UserSingleton.getInstance().getUser().token_new);
        call.enqueue(new CustomResponse<CheckOrderStatusModel>(getActivity(), false, false) {

            @Override
            public void onCustomSuccess(Call<CheckOrderStatusModel> call, Response<CheckOrderStatusModel> response) {
                super.onCustomSuccess(call, response);

                LogCS.i("LOG", "Order status: " + response.body().data.orderStatus);

                if(screenStatus == Const.MainDriverStatus.PENDING){
                    return;
                }

                if(response.body().data.orderStatus == Const.OrderStatusTypes.CANCELED){
                    BasicDialog.startOneButtonDialog(getActivity(), getString(R.string.info), getString(R.string.user_canceled_order));
                    animateBackUserLayout(true);
                    if(rlStartEndTripLayout.getVisibility() == View.VISIBLE){
                        animateBackStartTrip();
                    }
                }else{
                    checkOrderStatus(orderModel);
                }

            }

            @Override
            public void onCustomFailed(Call<CheckOrderStatusModel> call, Response<CheckOrderStatusModel> response) {
                super.onCustomFailed(call, response);
                checkOrderStatus(orderModel);
            }
        });
    }

    private void drawRoute(final int type, OrderModel model, final int paddingMap){
        if(type != Const.DrawRouteDriverTypes.STARTED_DRIVE_WITHOUT_ALTERNATIVES
                && type != Const.DrawRouteDriverTypes.ON_ACCEPTED_ORDER){
            googleMap.clear();
        }
        if(myLocation != null){

            final LatLng locationFrom = new LatLng(model.from.location.get(1), model.from.location.get(0));
            final LatLng locationTo = new LatLng(model.to.location.get(1), model.to.location.get(0));
            final LatLng myLocationLatLng = new LatLng(myLocation.getLatitude(), myLocation.getLongitude());

            if(type == Const.DrawRouteDriverTypes.STARTED_DRIVE_WITH_ALTERNATIVES){
                MapsUtils.calculateRouteWithAlternatives(myLocationLatLng, locationTo, new MapsUtils.OnRouteWithAlternativesCalculated() {
                    @Override
                    public void onSuccessCalculate(List<List<LatLng>> list, String distance, long distanceValue) {

                        tvDistance.setText(distance);

                        alternativesPolyline = new ArrayList<>();
                        int i = 1;
                        for(List<LatLng> item : list){
                            Polyline itemPoly = null;
                            if(i == 1){
                                itemPoly = MapsUtils.drawPolyLines(item, googleMap, true, paddingMap);
                            }else{
                                itemPoly = MapsUtils.drawPolyLinesAlternative(item, googleMap, true, paddingMap);
                            }
                            i ++;
                            if(itemPoly != null) alternativesPolyline.add(itemPoly);
                        }

                        if(driverMarker != null){
                            driverMarker.setPosition(myLocationLatLng);
                        }else{
                            driverMarker = googleMap.addMarker(new MarkerOptions().icon(BitmapDescriptorFactory.fromResource(R.drawable.map_car)).position(myLocationLatLng).rotation(90));
                        }
                        if(driverDestinationMarker == null){
                            driverDestinationMarker = googleMap.addMarker(new MarkerOptions().position(locationTo).snippet(""));
                        }
                    }
                }, getActivity());
            }else if(type == Const.DrawRouteDriverTypes.STARTED_DRIVE_WITHOUT_ALTERNATIVES){
                MapsUtils.calculateRoute(myLocationLatLng, locationTo, new MapsUtils.OnRouteCalculated() {

                    @Override
                    public void onSuccessCalculate(List<LatLng> list, String distance, long distanceValue) {

                        tvDistance.setText(distance);

                        final Polyline newPolyline = MapsUtils.drawPolyLines(list, googleMap, false, paddingMap);

                        if(driverMarker != null){
                            driverMarker.setPosition(myLocationLatLng);
                        }else{
                            driverMarker = googleMap.addMarker(new MarkerOptions().icon(BitmapDescriptorFactory.fromResource(R.drawable.map_car)).position(myLocationLatLng).rotation(90));
                        }
                        if(driverDestinationMarker == null){
                            driverDestinationMarker = googleMap.addMarker(new MarkerOptions().position(locationTo).snippet(""));
                        }

                        if(alternativesPolyline != null && alternativesPolyline.size() > 0){
                            for(Polyline item : alternativesPolyline){
                                item.remove();
                            }
                            alternativesPolyline.clear();
                        }

                        if(lastPolyline != null){
                            lastPolyline.remove();
                        }
                        lastPolyline = newPolyline;
                    }
                }, getActivity());
            }else if(type == Const.DrawRouteDriverTypes.ON_ACCEPTED_ORDER){
                MapsUtils.calculateRoute(myLocationLatLng, locationFrom, new MapsUtils.OnRouteCalculated() {
                    @Override
                    public void onSuccessCalculate(List<LatLng> list, String distance, long distanceValue) {

                        tvDistance.setText(distance);

                        if(onAcceptDriverMarker == null){
                            googleMap.clear();
                            onAcceptDriverMarker = googleMap.addMarker(new MarkerOptions().icon(BitmapDescriptorFactory.fromResource(R.drawable.map_car)).position(myLocationLatLng).rotation(90));
                        }else{
                            onAcceptDriverMarker.setPosition(myLocationLatLng);
                        }

                        Polyline newPolyline = MapsUtils.drawPolyLines(list, googleMap, true, paddingMap);

                        if(acceptedOrder != null){
                            if(onAcceptDestinationMarker == null){
                                final ImageView ivTemp = new ImageView(getActivity());
                                ImageUtils.setImageWithPicassoWithListener(ivTemp, Utils.getAvatarUrl(acceptedOrder.user), new Callback() {
                                    @Override
                                    public void onSuccess() {
                                        Bitmap bitmap = MapsUtils.getBitmapWithGreenPin(getActivity(), ((BitmapDrawable)ivTemp.getDrawable()).getBitmap());
                                        onAcceptDestinationMarker = googleMap.addMarker(new MarkerOptions().position(locationFrom).snippet(acceptedOrder._id).icon(BitmapDescriptorFactory.fromBitmap(bitmap)));
                                    }

                                    @Override
                                    public void onError() {
                                        onAcceptDestinationMarker = googleMap.addMarker(new MarkerOptions().position(locationFrom).snippet(acceptedOrder._id));
                                    }
                                });
                            }
                        }

                        if(onAcceptLastPolyline != null){
                            onAcceptLastPolyline.remove();
                        }
                        onAcceptLastPolyline = newPolyline;

                    }
                }, getActivity());
            }else {
                MapsUtils.calculateRoute(myLocationLatLng, locationFrom, new MapsUtils.OnRouteCalculated() {
                    @Override
                    public void onSuccessCalculate(List<LatLng> list, String distance, long distanceValue) {
                        googleMap.clear();
                        MapsUtils.drawPolyLines(list, googleMap, true, paddingMap);
                        googleMap.addMarker(new MarkerOptions().position(locationFrom).snippet(""));
                        googleMap.addMarker(new MarkerOptions().icon(BitmapDescriptorFactory.fromResource(R.drawable.map_car)).position(myLocationLatLng).rotation(90));
                    }
                }, getActivity());
            }

        }
    }

    private void checkAfterFiveSeconds(){
        LogCS.i("LOG", "Start checker screen: " + screenStatus);
        handlerForCheck.postDelayed(new Runnable() {
            @Override
            public void run() {
                checkForOpenOrder();
                checkForOtherTaxi();
            }
        }, 5000);
    }

    private void manageOrder(final int type, final OrderModel order){

        if(!Utils.checkForOrderType(type)){
            return;
        }

        final PostAcceptOrderModel postModel = new PostAcceptOrderModel(order._id);
        final DriverRetroApiInterface retroApiInterface = getRetrofit().create(DriverRetroApiInterface.class);
        Call<BaseModel> call = null;
        if(type == Const.ManageOrderType.STARTED_TIME){
            call = retroApiInterface.updateStartTime(postModel, UserSingleton.getInstance().getUser().token_new);
        }else if(type == Const.ManageOrderType.FINISHED_TIME){
            call = retroApiInterface.updateFinishTime(postModel, UserSingleton.getInstance().getUser().token_new);
        }else if(type == Const.ManageOrderType.ARRIVED_TIME){
            call = retroApiInterface.updateArriveTime(postModel, UserSingleton.getInstance().getUser().token_new);
        }else if(type == Const.ManageOrderType.ACCEPT_ORDER){
            call = retroApiInterface.acceptOrder(postModel, UserSingleton.getInstance().getUser().token_new);
        }else if(type == Const.ManageOrderType.IGNORE_ORDER){
            PostCancelTripModel postModelCancel = new PostCancelTripModel(order._id, Const.CancelTypes.DRIVER_CANCELED, "");
            call = retroApiInterface.cancelTrip(postModelCancel, UserSingleton.getInstance().getUser().token_new);
        }

        if (call == null){
            return;
        }

        call.enqueue(new CustomResponse<BaseModel>(getActivity(), true, true) {

            @Override
            public void onCustomSuccess(Call<BaseModel> call, Response<BaseModel> response) {
                super.onCustomSuccess(call, response);
                if(type == Const.ManageOrderType.STARTED_TIME){
                    onUpdateStartedTimeSuccess(order);
                }else if(type == Const.ManageOrderType.FINISHED_TIME){
                    onUpdateFinishedTimeSuccess(order);
                }else if(type == Const.ManageOrderType.ARRIVED_TIME){
                    onUpdateArrivedTimeSuccess(order);
                }else if(type == Const.ManageOrderType.ACCEPT_ORDER){
                    onAcceptedSuccess(order);
                }else if(type == Const.ManageOrderType.IGNORE_ORDER){
                    onIgnoreSuccess(order);
                }
            }

            @Override
            public void onTryAgain(Call<BaseModel> call, Response<BaseModel> response) {
                super.onTryAgain(call, response);
                if(response.body().code == Const.ErrorCodes.ALREADY_STARTED_OR_CANCELED
                        || response.body().code == Const.ErrorCodes.ALREADY_ACCEPTED_OR_CANCELED){
                    animateBackUserLayout(true);
                }else{
                    manageOrder(type, order);
                }
            }

            @Override
            public void onCustomFailed(Call<BaseModel> call, Response<BaseModel> response) {
                if(response.body().code == Const.ErrorCodes.ALREADY_STARTED_OR_CANCELED
                        || response.body().code == Const.ErrorCodes.ALREADY_ACCEPTED_OR_CANCELED){
                    animateBackUserLayout(true);
                }else{
                    super.onCustomFailed(call, response);
                }
            }
        });
    }

    private void onAcceptedSuccess(OrderModel order){
        acceptedOrder = order;
        acceptOrderLayoutInteract(order);
    }

    private void onIgnoreSuccess(OrderModel order){
        animateBackUserLayout(true);
    }

    private void onUpdateArrivedTimeSuccess(OrderModel order){

    }

    private void onUpdateStartedTimeSuccess(OrderModel order){
        googleMap.clear();
        setEndTripButton();
        screenStatus = Const.MainDriverStatus.START_TRIP;

        drawRoute(Const.DrawRouteDriverTypes.STARTED_DRIVE_WITH_ALTERNATIVES, acceptedOrder, 100);
    }

    private void onUpdateFinishedTimeSuccess(OrderModel order){
        driverDestinationMarker = null;
        driverMarker = null;
        lastPolyline = null;
        alternativesPolyline.clear();
        onAcceptDestinationMarker = null;
        onAcceptDriverMarker = null;
        onAcceptLastPolyline = null;
        googleMap.clear();
        gotoMyLocation();
        screenStatus = Const.MainDriverStatus.PENDING;
        animateBackStartTrip();
        RateUserDialog.startDialog(getActivity(), order);
    }

    private void updateCoordinates(LatLng newLocation){
        PostLatLngModel postModel = new PostLatLngModel(newLocation.latitude, newLocation.longitude);

        UserRetroApiInterface retroApiInterface = getRetrofit().create(UserRetroApiInterface.class);
        Call<BaseModel> call = retroApiInterface.updateCoordinates(postModel, UserSingleton.getInstance().getUser().token_new);
        call.enqueue(new CustomResponse<BaseModel>(getActivity(), false, false) {});
    }

    public void cancelTripClearMap(){
        if(acceptedOrder != null){
            driverDestinationMarker = null;
            driverMarker = null;
            lastPolyline = null;
            alternativesPolyline.clear();
            onAcceptDestinationMarker = null;
            onAcceptDriverMarker = null;
            onAcceptLastPolyline = null;
            screenStatus = Const.MainDriverStatus.PENDING;
            manageOrder(Const.ManageOrderType.IGNORE_ORDER, acceptedOrder);
            if(rlStartEndTripLayout.getVisibility() == View.VISIBLE){
                animateBackStartTrip();
            }
            acceptedOrder = null;
        }
    }

}
