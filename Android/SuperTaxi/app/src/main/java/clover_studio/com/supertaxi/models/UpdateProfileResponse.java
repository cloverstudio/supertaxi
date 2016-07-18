package clover_studio.com.supertaxi.models;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class UpdateProfileResponse extends BaseModel{

    public UpdateProfileResponseData data;

    public class UpdateProfileResponseData {
        public UserModel user;
    }

}
