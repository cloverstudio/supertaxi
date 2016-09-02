package clover_studio.com.supertaxi.dialog;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.DriverRetroApiInterface;
import clover_studio.com.supertaxi.api.retrofit.UserRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.models.OrderModel;
import clover_studio.com.supertaxi.models.post_models.PostCancelTripModel;
import clover_studio.com.supertaxi.models.post_models.PostRateModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.AnimationUtils;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.ImageUtils;
import clover_studio.com.supertaxi.utils.LogCS;
import clover_studio.com.supertaxi.utils.Utils;
import retrofit2.Call;
import retrofit2.Response;

public class RateUserDialog extends Dialog {

    RelativeLayout parentLayout;
    RelativeLayout mainLayout;

    private ImageView ivAvatar;
    private TextView tvName;
    private TextView tvAge;
    private TextView tvFrom;
    private TextView tvTo;
    private TextView tvNote;
    private LinearLayout llStarLayout;

    private OrderModel order;
    private boolean startClicked = false;

    public static RateUserDialog startDialog(Context context, OrderModel order) {
        return new RateUserDialog(context, order);
    }

    public RateUserDialog(Context context, OrderModel order) {
        super(context, R.style.Theme_Dialog_no_dim);

        setOwnerActivity((Activity) context);
        setCancelable(true);
        setCanceledOnTouchOutside(true);

        this.order = order;

        show();

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_rate_user);

        parentLayout = (RelativeLayout) findViewById(R.id.parentLayout);
        ivAvatar = (ImageView) findViewById(R.id.ivAvatarInUserDetails);
        llStarLayout = (LinearLayout) findViewById(R.id.bigStarsLayout);

        String url = Utils.getAvatarUrl(order.user);
        ImageUtils.setImageWithPicasso(ivAvatar, url);

        for(int i = 0; i < llStarLayout.getChildCount(); i++){
            ImageView star = (ImageView) llStarLayout.getChildAt(i);
            Integer tag = i + 1;
            star.setTag(tag);
            star.setOnClickListener(onStarClicked);
        }

        findViewById(R.id.buttonDoItNextTime).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });

    }

    private View.OnClickListener onStarClicked = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if(startClicked) {
                return;
            }
            startClicked = true;
            Integer tag = (Integer) v.getTag();
            for(int i = 0; i < tag; i++){
                if(i < llStarLayout.getChildCount()){
                    llStarLayout.getChildAt(i).setSelected(true);
                }
            }
            rateProfileApi(tag, order.user._id);
        }
    };

    private void rateProfileApi(final int rate, final String userId){
        if(getOwnerActivity() instanceof BaseActivity){
            PostRateModel postModel = new PostRateModel(userId, Const.UserType.USER_TYPE_USER, rate);
            UserRetroApiInterface retroApiInterface = ((BaseActivity)getOwnerActivity()).getRetrofit().create(UserRetroApiInterface.class);
            Call<BaseModel> call = retroApiInterface.rateProfile(postModel, UserSingleton.getInstance().getUser().token_new);
            call.enqueue(new CustomResponse<BaseModel>(getOwnerActivity(), true, true) {

                @Override
                public void onCustomSuccess(Call<BaseModel> call, Response<BaseModel> response) {
                    super.onCustomSuccess(call, response);

                    dismiss();

                }

                @Override
                public void onTryAgain(Call<BaseModel> call, Response<BaseModel> response) {
                    super.onTryAgain(call, response);
                    rateProfileApi(rate, userId);
                }

            });
        }
    }

    @Override
    public void dismiss() {
        AnimationUtils.fade(parentLayout, 1, 0, 300, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                RateUserDialog.super.dismiss();
            }
        });

    }

    @Override
    public void show() {
        super.show();
        AnimationUtils.fade(parentLayout, 0, 1, 300, null);
    }

}