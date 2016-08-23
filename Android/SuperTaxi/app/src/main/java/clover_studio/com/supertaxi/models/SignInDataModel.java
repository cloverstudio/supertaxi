package clover_studio.com.supertaxi.models;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class SignInDataModel extends BaseModel{

    public SignInDataInsideModel data;

    @Override
    public String toString() {
        return "SignInDataModel{" +
                "data=" + data +
                '}';
    }

    public class SignInDataInsideModel{
        public UserModel user;
        public String token_new;
    }

}
