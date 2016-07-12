package clover_studio.com.supertaxi.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import clover_studio.com.supertaxi.models.MyUserModel;

/**
 * Created by ubuntu_ivo on 22.07.15..
 */
public class Preferences {

    private SharedPreferences sharedPreferences;

    public Preferences(Context context) {
        sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
    }

    public String getCustomString(String key) {
        return sharedPreferences.getString(key, "");
    }

    public void setCustomString(String key, String value) {

        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(key, value);
        editor.apply();
    }

    public void setCustomBoolean(String key, boolean value) {

        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putBoolean(key, value);
        editor.apply();
    }

    public boolean getCustomBoolean(String key) {
        return sharedPreferences.getBoolean(key, false);
    }

    public void setCustomInt(String key, int value) {

        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putInt(key, value);
        editor.apply();
    }

    public int getCustomInt(String key) {
        return sharedPreferences.getInt(key, -1);
    }

    public void setCustomLong(String key, long value) {

        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putLong(key, value);
        editor.apply();
    }

    public Long getCustomLong(String key) {
        return sharedPreferences.getLong(key, -1);
    }

    public void setCustomFloat(String key, float value) {

        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putFloat(key, value);
        editor.apply();
    }

    public float getCustomFloat(String key) {

        try {
            return sharedPreferences.getFloat(key, 0.0f);

        } catch (Exception e) {
            return sharedPreferences.getInt(key, 0);
        }
    }

    public void setToken(String token){
        setCustomString(Const.PreferencesKey.TOKEN, token);
    }

    public String getToken(){
        return getCustomString(Const.PreferencesKey.TOKEN);
    }

    public void setPushToken(String token){
        setCustomString(Const.PreferencesKey.PUSH_TOKEN, token);
    }

    public String getPushToken(){
        return getCustomString(Const.PreferencesKey.PUSH_TOKEN);
    }

    public void setUserData(MyUserModel user){
        setCustomString(Const.PreferencesKey._ID, user.user._id);
        setCustomString(Const.PreferencesKey.USER_ID, user.user._id);
        setCustomString(Const.PreferencesKey.EMAIL, user.user.email);
        setCustomLong(Const.PreferencesKey.CREATED, user.user.created);
    }

    public void signOut(){
        removePreference(Const.PreferencesKey._ID);
        removePreference(Const.PreferencesKey.USER_ID);
        removePreference(Const.PreferencesKey.EMAIL);
        removePreference(Const.PreferencesKey.CREATED);
        removePreference(Const.PreferencesKey.TOKEN);
    }

    public void invalidToken(){
        removePreference(Const.PreferencesKey.TOKEN);
    }

    public void removePreference(String key) {

        SharedPreferences.Editor sharedEditor = sharedPreferences.edit();
        sharedEditor.remove(key);
        sharedEditor.apply();
    }

    public void clear() {

        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.clear();
        editor.apply();
    }

    public boolean hasPreferences(String key){
        if(sharedPreferences.contains(key)){
            return true;
        }
        return false;
    }

}
