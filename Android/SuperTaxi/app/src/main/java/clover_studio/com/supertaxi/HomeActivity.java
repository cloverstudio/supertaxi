package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.net.http.HttpResponseCache;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.FragmentManager;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v4.widget.DrawerLayout;
import android.util.Log;
import android.view.View;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.balysv.materialmenu.MaterialMenuDrawable;
import com.balysv.materialmenu.MaterialMenuView;

import java.io.File;
import java.io.IOException;

import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.UserRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.base.BaseFragment;
import clover_studio.com.supertaxi.base.SuperTaxiApp;
import clover_studio.com.supertaxi.fragments.AboutFragment;
import clover_studio.com.supertaxi.fragments.DriverMainFragment;
import clover_studio.com.supertaxi.fragments.DriverProfileFragment;
import clover_studio.com.supertaxi.fragments.HistoryFragment;
import clover_studio.com.supertaxi.fragments.MainFragment;
import clover_studio.com.supertaxi.fragments.ReportAProblemFragment;
import clover_studio.com.supertaxi.fragments.SettingsFragment;
import clover_studio.com.supertaxi.fragments.UserMainFragment;
import clover_studio.com.supertaxi.fragments.UserProfileFragment;
import clover_studio.com.supertaxi.models.GetUserProfileModel;
import clover_studio.com.supertaxi.models.OrderModel;
import clover_studio.com.supertaxi.models.UpdateProfileResponse;
import clover_studio.com.supertaxi.models.UserModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.ImageUtils;
import clover_studio.com.supertaxi.utils.LogCS;
import clover_studio.com.supertaxi.utils.Utils;
import retrofit2.Call;
import retrofit2.Response;

/**
 * Created by ubuntu_ivo on 08.02.16..
 */
public class HomeActivity extends BaseActivity {

    public static void startActivity(Activity activity){
        Intent startActivity = new Intent(activity, HomeActivity.class);
        if(activity instanceof BaseActivity){
            ((BaseActivity)activity).startActivity(startActivity);
        }else{
            activity.startActivity(startActivity);
        }
    }

    public static void startActivity(Activity activity, int type){
        Intent startActivity;
        if(type == Const.UserType.USER_TYPE_DRIVER){
            startActivity = new Intent(activity, DriverHomeActivity.class);
        }else{
            startActivity = new Intent(activity, UserHomeActivity.class);
        }
        if(activity instanceof BaseActivity){
            ((BaseActivity)activity).startActivity(startActivity);
        }else{
            activity.startActivity(startActivity);
        }
    }

    private FragmentManager frManager;

    //**********FOR SIDEBAR*****//
    private float lastTranslate = 0.0f;
    private boolean isDrawerOpened;

    DrawerLayout dlDrawerLayout;
    LinearLayout llSidebarDrawer;
    LinearLayout llMainContent;
    MaterialMenuView menuHamburgerView;
    TextView tvSidebarMyName;
    RelativeLayout rlForFragment;
    RelativeLayout rlForMainFragment;

    protected BaseFragment profileFragment;
    protected BaseFragment mainFragment;
    protected BaseFragment historyFragment;
    protected BaseFragment settingsFragment;
    protected BaseFragment reportAProblemFragment;
    protected BaseFragment aboutFragment;
    String activeFragmentTag;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_home);
        setToolbar(R.id.tToolbar, R.layout.custom_toolbar_title_menu_left_image_right);

        dlDrawerLayout = (DrawerLayout) findViewById(R.id.drawerLayout);
        llSidebarDrawer = (LinearLayout) findViewById(R.id.sidebarDrawer);
        llMainContent = (LinearLayout) findViewById(R.id.mainContent);
        menuHamburgerView = (MaterialMenuView) findViewById(R.id.sidebarBtnMaterial);
        tvSidebarMyName = (TextView) findViewById(R.id.tvSidebarMyName);
        rlForFragment = (RelativeLayout) findViewById(R.id.rlForFragment);
        rlForMainFragment = (RelativeLayout) findViewById(R.id.rlForMainFragment);

        frManager = getSupportFragmentManager();

        initOtherFragments();
        setInitialFragment();

        menuHamburgerView.setOnClickListener(onLeftToolbarListener);
