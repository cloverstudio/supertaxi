package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.UserRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.models.OrderModel;
import clover_studio.com.supertaxi.models.UserModel;
import clover_studio.com.supertaxi.models.post_models.PostRateModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.AnimationUtils;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.ImageUtils;
import clover_studio.com.supertaxi.utils.MapsUtils;
import clover_studio.com.supertaxi.utils.Utils;
import retrofit2.Call;
import retrofit2.Response;

public class LastTripDialogLikeActivity extends BaseActivity  implements OnMapReadyCallback {

    public static void startActivity(Activity activity, OrderModel order, UserModel driver){
        activity.startActivity(new Intent(activity, LastTripDialogLikeActivity.class)
                .putExtra(Const.Extras.ORDER_MODEL, order)
                .putExtra(Const.Extras.USER_MODEL, driver));
    }

    RelativeLayout parentLayout;
    RelativeLayout mainLayout;

    private ImageView ivAvatar;
    private TextView tvName;
    private TextView tvDate;
    private TextView tvPrice;
    private LinearLayout llStarLayout;

    GoogleMap googleMap;
    private FrameLayout layoutForMap;
    private OrderModel order;
    private UserModel driver;
    private boolean startClicked = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_last_trip);

        parentLayout = (RelativeLayout) findViewById(R.id.parentLayout);
        mainLayout = (RelativeLayout) findViewById(R.id.mainLayout);

        ivAvatar = (ImageView) findViewById(R.id.ivAvatarInDriverDetails);
        tvName = (TextView) findViewById(R.id.tvName);
        tvDate = (TextView) findViewById(R.id.tvLastTripDate);
        tvPrice = (TextView) findViewById(R.id.tvPriceValue);
        tvDate = (TextView) findViewById(R.id.tvLastTripDate);
        llStarLayout = (LinearLayout) findViewById(R.id.bigStarsLayout);
        layoutForMap = (FrameLayout) findViewById(R.id.frameForMapInDialog);

        order = getIntent().getParcelableExtra(Const.Extras.ORDER_MODEL);
        driver = getIntent().getParcelableExtra(Const.Extras.USER_MODEL);

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                SupportMapFragment mapFragment = new SupportMapFragment();
                getSupportFragmentManager().beginTransaction().add(layoutForMap.getId(), mapFragment, "TAG").commit();
                mapFragment.getMapAsync(LastTripDialogLikeActivity.this);
            }
        }, 600);

        animateLayout();

        for(int i = 0; i < llStarLayout.getChildCount(); i++){
            llStarLayout.getChildAt(i).setTag(i + 1);
            llStarLayout.getChildAt(i).setOnClickListener(onStarsClicked);
        }

        String url = Utils.getAvatarUrl(driver);
        ImageUtils.setImageWithPicasso(ivAvatar, url);

        tvName.setText(driver.driver.name);
        tvDate.setText(Utils.getDate(System.currentTimeMillis(), Const.DateFormat.DAY_WITH_TIME_FORMAT));

    }

    private View.OnClickListener onStarsClicked = new View.OnClickListener() {
        @Override
        public void onClick(View v) {

            if(startClicked) {
                return;
            }
            startClicked = true;
            Integer tag = (Integer) v.getTag();
            for(int i = 0; i < tag; i++){
                if(i < llStarLayout.getChildCount()){
                    llStarLayout.getChildAt(i).setSelected(true);
                }
            }
            rateProfileApi(tag, driver._id);

        }
    };

    private void animateLayout(){
        AnimationUtils.fade(mainLayout, 0, 1, 300, null);
    }

    @Override
    public void onMapReady(final GoogleMap googleMap) {
        this.googleMap = googleMap;

        LatLng startLocation = new LatLng(order.from.location.get(1), order.from.location.get(0));
        LatLng destinationLocation = new LatLng(order.to.location.get(1), order.to.location.get(0));

        if(startLocation != null && destinationLocation != null){

            List<LatLng> listLocation = new ArrayList<>();
            listLocation.add(startLocation);
            listLocation.add(destinationLocation);

            LatLngBounds bounds = MapsUtils.getSouthWestAndNorthEast(listLocation);

            googleMap.addMarker(new MarkerOptions().position(startLocation));
            googleMap.addMarker(new MarkerOptions().position(destinationLocation));

            googleMap.moveCamera(CameraUpdateFactory.newLatLngBounds(bounds, 100));
            googleMap.getUiSettings().setScrollGesturesEnabled(false);
            googleMap.getUiSettings().setZoomGesturesEnabled(false);
            googleMap.getUiSettings().setZoomControlsEnabled(false);

            MapsUtils.calculateRoute(startLocation, destinationLocation, new MapsUtils.OnRouteCalculated() {
                @Override
                public void onSuccessCalculate(List<LatLng> list, String distance, long distanceValue, String duration, long durationValue, LatLng northeast, LatLng southwest) {
                    MapsUtils.drawPolyLines(list, googleMap, false);

                    double price = 0;
                    int pricePerKm = driver.driver.fee_km;
                    int startPrice = driver.driver.fee_start;

                    if(distanceValue < 1000){
                        price = pricePerKm + startPrice;
                    }else{
                        double pricePerMeter = (double) pricePerKm / 1000.0;
                        price = (double) startPrice + (pricePerMeter * distanceValue);
                    }

                    tvPrice.setText(String.format("$%.2f", price));

                }
            }, getActivity());

        }

    }

    private void rateProfileApi(final int rate, final String userId){
        PostRateModel postModel = new PostRateModel(userId, Const.UserType.USER_TYPE_DRIVER, rate);
        UserRetroApiInterface retroApiInterface = getRetrofit().create(UserRetroApiInterface.class);
        Call<BaseModel> call = retroApiInterface.rateProfile(postModel, UserSingleton.getInstance().getUser().token_new);
        call.enqueue(new CustomResponse<BaseModel>(getActivity(), true, true) {

            @Override
            public void onCustomSuccess(Call<BaseModel> call, Response<BaseModel> response) {
                super.onCustomSuccess(call, response);

                finish();

            }

            @Override
            public void onTryAgain(Call<BaseModel> call, Response<BaseModel> response) {
                super.onTryAgain(call, response);
                rateProfileApi(rate, userId);
            }

        });
    }

}
