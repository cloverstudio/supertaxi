package clover_studio.com.supertaxi.models;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class CheckOrderStatusModel extends BaseModel implements Parcelable{

    public CheckOrderStatusDataModel data;

    protected CheckOrderStatusModel(Parcel in) {
        data = (CheckOrderStatusDataModel) in.readValue(CheckOrderStatusDataModel.class.getClassLoader());
    }

    @Override
    public String toString() {
        return "CheckOrderStatusModel{" +
                "data=" + data +
                '}';
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeValue(data);
    }

    @SuppressWarnings("unused")
    public static final Parcelable.Creator<CheckOrderStatusModel> CREATOR = new Parcelable.Creator<CheckOrderStatusModel>() {
        @Override
        public CheckOrderStatusModel createFromParcel(Parcel in) {
            return new CheckOrderStatusModel(in);
        }

        @Override
        public CheckOrderStatusModel[] newArray(int size) {
            return new CheckOrderStatusModel[size];
        }
    };

}
