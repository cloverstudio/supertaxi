package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v4.widget.DrawerLayout;
import android.util.Log;
import android.view.View;
import android.view.animation.TranslateAnimation;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.balysv.materialmenu.MaterialMenuDrawable;
import com.balysv.materialmenu.MaterialMenuView;

import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.fragments.UserMainFragment;
import clover_studio.com.supertaxi.models.OrderModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.Const;

/**
 * Created by ubuntu_ivo on 08.02.16..
 */
public class UserHomeActivity extends HomeActivity {

    public static void startActivity(Activity activity){
        Intent startActivity = new Intent(activity, UserHomeActivity.class);
        if(activity instanceof BaseActivity){
            ((BaseActivity)activity).startActivity(startActivity);
        }else{
            activity.startActivity(startActivity);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LocalBroadcastManager.getInstance(getActivity()).registerReceiver(onDriverRespondedReceiver, new IntentFilter(Const.ReceiverIntents.ON_DRIVER_RESPONDED_TRIP));

    }

    @Override
    protected void initSidebar() {
        if(UserSingleton.getInstance().getUser().user.name != null &&
                UserSingleton.getInstance().getUser().user.name.length() > 0){
            tvSidebarMyName.setText(UserSingleton.getInstance().getUser().user.name);
        }else{
            tvSidebarMyName.setText(UserSingleton.getInstance().getUser().email);
        }
        super.initSidebar();
    }

    @Override
    public void refreshSidebar() {
        if(UserSingleton.getInstance().getUser().user.name != null &&
                UserSingleton.getInstance().getUser().user.name.length() > 0){
            tvSidebarMyName.setText(UserSingleton.getInstance().getUser().user.name);
        }else{
            tvSidebarMyName.setText(UserSingleton.getInstance().getUser().email);
        }
        super.refreshSidebar();
    }

    @Override
    protected void onTripCancel(OrderModel orderModel) {
        ((UserMainFragment)mainFragment).cancelTripClearMap();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        LocalBroadcastManager.getInstance(getActivity()).unregisterReceiver(onDriverRespondedReceiver);

    }

    private BroadcastReceiver onDriverRespondedReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            OrderModel orderModel = intent.getParcelableExtra(Const.Extras.ORDER_MODEL);
            onTripAccepted(orderModel);
        }

    };

    private void onTripAccepted(OrderModel order){
        ((UserMainFragment)mainFragment).onTripAccepted(order);
    }
}
