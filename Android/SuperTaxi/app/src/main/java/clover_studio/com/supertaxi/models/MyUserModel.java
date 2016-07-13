package clover_studio.com.supertaxi.models;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class MyUserModel extends BaseModel{

    public String token_new;
    public MyUser user;

    public class MyUser{

        public String _id;
        public String email;
        public long created;

        @Override
        public String toString() {
            return "MyUser{" +
                    "_id='" + _id + '\'' +
                    ", email='" + email + '\'' +
                    ", created=" + created +
                    '}';
        }
    }

    @Override
    public String toString() {
        return "MyUserModel{" +
                "token_new='" + token_new + '\'' +
                ", user=" + user +
                '}';
    }
}
