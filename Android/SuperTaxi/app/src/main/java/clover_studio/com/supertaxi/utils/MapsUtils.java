package clover_studio.com.supertaxi.utils;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;
import com.squareup.picasso.Callback;
import com.squareup.picasso.NetworkPolicy;
import com.squareup.picasso.Picasso;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import clover_studio.com.supertaxi.JsonParser;
import clover_studio.com.supertaxi.R;

/**
 * Created by ivoperic on 15/07/16.
 */
public class MapsUtils {

    public static void calculateRoute(LatLng startLocation, LatLng destinationLocation, List<LatLng> middleLocations, final OnRouteCalculated listener, final Activity activity){
        String url = makeUrl(startLocation, destinationLocation, middleLocations);
        JsonParser parser = new JsonParser();
        parser.getJSONFromUrl(url, new JsonParser.OnResult() {
            @Override
            public void onResult(final String json) {
                parseResult(json, listener, activity);
            }
        });
    }

    public static void calculateRoute(LatLng startLocation, LatLng destinationLocation, OnRouteCalculated listener, Activity activity){
        calculateRoute(startLocation, destinationLocation, null, listener, activity);
    }

    public static void calculateRouteWithAlternatives(LatLng startLocation, LatLng destinationLocation, final OnRouteWithAlternativesCalculated listener, final Activity activity){
        String url = makeUrl(startLocation, destinationLocation, null);
        JsonParser parser = new JsonParser();
        parser.getJSONFromUrl(url, new JsonParser.OnResult() {
            @Override
            public void onResult(final String json) {
                parseResultWithAlternatives(json, listener, activity);
            }
        });
    }

    public static void getDistanceBetween(LatLng startLocation, LatLng destinationLocation, final OnDistanceCalculated distanceListener, final Activity activity){
        String url = makeUrl(startLocation, destinationLocation);
        JsonParser parser = new JsonParser();
        parser.getJSONFromUrl(url, new JsonParser.OnResult() {
            @Override
            public void onResult(final String json) {
                getDistance(json, distanceListener, activity);
            }
        });
    }

    private static String makeUrl(LatLng startLocation, LatLng destinationLocation){
        return makeUrl(startLocation, destinationLocation, null);
    }

    private static String makeUrl(LatLng startLocation, LatLng destinationLocation, List<LatLng> middleLocations){
        StringBuilder urlString = new StringBuilder();
        urlString.append("https://maps.googleapis.com/maps/api/directions/json");
        urlString.append("?origin=");// from
        urlString.append(Double.toString(startLocation.latitude));
        urlString.append(",");
        urlString.append(Double.toString( startLocation.longitude));
        if(middleLocations != null && middleLocations.size() > 0){
            for(LatLng item : middleLocations){
                urlString.append("&waypoints=");
                urlString.append(Double.toString(item.latitude));
                urlString.append(",");
                urlString.append(Double.toString(item.longitude));
            }
        }
        urlString.append("&destination=");// to
        urlString.append(Double.toString( destinationLocation.latitude));
        urlString.append(",");
        urlString.append(Double.toString( destinationLocation.longitude));
        urlString.append("&sensor=false&mode=driving&alternatives=true");
        urlString.append("&key=AIzaSyBONAsYG4Pq-Sx9obbuHxlDaj4aa872kvs");
        Log.d("LOG", "URL: " + urlString.toString());
        return urlString.toString();
    }

