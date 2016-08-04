package clover_studio.com.supertaxi.utils;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;

import java.util.ArrayList;
import java.util.List;

/**
 * This class is used for dynamic permission aproval. If new permission is needed it needs to be added in switch-case statement same as the others.
 * Also the myPermissionRequestResponse method from BaseActivity needs to be implemented if you want to do something after the permission has been granted.
 */
public class CheckPermissions {

    public static class Permissions {

        public static final int ACCESS_FINE_LOCATION = 1;
        public static final int READ_CONTACTS = 2;
        public static final int WRITE_CONTACTS = 3;
        public static final int CAMERA = 4;
        public static final int RECORD_AUDIO = 5;
        public static final int READ_PHONE_STATE = 6;
        public static final int READ_EXTERNAL_STORAGE = 7;
        public static final int ACCESS_COARSE_LOCATION = 8;
        public static final int READ_SMS = 9;
    }

    public static final int REQUEST_CODE_ASK_MULTIPLE_PERMISSIONS = 124;

    public static boolean isAllowed(Activity act, int permission) {
        return Build.VERSION.SDK_INT < 23 || handleMarshmallowPermissions(act, permission);
    }

    public static boolean isJustAllowed(Context ctx, int permission) {
        return Build.VERSION.SDK_INT < 23 || isMarshmallowPermissionAllowed(ctx, permission);
    }

    public static void askForPermissions(Activity act, List<Integer> permissionList) {

        if (Build.VERSION.SDK_INT >= 23) {

            final List<String> permissionsList = new ArrayList<>();

            for (Integer permission : permissionList) {

                switch (permission) {

                    case Permissions.ACCESS_FINE_LOCATION:

                        if (!addPermission(act, Manifest.permission.ACCESS_FINE_LOCATION)) {
                            permissionsList.add(Manifest.permission.ACCESS_FINE_LOCATION);
                        }

                        break;

                    case Permissions.READ_CONTACTS:

                        if (!addPermission(act, Manifest.permission.READ_CONTACTS)) {
                            permissionsList.add(Manifest.permission.READ_CONTACTS);
                        }

                        break;

                    case Permissions.WRITE_CONTACTS:

                        if (!addPermission(act, Manifest.permission.WRITE_CONTACTS)) {
                            permissionsList.add(Manifest.permission.WRITE_CONTACTS);
                        }

                        break;

                    case Permissions.CAMERA:

                        if (!addPermission(act, Manifest.permission.CAMERA)) {
                            permissionsList.add(Manifest.permission.CAMERA);
                        }

                        break;

                    case Permissions.RECORD_AUDIO:

                        if (!addPermission(act, Manifest.permission.RECORD_AUDIO)) {
                            permissionsList.add(Manifest.permission.RECORD_AUDIO);
                        }

                        break;

                    case Permissions.READ_PHONE_STATE:

                        if (!addPermission(act, Manifest.permission.READ_PHONE_STATE)) {
                            permissionsList.add(Manifest.permission.READ_PHONE_STATE);
                        }

                        break;

                    case Permissions.READ_EXTERNAL_STORAGE:

                        if (!addPermission(act, Manifest.permission.READ_EXTERNAL_STORAGE)) {
                            permissionsList.add(Manifest.permission.READ_EXTERNAL_STORAGE);
                        }

                        break;

                    case Permissions.ACCESS_COARSE_LOCATION:

                        if (!addPermission(act, Manifest.permission.ACCESS_COARSE_LOCATION)) {
                            permissionsList.add(Manifest.permission.ACCESS_COARSE_LOCATION);
                        }

                        break;

                    case Permissions.READ_SMS:

                        if (!addPermission(act, Manifest.permission.READ_SMS)) {
                            permissionsList.add(Manifest.permission.READ_SMS);
                        }

                        break;
                }
            }

            try {
                ActivityCompat.requestPermissions(act, permissionsList.toArray(new String[permissionsList.size()]), REQUEST_CODE_ASK_MULTIPLE_PERMISSIONS);
            } catch (Exception ignore) {
            }
        }
    }

