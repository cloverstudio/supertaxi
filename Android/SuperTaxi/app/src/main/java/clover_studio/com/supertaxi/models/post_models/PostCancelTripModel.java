package clover_studio.com.supertaxi.models.post_models;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class PostCancelTripModel {
    public String orderId;
    public int type;
    public String reason;

    public PostCancelTripModel(String orderId, int type, String reason){
        this.orderId = orderId;
        this.type = type;
        this.reason = reason;
    }

    @Override
    public String toString() {
        return "PostCancelTripModel{" +
                "orderId='" + orderId + '\'' +
                ", type=" + type +
                ", reason='" + reason + '\'' +
                '}';
    }
}
