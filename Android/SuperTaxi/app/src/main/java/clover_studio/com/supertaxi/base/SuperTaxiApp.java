package clover_studio.com.supertaxi.base;

import android.app.Application;
import android.content.Context;

import clover_studio.com.supertaxi.utils.Preferences;

/**
 * Created by ubuntu_ivo on 08.02.16..
 */
public class SuperTaxiApp extends Application{

    private static Context mAppContext;
    private static Preferences mAppPreferences;

    @Override
    public void onCreate() {
        super.onCreate();

        setAppContext(getApplicationContext());

    }

    // start: Init Application context
    public static Context getAppContext() {
        return mAppContext;
    }

    public void setAppContext(Context appContext) {
        mAppContext = appContext;
    }
    // end: Init Application context

    // start: Init Shared preferences
    public static Preferences getEnterpriseSharedPreferences() {

        if (mAppPreferences == null) {
            mAppPreferences = new Preferences(getAppContext());
        }

        return mAppPreferences;
    }
    // end: Init Shared preferences

}