    private static boolean handleMarshmallowPermissions(final Activity act, int permission) {

        final List<String> permissionsList = new ArrayList<>();

        boolean status;
        switch (permission) {

            case Permissions.ACCESS_FINE_LOCATION:

                status = addPermission(act, Manifest.permission.ACCESS_FINE_LOCATION);

                if (status) {
                    return true;
                } else {
                    permissionsList.add(Manifest.permission.ACCESS_FINE_LOCATION);
                }

                break;

            case Permissions.READ_CONTACTS:

                status = addPermission(act, Manifest.permission.READ_CONTACTS);

                if (status) {
                    return true;
                } else {
                    permissionsList.add(Manifest.permission.READ_CONTACTS);
                }

                break;

            case Permissions.WRITE_CONTACTS:

                status = addPermission(act, Manifest.permission.WRITE_CONTACTS);

                if (status) {
                    return true;
                } else {
                    permissionsList.add(Manifest.permission.WRITE_CONTACTS);
                }

                break;

            case Permissions.CAMERA:

                status = addPermission(act, Manifest.permission.CAMERA);

                if (status) {
                    return true;
                } else {
                    permissionsList.add(Manifest.permission.CAMERA);
                }

                break;

            case Permissions.RECORD_AUDIO:

                status = addPermission(act, Manifest.permission.RECORD_AUDIO);

                if (status) {
                    return true;
                } else {
                    permissionsList.add(Manifest.permission.RECORD_AUDIO);
                }

                break;

            case Permissions.READ_PHONE_STATE:

                status = addPermission(act, Manifest.permission.READ_PHONE_STATE);

                if (status) {
                    return true;
                } else {
                    permissionsList.add(Manifest.permission.READ_PHONE_STATE);
                }

                break;

            case Permissions.READ_EXTERNAL_STORAGE:

                status = addPermission(act, Manifest.permission.READ_EXTERNAL_STORAGE);

                if (status) {
                    return true;
                } else {
                    permissionsList.add(Manifest.permission.READ_EXTERNAL_STORAGE);
                }

                break;

            case Permissions.READ_SMS:

                status = addPermission(act, Manifest.permission.READ_SMS);

                if (status) {
                    return true;
                } else {
                    permissionsList.add(Manifest.permission.READ_SMS);
                }

                break;
        }

        ActivityCompat.requestPermissions(act, permissionsList.toArray(new String[permissionsList.size()]), REQUEST_CODE_ASK_MULTIPLE_PERMISSIONS);

        return false;
    }

    private static boolean isMarshmallowPermissionAllowed(Context ctx, int permission) {

        switch (permission) {

            case Permissions.ACCESS_FINE_LOCATION:

                if (ContextCompat.checkSelfPermission(ctx, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                    return true;
                } else {
                    return false;
                }

            case Permissions.READ_CONTACTS:

                if (ContextCompat.checkSelfPermission(ctx, Manifest.permission.READ_CONTACTS) == PackageManager.PERMISSION_GRANTED) {
                    return true;
                } else {
                    return false;
                }

            case Permissions.WRITE_CONTACTS:

                if (ContextCompat.checkSelfPermission(ctx, Manifest.permission.WRITE_CONTACTS) == PackageManager.PERMISSION_GRANTED) {
                    return true;
                } else {
                    return false;
                }

            case Permissions.CAMERA:

                if (ContextCompat.checkSelfPermission(ctx, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
                    return true;
                } else {
                    return false;
                }

            case Permissions.RECORD_AUDIO:

                if (ContextCompat.checkSelfPermission(ctx, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) {
                    return true;
                } else {
                    return false;
                }

            case Permissions.READ_PHONE_STATE:

                if (ContextCompat.checkSelfPermission(ctx, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                    return true;
                } else {
                    return false;
                }

            case Permissions.READ_EXTERNAL_STORAGE:

                if (ContextCompat.checkSelfPermission(ctx, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                    return true;
                } else {
                    return false;
                }

            case Permissions.READ_SMS:

                if (ContextCompat.checkSelfPermission(ctx, Manifest.permission.READ_SMS) == PackageManager.PERMISSION_GRANTED) {
                    return true;
                } else {
                    return false;
                }

        }

        return false;
    }

    private static boolean addPermission(Activity act, final String permission) {

        if (ContextCompat.checkSelfPermission(act, permission) != PackageManager.PERMISSION_GRANTED) {

            List<String> permissionsList = new ArrayList<>();
            permissionsList.add(permission);

            if (ActivityCompat.shouldShowRequestPermissionRationale(act, permission)) {

                ActivityCompat.requestPermissions(act, permissionsList.toArray(new String[permissionsList.size()]), REQUEST_CODE_ASK_MULTIPLE_PERMISSIONS);
                return true;
            }

            return false;
        }

        return true;
    }
}
