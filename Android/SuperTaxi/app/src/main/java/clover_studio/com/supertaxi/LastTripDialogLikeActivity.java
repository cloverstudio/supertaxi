package clover_studio.com.supertaxi;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.utils.AnimationUtils;
import clover_studio.com.supertaxi.utils.Const;

public class LastTripDialogLikeActivity extends BaseActivity  implements OnMapReadyCallback {

    public static void startActivity(Activity activity, LatLng startLocation, LatLng destinationLocation){
        activity.startActivity(new Intent(activity, LastTripDialogLikeActivity.class)
                .putExtra(Const.Extras.START_LOCATION, startLocation)
                .putExtra(Const.Extras.DESTINATION_LOCATION, destinationLocation));
    }

    RelativeLayout parentLayout;
    RelativeLayout mainLayout;

    private ImageView ivAvatar;
    private TextView tvName;
    private TextView tvDate;
    private TextView tvPrice;
    private LinearLayout llStarLayout;

    GoogleMap googleMap;
    private FrameLayout layoutForMap;
    private LatLng startLocation;
    private LatLng destinationLocation;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_last_trip);

        parentLayout = (RelativeLayout) findViewById(R.id.parentLayout);
        mainLayout = (RelativeLayout) findViewById(R.id.mainLayout);

        ivAvatar = (ImageView) findViewById(R.id.ivAvatarInDriverDetails);
        tvName = (TextView) findViewById(R.id.tvName);
        tvPrice = (TextView) findViewById(R.id.tvPriceValue);
        tvDate = (TextView) findViewById(R.id.tvLastTripDate);
        llStarLayout = (LinearLayout) findViewById(R.id.bigStarsLayout);
        layoutForMap = (FrameLayout) findViewById(R.id.frameForMapInDialog);

        startLocation = getIntent().getParcelableExtra(Const.Extras.START_LOCATION);
        destinationLocation = getIntent().getParcelableExtra(Const.Extras.DESTINATION_LOCATION);

        int rating = 2;
        if (rating > llStarLayout.getChildCount()) {
            rating = llStarLayout.getChildCount();
        }
        for (int i = 0; i < rating; i++) {
            llStarLayout.getChildAt(i).setSelected(true);
        }
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                SupportMapFragment mapFragment = new SupportMapFragment();
                getSupportFragmentManager().beginTransaction().add(layoutForMap.getId(), mapFragment, "TAG").commit();
                mapFragment.getMapAsync(LastTripDialogLikeActivity.this);
            }
        }, 600);

        animateLayout();

    }

    private void animateLayout(){
        AnimationUtils.fade(mainLayout, 0, 1, 300, null);
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        this.googleMap = googleMap;

        if(startLocation != null && destinationLocation != null){
            googleMap.addMarker(new MarkerOptions().position(startLocation));
            googleMap.addMarker(new MarkerOptions().position(destinationLocation));
            LatLngBounds bounds = null;
            if(startLocation.latitude < destinationLocation.latitude){
                bounds = new LatLngBounds(startLocation, destinationLocation);
            }else{
                bounds = new LatLngBounds(destinationLocation, startLocation);
            }
            googleMap.moveCamera(CameraUpdateFactory.newLatLngBounds(bounds, 100));
            googleMap.getUiSettings().setScrollGesturesEnabled(false);
            googleMap.getUiSettings().setZoomGesturesEnabled(false);
            googleMap.getUiSettings().setZoomControlsEnabled(false);

            String url = makeUrl();
            JsonParser parser = new JsonParser();
            parser.getJSONFromUrl(url, new JsonParser.OnResult() {
                @Override
                public void onResult(final String json) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            drawPath(json);
                        }
                    });
                }
            });
        }

    }

    private String makeUrl(){
        StringBuilder urlString = new StringBuilder();
        urlString.append("https://maps.googleapis.com/maps/api/directions/json");
        urlString.append("?origin=");// from
        urlString.append(Double.toString(startLocation.latitude));
        urlString.append(",");
        urlString.append(Double.toString( startLocation.longitude));
        urlString.append("&waypoints=");// from
        urlString.append(Double.toString(45.787848));
        urlString.append(",");
        urlString.append(Double.toString(15.930355));
        urlString.append("&destination=");// to
        urlString.append(Double.toString( destinationLocation.latitude));
        urlString.append(",");
        urlString.append(Double.toString( destinationLocation.longitude));
        urlString.append("&sensor=false&mode=driving&alternatives=true");
        urlString.append("&key=AIzaSyBONAsYG4Pq-Sx9obbuHxlDaj4aa872kvs");
        Log.d("LOG", "URL: " + urlString.toString());
        return urlString.toString();
    }

    public void drawPath(String  result) {

        try {
            //Tranform the string into a json object
            final JSONObject json = new JSONObject(result);
            JSONArray routeArray = json.getJSONArray("routes");
            JSONObject routes = routeArray.getJSONObject(0);
            JSONObject overviewPolylines = routes.getJSONObject("overview_polyline");
            String encodedString = overviewPolylines.getString("points");
            List<LatLng> list = decodePoly(encodedString);
            Polyline line = googleMap.addPolyline(new PolylineOptions()
                    .addAll(list)
                    .width(12)
                    .color(Color.parseColor("#05b1fb"))//Google maps blue color
                    .geodesic(true)
            );
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
        catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private List<LatLng> decodePoly(String encoded) {

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

}
