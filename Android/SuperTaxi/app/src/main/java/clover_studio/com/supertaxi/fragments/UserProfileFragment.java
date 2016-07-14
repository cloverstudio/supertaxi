package clover_studio.com.supertaxi.fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.telecom.Call;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.LoginRetroApiInterface;
import clover_studio.com.supertaxi.api.retrofit.UserRetroApiInterface;
import clover_studio.com.supertaxi.base.BaseFragment;
import clover_studio.com.supertaxi.models.BaseModel;
import clover_studio.com.supertaxi.models.MyUserDetailsModel;
import clover_studio.com.supertaxi.models.SignInDataModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.LogCS;
import clover_studio.com.supertaxi.utils.Utils;
import retrofit2.Response;

/**
 * Created by ivoperic on 13/07/16.
 */
public class UserProfileFragment extends BaseFragment{

    private EditText etName;
    private EditText etAge;
    private EditText etNote;
    private Button buttonSave;

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

        etName.addTextChangedListener(checkForButton);
        etAge.addTextChangedListener(checkForButton);
        etNote.addTextChangedListener(checkForButton);

        buttonSave.setOnClickListener(onSaveClick);

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
            updateProfileWithoutImage();
        }
    };

    private void updateProfileWithoutImage(){
        showProgress();
        UserRetroApiInterface retroApiInterface = getRetrofit().create(UserRetroApiInterface.class);
        final String name = etName.getText().toString();
        final String note = etName.getText().toString();
        final String telNum = "+385976376676";
        final int age = 27;
        final int type = 1;
        final String carType = "";
        final String carRegistration = "";
        final int feeStart = 0;
        final int feeKM = 0;
        retrofit2.Call<BaseModel> call = retroApiInterface.updateProfile(name, type, telNum, age, note, carType, carRegistration, feeStart, feeKM, UserSingleton.getInstance().getUser().token_new);
        call.enqueue(new CustomResponse<BaseModel>(getActivity(), true, true) {
            @Override
            public void onCustomSuccess(retrofit2.Call<BaseModel> call, Response<BaseModel> response) {
                super.onCustomSuccess(call, response);

                MyUserDetailsModel model = new MyUserDetailsModel();
                model.name = name;
                model.type = type;
                model.telNum = telNum;
                model.age = age;
                model.note = note;
                model.car_type = carType;
                model.car_registration = carRegistration;
                model.fee_start = feeStart;
                model.fee_km = feeKM;
                UserSingleton.getInstance().updateUserDetails(model);

                hideProgress();
                Utils.hideKeyboard(etNote, getActivity());

            }

            @Override
            public void onTryAgain(retrofit2.Call<BaseModel> call, Response<BaseModel> response) {
                super.onTryAgain(call, response);
                updateProfileWithoutImage();
            }
        });
    }

}
