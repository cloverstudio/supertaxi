package clover_studio.com.supertaxi.models;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class UserTypeModel extends BaseModel implements Parcelable{

    public String name;
    public String note;
    public int age;

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.name);
        dest.writeString(this.note);
        dest.writeInt(this.age);
    }

    public UserTypeModel() {
    }

    private UserTypeModel(Parcel in) {
        this.name = in.readString();
        this.note = in.readString();
        this.age = in.readInt();
    }

    public static final Creator<UserTypeModel> CREATOR = new Creator<UserTypeModel>() {
        public UserTypeModel createFromParcel(Parcel source) {
            return new UserTypeModel(source);
        }

        public UserTypeModel[] newArray(int size) {
            return new UserTypeModel[size];
        }
    };

    @Override
    public String toString() {
        return "UserTypeModel{" +
                "name='" + name + '\'' +
                ", note='" + note + '\'' +
                ", age=" + age +
                '}';
    }
}
