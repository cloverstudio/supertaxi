package clover_studio.com.supertaxi.utils;

import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;

import com.squareup.picasso.Callback;
import com.squareup.picasso.NetworkPolicy;
import com.squareup.picasso.Picasso;

import java.io.File;

/**
 * Created by ivoperic on 15/07/16.
 */
public class ImageUtils {

    public static void setImageWithPicasso(final ImageView imageView, final String url){
        setImageWithPicasso(imageView, url, null);
    }

    public static void setImageWithPicasso(final ImageView imageView, final String url, final ProgressBar loading){
        setImageWithPicasso(imageView, url, loading, -1);
    }

    public static void setImageWithPicasso(final ImageView imageView, final String url, final ProgressBar loading, final int resourceId){
        if(!TextUtils.isEmpty(url)){
            Picasso.with(imageView.getContext()).load(url).networkPolicy(NetworkPolicy.OFFLINE).into(imageView, new Callback() {
                @Override
                public void onSuccess() {
                    if(loading != null) loading.setVisibility(View.GONE);
                }

                @Override
                public void onError() {
                    Picasso.with(imageView.getContext()).load(url).into(imageView, new Callback() {
                        @Override
                        public void onSuccess() {
                            if(loading != null) loading.setVisibility(View.GONE);
                        }

                        @Override
                        public void onError() {
                            if(loading != null) loading.setVisibility(View.GONE);
                            if(resourceId != -1){
                                imageView.setImageResource(resourceId);
                            }
                        }
                    });
                }
            });
        }else{
            if(loading != null) loading.setVisibility(View.GONE);
            if(resourceId != -1){
                imageView.setImageResource(resourceId);
            }
        }
    }

    public static void setImageWithPicasso(final ImageView imageView, final File file){
        if(file.exists()){
            Picasso.with(imageView.getContext()).load(file).networkPolicy(NetworkPolicy.OFFLINE).into(imageView);
        }
    }

}
