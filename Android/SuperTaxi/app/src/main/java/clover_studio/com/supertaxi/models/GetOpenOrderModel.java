package clover_studio.com.supertaxi.models;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class GetOpenOrderModel extends BaseModel{

    public GetOpenOrderModelData data;

    @Override
    public String toString() {
        return "GetOpenOrderModel{" +
                "data=" + data +
                '}';
    }

    public class GetOpenOrderModelData{
        public OrderModel order;

        @Override
        public String toString() {
            return "GetOpenOrderModelData{" +
                    "order=" + order +
                    '}';
        }
    }

}
