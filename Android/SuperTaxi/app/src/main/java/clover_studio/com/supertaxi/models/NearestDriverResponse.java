package clover_studio.com.supertaxi.models;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class NearestDriverResponse extends BaseModel{

    public NearestDriverData data;

    public class NearestDriverData {
        public UserModel driver;
    }

}
