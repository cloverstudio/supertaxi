package clover_studio.com.supertaxi.models;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class ImageAvatarModel extends BaseModel implements Parcelable{

    public String fileid;
    public String thumbfileid;

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.fileid);
        dest.writeString(this.thumbfileid);
    }

    public ImageAvatarModel() {
    }

    private ImageAvatarModel(Parcel in) {
        this.fileid = in.readString();
        this.thumbfileid = in.readString();
    }

    public static final Creator<ImageAvatarModel> CREATOR = new Creator<ImageAvatarModel>() {
        public ImageAvatarModel createFromParcel(Parcel source) {
            return new ImageAvatarModel(source);
        }

        public ImageAvatarModel[] newArray(int size) {
            return new ImageAvatarModel[size];
        }
    };
}
