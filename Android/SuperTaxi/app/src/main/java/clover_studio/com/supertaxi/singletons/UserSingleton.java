package clover_studio.com.supertaxi.singletons;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.PowerManager;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import clover_studio.com.supertaxi.base.SuperTaxiApp;
import clover_studio.com.supertaxi.models.MyUserDetailsModel;
import clover_studio.com.supertaxi.models.MyUserModel;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.Utils;
import retrofit2.Call;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.converter.scalars.ScalarsConverterFactory;

/**
 * Created by ubuntu_ivo on 18.02.16..
 */
public class UserSingleton {

    private static UserSingleton singleton;

    private MyUserModel user;
    private MyUserDetailsModel userDetails;
    private boolean isAppActive = true;

    public static UserSingleton getInstance() {

        if (singleton == null) {
            singleton = new UserSingleton();
        }

        return singleton;
    }

    public MyUserModel getUser(){
        if(user == null){
            generateUser();
        }

        return user;
    }

    public MyUserDetailsModel getUserDetails(){
        if(userDetails == null){
            generateDetails();
        }

        return userDetails;
    }

    private void generateUser(){
        user = new MyUserModel();
        MyUserModel.MyUser myUser = user.new MyUser();
        myUser._id = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey._ID);
        myUser.email = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.EMAIL);
        myUser.created = SuperTaxiApp.getPreferences().getCustomLong(Const.PreferencesKey.CREATED);
        user.token_new = SuperTaxiApp.getPreferences().getToken();
        user.user = myUser;
    }

    private void generateDetails() {
        userDetails = new MyUserDetailsModel();
        userDetails.name = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.NAME);
        userDetails.type = SuperTaxiApp.getPreferences().getCustomInt(Const.PreferencesKey.USER_TYPE);
        userDetails.telNum = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.TEL_NUM);
        userDetails.age = SuperTaxiApp.getPreferences().getCustomInt(Const.PreferencesKey.AGE);
        userDetails.car_type = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.CAR_TYPE);
        userDetails.car_registration = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.CAR_REGISTRATION);
        userDetails.fee_km = SuperTaxiApp.getPreferences().getCustomInt(Const.PreferencesKey.FEE_KM);
        userDetails.fee_start = SuperTaxiApp.getPreferences().getCustomInt(Const.PreferencesKey.FEE_START);
    }

    public void updateUser(MyUserModel newUser){
        SuperTaxiApp.getPreferences().setUserData(newUser);
        generateUser();
    }

    public void updateToken(String token){
        SuperTaxiApp.getPreferences().setToken(token);
        generateUser();
    }

    public void updateUserDetails(MyUserDetailsModel newUser){
        SuperTaxiApp.getPreferences().setUserDetails(newUser);
        generateDetails();
    }

    public void singOut(Context context, boolean tokenInvalid){
        user = null;
        signOut(context, getUser().token_new);
        if(tokenInvalid){
            SuperTaxiApp.getPreferences().invalidToken();
        }else{
            SuperTaxiApp.getPreferences().signOut();
        }
    }

    public boolean isAppActive(){
        return isAppActive;
    }

    public void setIsAppActive(boolean isAppActive){
        this.isAppActive = isAppActive;
    }

    public void signOut(Context context, String token){
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(Const.BASE_URL)
                .addConverterFactory(ScalarsConverterFactory.create())
                .addConverterFactory(GsonConverterFactory.create())
                .build();
//        UsersRetroApiInterface retroApiInterface = retrofit.create(UsersRetroApiInterface.class);
//        Call<BaseModel> call = retroApiInterface.signOut(token);
//        call.enqueue(new CustomResponseNoNewToken<BaseModel>(context, false, false){});
    }

}
