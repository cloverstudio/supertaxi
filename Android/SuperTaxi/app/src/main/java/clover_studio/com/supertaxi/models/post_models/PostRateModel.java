package clover_studio.com.supertaxi.models.post_models;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class PostRateModel {
    public String id;
    public int type;
    public int rate;

    public PostRateModel(String id, int type, int rate){
        this.id = id;
        this.type = type;
        this.rate = rate;
    }

}
