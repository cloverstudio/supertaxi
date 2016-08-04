package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.DrawerLayout;
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

import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.base.BaseFragment;
import clover_studio.com.supertaxi.base.SuperTaxiApp;
import clover_studio.com.supertaxi.fragments.DriverProfileFragment;
import clover_studio.com.supertaxi.fragments.UserMainFragment;
import clover_studio.com.supertaxi.fragments.UserProfileFragment;
import clover_studio.com.supertaxi.models.UpdateProfileResponse;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.ImageUtils;
import clover_studio.com.supertaxi.utils.Utils;

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

    BaseFragment profileFragment;
    BaseFragment mainFragment;
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

        frManager = getSupportFragmentManager();

        initOtherFragments();
        setInitialFragment();
//
//        rightToolbarButton.setOnClickListener(onRightToolbarListener);
//        subRightToolbarButton.setOnClickListener(onSubRightToolbarListener);
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
////        MessageDB.removeAllMessagesAsync();
//
//        SocketManager.getInstance().initSocketManager();
//        SocketManager.getInstance().connectToEnterpriseSocket();
//
//        if(getIntent().hasExtra(Const.Extras.PUSH_DATA)){
//            NotificationModel pushData = (NotificationModel) getIntent().getSerializableExtra(Const.Extras.PUSH_DATA);
//            if(pushData.group != null){
//                getGroupDetailAndStartChat(pushData);
//            }else if(pushData.room != null){
//                getRoomDetailAndStartChat(pushData);
//            }else if(pushData.from != null){
//                getUserDetailAndStartChat(pushData);
//            }
//            getIntent().removeExtra(Const.Extras.PUSH_DATA);
//        }else if(getIntent().getBooleanExtra(Const.Extras.MISSED_CALL, false)){
//            if(homeFragment != null){
//                homeFragment.gotoMissedCall();
//            }
//        }
//
//        if (ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
//            ActivityCompat.requestPermissions(getActivity(), new String[]{android.Manifest.permission.WRITE_EXTERNAL_STORAGE}, Const.PermissionCode.CHAT_STORAGE);
//            return;
//        }else{
//            setCacheFolder();
//        }

    }

//    private void setCacheFolder(){
//        try {
//            File httpCacheDir = new File(Utils.getImageCacheFolderPath());
//            long httpCacheSize = 50 * 1024 * 1024; // 50 MiB
//            HttpResponseCache.install(httpCacheDir, httpCacheSize);
//        } catch (IOException e) {
//            LogCS.i("LOG", "HTTP response cache installation failed:" + e);
//        }
//    }

