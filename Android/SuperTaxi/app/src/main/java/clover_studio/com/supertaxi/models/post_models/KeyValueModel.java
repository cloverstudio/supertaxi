package clover_studio.com.supertaxi.models.post_models;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class KeyValueModel {
    public String key;
    public String value;

    public KeyValueModel(String key, String value){
        this.key = key;
        this.value = value;
    }

    @Override
    public String toString() {
        return "KeyValueModel{" +
                "key='" + key + '\'' +
                ", value='" + value + '\'' +
                '}';
    }
}
