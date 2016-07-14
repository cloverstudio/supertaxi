package clover_studio.com.supertaxi.base;

import android.support.v4.app.Fragment;

import clover_studio.com.supertaxi.utils.Const;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.converter.scalars.ScalarsConverterFactory;

/**
 * Created by ubuntu_ivo on 12.02.16..
 */
public class BaseFragment extends Fragment {

    public Retrofit getRetrofit(){
        if(getActivity() instanceof BaseActivity){
            return ((BaseActivity)getActivity()).getRetrofit();
        }else{
            return new Retrofit.Builder()
                    .baseUrl(Const.BASE_URL)
                    .addConverterFactory(ScalarsConverterFactory.create())
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();
        }
    }

    public void showProgress(){
        if(getActivity() instanceof BaseActivity){
            ((BaseActivity)getActivity()).showProgress();
        }
    }

    public void hideProgress(){
        if(getActivity() instanceof BaseActivity){
            ((BaseActivity)getActivity()).hideProgress();
        }
    }

}
