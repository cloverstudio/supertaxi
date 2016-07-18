package clover_studio.com.supertaxi.dialog;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.utils.AnimationUtils;
import clover_studio.com.supertaxi.view.CustomTextView;

public class CustomDialog extends Dialog {

    int width;
    private String title;

    LinearLayout llInsideScrollViewChoose;
    RelativeLayout parentLayout;
    TextView tvTitle;

    public static CustomDialog startDialog(Context context, String title){
        return new CustomDialog(context, title);
    }

    public CustomDialog(Context context, String title) {
        super(context, R.style.Theme_Dialog_no_dim);

        setOwnerActivity((Activity) context);
        setCancelable(true);
        setCanceledOnTouchOutside(true);

        width = context.getResources().getDisplayMetrics().widthPixels;
        this.title = title;

        show();

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_custom);

        parentLayout = (RelativeLayout) findViewById(R.id.parentLayout);
        llInsideScrollViewChoose = (LinearLayout) findViewById(R.id.llInsideScrollViewChoose);
        tvTitle = (TextView) findViewById(R.id.title);

        parentLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });

        if(title == null){
            tvTitle.setVisibility(View.GONE);
            findViewById(R.id.titleLine).setVisibility(View.GONE);
        }else{
            tvTitle.setText(title);
        }

    }

    public void addTextAndClickListener(boolean withLineBelow, String text, int resColor, final OnItemClickedListener onClickListener){
        int padding = (int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 15, getContext().getResources().getDisplayMetrics());

        CustomTextView textView = new CustomTextView(getContext());
        textView.setText(text);
        textView.setTextSize(18);
        textView.setTextColor(resColor);
        textView.setPadding(padding, padding, padding, padding);
        textView.setBackgroundResource(R.drawable.selector_trans_to_light_light_gray);
        llInsideScrollViewChoose.addView(textView);

        if(withLineBelow){
            View viewBelow = new View(getContext());
            viewBelow.setBackgroundColor(ContextCompat.getColor(getContext(), R.color.light_light_gray));
            llInsideScrollViewChoose.addView(viewBelow);
            viewBelow.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            viewBelow.getLayoutParams().height = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 1, getContext().getResources().getDisplayMetrics());
        }


        textView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismissWithListener(onClickListener);
            }
        });
    }

    public void addTextAndClickListener(boolean withLineBelow, String text, final OnItemClickedListener onClickListener){
        addTextAndClickListener(withLineBelow, text, ContextCompat.getColor(getContext(), R.color.devil_gray), onClickListener);
    }

    public void dismissWithListener(final OnItemClickedListener listener){
        AnimationUtils.fade(parentLayout, 1, 0, 300, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                if (listener != null) {
                    listener.onClicked(CustomDialog.this);
                }
                CustomDialog.super.dismiss();
            }
        });
    }

    @Override
    public void dismiss() {
        AnimationUtils.fade(parentLayout, 1, 0, 300, new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                CustomDialog.super.dismiss();
            }
        });

    }

    @Override
    public void show() {
        super.show();
        AnimationUtils.fade(parentLayout, 0, 1, 300, null);
    }

    public interface OnItemClickedListener{
        void onClicked(Dialog dialog);
    }

}