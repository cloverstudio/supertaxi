package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import java.sql.Driver;

import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.fragments.DriverMainFragment;
import clover_studio.com.supertaxi.fragments.UserMainFragment;
import clover_studio.com.supertaxi.models.OrderModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;

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

    @Override
    protected void initSidebar() {
        if(UserSingleton.getInstance().getUser().driver.name != null &&
                UserSingleton.getInstance().getUser().driver.name.length() > 0){
            tvSidebarMyName.setText(UserSingleton.getInstance().getUser().driver.name);
        }else{
            tvSidebarMyName.setText(UserSingleton.getInstance().getUser().email);
        }
        super.initSidebar();
    }

    @Override
    public void refreshSidebar() {
        if(UserSingleton.getInstance().getUser().driver.name != null &&
                UserSingleton.getInstance().getUser().driver.name.length() > 0){
            tvSidebarMyName.setText(UserSingleton.getInstance().getUser().driver.name);
        }else{
            tvSidebarMyName.setText(UserSingleton.getInstance().getUser().email);
        }
        super.refreshSidebar();
    }

    @Override
    protected void onTripCancel(OrderModel orderModel) {
        ((DriverMainFragment)mainFragment).cancelTripClearMap();
    }

}
