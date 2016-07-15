package clover_studio.com.supertaxi.file;

import android.os.Environment;

import java.io.File;
import java.io.IOException;

import clover_studio.com.supertaxi.utils.Const;

public class LocalFilesManagement {

    // start: init methods
    public static void init() {

        createLocalFolder(Const.Files.FILE_APP_DIRECTORY);
        createLocalFolder(Const.Files.FILE_APP_DIRECTORY + Const.Files.PROFILE_IMAGES_FOLDER);
        createLocalFolder(Const.Files.FILE_APP_DIRECTORY + Const.Files.AUDIO_FOLDER, false);
        createLocalFolder(Const.Files.FILE_APP_DIRECTORY + Const.Files.IMAGE_FOLDER, false);
        createLocalFolder(Const.Files.FILE_APP_DIRECTORY + Const.Files.VIDEO_FOLDER, false);

        createLocalFolder(Const.Files.FILE_APP_DIRECTORY + Const.Files.HIDDEN_IMAGE_FOLDER, true);
        createLocalFolder(Const.Files.FILE_APP_DIRECTORY + Const.Files.HIDDEN_AUDIO_FOLDER, true);
        createLocalFolder(Const.Files.FILE_APP_DIRECTORY + Const.Files.HIDDEN_VIDEO_FOLDER, true);

    }

    private static boolean createLocalFolder(String localFolder) {
        return createLocalFolder(localFolder, false);
    }

    private static boolean createLocalFolder(String localFolder, boolean isNoFile) {

        if (LocalFilesManagement.isMounted()) {

            String fullPath = Environment.getExternalStorageDirectory() + "/" + localFolder;

            File folder = new File(fullPath);

            boolean success = folder.exists() || folder.mkdir();

            if (success && isNoFile) {

                File noFile = new File(fullPath, Const.Files.FILE_APP_NO_FILE);

                try {
                    //noinspection ResultOfMethodCallIgnored
                    noFile.createNewFile();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            return success;
        }

        return false;
    }
    // end: init methods

    public static String getLocalFolder() {
        return !LocalFilesManagement.isMounted() ? null :
                new File(Environment.getExternalStorageDirectory() + "/" + Const.Files.FILE_APP_DIRECTORY).getAbsolutePath();
    }

    public static String getAudioFolder() {
        return !LocalFilesManagement.isMounted() ? null :
                new File(getLocalFolder() + "/" + Const.Files.AUDIO_FOLDER).getAbsolutePath();
    }

    public static String getImageFolder() {
        return !LocalFilesManagement.isMounted() ? null :
                new File(getLocalFolder() + "/" + Const.Files.IMAGE_FOLDER).getAbsolutePath();
    }

    public static String getVideoFolder() {
        return !LocalFilesManagement.isMounted() ? null :
                new File(getLocalFolder() + "/" + Const.Files.VIDEO_FOLDER).getAbsolutePath();
    }

    public static String getProfileImagesFolder() {
        return !LocalFilesManagement.isMounted() ? null :
                new File(getLocalFolder() + "/" + Const.Files.PROFILE_IMAGES_FOLDER).getAbsolutePath();
    }

    // start: util methods
    public static boolean isMounted() {
        return Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED);
    }

    public static void deleteFile(String filePath) {

        if (LocalFilesManagement.isMounted()) {

            File file = new File(filePath);

            if (file.exists()) {
                //noinspection ResultOfMethodCallIgnored
                file.delete();
            }
        }
    }

    // end: util methods

}
