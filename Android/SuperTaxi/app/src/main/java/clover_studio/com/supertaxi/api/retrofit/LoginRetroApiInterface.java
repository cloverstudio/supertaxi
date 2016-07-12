package clover_studio.com.supertaxi.api.retrofit;

import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.utils.Const;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.POST;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public interface LoginRetroApiInterface {

    @POST(Const.Server.SIGN_UP)
    Call<BaseModel> testApi();

}
