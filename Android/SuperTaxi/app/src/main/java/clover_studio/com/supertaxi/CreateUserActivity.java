package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.Locale;

import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.LoginRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.base.SuperTaxiApp;
import clover_studio.com.supertaxi.dialog.BasicDialog;
import clover_studio.com.supertaxi.fragments.DriverProfileFragment;
import clover_studio.com.supertaxi.fragments.UserProfileFragment;
import clover_studio.com.supertaxi.models.SignInDataModel;
import clover_studio.com.supertaxi.models.post_models.PostSignUpModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.SecretGeneratorUtils;
import retrofit2.Call;
import retrofit2.Response;

public class CreateUserActivity extends BaseActivity {

    public static void startActivity(Activity activity, int type){
        activity.startActivity(new Intent(activity, CreateUserActivity.class).putExtra(Const.Extras.USER_TYPE, type));
    }

    private int userType;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_user);
        setToolbar(R.id.tToolbar, R.layout.custom_toolbar_title_left_text_white);
        setToolbarTitle(getString(R.string.create_user_profile).toUpperCase(Locale.getDefault()));
        setToolbarLeftText(getString(R.string.cancel));
        setToolbarLeftTextListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoMain();
            }
        });

        userType = getIntent().getIntExtra(Const.Extras.USER_TYPE, 1);

        if(userType == Const.UserType.USER_TYPE_DRIVER){
            getSupportFragmentManager().beginTransaction().add(R.id.mainContent, new DriverProfileFragment(), DriverProfileFragment.class.getName()).commit();
        }else{
            getSupportFragmentManager().beginTransaction().add(R.id.mainContent, new UserProfileFragment(), UserProfileFragment.class.getName()).commit();
        }

    }

    private void gotoMain() {
        finish();
    }


    public void apiDone() {
        SuperTaxiApp.getPreferences().setCustomBoolean(Const.PreferencesKey.USER_CREATED, true);
        UserHomeActivity.startActivity(getActivity());
        finish();
    }
}
