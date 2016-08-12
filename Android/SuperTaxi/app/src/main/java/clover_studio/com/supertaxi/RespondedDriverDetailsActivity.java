package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.login.widget.LoginButton;
import com.google.android.gms.auth.api.Auth;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.auth.api.signin.GoogleSignInResult;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.SignInButton;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.maps.model.LatLng;

import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.Locale;

import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.DriverRetroApiInterface;
import clover_studio.com.supertaxi.api.retrofit.LoginRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.base.SuperTaxiApp;
import clover_studio.com.supertaxi.dialog.BasicDialog;
import clover_studio.com.supertaxi.dialog.CustomDialog;
import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.models.OrderModel;
import clover_studio.com.supertaxi.models.SignInDataModel;
import clover_studio.com.supertaxi.models.UserModel;
import clover_studio.com.supertaxi.models.post_models.PostCancelTripModel;
import clover_studio.com.supertaxi.models.post_models.PostSignUpModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.ImageUtils;
import clover_studio.com.supertaxi.utils.LogCS;
import clover_studio.com.supertaxi.utils.MapsUtils;
import clover_studio.com.supertaxi.utils.SecretGeneratorUtils;
import clover_studio.com.supertaxi.utils.Utils;
import retrofit2.Call;
import retrofit2.Response;

public class RespondedDriverDetailsActivity extends BaseActivity {

    private UserModel userModel;
    private OrderModel orderModel;

    public static void startActivity(Activity activity, UserModel model, LatLng startLocation, OrderModel order){
        activity.startActivity(new Intent(activity, RespondedDriverDetailsActivity.class).putExtra(Const.Extras.USER_MODEL, model).putExtra(Const.Extras.START_LOCATION, startLocation).putExtra(Const.Extras.ORDER_MODEL, order));
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_responded_driver_details);

        userModel = getIntent().getParcelableExtra(Const.Extras.USER_MODEL);
        orderModel = getIntent().getParcelableExtra(Const.Extras.ORDER_MODEL);

        ImageView ivAvatar = (ImageView) findViewById(R.id.ivAvatarInDriverDetails);
        TextView tvDriverName = (TextView) findViewById(R.id.tvName);
        final TextView tvDistance = (TextView) findViewById(R.id.tvDistance);
        TextView tvCar = (TextView) findViewById(R.id.tvCarTypeValue);
        TextView tvReg = (TextView) findViewById(R.id.tvCarRegValue);
        TextView tvStartFee = (TextView) findViewById(R.id.tvStartFeeValue);
        TextView tvKMFee = (TextView) findViewById(R.id.tvKMFeeValue);


        tvDriverName.setText(userModel.driver.name);
        String url = Utils.getAvatarUrl(userModel);
        ImageUtils.setImageWithPicasso(ivAvatar, url);
        tvStartFee.setText("$" + userModel.driver.fee_start);
        tvKMFee.setText("$" + userModel.driver.fee_km);
        tvCar.setText(userModel.driver.car_type);
        tvReg.setText(userModel.driver.car_registration);

        LatLng myLocation = getIntent().getParcelableExtra(Const.Extras.START_LOCATION);

        if(userModel.currentLocation != null){
            MapsUtils.getDistanceBetween(myLocation, new LatLng(userModel.currentLocation.get(1), userModel.currentLocation.get(0)), new MapsUtils.OnDistanceCalculated() {
                @Override
                public void onSuccessCalculate(String distance) {
                    String distanceString = getString(R.string.distance_between_driver_and_you);
                    distanceString = distanceString.replace("%s", distance);
                    tvDistance.setText(distanceString);
                }
            }, getActivity());
        }

        RelativeLayout rlContactDriver = (RelativeLayout) findViewById(R.id.rlContactDriver);
        rlContactDriver.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Utils.contactUserWithNum(getActivity(), userModel.telNum);
            }
        });

        Button cancelTrip = (Button) findViewById(R.id.buttonCancelTrip);
        cancelTrip.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cancelTripApi();
            }
        });

        findViewById(R.id.ibClose).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        findViewById(R.id.buttonShowOnMap).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        LocalBroadcastManager.getInstance(getActivity()).sendBroadcast(new Intent(Const.ReceiverIntents.ON_DRIVER_RESPONDED_TRIP).putExtra(Const.Extras.ORDER_MODEL, orderModel));

    }

    private void cancelTripApi(){
        PostCancelTripModel postModel = new PostCancelTripModel(orderModel._id, Const.UserType.USER_TYPE_USER, "");

        DriverRetroApiInterface retroApiInterface = getRetrofit().create(DriverRetroApiInterface.class);
        Call<BaseModel> call = retroApiInterface.cancelTrip(postModel, UserSingleton.getInstance().getUser().token_new);
        call.enqueue(new CustomResponse<BaseModel>(getActivity(), true, true) {

            @Override
            public void onCustomSuccess(Call<BaseModel> call, Response<BaseModel> response) {
                super.onCustomSuccess(call, response);

                LocalBroadcastManager.getInstance(getActivity()).sendBroadcast(new Intent(Const.ReceiverIntents.ON_CANCEL_TRIP).putExtra(Const.Extras.ORDER_MODEL, orderModel));
                finish();

            }

            @Override
            public void onTryAgain(Call<BaseModel> call, Response<BaseModel> response) {
                super.onTryAgain(call, response);
                cancelTripApi();
            }
        });
    }

}
