package clover_studio.com.supertaxi.dialog;

import android.Manifest;
import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.util.TypedValue;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.android.gms.maps.model.LatLng;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.DriverRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.models.CallTaxiModel;
import clover_studio.com.supertaxi.models.DriverListResponse;
import clover_studio.com.supertaxi.models.OrderModel;
import clover_studio.com.supertaxi.models.UserModel;
import clover_studio.com.supertaxi.models.post_models.PostCallTaxiModel;
import clover_studio.com.supertaxi.models.post_models.PostCancelTripModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.AnimationUtils;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.ImageUtils;
import clover_studio.com.supertaxi.utils.Utils;
import clover_studio.com.supertaxi.view.CustomButton;
import retrofit2.Call;
import retrofit2.Response;

public class DriverDetailsDialog extends Dialog {

    RelativeLayout parentLayout;
    RelativeLayout mainLayout;

    private ImageView ivAvatar;
    private TextView tvName;
    private TextView tvCarType;
    private TextView tvCarReg;
    private TextView tvStartFee;
    private TextView tvKMFee;
    private TextView tvMobile;
    private TextView tvRating;
    private LinearLayout llStarLayout;
    private LinearLayout llButtons;
    private CustomButton closeButton;

    private OrderModel order;
    private UserModel driver;
    private DriverListResponse.DriverData driverData;

    public static DriverDetailsDialog startDialog(Context context, OrderModel order, UserModel driver) {
        return new DriverDetailsDialog(context, order, driver, null);
    }

    public static DriverDetailsDialog startDialog(Context context, DriverListResponse.DriverData driverData) {
        return new DriverDetailsDialog(context, null, null, driverData);
    }

    public DriverDetailsDialog(Context context, OrderModel order, UserModel driver, DriverListResponse.DriverData driverData) {
        super(context, R.style.Theme_Dialog_no_dim);

        setOwnerActivity((Activity) context);
        setCancelable(true);
        setCanceledOnTouchOutside(true);

        this.order = order;
        this.driver = driver;
        this.driverData = driverData;

        show();

        if(order==null) {
            llButtons.setVisibility(View.INVISIBLE);
            closeButton.setVisibility(View.VISIBLE);

        }

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_driver_details);

        parentLayout = (RelativeLayout) findViewById(R.id.parentLayout);
        mainLayout = (RelativeLayout) findViewById(R.id.mainLayout);

        ivAvatar = (ImageView) findViewById(R.id.ivAvatarInDriverDetails);
        tvName = (TextView) findViewById(R.id.tvName);
        tvCarType = (TextView) findViewById(R.id.tvCarTypeValue);
        tvCarReg = (TextView) findViewById(R.id.tvCarRegValue);
        tvStartFee = (TextView) findViewById(R.id.tvStartFeeValue);
        tvKMFee = (TextView) findViewById(R.id.tvKMFeeValue);
        tvMobile = (TextView) findViewById(R.id.tvMobileValue);
        tvRating = (TextView) findViewById(R.id.tvKRatingValue);
        llStarLayout = (LinearLayout) findViewById(R.id.ratingStars);
        llButtons=(LinearLayout) findViewById(R.id.llButtons);
        closeButton = (CustomButton) findViewById(R.id.fullWidthCloseButton);

        if(driverData != null){
            String urlAvatar = Utils.getAvatarUrl(driverData);
            ImageUtils.setImageWithPicasso(ivAvatar, urlAvatar);

            tvName.setText(driverData.driver.name);
            tvCarReg.setText(driverData.driver.car_registration);
            tvCarType.setText(driverData.driver.car_type);
            tvStartFee.setText(String.valueOf(driverData.driver.fee_start));
            tvKMFee.setText(String.valueOf(driverData.driver.fee_km));
            tvMobile.setText(driverData.telNum);
            tvRating.setText(String.format("%.1f", driverData.averageRate));

            int rating = (int) Math.round(driverData.averageRate);
            if (rating > llStarLayout.getChildCount()) {
                rating = llStarLayout.getChildCount();
            }
            for (int i = 0; i < rating; i++) {
                llStarLayout.getChildAt(i).setSelected(true);
            }

            findViewById(R.id.fullWidthCloseButton).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    DriverDetailsDialog.this.dismiss();
                }
            });

            findViewById(R.id.buttonCancelTrip).setVisibility(View.INVISIBLE);

            ((View) tvMobile.getParent()).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Utils.contactUserWithNum(getOwnerActivity(), tvMobile.getText().toString());
                }
            });

        }else{
            String urlAvatar = Utils.getAvatarUrl(driver);
            ImageUtils.setImageWithPicasso(ivAvatar, urlAvatar);

            tvName.setText(driver.driver.name);
            tvCarReg.setText(driver.driver.car_registration);
            tvCarType.setText(driver.driver.car_type);
            tvStartFee.setText(String.valueOf(driver.driver.fee_start));
            tvKMFee.setText(String.valueOf(driver.driver.fee_km));
            tvMobile.setText(driver.telNum);
            tvRating.setText(String.format("%.1f", driver.averageRate));

            int rating = (int) Math.round(driver.averageRate);;
            if (rating > llStarLayout.getChildCount()) {
                rating = llStarLayout.getChildCount();
            }
            for (int i = 0; i < rating; i++) {
                llStarLayout.getChildAt(i).setSelected(true);
            }

            findViewById(R.id.closeButton).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    DriverDetailsDialog.this.dismiss();
                }
            });

            findViewById(R.id.closeButton).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    DriverDetailsDialog.this.dismiss();
                }
            });

            findViewById(R.id.buttonCancelTrip).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    cancelTripApi();
                }
            });

            ((View) tvMobile.getParent()).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Utils.contactUserWithNum(getOwnerActivity(), tvMobile.getText().toString());
                }
            });
        }

    }


    @Override
    public void dismiss() {
        AnimationUtils.fade(parentLayout, 1, 0, 300, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                DriverDetailsDialog.super.dismiss();
            }
        });

    }

    @Override
    public void show() {
        super.show();
        AnimationUtils.fade(parentLayout, 0, 1, 300, null);
    }

    private void cancelTripApi(){
        PostCancelTripModel postModel = new PostCancelTripModel(order._id, Const.UserType.USER_TYPE_USER, "");

        if(getOwnerActivity() instanceof BaseActivity){

            DriverRetroApiInterface retroApiInterface = ((BaseActivity)getOwnerActivity()).getRetrofit().create(DriverRetroApiInterface.class);
            Call<BaseModel> call = retroApiInterface.cancelTrip(postModel, UserSingleton.getInstance().getUser().token_new);
            call.enqueue(new CustomResponse<BaseModel>(getOwnerActivity(), true, true) {

                @Override
                public void onCustomSuccess(Call<BaseModel> call, Response<BaseModel> response) {
                    super.onCustomSuccess(call, response);

                    DriverDetailsDialog.this.dismiss();
                    LocalBroadcastManager.getInstance(getOwnerActivity()).sendBroadcast(new Intent(Const.ReceiverIntents.ON_CANCEL_TRIP).putExtra(Const.Extras.ORDER_MODEL, order));

                }

                @Override
                public void onTryAgain(Call<BaseModel> call, Response<BaseModel> response) {
                    super.onTryAgain(call, response);
                    cancelTripApi();
                }
            });

        }
    }

}