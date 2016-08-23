package clover_studio.com.supertaxi.models;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class GetUserProfileModel extends BaseModel{

    public GetUserProfileInsideModel data;

    public class GetUserProfileInsideModel{
        public UserModel user;
    }

}
