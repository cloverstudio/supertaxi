package clover_studio.com.supertaxi;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.base.SuperTaxiApp;
import clover_studio.com.supertaxi.dialog.BasicDialog;
import clover_studio.com.supertaxi.file.LocalFilesManagement;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.CheckPermissions;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.Utils;

public class SplashActivity extends BaseActivity {

    private BasicDialog.TwoButtonDialogListener twoButtonDialogListener;
    public static boolean firstLaunch;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initDialogListener();
        setContentView(R.layout.activity_splash);
        askForPermissions();

    }

    private void afterPermissions() {
        LocalFilesManagement.init();

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                if (SuperTaxiApp.getPreferences().getCustomBoolean(Const.PreferencesKey.USER_CREATED) &&
                        SuperTaxiApp.getPreferences().getCustomBoolean(Const.PreferencesKey.REMEMBER_ME)) {
                    firstLaunch=true;
                    HomeActivity.startActivity(getActivity(), UserSingleton.getInstance().getUserType());

                } else {
                    firstLaunch=true;
                    LoginActivity.startActivity(getActivity());
                }
                finish();
            }
        }, 1000);
    }

    private void askForPermissions() {
        if (ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {

            ActivityCompat.requestPermissions(getActivity(), new String[]{android.Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.ACCESS_FINE_LOCATION}, Const.PermissionCode.CHAT_STORAGE);

            return;
        } else {
            afterPermissions();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        switch (requestCode) {
            case Const.PermissionCode.CHAT_STORAGE: {
                if (grantResults.length > 0 && Utils.checkGrantResults(grantResults)) {
                    afterPermissions();
                } else {
                    Context context = getContext();
                    Log.d("Coarse", String.valueOf(ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.ACCESS_COARSE_LOCATION)));
                    Log.d("Fine", String.valueOf(ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.ACCESS_FINE_LOCATION)));
                    Log.d("Storage", String.valueOf(ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.WRITE_EXTERNAL_STORAGE)));
                    if (!ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.ACCESS_COARSE_LOCATION) ||
                            !ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.ACCESS_FINE_LOCATION) ||
                            !ActivityCompat.shouldShowRequestPermissionRationale(getActivity(), Manifest.permission.WRITE_EXTERNAL_STORAGE)) {

                        BasicDialog.startOneButtonDialog(context,"Warning","SuperTaxi needs this permissions. You can always set them in Settings>Applications").setOneButtonListener(new BasicDialog.OneButtonDialogListener() {
                            @Override
                            public void onOkClicked(BasicDialog dialog) {
                                dialog.dismiss();
                                finish();
                            }
                        });

                    } else {
                        BasicDialog.startTwoButtonDialog(context, context.getString(R.string.about), "This app needs permissions to work. Do you want to see the dialog again?").setTwoButtonListener(twoButtonDialogListener);
                    }
                }
            }
            // other 'case' lines to check for other
            // permissions this app might request
        }
    }


    private void initDialogListener() {
        twoButtonDialogListener = new BasicDialog.TwoButtonDialogListener() {
            @Override
            public void onOkClicked(BasicDialog dialog) {
               askForPermissions();
                dialog.dismiss();
            }

            @Override
            public void onCancelClicked(BasicDialog dialog) {
                dialog.dismiss();
                finish();
            }
        };
    }
}
