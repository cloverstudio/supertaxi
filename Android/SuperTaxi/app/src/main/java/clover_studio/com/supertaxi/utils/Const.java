package clover_studio.com.supertaxi.utils;

/**
 * Created by ivoperic on 12/07/16.
 */
public class Const {

    public static final String BASE_URL = "http://107.170.147.230";

    public static final class ErrorCodes{
        public static final int UNKNOWN = 6000000;
        public static final int NO_EMAIL = 6000001;
        public static final int NO_PASSWORD = 6000002;
        public static final int NO_SECRET = 6000003;
        public static final int WRONG_EMAIL = 6000004;
        public static final int WRONG_PASSWORD = 6000005;
        public static final int EMAIL_EXISTS = 6000006;
        public static final int WRONG_SECRET = 6000007;
        public static final int SIGN_IN_ERROR = 6000008;
        public static final int INVALID_TOKEN = 6000009;
        public static final int NO_NAME = 6000010;
        public static final int WRONG_TYPE = 6000011;
        public static final int WRONG_IMAGE_TYPE = 6000012;
        public static final int FEE_START = 6000013;
        public static final int FEE_KM = 6000014;
        public static final int AGE = 6000015;
        public static final int WRONG_TEL_NUM = 6000016;
        public static final int LATITUDE_FROM = 6000017;
        public static final int LONGITUDE_FROM = 6000018;
        public static final int NO_ADDRESS_FROM = 6000019;
        public static final int LATITUDE_TO = 6000020;
        public static final int LONGITUDE_TO = 6000021;
        public static final int NO_ADDRESS_TO = 6000022;
        public static final int CREW_NUMBER = 6000023;
    }

    public class ReceiverIntents {
        public static final String INVALID_TOKEN_BROADCAST = "INVALID TOKEN";
    }

    public class PreferencesKey {
        public static final String TOKEN = "TOKEN";
        public static final String _ID = "_ID";
        public static final String EMAIL = "EMAIL";
        public static final String PUSH_TOKEN = "PUSH_TOKEN";
        public static final String CREATED = "CREATED";
        public static final String REMEMBER_ME = "REMEMBER_ME";
        public static final String SHA1_PASSWORD = "SHA1_PASSWORD";
        public static final String EMAIL_LOGIN = "EMAIL_LOGIN";
        public static final String USER_TYPE = "USER_TYPE";

        public static final String TEL_NUM = "TEL_NUM";
        public static final String AGE = "AGE";
        public static final String NOTE = "NOTE";
        public static final String CAR_TYPE = "CAR_TYPE";
        public static final String CAR_REGISTRATION = "CAR_REGISTRATION";
        public static final String FEE_START = "FEE_START";
        public static final String FEE_KM = "FEE_KM";
        public static final String AVATAR_FILE_ID = "AVATAR_FILE_ID";
        public static final String AVATAR_THUMB_ID = "AVATAR_THUMB_ID";

        public static final String DRIVER_TYPE_NAME = "DRIVER_TYPE_NAME";
        public static final String USER_TYPE_NAME = "USER_TYPE_NAME";

        public static final String USER_CREATED = "USER_CREATED";
    }

    public class Server {
        public static final String SIGN_UP = "/api/v1/signup";
        public static final String SIGN_IN = "/api/v1/signin";
        public static final String TEST_API = "/api/v1/test";
        public static final String UPDATE_USER_API = "/api/v1/profile/update";
        public static final String UPLOADS = "/uploads";
        public static final String GET_DRIVER_LIST = "/api/v1/profile/getDriverList";
        public static final String CALL_TAXI = "/api/v1/order/call";
    }

    public class Secrets {
        public static final String STATIC_SALT = "8zgqvU6LaziThJI1uz3PevYd";
    }

    public class UserType {
        public static final int USER_TYPE_USER = 1;
        public static final int USER_TYPE_DRIVER = 2;
    }

    public class Extras {
        public static final String USER_TYPE = "USER_TYPE";
    }

    public class PostParams {
        public static final String NAME = "name";
        public static final String TYPE = "type";
        public static final String TEL_NUM = "telNum";
        public static final String AGE = "age";
        public static final String NOTE = "note";
        public static final String CAR_TYPE = "car_type";
        public static final String CAR_REGISTRATION = "car_registration";
        public static final String FEE_START = "fee_start";
        public static final String FEE_KM = "fee_km";
        public static final String FILE = "file";
    }

    public class HeadersParams {
        public static final String ACCESS_TOKEN = "access-token";
    }

    public class ContentTypes {
        public static final String IMAGE_JPG = "image/jpeg";
        public static final String IMAGE_PNG = "image/png";
    }

    public class IntentParams {
        public static final String INTENT_TYPE = "IntentType";
        public static final String GALLERY_INTENT = "GalleryIntent";
        public static final String CAMERA_INTENT = "CameraIntent";
        public static final String PATH_INTENT = "PathIntent";
        public static final String EXTRA_PATH = "ExtraPath";
    }

    public class Files {
        public static final String FILE_APP_DIRECTORY = "SuperTaxi/";
        public static final String PROFILE_IMAGES_FOLDER = ".ProfileImages/";
        public static final String FILE_APP_NO_FILE = ".nofile";

        public static final String VIDEO_FOLDER = "Zipt Video/";
        public static final String AUDIO_FOLDER = "Zipt Audio/";
        public static final String IMAGE_FOLDER = "Zipt Image/";

        public static final String HIDDEN_VIDEO_FOLDER = ".Video/";
        public static final String HIDDEN_AUDIO_FOLDER = ".Audio/";
        public static final String HIDDEN_IMAGE_FOLDER = ".Image/";
    }

    public class PermissionCode {
        public static final int CHAT_STORAGE = 99;
    }
}