//    private void getGroupDetailAndStartChat(final NotificationModel model){
//        showProgress();
//        RoomRetroApiInterface retroApiInterface = getRetrofit().create(RoomRetroApiInterface.class);
//        Call<GroupDetailsDataModel> call = retroApiInterface.getGroupDetails(model.group.id, UserSingleton.getInstance().getUser().token);
//        call.enqueue(new CustomResponse<GroupDetailsDataModel>(getActivity(), true, true){
//            @Override
//            public void onCustomSuccess(Call<GroupDetailsDataModel> call, Response<GroupDetailsDataModel> response) {
//                super.onCustomSuccess(call, response);
//                hideProgress();
//                if(pinDialog != null) pinDialog.dismiss();
//                String messageFromPushReply = getIntent().getStringExtra(Const.Extras.MESSAGE_STRING);
//                if(TextUtils.isEmpty(messageFromPushReply)){
//                    messageFromPushReply = null;
//                }
//                ChatActivity.startChatActivityWithGroupModel(getActivity(), response.body().data.group, null, null, true, messageFromPushReply);
//            }
//
//            @Override
//            public void onTryAgain(Call<GroupDetailsDataModel> call, Response<GroupDetailsDataModel> response) {
//                super.onTryAgain(call, response);
//                getGroupDetailAndStartChat(model);
//            }
//
//            @Override
//            public void onNewToken() {
//                getGroupDetailAndStartChat(model);
//            }
//        });
//    }
//
//    private void getRoomDetailAndStartChat(final NotificationModel model){
//        showProgress();
//        RoomRetroApiInterface retroApiInterface = getRetrofit().create(RoomRetroApiInterface.class);
//        Call<RoomDataModel> call = retroApiInterface.getRoomDetails(model.room.id, UserSingleton.getInstance().getUser().token);
//        call.enqueue(new CustomResponse<RoomDataModel>(getActivity(), true, true){
//            @Override
//            public void onCustomSuccess(Call<RoomDataModel> call, Response<RoomDataModel> response) {
//                super.onCustomSuccess(call, response);
//                hideProgress();
//                if(pinDialog != null) pinDialog.dismiss();
//                String messageFromPushReply = getIntent().getStringExtra(Const.Extras.MESSAGE_STRING);
//                if(TextUtils.isEmpty(messageFromPushReply)){
//                    messageFromPushReply = null;
//                }
//                ChatActivity.startChatActivityWithRoomModel(getActivity(), response.body().data.room, null, null, true, messageFromPushReply);
//            }
//
//            @Override
//            public void onTryAgain(Call<RoomDataModel> call, Response<RoomDataModel> response) {
//                super.onTryAgain(call, response);
//                getRoomDetailAndStartChat(model);
//            }
//
//            @Override
//            public void onNewToken() {
//                getRoomDetailAndStartChat(model);
//            }
//        });
//    }
//
//    private void getUserDetailAndStartChat(final NotificationModel model){
//        showProgress();
//        UsersRetroApiInterface retroApiInterface = getRetrofit().create(UsersRetroApiInterface.class);
//        Call<UserDataModel> call = retroApiInterface.getUserDetail(model.from.id, UserSingleton.getInstance().getUser().token);
//        call.enqueue(new CustomResponse<UserDataModel>(getActivity(), true, true){
//            @Override
//            public void onCustomSuccess(Call<UserDataModel> call, Response<UserDataModel> response) {
//                super.onCustomSuccess(call, response);
//                hideProgress();
//                if(pinDialog != null) pinDialog.dismiss();
//                String messageFromPushReply = getIntent().getStringExtra(Const.Extras.MESSAGE_STRING);
//                if(TextUtils.isEmpty(messageFromPushReply)){
//                    messageFromPushReply = null;
//                }
//                ChatActivity.startChatActivityWithTargetUser(getActivity(), response.body().data.user, null, null, true, messageFromPushReply);
//            }
//
//            @Override
//            public void onTryAgain(Call<UserDataModel> call, Response<UserDataModel> response) {
//                super.onTryAgain(call, response);
//                getUserDetailAndStartChat(model);
//            }
//
//            @Override
//            public void onNewToken() {
//                getUserDetailAndStartChat(model);
//            }
//        });
//    }

    private void setInitialFragment() {

        activeFragmentTag = mainFragment.getClass().getName();
        frManager.beginTransaction().add(rlForFragment.getId(), mainFragment, activeFragmentTag).commit();

    }

    private void initOtherFragments(){
        if(UserSingleton.getInstance().getUserType() == Const.UserType.USER_TYPE_DRIVER){
            profileFragment = new DriverProfileFragment();
        }else{
            profileFragment = new UserProfileFragment();
        }

        if(UserSingleton.getInstance().getUserType() == Const.UserType.USER_TYPE_DRIVER){
            mainFragment = new UserMainFragment();
        }else{
            mainFragment = new UserMainFragment();
        }
    }

//
//    public void manageToolbar(int type){
//        if(type == Const.ToolbarTypes.NONE){
//            hideWithoutMenuToolbarButton();
//        } else if (type == Const.ToolbarTypes.BOTH) {
//            showToolbarButton();
//        } else if (type == Const.ToolbarTypes.ONE) {
//            showToolbarButtonWithOneRight();
//        } else {
//            hideWithoutMenuToolbarButton();
//        }
//    }
//
//    public void changeImageOfRightToolbar(int resource){
//        changeImageOfRightButton(resource);
//    }
//
//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//        if(homeFragment != null){
//            homeFragment.onActivityResult(requestCode, resultCode, data);
//        }
//
//    }
//
//    private View.OnClickListener onRightToolbarListener = new View.OnClickListener() {
//        @Override
//        public void onClick(View v) {
//            if(homeFragment != null){
//                homeFragment.onRightToolbarClicked();
//            }
//        }
//    };
//
    private View.OnClickListener onLeftToolbarListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            dlDrawerLayout.openDrawer(llSidebarDrawer);
        }
    };
//
//    private View.OnClickListener onSubRightToolbarListener = new View.OnClickListener() {
//        @Override
//        public void onClick(View v) {
//            if(homeFragment != null){
//                homeFragment.onSubRightToolbarClicked();
//            }
//        }
//    };
//
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
                    Toast.makeText(getActivity(), "HISTORY", Toast.LENGTH_SHORT).show();
                    break;

                case R.id.tvSettings:
                    Toast.makeText(getActivity(), "tvSettings", Toast.LENGTH_SHORT).show();
                    break;

                case R.id.tvReportAProblem:
                    Toast.makeText(getActivity(), "tvReportAProblem", Toast.LENGTH_SHORT).show();
                    break;

                case R.id.tvAbout:
                    Toast.makeText(getActivity(), "tvAbout", Toast.LENGTH_SHORT).show();
                    break;

                case R.id.myDataContent:
                    setToolbarTitle(getString(R.string.profile_capital));
                    switchFragment(profileFragment);
                    break;
            }
        }
    };

