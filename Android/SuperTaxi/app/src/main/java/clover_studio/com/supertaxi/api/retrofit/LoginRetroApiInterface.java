package clover_studio.com.supertaxi.api.retrofit;

import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.models.SignInDataModel;
import clover_studio.com.supertaxi.models.post_models.PostSignUpModel;
import clover_studio.com.supertaxi.utils.Const;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public interface LoginRetroApiInterface {

    @GET(Const.Server.TEST_API)
    Call<BaseModel> testApi();

    @POST(Const.Server.SIGN_UP)
    Call<SignInDataModel> signUp(@Body PostSignUpModel post);

    @POST(Const.Server.SIGN_IN)
    Call<SignInDataModel> signIn(@Body PostSignUpModel post);

}
