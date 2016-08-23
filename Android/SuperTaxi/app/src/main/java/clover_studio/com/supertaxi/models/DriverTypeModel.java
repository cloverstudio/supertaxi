package clover_studio.com.supertaxi.models;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class DriverTypeModel extends BaseModel implements Parcelable{

    public String name;
    public String car_type;
    public String car_registration;
    public int fee_start;
    public int fee_km;

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.name);
        dest.writeString(this.car_type);
        dest.writeString(this.car_registration);
        dest.writeInt(this.fee_start);
        dest.writeInt(this.fee_km);
    }

    public DriverTypeModel() {
    }

    private DriverTypeModel(Parcel in) {
        this.name = in.readString();
        this.car_type = in.readString();
        this.car_registration = in.readString();
        this.fee_start = in.readInt();
        this.fee_km = in.readInt();
    }

    public static final Creator<DriverTypeModel> CREATOR = new Creator<DriverTypeModel>() {
        public DriverTypeModel createFromParcel(Parcel source) {
            return new DriverTypeModel(source);
        }

        public DriverTypeModel[] newArray(int size) {
            return new DriverTypeModel[size];
        }
    };

    @Override
    public String toString() {
        return "DriverTypeModel{" +
                "name='" + name + '\'' +
                ", car_type='" + car_type + '\'' +
                ", car_registration='" + car_registration + '\'' +
                ", fee_start=" + fee_start +
                ", fee_km=" + fee_km +
                '}';
    }
}