//    private void switchToMessages(boolean goToSettings){
//        if(homeFragment == null){
//            LogCS.e("LOG", "home fragment je null");
//            homeFragment = HomeFragment.newInstance();
//        }
//        showToolbarButton();
//        switchFragment(homeFragment, goToSettings);
//    }
//
    private void switchFragment (BaseFragment fragment){
        if(fragment.getClass().toString().equals(activeFragmentTag)){
            dlDrawerLayout.closeDrawer(llSidebarDrawer);
        }else{

            activeFragmentTag = fragment.getClass().getName();
            frManager.beginTransaction().replace(rlForFragment.getId(), fragment, activeFragmentTag).commit();

            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    dlDrawerLayout.closeDrawer(llSidebarDrawer);
                }
            }, 200);

        }

    }

//    //*****************DATA FOR FRAGMENT******//
//    public void addDataForUsersFragment(List<UserModel> users, int currentPage){
//        usersFragmentData.addAll(users);
//        this.usersFragmentCurrentPage = currentPage;
//    }
//
//    public List<UserModel> getUsersFragmentData(){
//        return usersFragmentData;
//    }
//
//    public int getUsersFragmentCurrentPage(){
//        return usersFragmentCurrentPage;
//    }
//
//    public void addDataForGroupsFragment(List<GroupModel> groups, int currentPage){
//        groupsFragmentData.addAll(groups);
//        this.groupsFragmentCurrentPage = currentPage;
//    }
//
//    public List<GroupModel> getGroupsFragmentData(){
//        return groupsFragmentData;
//    }
//
//    public int getGroupsFragmentCurrentPage(){
//        return groupsFragmentCurrentPage;
//    }
//
//    @Override
//    protected void receiveNewMessage(NewMessageEnterpriseModel model) {
//        if(homeFragment != null){
//            homeFragment.refreshData();
//        }
//        super.receiveNewMessage(model);
//    }
//
//    @Override
//    public void onBackPressed() {
//        if(isDrawerOpened){
//            dlDrawerLayout.closeDrawer(llSidebarDrawer);
//        }else if(favoritesFragment != null && favoritesFragment.getClass().getName().equals(activeFragmentTag)){
//            if(!favoritesFragment.isChooseUserOpened){
//                checkForExit();
//            }else{
//                favoritesFragment.removeChooseView();
//            }
//        }else if(homeFragment != null && homeFragment.getClass().getName().equals(activeFragmentTag)){
//            if(homeFragment.isSearchOpened()){
//                homeFragment.closeSearch();
//            }else if(homeFragment.isPickUserForCallOpened()){
//                homeFragment.closePickCallUser();
//            }else{
//                checkForExit();
//            }
//        }else{
//            checkForExit();
//        }
//    }
//
//    private void checkForExit(){
//        if(HomeFragment.class.getName().equals(activeFragmentTag)){
//            super.onBackPressed();
//        }else{
//            switchToMessages(false);
//        }
//    }
//
//    //reload recent user and groups
//    public void reloadAllData(){
//        if(homeFragment != null){
//            homeFragment.reloadAllData();
//        }
//    }
//
//    //reload settings
//    public void reloadSettings(){
//        if(homeFragment != null){
//            homeFragment.reloadSettings();
//        }
//    }

    public void refreshSidebar(){
        String url = Utils.getMyAvatarUrl();
        ImageUtils.setImageWithPicasso((ImageView) findViewById(R.id.myAvatar), url);
    }

//    @Override
//    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
//        switch (requestCode) {
//            case Const.PermissionCode.CHAT_STORAGE: {
//                if (grantResults.length > 0 && Utils.checkGrantResults(grantResults)) {
//                    setCacheFolder();
//                }else{
//                    finish();
//                }
//                return;
//            }
//            // other 'case' lines to check for other
//            // permissions this app might request
//        }
//    }
//
//    @Override
//    protected void onResume() {
//        super.onResume();
//
//        new Handler().postDelayed(new Runnable() {
//            @Override
//            public void run() {
//                UserSingleton.getInstance().checkForUserDetails(getRetrofit(), getActivity(), new UserSingleton.CheckForSettingComplete() {
//                    @Override
//                    public void finish() {
//                        if(getActivity() != null && getActivity() instanceof HomeActivity){
//                            ((HomeActivity)getActivity()).refreshSidebar();
//                        }
//                        if(getActivity() != null && getActivity() instanceof HomeActivity){
//                            ((HomeActivity)getActivity()).reloadSettings();
//                        }
//                    }
//                });
//            }
//        }, 200);
//
//        refreshMissedCallCount();
//
//    }
//
//    public void refreshMissedCallCount(){
//        CallLogJsonDB.getMissedActiveCountAsync(new CallLogJsonDB.OnDatabaseFinish() {
//            @Override
//            public void onGetCallLogs(List<CallLogModel> callLogs) {
//                if(homeFragment != null){
//                    homeFragment.manageMissedCalls(callLogs.size());
//                }
//            }
//        });
//    }
}
