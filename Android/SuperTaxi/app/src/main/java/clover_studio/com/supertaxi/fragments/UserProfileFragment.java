package clover_studio.com.supertaxi.fragments;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.google.gson.Gson;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import clover_studio.com.supertaxi.CameraCropActivity;
import clover_studio.com.supertaxi.CreateUserActivity;
import clover_studio.com.supertaxi.DriverHomeActivity;
import clover_studio.com.supertaxi.HomeActivity;
import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.UserHomeActivity;
import clover_studio.com.supertaxi.api.UploadFileManagement;
import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.UserRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseFragment;
import clover_studio.com.supertaxi.dialog.BasicDialog;
import clover_studio.com.supertaxi.dialog.CustomDialog;
import clover_studio.com.supertaxi.dialog.UploadFileDialog;
import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.models.UpdateProfileResponse;
import clover_studio.com.supertaxi.models.UserModel;
import clover_studio.com.supertaxi.models.post_models.KeyValueModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.ErrorUtils;
import clover_studio.com.supertaxi.utils.ImageUtils;
import clover_studio.com.supertaxi.utils.LogCS;
import clover_studio.com.supertaxi.utils.Utils;
import retrofit2.Response;

/**
 * Created by ivoperic on 13/07/16.
 */
public class UserProfileFragment extends BaseFragment{

    public static final int RESULT_CODE = 9999;

