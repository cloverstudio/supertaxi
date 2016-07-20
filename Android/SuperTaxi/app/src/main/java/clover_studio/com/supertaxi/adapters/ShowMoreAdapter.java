package clover_studio.com.supertaxi.adapters;

import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.models.DriverListResponse;

/**
 * Created by ubuntu_ivo on 17.07.15..
 */
public class ShowMoreAdapter extends RecyclerView.Adapter<ShowMoreAdapter.ViewHolder>{

    private List<DriverListResponse.DriverData> data;

    public ShowMoreAdapter(List<DriverListResponse.DriverData> data){
        this.data = data;
    }

    public void setData (List<DriverListResponse.DriverData> data){
        if(this.data == null){
            this.data = new ArrayList<>();
        }
        this.data.clear();
        this.data.addAll(data);
        notifyDataSetChanged();
    }

    public void addData (List<DriverListResponse.DriverData> data){
        if(this.data == null){
            this.data = new ArrayList<>();
        }
        this.data.addAll(data);
        notifyDataSetChanged();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {

        TextView tvNumOfPeople;
        TextView tvMinValue;

        ViewHolder(View v) {
            super(v);
            tvNumOfPeople = (TextView) v.findViewById(R.id.tvNumOfPeople);
            tvMinValue = (TextView) v.findViewById(R.id.tvMinValue);
        }
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_show_more_driver, parent, false));
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {

        final DriverListResponse.DriverData item = data.get(position);

    }

    @Override
    public int getItemCount() {
        return data.size();
    }

}
