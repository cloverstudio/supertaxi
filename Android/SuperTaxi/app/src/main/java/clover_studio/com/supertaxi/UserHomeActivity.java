package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.DrawerLayout;
import android.view.View;
import android.view.animation.TranslateAnimation;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.balysv.materialmenu.MaterialMenuDrawable;
import com.balysv.materialmenu.MaterialMenuView;

import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.singletons.UserSingleton;

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

    }

}
