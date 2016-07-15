package clover_studio.com.supertaxi;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.format.DateFormat;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.RelativeLayout;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

import clover_studio.com.supertaxi.base.BaseActivity;
import clover_studio.com.supertaxi.base.SuperTaxiApp;
import clover_studio.com.supertaxi.file.LocalFilesManagement;
import clover_studio.com.supertaxi.utils.Const;
import clover_studio.com.supertaxi.utils.Utils;
import clover_studio.com.supertaxi.view.cropper.CropImageView;

public class CameraCropActivity extends BaseActivity implements OnClickListener {

    CropImageView cropImageView;

    // compressed max size
    final double MAX_SIZE = 640;

    // Gallery type marker
    final int GALLERY = 1;
    // Camera type marker
    final int CAMERA = 2;
    // Uri for captured image so we can get image path
    String _path;

    String mFilePath;

    Button btnSend;
    Button btnRotate;

    boolean mIsOverJellyBean = false;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_camera_crop);

        cropImageView = (CropImageView) findViewById(R.id.CropImageView);
        cropImageView.setImageBitmap(null);
        cropImageView.setAspectRatio(20, 20);
        cropImageView.setFixedAspectRatio(true);


        btnRotate = (Button) findViewById(R.id.btn_rotate);
        btnRotate.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != cropImageView.getImageBitmap()) {
                    cropImageView.rotateImage(90);
                }
            }
        });

        mIsOverJellyBean = Build.VERSION.SDK_INT > Build.VERSION_CODES.JELLY_BEAN_MR2;

        btnSend = (Button) findViewById(R.id.btn_done);
        btnSend.setOnClickListener(this);

        clearCameraCache();

        getImageIntents();
    }

    @SuppressLint("InlinedApi")
    private void getImageIntents() {

        if (getIntent().getExtras() != null && getIntent().getStringExtra(Const.IntentParams.INTENT_TYPE).equals(Const.IntentParams.GALLERY_INTENT)) {

            if (mIsOverJellyBean) {

                Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
                intent.addCategory(Intent.CATEGORY_OPENABLE);
                intent.setType("image/*");
                startActivityForResult(intent, GALLERY);
            } else {

                Intent intent = new Intent();
                intent.setType("image/*");
                intent.setAction(Intent.ACTION_GET_CONTENT);
                startActivityForResult(intent, GALLERY);
            }

        } else if (getIntent().getExtras() != null && getIntent().getStringExtra(Const.IntentParams.INTENT_TYPE).equals(Const.IntentParams.CAMERA_INTENT)) {

            try {
                startCamera();
            } catch (Exception ex) {
                ex.printStackTrace();
                // TODO failed dialog
            }

        } else if (getIntent().getExtras() != null && getIntent().getStringExtra(Const.IntentParams.INTENT_TYPE).equals(Const.IntentParams.PATH_INTENT)) {

            String path = getIntent().getStringExtra(Const.IntentParams.EXTRA_PATH);
            onPhotoTaken(path);
        }
    }

    public void startCamera() {

        // Check if camera exists
        if (!getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA_FRONT) || !getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY)) {
            // TODO no camera dialog
        } else {

            try {

                long date = System.currentTimeMillis();
                String filename = DateFormat.format("yyyy-MM-dd_kk.mm.ss", date).toString() + ".jpg";

                _path = LocalFilesManagement.getProfileImagesFolder() + "/" + filename;

                File file = new File(_path);
                Uri outputFileUri = Uri.fromFile(file);

                Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                intent.putExtra(MediaStore.EXTRA_OUTPUT, outputFileUri);
                startActivityForResult(intent, CAMERA);

            } catch (Exception ex) {
                ex.printStackTrace();
                // TODO no camera
            }
        }
    }

