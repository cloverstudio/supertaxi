package clover_studio.com.supertaxi.models;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class OrderModel extends BaseModel implements Parcelable{

    public String _id;
    public String userId;
    public String createOrderTs;
    public int crewNum;
    public OrderLocationModel to;
    public OrderLocationModel from;

    public OrderModel(){};

    protected OrderModel(Parcel in) {
        _id = in.readString();
        userId = in.readString();
        createOrderTs = in.readString();
        crewNum = in.readInt();
        to = (OrderLocationModel) in.readValue(OrderLocationModel.class.getClassLoader());
        from = (OrderLocationModel) in.readValue(OrderLocationModel.class.getClassLoader());
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(_id);
        dest.writeString(userId);
        dest.writeString(createOrderTs);
        dest.writeInt(crewNum);
        dest.writeValue(to);
        dest.writeValue(from);
    }

    @SuppressWarnings("unused")
    public static final Creator<OrderModel> CREATOR = new Creator<OrderModel>() {
        @Override
        public OrderModel createFromParcel(Parcel in) {
            return new OrderModel(in);
        }

        @Override
        public OrderModel[] newArray(int size) {
            return new OrderModel[size];
        }
    };

    @Override
    public String toString() {
        return "OrderModel{" +
                "_id='" + _id + '\'' +
                ", userId='" + userId + '\'' +
                ", createOrderTs='" + createOrderTs + '\'' +
                ", crewNum=" + crewNum +
                ", to=" + to +
                ", from=" + from +
                '}';
    }
}