    private EditText etName;
    private EditText etAge;
    private EditText etNote;
    private Button buttonSave;
    private LinearLayout llForChangeImage;
    private ImageView ivAvatarImage;
    private String imagePath = null;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_user_profile, container, false);

        etName = (EditText) rootView.findViewById(R.id.etName);
        etAge = (EditText) rootView.findViewById(R.id.etAge);
        etNote = (EditText) rootView.findViewById(R.id.etNote);
        buttonSave = (Button) rootView.findViewById(R.id.buttonSave);
        llForChangeImage = (LinearLayout) rootView.findViewById(R.id.llEditImage);
        ivAvatarImage = (ImageView) rootView.findViewById(R.id.ivAvatar);

        etName.addTextChangedListener(checkForButton);
        etAge.addTextChangedListener(checkForButton);
        etNote.addTextChangedListener(checkForButton);

        buttonSave.setOnClickListener(onSaveClick);
        llForChangeImage.setOnClickListener(onImageChange);
        ivAvatarImage.setOnClickListener(onImageChange);

        UserModel myUser = UserSingleton.getInstance().getUser();
        if(myUser.user != null){
            if(!TextUtils.isEmpty(myUser.user.name)){
                etName.setText(myUser.user.name);
            }
            if(!TextUtils.isEmpty(myUser.user.note)){
                etNote.setText(myUser.user.note);
            }
            if(myUser.user.age != 0){
                etAge.setText(String.valueOf(myUser.user.age));
            }
        }
        String avatarUrl = Utils.getMyAvatarUrl();
        if(!TextUtils.isEmpty(avatarUrl)){
            llForChangeImage.setVisibility(View.GONE);
            ivAvatarImage.setVisibility(View.VISIBLE);
            ImageUtils.setImageWithPicasso(ivAvatarImage, avatarUrl);
        }

        return rootView;
    }

    TextWatcher checkForButton = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {}

        @Override
        public void afterTextChanged(Editable s) {

            if(etName.getText().toString().length() > 0 && etAge.getText().toString().length() > 0 && etNote.getText().toString().length() > 0){
                buttonSave.setEnabled(true);
            }else{
                buttonSave.setEnabled(false);
            }

        }
    };

    View.OnClickListener onSaveClick = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if(imagePath != null){
                uploadImage(imagePath);
            }else{
                updateProfileWithoutImage();
            }
        }
    };

    View.OnClickListener onImageChange = new View.OnClickListener() {
        @Override
        public void onClick(View v) {

            CustomDialog dialog = CustomDialog.startDialog(getActivity(), getActivity().getString(R.string.choose_camera_or_gallery));
            dialog.addTextAndClickListener(true, getActivity().getString(R.string.camera), new CustomDialog.OnItemClickedListener() {
                @Override
                public void onClicked(Dialog dialog) {
                    Intent intent;
                    intent = new Intent(getActivity(), CameraCropActivity.class);
                    intent.putExtra(Const.IntentParams.INTENT_TYPE, Const.IntentParams.CAMERA_INTENT);
                    startActivityForResult(intent, RESULT_CODE);
                }
            });
            dialog.addTextAndClickListener(true, getActivity().getString(R.string.gallery), new CustomDialog.OnItemClickedListener() {
                @Override
                public void onClicked(Dialog dialog) {
                    Intent intent;
                    intent = new Intent(getActivity(), CameraCropActivity.class);
                    intent.putExtra(Const.IntentParams.INTENT_TYPE, Const.IntentParams.GALLERY_INTENT);
                    startActivityForResult(intent, RESULT_CODE);
                }
            });

        }
    };

    private void updateProfileWithoutImage(){
        showProgress();
        UserRetroApiInterface retroApiInterface = getRetrofit().create(UserRetroApiInterface.class);
        final String name = etName.getText().toString();
        final String note = etNote.getText().toString();
        final String telNum = "+385976376676";
        final int age = Integer.parseInt(etAge.getText().toString());
        final int type = Const.UserType.USER_TYPE_USER;
        final String carType = "";
        final String carRegistration = "";
        final int feeStart = 0;
        final int feeKM = 0;
        retrofit2.Call<UpdateProfileResponse> call = retroApiInterface.updateProfile(name, type, telNum, age, note, carType, carRegistration, feeStart, feeKM, UserSingleton.getInstance().getUser().token_new);
        call.enqueue(new CustomResponse<UpdateProfileResponse>(getActivity(), true, true) {
            @Override
            public void onCustomSuccess(retrofit2.Call<UpdateProfileResponse> call, Response<UpdateProfileResponse> response) {
                super.onCustomSuccess(call, response);

                afterApi(response.body());

            }

            @Override
            public void onTryAgain(retrofit2.Call<UpdateProfileResponse> call, Response<UpdateProfileResponse> response) {
                super.onTryAgain(call, response);
                updateProfileWithoutImage();
            }
        });
    }

    private void uploadImage(final String path) {
        final UploadFileDialog dialog = UploadFileDialog.startDialog(getActivity());

        UploadFileManagement uploadFileManager = new UploadFileManagement();

        List<KeyValueModel> postModel = new ArrayList<>();
        final String name = etName.getText().toString();
        final String note = etNote.getText().toString();
        final String telNum = "+385976376676";
        final int age = Integer.parseInt(etAge.getText().toString());
        final int type = Const.UserType.USER_TYPE_USER;
        final String carType = "";
        final String carRegistration = "";
        final int feeStart = 0;
        final int feeKM = 0;
        postModel.add(new KeyValueModel(Const.PostParams.NAME, name));
        postModel.add(new KeyValueModel(Const.PostParams.NOTE, note));
        postModel.add(new KeyValueModel(Const.PostParams.TEL_NUM, telNum));
        postModel.add(new KeyValueModel(Const.PostParams.AGE, String.valueOf(age)));
        postModel.add(new KeyValueModel(Const.PostParams.TYPE, String.valueOf(type)));
        postModel.add(new KeyValueModel(Const.PostParams.CAR_TYPE, carType));
        postModel.add(new KeyValueModel(Const.PostParams.CAR_REGISTRATION, carRegistration));
        postModel.add(new KeyValueModel(Const.PostParams.FEE_KM, String.valueOf(feeKM)));
        postModel.add(new KeyValueModel(Const.PostParams.FEE_START, String.valueOf(feeStart)));

        String contentType = Const.ContentTypes.IMAGE_JPG;
        if(path.endsWith(".png")){
            contentType = Const.ContentTypes.IMAGE_PNG;
        }

        uploadFileManager.new BackgroundUploader(Const.BASE_URL + Const.Server.UPDATE_USER_API, new File(path), contentType, postModel, new UploadFileManagement.OnUploadResponse() {
            @Override
            public void onStart() {
                LogCS.d("LOG", "START");
            }

            @Override
            public void onSetMax(final int max) {
                getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        dialog.setMax(max);
                    }
                });
            }

            @Override
            public void onProgress(final int current) {
                getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        dialog.setCurrent(current);
                    }
                });
            }

            @Override
            public void onFinishUpload() {
                getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        dialog.fileUploaded();
                    }
                });
            }

            @Override
            public void onResponse(final boolean isSuccess, final String result) {
                getActivity().runOnUiThread(new Runnable() {
                    @SuppressWarnings("ResultOfMethodCallIgnored")
                    @Override
                    public void run() {
                        dialog.dismiss();
                        new File(path).delete();
                        if (!isSuccess) {
                            BasicDialog.startOneButtonDialog(getActivity(), getString(R.string.error), getString(R.string.error_unknown));
                        } else {

                            Gson gson = new Gson();
                            UpdateProfileResponse resultParsed = gson.fromJson(result, UpdateProfileResponse.class);

                            if (resultParsed instanceof BaseModel && resultParsed.code == 1) {

                                afterApi(resultParsed);

                            } else {
                                if (resultParsed instanceof BaseModel) {
                                    BasicDialog.startOneButtonDialog(getActivity(), getString(R.string.error), ErrorUtils.parseError(getResources(), resultParsed.code));
                                }
                            }

                        }
                    }
                });

            }
        }).execute();
    }

    private void afterApi(UpdateProfileResponse response){
        UserSingleton.getInstance().updateUser(response.data.user);

        hideProgress();
        Utils.hideKeyboard(etNote, getActivity());

        if(getActivity() != null && getActivity() instanceof HomeActivity){
            ((HomeActivity)getActivity()).refreshSidebar();
        }

        if(getActivity() != null && getActivity() instanceof CreateUserActivity){
            ((CreateUserActivity)getActivity()).apiDone();
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == RESULT_CODE && data != null && data.getExtras() != null) {

            Bundle extras = data.getExtras();

            String imagePath = extras.getString(Const.IntentParams.PATH_INTENT, null);
            ImageUtils.setImageWithPicasso(ivAvatarImage, new File(imagePath));
            ivAvatarImage.setVisibility(View.VISIBLE);
            llForChangeImage.setVisibility(View.GONE);
            this.imagePath = imagePath;

        }
    }
}
