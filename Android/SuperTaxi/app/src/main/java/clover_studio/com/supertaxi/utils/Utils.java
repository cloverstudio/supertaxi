package clover_studio.com.supertaxi.utils;

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

}
