package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
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

import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.Locale;

import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.LoginRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.base.SuperTaxiApp;
import clover_studio.com.supertaxi.dialog.BasicDialog;
import clover_studio.com.supertaxi.dialog.CustomDialog;
import clover_studio.com.supertaxi.models.SignInDataModel;
import clover_studio.com.supertaxi.models.post_models.PostSignUpModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.LogCS;
import clover_studio.com.supertaxi.utils.SecretGeneratorUtils;
import retrofit2.Call;
import retrofit2.Response;

public class RespondedDriverDetailsActivity extends BaseActivity {

    public static void startActivity(Activity activity){
        activity.startActivity(new Intent(activity, RespondedDriverDetailsActivity.class));
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_responded_driver_details);

    }

}
