package clover_studio.com.supertaxi.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import clover_studio.com.supertaxi.R;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class BasicDialog extends Dialog{

    private Type type;
    private String textStr;
    private String titleStr;

    private OneButtonDialogListener oneButtonListener;
    private TwoButtonDialogListener twoButtonListener;


    public enum Type{
        ONE_BUTTON, TWO_BUTTON
    }

    /**
     * start info dialog with one button
     * @param context context
     * @param title dialog title
     * @param text dialog text
     * @return dialog
     */
    public static BasicDialog startOneButtonDialog(Context context, String title, String text){
        return new BasicDialog(context, title, text, Type.ONE_BUTTON);
    }

    /**
     * start info dialog with two button
     * @param context context
     * @param title dialog title
     * @param text dialog text
     * @return dialog
     */
    public static BasicDialog startTwoButtonDialog(Context context, String title, String text){
        return new BasicDialog(context, title, text, Type.TWO_BUTTON);
    }

    public BasicDialog(Context context, String title, String text, Type type) {
        super(context, R.style.Theme_Dialog_no_dim);

        setOwnerActivity((Activity) context);
        setCancelable(false);
        setCanceledOnTouchOutside(false);

        titleStr = title;
        textStr = text;
        this.type = type;

        show();

    }

    /**
     * set one button listener
     * @param listener listener
     */
    public void setOneButtonListener(OneButtonDialogListener listener){
        oneButtonListener = listener;
    }

    /**
     * set two button listener
     * @param listener listener
     */
    public void setTwoButtonListener(TwoButtonDialogListener listener){
        twoButtonListener = listener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(type);
    }

    private void setContentView(Type type) {
        if(type == Type.ONE_BUTTON){
            super.setContentView(R.layout.dialog_basic_one_button);
            setOneButtonOptions();
        }else{
            super.setContentView(R.layout.dialog_basic_two_button);
            setTwoButtonOptions();
        }
    }

    private void setOneButtonOptions() {
        TextView text = (TextView) findViewById(R.id.info_text);
        text.setText(textStr);

        TextView title = (TextView) findViewById(R.id.info_title);
        title.setText(titleStr);

        Button buttonOk = (Button) findViewById(R.id.oneButton);
        buttonOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (oneButtonListener != null) {
                    oneButtonListener.onOkClicked(BasicDialog.this);
                } else {
                    dismiss();
                }
            }
        });

    }

    private void setTwoButtonOptions() {
        TextView text = (TextView) findViewById(R.id.info_text);
        text.setText(textStr);

        TextView title = (TextView) findViewById(R.id.info_title);
        title.setText(titleStr);

        Button buttonOk = (Button) findViewById(R.id.rightButton);
        buttonOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (twoButtonListener != null) {
                    twoButtonListener.onOkClicked(BasicDialog.this);
                } else {
                    dismiss();
                }
            }
        });

        Button buttonCancel = (Button) findViewById(R.id.leftButton);
        buttonCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (twoButtonListener != null) {
                    twoButtonListener.onCancelClicked(BasicDialog.this);
                } else {
                    dismiss();
                }
            }
        });

    }

    public void setCancelOnDim(){
        View rootView = findViewById(R.id.rootView);
        if(rootView != null){
            rootView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    dismiss();
                }
            });
        }
    }

    /**
     * set buttons text, (for two button dialogs)
     * @param leftButton text for left button
     * @param rightButton text for right button
     */
    public void setButtonsText(String leftButton, String rightButton){
        Button buttonRight = (Button) findViewById(R.id.rightButton);
        buttonRight.setText(rightButton);

        Button buttonLeft = (Button) findViewById(R.id.leftButton);
        buttonLeft.setText(leftButton);
    }

    public void setButtonText(String text){
        Button button = (Button) findViewById(R.id.oneButton);
        button.setText(text);
    }

    public interface OneButtonDialogListener{
        void onOkClicked(BasicDialog dialog);
    }

    public interface TwoButtonDialogListener{
        void onOkClicked(BasicDialog dialog);
        void onCancelClicked(BasicDialog dialog);
    }

}