    private static void parseResult(String result, final OnRouteCalculated listener, Activity activity) {

        try {
            //Tranform the string into a json object
            final JSONObject json = new JSONObject(result);
            JSONArray routeArray = json.getJSONArray("routes");
            JSONObject routes = routeArray.getJSONObject(0);
            JSONObject overviewPolylines = routes.getJSONObject("overview_polyline");
            String encodedString = overviewPolylines.getString("points");
            JSONArray legs = routes.getJSONArray("legs");
            JSONObject leg = legs.getJSONObject(0);
            JSONObject distance = leg.getJSONObject("distance");
            final String distanceString = distance.getString("text");
            final long distanceValue = distance.getLong("value");
            final List<LatLng> list = decodePoly(encodedString);
            if(listener != null){
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        listener.onSuccessCalculate(list, distanceString, distanceValue);
                    }
                });
            }

        }
        catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private static void parseResultWithAlternatives(String result, final OnRouteWithAlternativesCalculated listener, Activity activity) {

        try {
            //Tranform the string into a json object
            final JSONObject json = new JSONObject(result);
            JSONArray routeArray = json.getJSONArray("routes");
            final List<List<LatLng>> list = new ArrayList<>();
            String distanceString = null;
            long distanceValue = 0;
            for(int i = 0; i < routeArray.length(); i++){

                JSONObject routes = routeArray.getJSONObject(i);
                JSONObject overviewPolylines = routes.getJSONObject("overview_polyline");
                String encodedString = overviewPolylines.getString("points");
                JSONArray legs = routes.getJSONArray("legs");
                JSONObject leg = legs.getJSONObject(0);
                JSONObject distance = leg.getJSONObject("distance");
                if (distanceString == null) {
                    distanceString = distance.getString("text");
                    distanceValue = distance.getLong("value");
                }
                List<LatLng> inner = decodePoly(encodedString);
                list.add(inner);

            }

            final String finalDistanceString = distanceString;
            final long finalDistanceValue = distanceValue;

            if(listener != null){
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        listener.onSuccessCalculate(list, finalDistanceString, finalDistanceValue);
                    }
                });
            }

        }
        catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private static void getDistance(String result, final OnDistanceCalculated listener, Activity activity) {

        try {
            //Tranform the string into a json object
            final JSONObject json = new JSONObject(result);
            JSONArray routeArray = json.getJSONArray("routes");
            JSONObject routes = routeArray.getJSONObject(0);
            JSONArray legs = routes.getJSONArray("legs");
            JSONObject leg = legs.getJSONObject(0);
            JSONObject distance = leg.getJSONObject("distance");
            final String distanceString = distance.getString("text");
            if(listener != null){
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        listener.onSuccessCalculate(distanceString);
                    }
                });
            }

        }
        catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private static List<LatLng> decodePoly(String encoded) {

        List<LatLng> poly = new ArrayList<LatLng>();
        int index = 0, len = encoded.length();
        int lat = 0, lng = 0;

        while (index < len) {
            int b, shift = 0, result = 0;
            do {
                b = encoded.charAt(index++) - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            } while (b >= 0x20);
            int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
            lat += dlat;

            shift = 0;
            result = 0;
            do {
                b = encoded.charAt(index++) - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            } while (b >= 0x20);
            int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
            lng += dlng;

            LatLng p = new LatLng( (((double) lat / 1E5)),
                    (((double) lng / 1E5) ));
            poly.add(p);
        }

        return poly;
    }

    public static void drawPolyLines(final List<LatLng> list, final GoogleMap googleMap, boolean withZoom){
        Polyline line = googleMap.addPolyline(new PolylineOptions()
                .addAll(list)
                .width(12)
                .color(Color.parseColor("#05b1fb"))//Google maps blue color
                .geodesic(true)
        );

        if(withZoom){
            googleMap.moveCamera(CameraUpdateFactory.newLatLngBounds(getSouthWestAndNorthEast(list), 200));

        }

         /*
           for(int z = 0; z<list.size()-1;z++){
                LatLng src= list.get(z);
                LatLng dest= list.get(z+1);
                Polyline line = mMap.addPolyline(new PolylineOptions()
                .add(new LatLng(src.latitude, src.longitude), new LatLng(dest.latitude,   dest.longitude))
                .width(2)
                .color(Color.BLUE).geodesic(true));
            }
           */
    }

    public static Polyline drawPolyLines(final List<LatLng> list, final GoogleMap googleMap, boolean withZoom, int paddingMaps){
        Polyline line = googleMap.addPolyline(new PolylineOptions()
                .addAll(list)
                .width(12)
                .color(Color.parseColor("#05b1fb"))//Google maps blue color
                .geodesic(true)
        );

        if(withZoom){
            googleMap.moveCamera(CameraUpdateFactory.newLatLngBounds(getSouthWestAndNorthEast(list), paddingMaps));

        }

        return line;

         /*
           for(int z = 0; z<list.size()-1;z++){
                LatLng src= list.get(z);
                LatLng dest= list.get(z+1);
                Polyline line = mMap.addPolyline(new PolylineOptions()
                .add(new LatLng(src.latitude, src.longitude), new LatLng(dest.latitude,   dest.longitude))
                .width(2)
                .color(Color.BLUE).geodesic(true));
            }
           */
    }

    public static Polyline drawPolyLinesAlternative(final List<LatLng> list, final GoogleMap googleMap, boolean withZoom, int paddingMaps){
        Polyline line = googleMap.addPolyline(new PolylineOptions()
                .addAll(list)
                .width(6)
                .color(Color.parseColor("#8805b1fb"))//Google maps blue color
                .geodesic(true)
        );

        if(withZoom){
            googleMap.moveCamera(CameraUpdateFactory.newLatLngBounds(getSouthWestAndNorthEast(list), paddingMaps));

        }

        return line;

         /*
           for(int z = 0; z<list.size()-1;z++){
                LatLng src= list.get(z);
                LatLng dest= list.get(z+1);
                Polyline line = mMap.addPolyline(new PolylineOptions()
                .add(new LatLng(src.latitude, src.longitude), new LatLng(dest.latitude,   dest.longitude))
                .width(2)
                .color(Color.BLUE).geodesic(true));
            }
           */
    }

    public static LatLngBounds getSouthWestAndNorthEast(List<LatLng> list){

        List<Double> latitudeAll = new ArrayList<>();
        List<Double> longitudeAll = new ArrayList<>();

        for(LatLng item : list){
            latitudeAll.add(item.latitude);
            longitudeAll.add(item.longitude);
        }

        LatLng southWest = new LatLng(Collections.min(latitudeAll), Collections.min(longitudeAll));
        LatLng northEast = new LatLng(Collections.max(latitudeAll), Collections.max(longitudeAll));
        LatLngBounds bounds = new LatLngBounds(southWest, northEast);

        return bounds;
    }

    public interface OnRouteCalculated{
        void onSuccessCalculate(List<LatLng> list, String distance, long distanceValue);
    }

    public interface OnRouteWithAlternativesCalculated{
        void onSuccessCalculate(List<List<LatLng>> list, String firstRouteDistance, long firstRouteDistanceValue);
    }

    public interface OnDistanceCalculated{
        void onSuccessCalculate(String distance);
    }

    public static Bitmap getBitmapWithGreenPin(Context context, Bitmap avatarBitmap){
        RelativeLayout rlParent = new RelativeLayout(context);
        View view = LayoutInflater.from(context).inflate(R.layout.item_pin, null, false);
        ImageView ivAvatar = (ImageView) view.findViewById(R.id.ivAvatarPin);
        ivAvatar.setImageBitmap(avatarBitmap);
        rlParent.addView(view);
        return createDrawableFromView(context, rlParent);
    }

    public static Bitmap getBitmapWithGreenPinAndCar(Context context, Bitmap avatarBitmap){
        RelativeLayout rlParent = new RelativeLayout(context);
        View view = LayoutInflater.from(context).inflate(R.layout.item_pin_with_car, null, false);
        ImageView ivAvatar = (ImageView) view.findViewById(R.id.ivAvatarPin);
        ivAvatar.setImageBitmap(avatarBitmap);
        rlParent.addView(view);
        return createDrawableFromView(context, rlParent);
    }

    // Convert a view to bitmap
    private static Bitmap createBitmapFromView(View view) {

        int size = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 40f, view.getContext().getResources().getDisplayMetrics());

        Bitmap bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888);

        Canvas canvas = new Canvas(bitmap);
        view.draw(canvas);

        return bitmap;
    }

    private static Bitmap createDrawableFromView(Context context, View view) {
        DisplayMetrics displayMetrics = new DisplayMetrics();
        ((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        view.setLayoutParams(new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT));
        view.measure(displayMetrics.widthPixels, displayMetrics.heightPixels);
        view.layout(0, 0, displayMetrics.widthPixels, displayMetrics.heightPixels);
        view.buildDrawingCache();
        Bitmap bitmap = Bitmap.createBitmap(view.getMeasuredWidth(), view.getMeasuredHeight(), Bitmap.Config.ARGB_8888);

        Canvas canvas = new Canvas(bitmap);
        view.draw(canvas);

        return bitmap;
    }

    public static void setMapParentLayoutParams(Integer topMargin, Integer bottomMargin, FrameLayout layoutForMap){
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) layoutForMap.getLayoutParams();
        if(topMargin != null){
            params.topMargin = topMargin;
        }
        if(bottomMargin != null){
            params.bottomMargin = bottomMargin;
        }
        layoutForMap.setLayoutParams(params);
    }

}
