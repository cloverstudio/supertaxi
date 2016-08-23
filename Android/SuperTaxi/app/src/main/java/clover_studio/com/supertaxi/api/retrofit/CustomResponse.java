package clover_studio.com.supertaxi.api.retrofit;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;

import java.io.IOException;

import clover_studio.com.supertaxi.LoginActivity;
import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.dialog.BasicDialog;
import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.ErrorUtils;
import clover_studio.com.supertaxi.utils.LogCS;
import retrofit2.Call;
import retrofit2.Response;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public abstract class CustomResponse<T> implements CustomResponseListener<T>{

    public CustomResponse(Context context, boolean shouldTryAgain, boolean shouldShowErrorDialog){
        this.context = context;
        this.shouldTryAgain = shouldTryAgain;
        this.shouldShowErrorDialog = shouldShowErrorDialog;
    }

    private Context context;
    private boolean shouldTryAgain = false;
    private boolean shouldShowErrorDialog = true;

    @Override
    public void onFailure(Call<T> call, Throwable t) {
        LogCS.e("LOG", t.toString());
        if(context instanceof BaseActivity){
            ((BaseActivity)context).hideProgress();
        }
        if(context != null){
            if(shouldShowErrorDialog){
                BasicDialog.startOneButtonDialog(context, context.getString(R.string.error), t.toString());
            }
        }
    }

    @Override
    public void onResponse(Call<T> call, Response<T> response) {
        if(response.body() instanceof BaseModel){
            if(((BaseModel)response.body()).code != 1){
                onCustomFailed(call, response);
            }else{
                onCustomSuccess(call, response);
            }
        }else if (response.body() instanceof String){
            LogCS.custom("LOG", "RESPONSE: " + response.body());
            onCustomFailed(call, response);
        }else{
            onCustomFailed(call, response);
        }
    }

    @Override
    public void onCustomFailed(final Call<T> call, final Response<T> response) {
        if(context instanceof BaseActivity){
            ((BaseActivity)context).hideProgress();
        }

        //invalid token
        if(response.body() instanceof BaseModel && context != null && context instanceof BaseActivity){
            if(((BaseModel) response.body()).code == Const.ErrorCodes.INVALID_TOKEN){
                ((BaseActivity)context).showInvalidToken();
            }
        }

        if(response.body() instanceof BaseModel){
            LogCS.e("LOG", "CUSTOM RESPONSE ERROR, CODE => " + ((BaseModel) response.body()).code + " || API URL => " + call.request().url());

            if(context instanceof Activity && ((BaseModel)response.body()).code == Const.ErrorCodes.INVALID_TOKEN){

                if(shouldShowErrorDialog){
                    BasicDialog dialog = BasicDialog.startOneButtonDialog(context, context.getString(R.string.error), ErrorUtils.parseError(context.getResources(), ((BaseModel) response.body()).code));
                    dialog.setOneButtonListener(new BasicDialog.OneButtonDialogListener() {
                        @Override
                        public void onOkClicked(BasicDialog dialog) {
                            UserSingleton.getInstance().singOut(context, true);
                            LoginActivity.startActivity((Activity) context);
                            ((Activity) context).finish();
                        }
                    });
                }

            }else{
                if(shouldShowErrorDialog){
                    if(((BaseModel) response.body()).code == Const.ErrorCodes.INVALID_TOKEN){
                        shouldTryAgain = false;
                    }
                    if(shouldTryAgain){
                        BasicDialog dialog = BasicDialog.startTwoButtonDialog(context, context.getString(R.string.error), ErrorUtils.parseError(context.getResources(), ((BaseModel) response.body()).code));
                        dialog.setButtonsText(context.getString(R.string.cancel), context.getString(R.string.try_again));
                        dialog.setTwoButtonListener(new BasicDialog.TwoButtonDialogListener() {
                            @Override
                            public void onOkClicked(BasicDialog dialog) {
                                dialog.dismiss();
                                CustomResponse.this.onTryAgain(call, response);
                            }

                            @Override
                            public void onCancelClicked(BasicDialog dialog) {
                                dialog.dismiss();
                            }
                        });
                    }else{
                        BasicDialog dialog = BasicDialog.startOneButtonDialog(context, context.getString(R.string.error), ErrorUtils.parseError(context.getResources(), ((BaseModel) response.body()).code));
                        if(((BaseModel) response.body()).code == Const.ErrorCodes.INVALID_TOKEN) {
                            dialog.setOneButtonListener(new BasicDialog.OneButtonDialogListener() {
                                @Override
                                public void onOkClicked(BasicDialog dialog) {
                                    LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(Const.ReceiverIntents.INVALID_TOKEN_BROADCAST));
                                }
                            });
                        }
                    }
                }
            }
        }else{
            LogCS.e("LOG", "CUSTOM RESPONSE ERROR, UNKNOWN ERROR" + " || API URL => " + call.request().url());
            if(shouldShowErrorDialog){
                if(shouldTryAgain){
                    BasicDialog dialog = BasicDialog.startTwoButtonDialog(context, context.getString(R.string.error), context.getString(R.string.error_unknown));
                    dialog.setButtonsText(context.getString(R.string.cancel), context.getString(R.string.try_again));
                    dialog.setTwoButtonListener(new BasicDialog.TwoButtonDialogListener() {
                        @Override
                        public void onOkClicked(BasicDialog dialog) {
                            dialog.dismiss();
                            CustomResponse.this.onTryAgain(call, response);
                        }

                        @Override
                        public void onCancelClicked(BasicDialog dialog) {
                            dialog.dismiss();
                        }
                    });
                }else{
                    BasicDialog.startOneButtonDialog(context, context.getString(R.string.error), context.getString(R.string.error_unknown));
                }
            }
        }
    }

    @Override
    public void onCustomSuccess(Call<T> call, Response<T> response) {

    }

    @Override
    public void onTryAgain(Call<T> call, Response<T> response) {

    }

}