//    @Override
//    public void onConfigurationChanged(Configuration newConfig) {
//        super.onConfigurationChanged(newConfig);
//
//        // Image rotation for samsung mobile phones
//
//        String pManufacturer = Build.MANUFACTURER;
//        String pModel = Build.MODEL;
//
//        if ("GT-I9300".equals(pModel) && "samsung".equals(pManufacturer)) {
//
//            RelativeLayout main = (RelativeLayout) findViewById(R.id.relativeLayout_main);
//            main.invalidate();
//
//            setContentView(R.layout.activity_camera_crop);
//
//            cropImageView = (CropImageView) findViewById(R.id.CropImageView);
//
//            File file = new File(_path);
//            boolean exists = file.exists();
//
//            if (exists) {
//                onPhotoTaken(_path);
//            } else {
//                // TODO error accured
//            }
//        }
//    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK) {
            switch (requestCode) {

                case GALLERY:
                    if (mIsOverJellyBean) {
                        Uri uri = null;
                        if (data != null) {
                            uri = data.getData();
                            String selected_image_path = Utils.getImagePathImageProfile(this, uri, mIsOverJellyBean);
                            onPhotoTaken(selected_image_path);

                        } else {
                            // TODO error while loading image from gallery
                        }
                    } else {
                        try {
                            Uri selected_image = data.getData();
                            String selected_image_path = Utils.getImagePathImageProfile(this, selected_image, mIsOverJellyBean);
                            onPhotoTaken(selected_image_path);

                        } catch (Exception e) {
                            e.printStackTrace();
                            // TODO error while loading image from gallery
                        }
                    }
                    break;

                case CAMERA:
                    File file = new File(_path);
                    boolean exists = file.exists();
                    if (exists) {
                        onPhotoTaken(_path);
                    } else {
                        // TODO something went wrong while taking an image
                    }
                    break;

                default:
                    finish();
                    break;
            }
        } else {
            // if there is no image, just finish the activity
            finish();
        }
    }

    protected void onPhotoTaken(final String path) {


        String fileName = Uri.parse(path).getLastPathSegment();
        mFilePath = LocalFilesManagement.getProfileImagesFolder() + "/" + fileName;


        if (!path.equals(mFilePath)) {
            try {
                Utils.copyStream(new FileInputStream(new File(path)), new FileOutputStream(new File(mFilePath)));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
        }

        AsyncTask<String, Void, byte[]> task = new AsyncTask<String, Void, byte[]>() {

            Bitmap mBitmap;

            @SuppressWarnings("deprecation")
            @Override
            protected byte[] doInBackground(String... params) {
                try {

                    if (params == null) {
                        return null;
                    }

                    File f = new File(params[0]);
                    ExifInterface exif = new ExifInterface(f.getPath());
                    int orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);

                    int angle = 0;

                    if (orientation == ExifInterface.ORIENTATION_ROTATE_90) {
                        angle = 90;
                    } else if (orientation == ExifInterface.ORIENTATION_ROTATE_180) {
                        angle = 180;
                    } else if (orientation == ExifInterface.ORIENTATION_ROTATE_270) {
                        angle = 270;
                    }

                    BitmapFactory.Options optionsMeta = new BitmapFactory.Options();
                    optionsMeta.inJustDecodeBounds = true;
                    BitmapFactory.decodeFile(f.getAbsolutePath(), optionsMeta);

                    int actualHeight = optionsMeta.outHeight;
                    int actualWidth = optionsMeta.outWidth;

                    optionsMeta.inJustDecodeBounds = false;
                    optionsMeta.inPurgeable = true;
                    optionsMeta.inInputShareable = true;
                    optionsMeta.inTempStorage = new byte[16 * 1024];

                    float maxHeight = 1024.0f;
                    float maxWidth = 1024.0f;

                    optionsMeta.inSampleSize = Utils.calculateInSampleSize(optionsMeta, (int) maxWidth, (int) maxHeight);

                    float imgRatio = (float) actualWidth / (float) actualHeight;
                    float maxRatio = maxWidth / maxHeight;

                    if (actualHeight > maxHeight || actualWidth > maxWidth) {
                        if (imgRatio < maxRatio) {
                            imgRatio = maxHeight / actualHeight;
                            actualWidth = (int) (imgRatio * actualWidth);
                            actualHeight = (int) maxHeight;
                        } else if (imgRatio > maxRatio) {
                            imgRatio = maxWidth / actualWidth;
                            actualHeight = (int) (imgRatio * actualHeight);
                            actualWidth = (int) maxWidth;
                        } else {
                            actualHeight = (int) maxHeight;
                            actualWidth = (int) maxWidth;
                        }
                    }

                    Bitmap tempBitmap = BitmapFactory.decodeStream(new FileInputStream(f), null, optionsMeta);
                    mBitmap = Bitmap.createBitmap(actualWidth, actualHeight, Bitmap.Config.ARGB_8888);

                    float ratioX = actualWidth / (float) optionsMeta.outWidth;
                    float ratioY = actualHeight / (float) optionsMeta.outHeight;
                    float middleX = actualWidth / 2.0f;
                    float middleY = actualHeight / 2.0f;

                    Matrix mat = new Matrix();
                    mat.postRotate(angle);

                    Matrix scaleMatrix = new Matrix();
                    scaleMatrix.setScale(ratioX, ratioY, middleX, middleY);

                    Canvas canvas = new Canvas(mBitmap);
                    canvas.setMatrix(scaleMatrix);
                    canvas.drawBitmap(tempBitmap, middleX - tempBitmap.getWidth() / 2, middleY - tempBitmap.getHeight() / 2, null);

                    mBitmap = Bitmap.createBitmap(mBitmap, 0, 0, mBitmap.getWidth(), mBitmap.getHeight(), mat, true);

                    saveBitmapToFile(mBitmap, mFilePath);

                    return null;
                } catch (Exception ex) {
                    ex.printStackTrace();
                    mBitmap = null;
                }

                return null;
            }

            @Override
            protected void onPostExecute(byte[] result) {
                super.onPostExecute(result);

                if (null != mBitmap) {
                    cropImageView.setImageBitmap(mBitmap);
                    cropImageView.setFixedAspectRatio(true);
                    ((View) findViewById(R.id.relativeLayout_main).getParent()).postInvalidate();

                } else {
                    try {
                        cropImageView.setImageBitmap(null);
                        // TODO error dialog
                    } catch (Exception ignore) {
                        // if activity crashes do not show failed
                    }
                }

            }
        };

        task.execute(mFilePath);
    }

    private boolean saveBitmapToFile(Bitmap bitmap, String path) {

        File file = new File(path);
        FileOutputStream fOut;

        try {

            fOut = new FileOutputStream(file);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, fOut);
            fOut.flush();
            fOut.close();

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    protected void onResume() {
        super.onResume();

        clearCameraCache();
    }

    @Override
    public void onClick(View view) {

        int id = view.getId();
        if (id == R.id.btn_done) {

            btnSend.setClickable(false);
            if (null != cropImageView.getImageBitmap()) {
                prepareFileForUpload(compressFileBeforePrepare());
            } else {
                btnSend.setClickable(true);
            }
        }
    }

    private Bitmap compressFileBeforePrepare() {

        Bitmap bmp = cropImageView.getCroppedImage();

        if(bmp == null){
            return null;
        }

        int curWidth = bmp.getWidth();
        int curHeight = bmp.getHeight();

        int sizeToManipulate = curWidth > curHeight ? curWidth : curHeight;
        double resizeCoefficient = MAX_SIZE / sizeToManipulate;

        int dstWidth = (int) (curWidth * resizeCoefficient);
        int dstHeight = (int) (curHeight * resizeCoefficient);

        return Bitmap.createScaledBitmap(bmp, dstWidth, dstHeight, false);
    }

    private void prepareFileForUpload(Bitmap bmp) {

        if(bmp == null){
            return;
        }

        ByteArrayOutputStream bs = new ByteArrayOutputStream();
        bmp.compress(Bitmap.CompressFormat.JPEG, 100, bs);

//        ImageLoader.getInstance().clearMemoryCache();
//        ImageLoader.getInstance().clearDiskCache();

        if (saveBitmapToFile(bmp, mFilePath)) {
            // TODO upload file
            //            fileUploadAsync(mFilePath);

            Intent intent = new Intent();
            intent.putExtra(Const.IntentParams.PATH_INTENT, mFilePath);
            setResult(RESULT_OK, intent);
            finish();

            SuperTaxiApp.setSamsungImagePath(null);

        } else {
            // TODO Error while saving to file
        }
    }

    private void clearCameraCache() {
        File cacheDir = getBaseContext().getCacheDir();

        File[] files = cacheDir.listFiles();

        if (files != null) {
            for (File file : files)
                file.delete();
        }
    }

}