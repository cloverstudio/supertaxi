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
            case Const.ErrorCodes.LATITUDE_FROM:
                return res.getString(R.string.error_latitude_from);
            case Const.ErrorCodes.LONGITUDE_FROM:
                return res.getString(R.string.error_longitude_from);
            case Const.ErrorCodes.NO_ADDRESS_FROM:
                return res.getString(R.string.error_address_from);
            case Const.ErrorCodes.NO_ADDRESS_TO:
                return res.getString(R.string.error_address_to);
            case Const.ErrorCodes.LATITUDE_TO:
                return res.getString(R.string.error_latitude_to);
            case Const.ErrorCodes.LONGITUDE_TO:
                return res.getString(R.string.error_longitude_to);
            case Const.ErrorCodes.CREW_NUMBER:
                return res.getString(R.string.error_crew_number);
            case Const.ErrorCodes.NO_EMAIL:
                return res.getString(R.string.error_no_email);
            case Const.ErrorCodes.NO_PASSWORD:
                return res.getString(R.string.error_no_password);
            case Const.ErrorCodes.NO_SECRET:
                return res.getString(R.string.error_no_secret);
            case Const.ErrorCodes.SIGN_IN_ERROR:
                return res.getString(R.string.error_sign_in);
            case Const.ErrorCodes.WRONG_EMAIL:
                return res.getString(R.string.error_wrong_email);
            case Const.ErrorCodes.WRONG_PASSWORD:
                return res.getString(R.string.error_wrong_password);
            case Const.ErrorCodes.WRONG_SECRET:
                return res.getString(R.string.error_wrong_secret);
            case Const.ErrorCodes.EMAIL_EXISTS:
                return res.getString(R.string.error_email_exists);
            case Const.ErrorCodes.ALREADY_ACCEPTED_OR_CANCELED:
                return res.getString(R.string.error_already_accepted_or_canceled);
            case Const.ErrorCodes.ALREADY_STARTED_OR_CANCELED:
                return res.getString(R.string.error_already_started_or_canceled);
            default:
                return res.getString(R.string.error_unknown);
        }
    }

}
