package clover_studio.com.supertaxi.utils;

import android.util.Log;

import retrofit2.Call;

/**
 * Created by ubuntu_ivo on 22.07.15..
 */
public class LogCS {

    public static final String defaultLog = "LOG";

    public static void d(String tag, String message){
        Log.d(tag, message);
    }

    public static void d(String message){
        Log.d(defaultLog, message);
    }

    public static void e(String tag, String message){
        Log.e(tag, message);
    }

    public static void e(String message){
        Log.e(defaultLog, message);
    }

    public static void w(String tag, String message){
        Log.w(tag, message);
    }

    public static void w(String message){
        Log.w(defaultLog, message);
    }

    public static void v(String tag, String message){
        Log.v(tag, message);
    }

    public static void v(String message){
        Log.v(defaultLog, message);
    }

    public static void i(String tag, String message){
        Log.i(tag, message);
    }

    public static void i(String message){
        Log.i(defaultLog, message);
    }

    public static void custom(String tag, String message) {

        int maxLogSize = 1000;
        for (int i = 0; i <= message.length() / maxLogSize; i++) {

            int start = i * maxLogSize;
            int end = (i + 1) * maxLogSize;

            end = end > message.length() ? message.length() : end;

            LogCS.i(tag, message.substring(start, end));
        }
    }

    public static void logCallRetro (Call<?> call){
        if(call.request().url() != null) LogCS.w("LOG", "URL: " + call.request().url().toString());
        if(call.request().headers() != null)  LogCS.w("LOG", "HEADERS: " + call.request().headers().toString());
        if(call.request().body() != null) LogCS.w("LOG", "BODY: " + call.request().body().toString());
        if(call.request().method() != null) LogCS.w("LOG", "METHOD: " + call.request().method().toString());
    }

}
