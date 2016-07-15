package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;

import java.util.ArrayList;
import java.util.List;

import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.file.LocalFilesManagement;
import clover_studio.com.supertaxi.utils.CheckPermissions;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.Utils;

public class SplashActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);

        if (ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(getActivity(), new String[]{android.Manifest.permission.WRITE_EXTERNAL_STORAGE}, Const.PermissionCode.CHAT_STORAGE);
            return;
        }else{
            afterPermissions();
        }

    }

    private void afterPermissions(){
        LocalFilesManagement.init();

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                LoginActivity.startActivity(getActivity());
                finish();
            }
        }, 1000);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        switch (requestCode) {
            case Const.PermissionCode.CHAT_STORAGE: {
                if (grantResults.length > 0 && Utils.checkGrantResults(grantResults)) {
                    afterPermissions();
                }else{
                    finish();
                }
            }
            // other 'case' lines to check for other
            // permissions this app might request
        }
    }
}
