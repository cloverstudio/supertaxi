package clover_studio.com.supertaxi.base;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.TextView;

import java.util.Locale;

import clover_studio.com.supertaxi.R;

/**
 * Created by ivoperic on 12/07/16.
 */
public class BaseActivity extends AppCompatActivity{

    protected Toolbar toolbar;

    public Activity getActivity(){
        return this;
    }

    public Context getContext(){
        return this;
    }

    @Override
    public void onCreate(Bundle savedInstanceState, PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);
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
}
