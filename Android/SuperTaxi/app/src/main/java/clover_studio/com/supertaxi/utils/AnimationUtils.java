package clover_studio.com.supertaxi.utils;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.Transformation;
import android.widget.RelativeLayout;

/**
 * Created by ubuntu_ivo on 08.02.16..
 */
public class AnimationUtils {


    public static void tripleScale(View view, float to, float from, int duration, AnimatorListenerAdapter listener){
        ObjectAnimator scaleX = ObjectAnimator.ofFloat(view, "scaleX", from, to);
        ObjectAnimator scaleY = ObjectAnimator.ofFloat(view, "scaleY", from, to);

        ObjectAnimator scaleX2 = ObjectAnimator.ofFloat(view, "scaleX", to, from);
        ObjectAnimator scaleY2 = ObjectAnimator.ofFloat(view, "scaleY", to, from);
        scaleX2.setStartDelay(duration);
        scaleY2.setStartDelay(duration);

        ObjectAnimator scaleX3 = ObjectAnimator.ofFloat(view, "scaleX", from, to);
        ObjectAnimator scaleY3 = ObjectAnimator.ofFloat(view, "scaleY", from, to);
        scaleX3.setStartDelay(duration * 2);
        scaleY3.setStartDelay(duration * 2);

        ObjectAnimator scaleX4 = ObjectAnimator.ofFloat(view, "scaleX", to, from);
        ObjectAnimator scaleY4 = ObjectAnimator.ofFloat(view, "scaleY", to, from);
        scaleX4.setStartDelay(duration * 3);
        scaleY4.setStartDelay(duration * 3);

        ObjectAnimator scaleX5 = ObjectAnimator.ofFloat(view, "scaleX", from, to);
        ObjectAnimator scaleY5 = ObjectAnimator.ofFloat(view, "scaleY", from, to);
        scaleX5.setStartDelay(duration * 4);
        scaleY5.setStartDelay(duration * 4);

        ObjectAnimator scaleX6 = ObjectAnimator.ofFloat(view, "scaleX", to, from);
        ObjectAnimator scaleY6 = ObjectAnimator.ofFloat(view, "scaleY", to, from);
        scaleX6.setStartDelay(duration * 5);
        scaleY6.setStartDelay(duration * 5);

        if(listener != null){
            scaleX6.addListener(listener);
        }

        scaleX.start();
        scaleY.start();
        scaleX2.start();
        scaleY2.start();
        scaleX3.start();
        scaleY3.start();
        scaleX4.start();
        scaleY4.start();
        scaleX5.start();
        scaleY5.start();
        scaleX6.start();
        scaleY6.start();
    }

