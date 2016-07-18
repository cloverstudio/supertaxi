package clover_studio.com.supertaxi.base;

import android.app.Application;
import android.content.Context;

import java.io.File;

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
    public static Preferences getPreferences() {

        if (mAppPreferences == null) {
            mAppPreferences = new Preferences(getAppContext());
        }

        return mAppPreferences;
    }
    // end: Init Shared preferences

    // start; Samsung image path variable and methods
    private static String mSamsungPath = null;

    public static String samsungImagePath() {
        return mSamsungPath;
    }

    public static void setSamsungImagePath(String path) {
        mSamsungPath = path;
    }

    public static void deleteSamsungPathImage() {

        if (mSamsungPath != null && !mSamsungPath.equals("-1")) {

            File f = new File(mSamsungPath);
            if (f.exists()) {

                //noinspection ResultOfMethodCallIgnored
                f.delete();
            }
        }

        setSamsungImagePath(null);
    }
    // end: Samsung image path variable and methods

}
