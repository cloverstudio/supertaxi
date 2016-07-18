package clover_studio.com.supertaxi.singletons;

import android.content.Context;

import clover_studio.com.supertaxi.base.SuperTaxiApp;
import clover_studio.com.supertaxi.models.DriverTypeModel;
import clover_studio.com.supertaxi.models.ImageAvatarModel;
import clover_studio.com.supertaxi.models.UserModel;
import clover_studio.com.supertaxi.models.UserTypeModel;
import clover_studio.com.supertaxi.utils.Const;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.converter.scalars.ScalarsConverterFactory;

/**
 * Created by ubuntu_ivo on 18.02.16..
 */
public class UserSingleton {

    private static UserSingleton singleton;

    private UserModel user;
    private boolean isAppActive = true;

    public static UserSingleton getInstance() {

        if (singleton == null) {
            singleton = new UserSingleton();
        }

        return singleton;
    }

    public UserModel getUser(){
        if(user == null){
            generateUser();
        }

        return user;
    }

    private void generateUser(){
        user = new UserModel();
        user._id = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey._ID);
        user.email = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.EMAIL);
        user.created = SuperTaxiApp.getPreferences().getCustomLong(Const.PreferencesKey.CREATED);
        user.token_new = SuperTaxiApp.getPreferences().getToken();
        user.type = SuperTaxiApp.getPreferences().getCustomInt(Const.PreferencesKey.USER_TYPE);
        user.telNum = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.TEL_NUM);

        ImageAvatarModel avatar = new ImageAvatarModel();
        avatar.fileid = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.AVATAR_FILE_ID);
        avatar.thumbfileid = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.AVATAR_THUMB_ID);
        if(avatar.fileid != null && avatar.fileid.length() > 0) {
            user.avatar = avatar;
        }

        DriverTypeModel driver = new DriverTypeModel();
        driver.name = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.DRIVER_TYPE_NAME);
        driver.car_type = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.CAR_TYPE);
        driver.car_registration = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.CAR_REGISTRATION);
        driver.fee_km = SuperTaxiApp.getPreferences().getCustomInt(Const.PreferencesKey.FEE_KM);
        driver.fee_start = SuperTaxiApp.getPreferences().getCustomInt(Const.PreferencesKey.FEE_START);
        if(driver.name != null && driver.name.length() > 0) {
            user.driver = driver;
        }

        UserTypeModel userType = new UserTypeModel();
        userType.name = SuperTaxiApp.getPreferences().getCustomString(Const.PreferencesKey.USER_TYPE_NAME);
        userType.age = SuperTaxiApp.getPreferences().getCustomInt(Const.PreferencesKey.AGE);
        if(userType.name != null && userType.name.length() > 0) {
            user.user = userType;
        }

    }

    public void updateUser(UserModel newUser){
        SuperTaxiApp.getPreferences().setUserData(newUser);
        generateUser();
    }

    public void updateToken(String token){
        SuperTaxiApp.getPreferences().setToken(token);
        generateUser();
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