    public static void animateViewToOpenCollapse(boolean toOpen, final View view){
        if(toOpen){
            view.measure(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
            final int targetHeight = view.getMeasuredHeight();

            // Older versions of android (pre API 21) cancel animations for views with a height of 0.
            view.getLayoutParams().height = 1;
            view.setVisibility(View.VISIBLE);
            Animation a = new Animation()
            {
                @Override
                protected void applyTransformation(float interpolatedTime, Transformation t) {
                    view.getLayoutParams().height = interpolatedTime == 1
                            ? RelativeLayout.LayoutParams.WRAP_CONTENT
                            : (int)(targetHeight * interpolatedTime);
                    view.requestLayout();
                }

                @Override
                public boolean willChangeBounds() {
                    return true;
                }
            };

            // 1dp/ms
            a.setDuration((int)(targetHeight / view.getContext().getResources().getDisplayMetrics().density));
            view.startAnimation(a);
        }else{
            final int initialHeight = view.getMeasuredHeight();

            Animation a = new Animation()
            {
                @Override
                protected void applyTransformation(float interpolatedTime, Transformation t) {
                    if(interpolatedTime == 1){
                        view.setVisibility(View.GONE);
                    }else{
                        view.getLayoutParams().height = initialHeight - (int)(initialHeight * interpolatedTime);
                        view.requestLayout();
                    }
                }

                @Override
                public boolean willChangeBounds() {
                    return true;
                }
            };

            // 1dp/ms
            a.setDuration((int)(initialHeight / view.getContext().getResources().getDisplayMetrics().density));
            view.startAnimation(a);
        }
    }

    /**
     * translate along the x axis
     *
     * @param view
     * @param from
     * @param to
     * @param duration
     * @param listener animator listener adapter, can be null
     * @return ObjectAnimator
     */
    public static ObjectAnimator translateX(View view, float from, float to, int duration, AnimatorListenerAdapter listener) {
        ObjectAnimator translationX = ObjectAnimator.ofFloat(view, "translationX", from, to);
        translationX.setDuration(duration);

        if (listener != null) {
            translationX.addListener(listener);
        }

        translationX.start();

        return translationX;

    }

    public static ObjectAnimator translateX(View view, float from, float to, int duration, int delay, AnimatorListenerAdapter listener) {
        ObjectAnimator translationX = ObjectAnimator.ofFloat(view, "translationX", from, to);
        translationX.setDuration(duration);
        translationX.setStartDelay(delay);

        if (listener != null) {
            translationX.addListener(listener);
        }

        translationX.start();

        return translationX;

    }

    /**
     * translate along the y axis
     *
     * @param view
     * @param from
     * @param to
     * @param duration
     * @param listener animator listener adapter, can be null
     * @return ObjectAnimator
     */
    public static ObjectAnimator translateY(View view, float from, float to, int duration, AnimatorListenerAdapter listener) {
        ObjectAnimator translationY = ObjectAnimator.ofFloat(view, "translationY", from, to);
        translationY.setDuration(duration);

        if (listener != null) {
            translationY.addListener(listener);
        }

        translationY.start();

        return translationY;

    }

    /**
     * apply alpha animation to given view
     * @param view
     * @param from
     * @param to
     * @param duration
     * @param listener animator listener adapter, can be null
     * @return ObjectAnimator
     */
    public static ObjectAnimator fade(View view, float from, float to, int duration, AnimatorListenerAdapter listener) {
        ObjectAnimator alpha = ObjectAnimator.ofFloat(view, "alpha", from, to);
        alpha.setDuration(duration);

        if (listener != null) {
            alpha.addListener(listener);
        }

        alpha.start();

        return alpha;

    }

    public static ObjectAnimator fade(View view, float from, float to, int duration, int delay, AnimatorListenerAdapter listener) {
        ObjectAnimator alpha = ObjectAnimator.ofFloat(view, "alpha", from, to);
        alpha.setDuration(duration);
        alpha.setStartDelay(delay);

        if (listener != null) {
            alpha.addListener(listener);
        }

        alpha.start();

        return alpha;

    }

    /**
     * apply alpha animation to given view and set visibility to gone or visible
     * @param view
     * @param from have to be 1 or 0
     * @param to have to be 1 or 0
     * @param duration
     * @return ObjectAnimator
     */
    public static ObjectAnimator fadeThenGoneOrVisible(final View view, float from, final float to, int duration) {

        if(from == 0){
            view.setVisibility(View.VISIBLE);
        }

        ObjectAnimator alpha = ObjectAnimator.ofFloat(view, "alpha", from, to);
        alpha.setDuration(duration);

        alpha.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                if(to == 0){
                    view.setVisibility(View.GONE);
                }
            }
        });

        alpha.start();

        return alpha;

    }

    /**
     * rotate view
     *
     * @param view
     * @param from
     * @param to
     * @param duration
     * @param listener listener animator listener adapter, can be null
     * @return ObjectAnimator
     */
    public static ObjectAnimator rotateX(View view, float from, float to, int duration, AnimatorListenerAdapter listener) {
        ObjectAnimator rotate = ObjectAnimator.ofFloat(view, "rotation", from, to);
        rotate.setDuration(duration);

        if (listener != null) {
            rotate.addListener(listener);
        }

        rotate.start();

        return rotate;

    }

    public static void rotationInfinite(View view, boolean clockwise, int cycleDuration) {
        ObjectAnimator rotation = ObjectAnimator.ofFloat(view, "rotation", 0, clockwise ? 360 : -360);
        rotation.setDuration(cycleDuration);
        rotation.setRepeatMode(Animation.RESTART);
        rotation.setRepeatCount(Animation.INFINITE);
        rotation.setInterpolator(new LinearInterpolator());
        rotation.start();
    }

    /**
     * scale view
     * @param view
     * @param from
     * @param to
     * @param pivotX
     * @param pivotY
     * @param duration
     * @param listener listener animator listener adapter, can be null
     */
    public static void scale(View view, float from, float to, float pivotX, float pivotY, int duration, AnimatorListenerAdapter listener) {
        view.setPivotX(pivotX);
        view.setPivotY(pivotY);
        ObjectAnimator scaleX = ObjectAnimator.ofFloat(view, "scaleX", from, to);
        ObjectAnimator scaleY = ObjectAnimator.ofFloat(view, "scaleY", from, to);

        scaleX.setDuration(duration);
        scaleY.setDuration(duration);


        if (listener != null) {
            scaleX.addListener(listener);
        }

        scaleX.start();
        scaleY.start();

    }

    /**
     * scale view
     * @param view
     * @param from
     * @param to
     * @param duration
     * @param listener listener animator listener adapter, can be null
     */
    public static void scale(View view, float from, float to, int duration, AnimatorListenerAdapter listener) {
        ObjectAnimator scaleX = ObjectAnimator.ofFloat(view, "scaleX", from, to);
        ObjectAnimator scaleY = ObjectAnimator.ofFloat(view, "scaleY", from, to);

        scaleX.setDuration(duration);
        scaleY.setDuration(duration);


        if (listener != null) {
            scaleX.addListener(listener);
        }

        scaleX.start();
        scaleY.start();

    }

    /**
     * infinite fade animation
     *
     * @param view
     * @param singleDuration duration of single alpha animation
     * @return AnimatorSet
     */
    public static AnimatorSet fadingInfinite(View view, long singleDuration){
        ObjectAnimator firstFade = ObjectAnimator.ofFloat(view, "alpha", 0.0f, 1.0f).setDuration(singleDuration);
        ObjectAnimator secondFade = ObjectAnimator.ofFloat(view, "alpha", 1.0f, 0.0f).setDuration(singleDuration);

        final AnimatorSet animatorSet = new AnimatorSet();

        animatorSet.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                animatorSet.start();
            }
        });

        animatorSet.play(firstFade).before(secondFade);
        animatorSet.start();

        return animatorSet;
    }

}
