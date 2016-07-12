package clover_studio.com.supertaxi.models.post_models;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class PostSignUpModel {
    public String email;
    public String password;
    public String secret;

    public PostSignUpModel(String email, String password, String secret){
        this.email = email;
        this.password = password;
        this.secret = secret;
    }

}
