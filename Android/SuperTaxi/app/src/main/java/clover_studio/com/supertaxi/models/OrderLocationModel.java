package clover_studio.com.supertaxi.models;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class OrderLocationModel extends BaseModel implements Parcelable{

    public List<Double> location;
    public String address;

    public OrderLocationModel(){};

    protected OrderLocationModel(Parcel in) {
        if (in.readByte() == 0x01) {
            location = new ArrayList<Double>();
            in.readList(location, Double.class.getClassLoader());
        } else {
            location = null;
        }
        address = in.readString();
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        if (location == null) {
            dest.writeByte((byte) (0x00));
        } else {
            dest.writeByte((byte) (0x01));
            dest.writeList(location);
        }
        dest.writeString(address);
    }

    @SuppressWarnings("unused")
    public static final Creator<OrderLocationModel> CREATOR = new Creator<OrderLocationModel>() {
        @Override
        public OrderLocationModel createFromParcel(Parcel in) {
            return new OrderLocationModel(in);
        }

        @Override
        public OrderLocationModel[] newArray(int size) {
            return new OrderLocationModel[size];
        }
    };

    @Override
    public String toString() {
        return "OrderLocationModel{" +
                "location=" + location +
                ", address='" + address + '\'' +
                '}';
    }
}
