package clover_studio.com.supertaxi.utils;

import android.app.Activity;
import android.content.Context;
import android.view.View;
import android.view.inputmethod.InputMethodManager;

/**
 * Created by ubuntu_ivo on 08.02.16..
 */
public class Utils {

    /**
     * checked if android version is above given version
     * @param version version to compare
     * @return true is above, false is equals or below
     */
    public static boolean isBuildOver(int version) {
        if (android.os.Build.VERSION.SDK_INT > version)
            return true;
        return false;
    }

    public static boolean isBuildBelow(int version) {
        if (android.os.Build.VERSION.SDK_INT < version)
            return true;
        return false;
    }

    public static void hideKeyboard(View pView, Activity pActivity) {
        if (pView == null) {
            pView = pActivity.getWindow().getCurrentFocus();
        }
        if (pView != null) {
            InputMethodManager imm = (InputMethodManager) pActivity.getSystemService(Context.INPUT_METHOD_SERVICE);
            if (imm != null) {
                imm.hideSoftInputFromWindow(pView.getWindowToken(), 0);
            }
        }
    }

}
