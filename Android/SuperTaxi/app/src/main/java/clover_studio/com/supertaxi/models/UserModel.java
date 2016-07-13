package clover_studio.com.supertaxi.models;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class UserModel extends BaseModel implements Parcelable{

    public String _id;
    public String email;
    public long created;

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this._id);
        dest.writeString(this.email);
        dest.writeLong(this.created);
    }

    public UserModel() {
    }

    private UserModel(Parcel in) {
        this._id = in.readString();
        this.email = in.readString();
        this.created = in.readLong();
    }

    public static final Creator<UserModel> CREATOR = new Creator<UserModel>() {
        public UserModel createFromParcel(Parcel source) {
            return new UserModel(source);
        }

        public UserModel[] newArray(int size) {
            return new UserModel[size];
        }
    };
}
