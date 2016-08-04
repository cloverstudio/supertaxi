package clover_studio.com.supertaxi.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.utils.Utils;

public class UploadFileDialog extends Dialog {

    private TextView progressTv;
    private TextView title;
    private ProgressBar progressPb;
    private ProgressBar loading;

    private int max;
    private String maxString;

    public static UploadFileDialog startDialog(Context context){
        UploadFileDialog dialog = new UploadFileDialog(context);
        return dialog;
    }

    public UploadFileDialog(Context context) {
        super(context, R.style.Theme_Dialog);

        setCancelable(false);
        setCanceledOnTouchOutside(false);

        setOwnerActivity((Activity) context);

        show();

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_upload_file);

        title = (TextView) findViewById(R.id.title);
        progressTv = (TextView) findViewById(R.id.progress);
        progressPb = (ProgressBar) findViewById(R.id.progressBarHorizontal);
        loading = (ProgressBar) findViewById(R.id.progressBarLoading);
        progressPb.setProgress(0);

    }

    public void setMax(int max){
        progressPb.setMax(max);
        this.max = max;
        this.maxString = Utils.readableFileSize(max);
        String text = "0/" + maxString;
        progressTv.setText(text);
    }

    public void setCurrent(int current){
        progressPb.setProgress(current);
        String text = Utils.readableFileSize(current) + "/" + maxString;
        progressTv.setText(text);
    }

    public void fileUploaded(){
        progressPb.setVisibility(View.INVISIBLE);
        loading.setVisibility(View.VISIBLE);
        progressTv.setText(getOwnerActivity().getString(R.string.waiting_to_response));
    }

}