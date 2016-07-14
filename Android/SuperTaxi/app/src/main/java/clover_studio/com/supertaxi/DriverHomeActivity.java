package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import clover_studio.com.supertaxi.base.BaseActivity;

/**
 * Created by ubuntu_ivo on 08.02.16..
 */
public class DriverHomeActivity extends HomeActivity {

    public static void startActivity(Activity activity){
        Intent startActivity = new Intent(activity, DriverHomeActivity.class);
        if(activity instanceof BaseActivity){
            ((BaseActivity)activity).startActivity(startActivity);
        }else{
            activity.startActivity(startActivity);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        TextView tvHistory = (TextView) findViewById(R.id.tvHistory);
        tvHistory.setVisibility(View.GONE);

        View tvHistoryLine = findViewById(R.id.lineViewAboveHistory);
        tvHistoryLine.setVisibility(View.GONE);

    }

}
