package clover_studio.com.supertaxi.api.retrofit;

import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.models.SignInDataModel;
import clover_studio.com.supertaxi.models.post_models.PostSignUpModel;
import clover_studio.com.supertaxi.utils.Const;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.Part;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public interface UserRetroApiInterface {

    @Multipart
    @POST(Const.Server.UPDATE_USER_API)
    Call<BaseModel> updateProfile(@Part(Const.PostParams.NAME) String name,
                                  @Part(Const.PostParams.TYPE) int type,
                                  @Part(Const.PostParams.TEL_NUM) String telNum,
                                  @Part(Const.PostParams.AGE) int age,
                                  @Part(Const.PostParams.NOTE) String note,
                                  @Part(Const.PostParams.CAR_TYPE) String car_type,
                                  @Part(Const.PostParams.CAR_REGISTRATION) String car_registration,
                                  @Part(Const.PostParams.FEE_START) int fee_start,
                                  @Part(Const.PostParams.FEE_KM) int fee_km,
                                  @Header(Const.HeadersParams.ACCESS_TOKEN) String token);


}
