package clover_studio.com.supertaxi.dialog;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.android.gms.maps.model.LatLng;

import java.util.ArrayList;
import java.util.List;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.adapters.ShowMoreAdapter;
import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.DriverRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.models.DriverListResponse;
import clover_studio.com.supertaxi.models.post_models.PostLatLngModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.AnimationUtils;
import retrofit2.Call;
import retrofit2.Response;

public class ShowMoreInMapDialog extends Dialog {

    RelativeLayout parentLayout;
    private LatLng latLng;
    private OnItemClickedListener listener;
    RecyclerView rv;
    private TextView tvCarsAvailable;
    private TextView tvMinFare;
    private ProgressBar pbLoading;

    public static ShowMoreInMapDialog startDialog(Context context, LatLng latLng){
        return new ShowMoreInMapDialog(context, latLng);
    }

    public ShowMoreInMapDialog(Context context, LatLng latLng) {
        super(context, R.style.Theme_Dialog_no_dim);

        setOwnerActivity((Activity) context);
        setCancelable(true);
        setCanceledOnTouchOutside(true);

        this.latLng = latLng;

        show();

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_show_more_in_map);

        parentLayout = (RelativeLayout) findViewById(R.id.parentLayout);
        findViewById(R.id.rootView).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
        findViewById(R.id.ibBlueClose).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
        rv = (RecyclerView) findViewById(R.id.rv);
        rv.setLayoutManager(new LinearLayoutManager(getOwnerActivity()));
        rv.setAdapter(new ShowMoreAdapter(new ArrayList<DriverListResponse.DriverData>()));

        tvCarsAvailable = (TextView) findViewById(R.id.tvCarsAvailable);
        tvMinFare = (TextView) findViewById(R.id.tvMinFareValue);
        pbLoading = (ProgressBar) findViewById(R.id.loading);

        getDrivers();

    }

    private void getDrivers(){
        showProgress();
        PostLatLngModel postModel = new PostLatLngModel(latLng.latitude, latLng.longitude);
        DriverRetroApiInterface retroApiInterface = ((BaseActivity)getOwnerActivity()).getRetrofit().create(DriverRetroApiInterface.class);
        Call<DriverListResponse> call = retroApiInterface.getDriverList(postModel, UserSingleton.getInstance().getUser().token_new);
        call.enqueue(new CustomResponse<DriverListResponse>(getOwnerActivity(), true, true) {

            @Override
            public void onCustomSuccess(Call<DriverListResponse> call, Response<DriverListResponse> response) {
                super.onCustomSuccess(call, response);

                hideProgress();
                setDrivers(response.body().data.drivers);

            }

            @Override
            public void onTryAgain(Call<DriverListResponse> call, Response<DriverListResponse> response) {
                super.onTryAgain(call, response);
                showProgress();
                getDrivers();
            }
        });
    }

    @Override
    public void dismiss() {
        AnimationUtils.fade(parentLayout, 1, 0, 200, 300, null);
        int to = (int) (parentLayout.getContext().getResources().getDisplayMetrics().heightPixels * 0.45);
        AnimationUtils.translateY(parentLayout, 0, to, 500, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                ShowMoreInMapDialog.super.dismiss();
            }
        });

    }

    @Override
    public void show() {
        super.show();
        AnimationUtils.fade(parentLayout, 0, 1, 200, null);
        int from = (int) (parentLayout.getContext().getResources().getDisplayMetrics().heightPixels * 0.45);
        AnimationUtils.translateY(parentLayout, from, 0, 500, null);
    }

    public void setDrivers(List<DriverListResponse.DriverData> drivers) {
        ((ShowMoreAdapter)rv.getAdapter()).addData(drivers);
        tvCarsAvailable.setText(drivers.size() + " " + getOwnerActivity().getString(R.string.cars_available));
    }

    public interface OnItemClickedListener{
        void onClicked(Dialog dialog);
    }

    public void setListener (OnItemClickedListener lis){
        listener = lis;
    }

    private void showProgress(){
        pbLoading.setVisibility(View.VISIBLE);
    }

    private void hideProgress(){
        pbLoading.setVisibility(View.GONE);
    }

}