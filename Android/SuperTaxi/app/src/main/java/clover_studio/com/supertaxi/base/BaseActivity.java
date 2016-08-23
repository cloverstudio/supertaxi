package clover_studio.com.supertaxi.base;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import clover_studio.com.supertaxi.LoginActivity;
import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.dialog.BasicDialog;
import clover_studio.com.supertaxi.dialog.BasicProgressDialog;
import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.ErrorUtils;
import clover_studio.com.supertaxi.utils.ImageUtils;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.converter.scalars.ScalarsConverterFactory;

/**
 * Created by ivoperic on 12/07/16.
 */
public class BaseActivity extends AppCompatActivity{

    protected Toolbar toolbar;
    private BasicProgressDialog basicDialog;
    private BasicDialog invalidTokenDialog;
    protected Retrofit client;

    public Activity getActivity(){
        return this;
    }

    public Context getContext(){
        return this;
    }

    public Retrofit getRetrofit(){
        return client;
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        client = new Retrofit.Builder()
                .baseUrl(Const.BASE_URL)
                .addConverterFactory(ScalarsConverterFactory.create())
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        LocalBroadcastManager.getInstance(getActivity()).registerReceiver(receiverFinishActivity, new IntentFilter(Const.ReceiverIntents.FINISH_ALL_ACTIVITY));
    }

    @Override
    protected void onDestroy() {
        LocalBroadcastManager.getInstance(getActivity()).unregisterReceiver(receiverFinishActivity);
        super.onDestroy();
    }

    /**
     * set toolbar for activity
     * @param toolbarId id of view when toolbar will be added
     * @param toolbarLayout layout of custom toolbar
     */
    protected void setToolbar(int toolbarId, int toolbarLayout){
        toolbar = (Toolbar) findViewById(toolbarId);
        View customToolbarView = getLayoutInflater().inflate(toolbarLayout, null);
        if(toolbar != null){
            setSupportActionBar(toolbar);
            toolbar.setContentInsetsAbsolute(0, 0);
            toolbar.addView(customToolbarView);
            if(getSupportActionBar() != null) getSupportActionBar().setDisplayShowTitleEnabled(false);
        }
    }

    /**
     * set toolbar title
     * @param title title to show
     */
    protected void setToolbarTitle(String title){
        if(toolbar != null){
            TextView tvTitle = (TextView) toolbar.findViewById(R.id.toolbarTitle);
            if(tvTitle != null) tvTitle.setText(title);
        }
    }

    protected void setToolbarRightImage(String url){
        if(toolbar != null){
            ImageView imageView = (ImageView) toolbar.findViewById(R.id.ivAvatarInToolbar);
            if(imageView != null) {
                if(TextUtils.isEmpty(url)){
                    imageView.setVisibility(View.INVISIBLE);
                }else{
                    imageView.setVisibility(View.VISIBLE);
                    ImageUtils.setImageWithPicasso(imageView, url);
                }
            }
        }
    }

    /**
     * set toolbar left text button
     * @param left text to show
     */
    protected void setToolbarLeftText(String left){
        if(toolbar != null){
            TextView tvLeft = (TextView) toolbar.findViewById(R.id.toolbarLeft);
            if(tvLeft != null) tvLeft.setText(left);
        }
    }

    /**
     * set toolbar left text button clicklistener
     * @param onClickListener click listener
     */
    protected void setToolbarLeftTextListener(View.OnClickListener onClickListener){
        if(toolbar != null){
            TextView tvLeft = (TextView) toolbar.findViewById(R.id.toolbarLeft);
            if(tvLeft != null) tvLeft.setOnClickListener(onClickListener);
        }
    }

    public void showProgress(){
        try {

            if (basicDialog != null && basicDialog.isShowing()) {
                basicDialog.dismiss();
                basicDialog = null;
            }

            basicDialog = new BasicProgressDialog(this);
            basicDialog.show();

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public void hideProgress(){
        try {

            if (basicDialog != null && basicDialog.isShowing()) {
                basicDialog.dismiss();
            }

            basicDialog = null;

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private BroadcastReceiver receiverFinishActivity = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            finish();
        }
    };

    public void showInvalidToken(){
        if(invalidTokenDialog == null){
            invalidTokenDialog = BasicDialog.startOneButtonDialog(getActivity(), getActivity().getString(R.string.error), getString(R.string.error_invalid_token));
            invalidTokenDialog.setButtonText(getString(R.string.log_out));
            invalidTokenDialog.setOneButtonListener(new BasicDialog.OneButtonDialogListener() {
                @Override
                public void onOkClicked(BasicDialog dialog) {
                    dialog.dismiss();
                    LocalBroadcastManager.getInstance(getActivity()).sendBroadcast(new Intent(Const.ReceiverIntents.FINISH_ALL_ACTIVITY));
                    LoginActivity.startActivity(getActivity());
                }
            });
        }
    }
}