//
        //SIDEBAR
        int width = getResources().getDisplayMetrics().widthPixels;
        llSidebarDrawer.setMinimumWidth((int) (width * 0.8));
        dlDrawerLayout.addDrawerListener(sidebarDrawerListener);
        dlDrawerLayout.setScrimColor(Color.TRANSPARENT);
        initSidebar();
        setToolbarTitle(getString(R.string.home_capital));
        setToolbarRightImage(Utils.getMyAvatarUrl());
//
//        LogCS.d("LOG", "ACCESS TOKEN: " + UserSingleton.getInstance().getUser().token);
//        LogCS.d("LOG", "MY USER ID: " + UserSingleton.getInstance().getUser()._id);
////        LogCS.d("LOG", "MY PASSWORD: " + SpikaApp.getEnterpriseSharedPreferences().getCustomString(Const.PreferencesKeys.SHA1_PASSWORD));
//
        if (ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(getActivity(), new String[]{android.Manifest.permission.WRITE_EXTERNAL_STORAGE}, Const.PermissionCode.CHAT_STORAGE);
            return;
        }else{
            setCacheFolder();
        }

        getMyUserProfile();

        LocalBroadcastManager.getInstance(getActivity()).registerReceiver(onCancelTripReceiver, new IntentFilter(Const.ReceiverIntents.ON_CANCEL_TRIP));

    }

    private void setCacheFolder(){
        try {
            File httpCacheDir = new File(Utils.getImageCacheFolderPath());
            long httpCacheSize = 50 * 1024 * 1024; // 50 MiB
            HttpResponseCache.install(httpCacheDir, httpCacheSize);
        } catch (IOException e) {
            LogCS.i("LOG", "HTTP response cache installation failed:" + e);
        }
    }

    private void setInitialFragment() {

        activeFragmentTag = mainFragment.getClass().getName();
        frManager.beginTransaction().add(rlForMainFragment.getId(), mainFragment, activeFragmentTag).commit();

    }

    private void initOtherFragments(){
        if(UserSingleton.getInstance().getUserType() == Const.UserType.USER_TYPE_DRIVER){
            profileFragment = new DriverProfileFragment();
        }else{
            profileFragment = new UserProfileFragment();
        }

        if(UserSingleton.getInstance().getUserType() == Const.UserType.USER_TYPE_DRIVER){
            mainFragment = new DriverMainFragment();
        }else{
            mainFragment = new UserMainFragment();
        }

        historyFragment = new HistoryFragment();
        settingsFragment = new SettingsFragment();
        reportAProblemFragment = new ReportAProblemFragment();
        aboutFragment = new AboutFragment();
    }

    private View.OnClickListener onLeftToolbarListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            dlDrawerLayout.openDrawer(llSidebarDrawer);
        }
    };

    //***SIDEBAR***//
    DrawerLayout.DrawerListener sidebarDrawerListener = new DrawerLayout.DrawerListener() {
        @Override
        public void onDrawerSlide(View drawerView, float slideOffset) {

            float moveFactor = (llSidebarDrawer.getWidth() * slideOffset);

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB)
            {
                llMainContent.setTranslationX(moveFactor);
            }
            else
            {
                TranslateAnimation anim = new TranslateAnimation(lastTranslate, moveFactor, 0.0f, 0.0f);
                anim.setDuration(0);
                anim.setFillAfter(true);
                llMainContent.startAnimation(anim);

                lastTranslate = moveFactor;
            }

            menuHamburgerView.setTransformationOffset(
                    MaterialMenuDrawable.AnimationState.BURGER_X,
                    isDrawerOpened ? 2 - slideOffset : slideOffset
            );

        }

        @Override
        public void onDrawerOpened(View drawerView) {
            isDrawerOpened = true;
        }

        @Override
        public void onDrawerClosed(View drawerView) {
            isDrawerOpened = false;
        }

        @Override
        public void onDrawerStateChanged(int newState) {
            if(newState == DrawerLayout.STATE_IDLE) {
                if(isDrawerOpened) menuHamburgerView.setState(MaterialMenuDrawable.IconState.X);
                else menuHamburgerView.setState(MaterialMenuDrawable.IconState.BURGER);
            }
        }
    };

    protected void initSidebar() {
        String url = Utils.getMyAvatarUrl();
        ImageUtils.setImageWithPicasso((ImageView) findViewById(R.id.myAvatar), url, (ProgressBar) findViewById(R.id.myAvatarProgressBar), R.drawable.user);

        LinearLayout menuListLayout = (LinearLayout) findViewById(R.id.menuListLayout);
        if(menuListLayout != null){
            for(int i = 0; i < menuListLayout.getChildCount(); i++){
                menuListLayout.getChildAt(i).setOnClickListener(onSideBarItemClickListener);
            }
        }

        View rlMyData = findViewById(R.id.myDataContent);
        if(rlMyData != null) rlMyData.setOnClickListener(onSideBarItemClickListener);

        TextView tvTitle = (TextView) findViewById(R.id.tvInformationTitle);
        String text = getString(R.string.app_name);
        if(tvTitle != null) tvTitle.setText(text);
        TextView tvSubtitle = (TextView) findViewById(R.id.tvInformationSubtitle);
        String text2 = getString(R.string.version) + ": " + BuildConfig.VERSION_NAME + ", " + getString(R.string.build) + ": " + BuildConfig.VERSION_CODE;
        if(tvSubtitle != null) tvSubtitle.setText(text2);
    }

    private View.OnClickListener onSideBarItemClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            switch (v.getId()) {

                case R.id.tvHome:
                    setToolbarTitle(getString(R.string.home_capital));
                    switchFragment(mainFragment);
                    break;

                case R.id.tvHistory:
                    setToolbarTitle(getString(R.string.history_capital));
                    switchFragment(historyFragment);
                    break;

                case R.id.tvSettings:
                    setToolbarTitle(getString(R.string.settings_capital));
                    switchFragment(settingsFragment);
                    break;

                case R.id.tvReportAProblem:
                    setToolbarTitle(getString(R.string.report_a_problem_capital));
                    switchFragment(reportAProblemFragment);
                    break;

                case R.id.tvAbout:
                    setToolbarTitle(getString(R.string.about_capital));
                    switchFragment(aboutFragment);
                    break;

                case R.id.myDataContent:
                    setToolbarTitle(getString(R.string.profile_capital));
                    switchFragment(profileFragment);
                    break;
            }
        }
    };

    private void switchFragment (BaseFragment fragment){
        if(fragment.getClass().getName().equals(activeFragmentTag)){
            dlDrawerLayout.closeDrawer(llSidebarDrawer);
        }else{

            if(fragment instanceof MainFragment){
                frManager.beginTransaction().remove(frManager.findFragmentById(rlForFragment.getId())).commit();
            }else{
                frManager.beginTransaction().replace(rlForFragment.getId(), fragment, activeFragmentTag).commit();
            }
            activeFragmentTag = fragment.getClass().getName();

            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    dlDrawerLayout.closeDrawer(llSidebarDrawer);
                }
            }, 200);

        }

    }

    @Override
    public void onBackPressed() {
        if(isDrawerOpened){
            dlDrawerLayout.closeDrawer(llSidebarDrawer);
        }else{
            if(activeFragmentTag.equals(mainFragment.getClass().getName())){
                super.onBackPressed();
            }else{
                setToolbarTitle(getString(R.string.home_capital));
                switchFragment(mainFragment);
            }
        }
    }

    public void refreshSidebar(){
        String url = Utils.getMyAvatarUrl();
        ImageUtils.setImageWithPicasso((ImageView) findViewById(R.id.myAvatar), url);
        setToolbarRightImage(url);
    }

    private BroadcastReceiver onCancelTripReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            OrderModel orderModel = intent.getParcelableExtra(Const.Extras.ORDER_MODEL);
            onTripCancel(orderModel);
        }

    };

    protected void onTripCancel(OrderModel orderModel) {
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        LocalBroadcastManager.getInstance(getActivity()).unregisterReceiver(onCancelTripReceiver);

    }

    public void getMyUserProfile() {
        UserRetroApiInterface retro = getRetrofit().create(UserRetroApiInterface.class);
        Call<GetUserProfileModel> call = retro.getMyUserProfile(UserSingleton.getInstance().getUser().token_new);
        call.enqueue(new CustomResponse<GetUserProfileModel>(getActivity(), false, false) {
            @Override
            public void onCustomSuccess(Call<GetUserProfileModel> call, Response<GetUserProfileModel> response) {
                super.onCustomSuccess(call, response);

                UserModel user = response.body().data.user;
                UserSingleton.getInstance().updateUser(user);

            }
        });

    }
}
