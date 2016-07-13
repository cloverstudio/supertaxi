package clover_studio.com.supertaxi.base;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.TextView;

import java.util.Locale;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.dialog.BasicProgressDialog;
import clover_studio.com.supertaxi.utils.Const;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.converter.scalars.ScalarsConverterFactory;

/**
 * Created by ivoperic on 12/07/16.
 */
public class BaseActivity extends AppCompatActivity{

    protected Toolbar toolbar;
    private BasicProgressDialog basicDialog;
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
}
