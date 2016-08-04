package clover_studio.com.supertaxi.models;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class CallTaxiModel extends BaseModel{

    public CallTaxiData data;

    @Override
    public String toString() {
        return "CallTaxiModel{" +
                "data=" + data +
                '}';
    }

    public class CallTaxiData{
        public OrderModel order;

        @Override
        public String toString() {
            return "CallTaxiData{" +
                    "order=" + order +
                    '}';
        }
    }

}
