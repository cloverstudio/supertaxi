package clover_studio.com.supertaxi.models;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class CheckOrderStatusDataModel extends BaseModel implements Parcelable{

    public int orderStatus;
    public UserModel driver;
    public int cancelType;

    protected CheckOrderStatusDataModel(Parcel in) {
        orderStatus = in.readInt();
        driver = (UserModel) in.readValue(UserModel.class.getClassLoader());
        cancelType = in.readInt();
    }

    @Override
    public String toString() {
        return "CheckOrderStatusModel{" +
                "orderStatus=" + orderStatus +
                ", driver=" + driver +
                ", cancelType=" + cancelType +
                '}';
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(orderStatus);
        dest.writeValue(driver);
        dest.writeInt(cancelType);
    }

    @SuppressWarnings("unused")
    public static final Creator<CheckOrderStatusDataModel> CREATOR = new Creator<CheckOrderStatusDataModel>() {
        @Override
        public CheckOrderStatusDataModel createFromParcel(Parcel in) {
            return new CheckOrderStatusDataModel(in);
        }

        @Override
        public CheckOrderStatusDataModel[] newArray(int size) {
            return new CheckOrderStatusDataModel[size];
        }
    };

}
