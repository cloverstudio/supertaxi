package clover_studio.com.supertaxi.utils;

import android.app.Activity;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import clover_studio.com.supertaxi.api.retrofit.CustomResponse;
import clover_studio.com.supertaxi.api.retrofit.LoginRetroApiInterface;
import clover_studio.com.supertaxi.models.BaseModel;
import retrofit2.Call;
import retrofit2.Response;
import retrofit2.Retrofit;

/**
 * Created by ubuntu_ivo on 09.02.16..
 */
public class SecretGeneratorUtils {

    private static String convertToHex(byte[] data) {
        StringBuilder buf = new StringBuilder();
        for (byte b : data) {
            int halfbyte = (b >>> 4) & 0x0F;
            int two_halfs = 0;
            do {
                buf.append((0 <= halfbyte) && (halfbyte <= 9) ? (char) ('0' + halfbyte) : (char) ('a' + (halfbyte - 10)));
                halfbyte = b & 0x0F;
            } while (two_halfs++ < 1);
        }
        return buf.toString();
    }

    public static String SHA1(String text) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        MessageDigest md = MessageDigest.getInstance("SHA-1");
        md.update(text.getBytes("iso-8859-1"), 0, text.length());
        byte[] sha1hash = md.digest();
        return convertToHex(sha1hash);
    }

    public static void getTimeForSecret(final String sha1Password, final Retrofit client, final Activity activity, final GetTimeForSecretListener listener){

        LoginRetroApiInterface retroApiInterface = client.create(LoginRetroApiInterface.class);
        Call<BaseModel> call = retroApiInterface.testApi();
        call.enqueue(new CustomResponse<BaseModel>(activity, true, true){

            @Override
            public void onCustomSuccess(Call<BaseModel> call, Response<BaseModel> response) {
                super.onCustomSuccess(call, response);
                BaseModel temp = response.body();
                long time = temp.time;
                time = time / 10000;
                String timePlusSalt = Const.Secrets.STATIC_SALT + time;

                try {

                    String sha1Secret = SecretGeneratorUtils.SHA1(timePlusSalt);
                    if(listener != null){
                        listener.getTimeSuccess(sha1Password, sha1Secret);
                    }
                } catch (NoSuchAlgorithmException e) {
                    e.printStackTrace();
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }

            }

            @Override
            public void onTryAgain(Call<BaseModel> call, Response<BaseModel> response) {
                super.onTryAgain(call, response);
                if(listener != null){
                    listener.getTimeTryAgainForProgress();
                }
                getTimeForSecret(sha1Password, client, activity, listener);
            }
        });

    }

    public interface GetTimeForSecretListener{
        void getTimeSuccess(String sha1Password, String sha1Secret);
        void getTimeTryAgainForProgress();
    }

}
