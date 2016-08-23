package clover_studio.com.supertaxi.api.retrofit;

import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.models.CallTaxiModel;
import clover_studio.com.supertaxi.models.DriverListResponse;
import clover_studio.com.supertaxi.models.GetOpenOrderModel;
import clover_studio.com.supertaxi.models.post_models.PostAcceptOrderModel;
import clover_studio.com.supertaxi.models.post_models.PostCallTaxiModel;
import clover_studio.com.supertaxi.models.post_models.PostCancelTripModel;
import clover_studio.com.supertaxi.models.post_models.PostLatLngModel;
import clover_studio.com.supertaxi.utils.Const;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.Header;
import retrofit2.http.POST;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public interface DriverRetroApiInterface {

    @POST(Const.Server.GET_DRIVER_LIST)
    Call<DriverListResponse> getDriverList(@Body PostLatLngModel postModel, @Header(Const.HeadersParams.ACCESS_TOKEN) String token);

    @POST(Const.Server.CALL_TAXI)
    Call<CallTaxiModel> callTaxi(@Body PostCallTaxiModel postModel, @Header(Const.HeadersParams.ACCESS_TOKEN) String token);

    @POST(Const.Server.CANCEL_TRIP)
    Call<BaseModel> cancelTrip(@Body PostCancelTripModel postModel, @Header(Const.HeadersParams.ACCESS_TOKEN) String token);

    @POST(Const.Server.GET_OPEN_ORDER)
    Call<GetOpenOrderModel> getOpenOrder(@Body PostLatLngModel postModel, @Header(Const.HeadersParams.ACCESS_TOKEN) String token);

    @POST(Const.Server.ACCEPT_ORDER)
    Call<BaseModel> acceptOrder(@Body PostAcceptOrderModel postModel, @Header(Const.HeadersParams.ACCESS_TOKEN) String token);

    @POST(Const.Server.UPDATE_ARRIVE_TIME)
    Call<BaseModel> updateArriveTime(@Body PostAcceptOrderModel postModel, @Header(Const.HeadersParams.ACCESS_TOKEN) String token);

    @POST(Const.Server.UPDATE_FINISH_TIME)
    Call<BaseModel> updateFinishTime(@Body PostAcceptOrderModel postModel, @Header(Const.HeadersParams.ACCESS_TOKEN) String token);

    @POST(Const.Server.UPDATE_START_TIME)
    Call<BaseModel> updateStartTime(@Body PostAcceptOrderModel postModel, @Header(Const.HeadersParams.ACCESS_TOKEN) String token);

}
