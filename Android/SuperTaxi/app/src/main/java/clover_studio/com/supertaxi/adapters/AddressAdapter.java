package clover_studio.com.supertaxi.adapters;

import android.location.Address;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.models.DriverListResponse;
import clover_studio.com.supertaxi.utils.Utils;

/**
 * Created by ubuntu_ivo on 17.07.15..
 */
public class AddressAdapter extends RecyclerView.Adapter<AddressAdapter.ViewHolder>{

    private List<Address> data;
    private OnAddressItemClicked listener;

    public AddressAdapter(List<Address> data){
        this.data = data;
    }

    public void setData (List<Address> data){
        if(this.data == null){
            this.data = new ArrayList<>();
        }
        this.data.clear();
        this.data.addAll(data);
        notifyDataSetChanged();
    }

    public void addData (List<Address> data){
        if(this.data == null){
            this.data = new ArrayList<>();
        }
        this.data.addAll(data);
        notifyDataSetChanged();
    }

    public void clearData(){
        if(this.data == null){
            this.data = new ArrayList<>();
        }
        this.data.clear();
        notifyDataSetChanged();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {

        TextView tvAddress;

        ViewHolder(View v) {
            super(v);
            tvAddress = (TextView) v.findViewById(R.id.tvAddress);
        }
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_address, parent, false));
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {

        final Address item = data.get(position);
        holder.tvAddress.setText(Utils.formatAddress(item));

        holder.tvAddress.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(listener != null){
                    listener.onAddressClicked(item);
                }
            }
        });

    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public interface OnAddressItemClicked{
        void onAddressClicked(Address item);
    }

    public void setListener(OnAddressItemClicked listener){
        this.listener = listener;
    }

}
