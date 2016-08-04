package clover_studio.com.supertaxi.dialog;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.android.gms.maps.model.LatLng;

import java.util.ArrayList;
import java.util.List;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.RespondedDriverDetailsActivity;
import clover_studio.com.supertaxi.adapters.ShowMoreAdapter;
import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.DriverRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.models.CallTaxiModel;
import clover_studio.com.supertaxi.models.DriverListResponse;
import clover_studio.com.supertaxi.models.OrderModel;
import clover_studio.com.supertaxi.models.post_models.PostCallTaxiModel;
import clover_studio.com.supertaxi.models.post_models.PostCancelTripModel;
import clover_studio.com.supertaxi.models.post_models.PostLatLngModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.AnimationUtils;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.LogCS;
import retrofit2.Call;
import retrofit2.Response;

public class RequestSentDialog extends Dialog {

    RelativeLayout parentLayout;
    private View progressLoadingView;

    private int widthOfLoadingView;
    private int widthOfLoadingParent;
    private int sizeForAnimation;
    private boolean stopAnimation;

    private LatLng pickUpLocation, destinationLocation;
    private String pickUpAddress, destinationAddress;
    private int numberOfSeats;

    private OrderModel orderModel = null;

    private Button cancelTripButton;

    public static RequestSentDialog startDialog(Context context, LatLng pickUpLocation, LatLng destinationLocation, String pickUpAddress, String destinationAddress, int numberOfSeats){
        return new RequestSentDialog(context, pickUpLocation, destinationLocation, pickUpAddress, destinationAddress, numberOfSeats);
    }

    public RequestSentDialog(Context context, LatLng pickUpLocation, LatLng destinationLocation, String pickUpAddress, String destinationAddress, int numberOfSeats) {
        super(context, R.style.Theme_Dialog_no_dim);

        setOwnerActivity((Activity) context);
        setCancelable(true);
        setCanceledOnTouchOutside(true);

        this.pickUpLocation = pickUpLocation;
        this.destinationLocation = destinationLocation;
        this.pickUpAddress = pickUpAddress;
        this.destinationAddress = destinationAddress;
        this.numberOfSeats = numberOfSeats;

        show();

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_request_sent);

        parentLayout = (RelativeLayout) findViewById(R.id.parentLayout);
        progressLoadingView = findViewById(R.id.loadingProgressView);

        TextView tvSeatValue = (TextView) findViewById(R.id.tvSeatValue);
        ImageView ivSeatImage = (ImageView) findViewById(R.id.ivSeatImage);

        if(numberOfSeats == 1){
            tvSeatValue.setText(numberOfSeats + " " + getOwnerActivity().getResources().getString(R.string.seat));
            ivSeatImage.setImageResource(R.drawable.car_one_seat_available);
        }else if(numberOfSeats == 2){
            tvSeatValue.setText(numberOfSeats + " " + getOwnerActivity().getResources().getString(R.string.seats));
            ivSeatImage.setImageResource(R.drawable.car_two_seats_available);
        }else{
            tvSeatValue.setText(numberOfSeats + " " + getOwnerActivity().getResources().getString(R.string.seats));
            ivSeatImage.setImageResource(R.drawable.car_three_seats_available);
        }

        widthOfLoadingView = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 80, getOwnerActivity().getResources().getDisplayMetrics());
        widthOfLoadingParent = (int) (getOwnerActivity().getResources().getDisplayMetrics().widthPixels - (2 * getOwnerActivity().getResources().getDimension(R.dimen.default_margin)));
        sizeForAnimation = widthOfLoadingParent - widthOfLoadingView;

        cancelTripButton = (Button) findViewById(R.id.buttonCancelTrip);
        cancelTripButton.setEnabled(false);
        cancelTripButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(orderModel != null){
                    cancelTripApi();
                }
            }
        });

        animateLoading(true);

        requestTaxiApi();

    }

    private void animateLoading(boolean toRight){
        if(stopAnimation){
            return;
        }
        if(toRight){
            AnimationUtils.translateX(progressLoadingView, 0, sizeForAnimation, 1200, new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    super.onAnimationEnd(animation);
                    animateLoading(false);
                }
            });
        }else{
            AnimationUtils.translateX(progressLoadingView, sizeForAnimation, 0, 1200, new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    super.onAnimationEnd(animation);
                    animateLoading(true);
                }
            });
        }
    }

    @Override
    public void dismiss() {
        stopAnimation = true;
        AnimationUtils.fade(parentLayout, 1, 0, 200, 300, null);
        int to = parentLayout.getContext().getResources().getDisplayMetrics().heightPixels;
        AnimationUtils.translateY(parentLayout, 0, to, 500, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                RequestSentDialog.super.dismiss();
            }
        });

    }

    @Override
    public void show() {
        super.show();
        AnimationUtils.fade(parentLayout, 0, 1, 200, null);
        int from = parentLayout.getContext().getResources().getDisplayMetrics().heightPixels;
        AnimationUtils.translateY(parentLayout, from, 0, 500, null);
    }

    private void requestTaxiApi(){

        PostCallTaxiModel postModel = new PostCallTaxiModel(pickUpLocation.latitude, pickUpLocation.longitude, pickUpAddress,
                destinationLocation.latitude, destinationLocation.longitude, destinationAddress, numberOfSeats);

        if(getOwnerActivity() instanceof BaseActivity){

            DriverRetroApiInterface retroApiInterface = ((BaseActivity)getOwnerActivity()).getRetrofit().create(DriverRetroApiInterface.class);
            Call<CallTaxiModel> call = retroApiInterface.callTaxi(postModel, UserSingleton.getInstance().getUser().token_new);
            call.enqueue(new CustomResponse<CallTaxiModel>(getOwnerActivity(), true, true) {

                @Override
                public void onCustomSuccess(Call<CallTaxiModel> call, Response<CallTaxiModel> response) {
                    super.onCustomSuccess(call, response);

                    orderModel = response.body().data.order;
                    cancelTripButton.setEnabled(true);

                }

                @Override
                public void onTryAgain(Call<CallTaxiModel> call, Response<CallTaxiModel> response) {
                    super.onTryAgain(call, response);
                    requestTaxiApi();
                }
            });

        }

    }

    private void cancelTripApi(){
        PostCancelTripModel postModel = new PostCancelTripModel(orderModel._id, Const.UserType.USER_TYPE_USER, "");

        if(getOwnerActivity() instanceof BaseActivity){

            DriverRetroApiInterface retroApiInterface = ((BaseActivity)getOwnerActivity()).getRetrofit().create(DriverRetroApiInterface.class);
            Call<BaseModel> call = retroApiInterface.cancelTrip(postModel, UserSingleton.getInstance().getUser().token_new);
            call.enqueue(new CustomResponse<BaseModel>(getOwnerActivity(), true, true) {

                @Override
                public void onCustomSuccess(Call<BaseModel> call, Response<BaseModel> response) {
                    super.onCustomSuccess(call, response);

                    RequestSentDialog.this.dismiss();

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