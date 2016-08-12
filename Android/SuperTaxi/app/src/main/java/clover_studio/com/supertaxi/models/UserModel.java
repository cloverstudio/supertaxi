package clover_studio.com.supertaxi.models;

import android.os.Parcel;
import android.os.Parcelable;
import android.support.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class UserModel extends BaseModel implements Parcelable{

    public String _id;
    public String email;
    public long created;
    public String telNum;
    public ImageAvatarModel avatar;
    public DriverTypeModel driver;
    public UserTypeModel user;

    @Nullable public List<Double> currentLocation;

    public int type;
    public String token_new;

    public UserModel(){};

    protected UserModel(Parcel in) {
        _id = in.readString();
        email = in.readString();
        created = in.readLong();
        telNum = in.readString();
        avatar = (ImageAvatarModel) in.readValue(ImageAvatarModel.class.getClassLoader());
        driver = (DriverTypeModel) in.readValue(DriverTypeModel.class.getClassLoader());
        user = (UserTypeModel) in.readValue(UserTypeModel.class.getClassLoader());
        type = in.readInt();
        token_new = in.readString();
        if (in.readByte() == 0x01) {
            currentLocation = new ArrayList<Double>();
            in.readList(currentLocation, Double.class.getClassLoader());
        } else {
            currentLocation = null;
        }
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(_id);
        dest.writeString(email);
        dest.writeLong(created);
        dest.writeString(telNum);
        dest.writeValue(avatar);
        dest.writeValue(driver);
        dest.writeValue(user);
        dest.writeInt(type);
        dest.writeString(token_new);
        if (currentLocation == null) {
            dest.writeByte((byte) (0x00));
        } else {
            dest.writeByte((byte) (0x01));
            dest.writeList(currentLocation);
        }
    }

    @SuppressWarnings("unused")
    public static final Parcelable.Creator<UserModel> CREATOR = new Parcelable.Creator<UserModel>() {
        @Override
        public UserModel createFromParcel(Parcel in) {
            return new UserModel(in);
        }

        @Override
        public UserModel[] newArray(int size) {
            return new UserModel[size];
        }
    };

    @Override
    public String toString() {
        return "UserModel{" +
                "_id='" + _id + '\'' +
                ", email='" + email + '\'' +
                ", created=" + created +
                ", telNum='" + telNum + '\'' +
                ", avatar=" + avatar +
                ", driver=" + driver +
                ", user=" + user +
                ", currentLocation=" + currentLocation +
                ", type=" + type +
                ", token_new='" + token_new + '\'' +
                '}';
    }
}
