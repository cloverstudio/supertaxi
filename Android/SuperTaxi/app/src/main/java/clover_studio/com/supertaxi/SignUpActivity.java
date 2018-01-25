package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

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

public class SignUpActivity extends BaseActivity {

    public static void startActivity(Activity activity){
        activity.startActivity(new Intent(activity, SignUpActivity.class));
    }

    private EditText etEmailAddress;
    private EditText etPassword;
    private Button buttonSignUp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);

        setToolbar(R.id.tToolbar, R.layout.custom_toolbar_title_left_text);
        setToolbarTitle(getString(R.string.app_name).toUpperCase(Locale.getDefault()));
        setToolbarLeftText(getString(R.string.cancel));
        setToolbarLeftTextListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        etEmailAddress = (EditText) findViewById(R.id.etEmailAddress);
        etPassword = (EditText) findViewById(R.id.etPassword);
        buttonSignUp = (Button) findViewById(R.id.buttonSignUp);

        buttonSignUp.setOnClickListener(onSignUpClick);

    }

    private View.OnClickListener onSignUpClick = new View.OnClickListener() {
        @Override
        public void onClick(View v) {

            if(etPassword.getText().toString().trim().length() == 0){
                BasicDialog.startOneButtonDialog(getActivity(), getString(R.string.error), getString(R.string.error_wrong_password));
                return;
            }else if(etEmailAddress.getText().toString().trim().length() == 0){
                BasicDialog.startOneButtonDialog(getActivity(), getString(R.string.error), getString(R.string.error_wrong_email));
                return;
            }

            showProgress();
            String password = etPassword.getText().toString().trim();
            String passwordPlusSalt = password + Const.Secrets.STATIC_SALT;
            try {
                String sha1Password = SecretGeneratorUtils.SHA1(passwordPlusSalt);
                SecretGeneratorUtils.getTimeForSecret(sha1Password, getRetrofit(), getActivity(), new SecretGeneratorUtils.GetTimeForSecretListener() {
                    @Override
                    public void getTimeSuccess(String sha1Password, String sha1Secret) {
                        signUpToServer(sha1Password, sha1Secret);
                    }

                    @Override
                    public void getTimeTryAgainForProgress() {
                        showProgress();
                    }
                });
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
    };

    private void signUpToServer(final String sha1Password, final String sha1Secret){

        PostSignUpModel postModel = new PostSignUpModel(etEmailAddress.getText().toString(), sha1Password, sha1Secret);
        LoginRetroApiInterface retroApiInterface = getRetrofit().create(LoginRetroApiInterface.class);
        Call<SignInDataModel> call = retroApiInterface.signUp(postModel);
        call.enqueue(new CustomResponse<SignInDataModel>(getActivity(), true, true) {

            @Override
            public void onCustomSuccess(Call<SignInDataModel> call, Response<SignInDataModel> response) {
                super.onCustomSuccess(call, response);

                SignInDataModel model = response.body();

                if(model.data.token_new != null){
                    UserSingleton.getInstance().updateToken(model.data.token_new);
                }

                if(model.data.user != null){
                    UserSingleton.getInstance().updateUser(model.data.user);
                }

                SuperTaxiApp.getPreferences().setCustomBoolean(Const.PreferencesKey.REMEMBER_ME, true);
                SuperTaxiApp.getPreferences().setCustomString(Const.PreferencesKey.SHA1_PASSWORD, sha1Password);
                SuperTaxiApp.getPreferences().setCustomString(Const.PreferencesKey.EMAIL_LOGIN, etEmailAddress.getText().toString().trim());

                hideProgress();

                ChooseTypeActivity.startActivity(getActivity());
                finish();

            }

            @Override
            public void onTryAgain(Call<SignInDataModel> call, Response<SignInDataModel> response) {
                super.onTryAgain(call, response);
                showProgress();
                signUpToServer(sha1Password, sha1Secret);
            }

        });

    }

}
