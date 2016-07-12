package clover_studio.com.supertaxi.utils;

import android.content.res.Resources;

import clover_studio.com.supertaxi.R;

/**
 * Created by ubuntu_ivo on 08.02.16..
 */
public class ErrorUtils {

    public static String parseError(Resources res, int code){
        switch (code){
            case Const.ErrorCodes.INVALID_TOKEN:
                return res.getString(R.string.error_invalid_token);
            case Const.ErrorCodes.NO_NAME:
                return res.getString(R.string.error_no_name);
            case Const.ErrorCodes.WRONG_TYPE:
                return res.getString(R.string.error_wrong_type);
            case Const.ErrorCodes.FEE_START:
                return res.getString(R.string.error_fee_start);
            case Const.ErrorCodes.FEE_KM:
                return res.getString(R.string.error_fee_km);
            case Const.ErrorCodes.WRONG_IMAGE_TYPE:
                return res.getString(R.string.error_wrong_image_type);
            case Const.ErrorCodes.AGE:
                return res.getString(R.string.error_age);
            case Const.ErrorCodes.WRONG_TEL_NUM:
                return res.getString(R.string.error_wrong_tel_num);
            default:
                return res.getString(R.string.error_unknown);
        }
    }

}
