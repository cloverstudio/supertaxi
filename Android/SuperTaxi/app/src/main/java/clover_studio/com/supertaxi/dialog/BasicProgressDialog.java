package clover_studio.com.supertaxi.dialog;

import android.app.AlertDialog;
import android.content.Context;
import android.os.Bundle;

import clover_studio.com.supertaxi.R;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class BasicProgressDialog extends AlertDialog {

    public BasicProgressDialog(Context context) {
        super(context, R.style.Theme_Dialog);

        setCancelable(false);
        setCanceledOnTouchOutside(false);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_basic_progress);
    }

}
