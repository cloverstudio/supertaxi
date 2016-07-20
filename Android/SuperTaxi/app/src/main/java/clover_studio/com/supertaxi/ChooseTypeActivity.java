package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.Locale;

import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.LoginRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.base.SuperTaxiApp;
import clover_studio.com.supertaxi.dialog.BasicDialog;
import clover_studio.com.supertaxi.models.SignInDataModel;
import clover_studio.com.supertaxi.models.post_models.PostSignUpModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.SecretGeneratorUtils;
import retrofit2.Call;
import retrofit2.Response;

public class ChooseTypeActivity extends BaseActivity {

    public static void startActivity(Activity activity){
        activity.startActivity(new Intent(activity, ChooseTypeActivity.class));
    }

    private RelativeLayout rlUserType;
    private RelativeLayout rlTaxiType;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_choose_type);

        setToolbar(R.id.tToolbar, R.layout.custom_toolbar_title);
        setToolbarTitle(getString(R.string.app_name).toUpperCase(Locale.getDefault()));

        rlUserType = (RelativeLayout) findViewById(R.id.rlUserType);
        rlTaxiType = (RelativeLayout) findViewById(R.id.rlTaxiType);

        rlUserType.setOnClickListener(onUserTypeClick);
        rlTaxiType.setOnClickListener(onTaxiTypeClick);

    }

    private View.OnClickListener onUserTypeClick = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            UserSingleton.getInstance().setUserType(Const.UserType.USER_TYPE_USER);
            afterSelected();
        }
    };

    private View.OnClickListener onTaxiTypeClick = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            UserSingleton.getInstance().setUserType(Const.UserType.USER_TYPE_DRIVER);
            afterSelected();
        }
    };

    private void afterSelected(){
        CreateUserActivity.startActivity(getActivity(), UserSingleton.getInstance().getUserType());
        finish();
    }

}
