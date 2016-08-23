package clover_studio.com.supertaxi.models;

import java.util.List;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class DriverListResponse extends BaseModel{

    public DriverListData data;

    public class DriverListData {
        public List<DriverData> drivers;
    }

    public class DriverData {
        public String _id;
        public String email;
        public long created;
        public String telNum;
        public double averageRate;
        public ImageAvatarModel avatar;
        public DriverTypeModel driver;
        public double[] currentLocation;
    }

}
