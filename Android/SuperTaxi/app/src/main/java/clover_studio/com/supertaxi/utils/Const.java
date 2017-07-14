package clover_studio.com.supertaxi.utils;

/**
 * Created by ivoperic on 12/07/16.
 */
public class Const {

    public static final String BASE_URL = "http://54.193.2.179";

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
        public static final int PARAM_INVALID_ID = 6000026;
        public static final int ALREADY_ACCEPTED_OR_CANCELED = 6000027;
        public static final int ALREADY_STARTED_OR_CANCELED = 6000029;

        public static final int PARAM_ERROR_LATITUDE = 6000024;
        public static final int PARAM_ERROR_LONGITUDE = 6000025;
        public static final int ALREADY_ARRIVED_OR_CANCELED = 6000028;
        public static final int ALREADY_FINISHED = 6000030;
        public static final int PARAM_ERROR_RATE_NUMBER = 6000031;
        public static final int PARAM_ERROR_USER_NOT_FOUND = 6000032;
        public static final int PARAM_ERROR_DRIVER_NOT_FOUND = 6000033;
        public static final int PARAM_ERROR_ORDER_NOT_FOUND = 6000034;
    }

    public class ReceiverIntents {
        public static final String INVALID_TOKEN_BROADCAST = "INVALID TOKEN";
        public static final String ON_CANCEL_TRIP = "ON_CANCEL_TRIP";
        public static final String ON_DRIVER_RESPONDED_TRIP = "ON_DRIVER_RESPONDED_TRIP";
        public static final String FINISH_ALL_ACTIVITY = "FINISH_ALL_ACTIVITY";
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

        //FROM SIGN UP TEMP
        public static final String FROM_SIGN_UP_NAME = "FROM_SIGN_UP_NAME";
        public static final String FROM_SIGN_UP_IMAGE = "FROM_SIGN_UP_IMAGE";

    }

    public class Server {
        public static final String SIGN_UP = "/api/v1/signup";
        public static final String SIGN_IN = "/api/v1/signin";
        public static final String TEST_API = "/api/v1/test";
        public static final String UPDATE_USER_API = "/api/v1/profile/update";
        public static final String UPLOADS = "/uploads";
        public static final String GET_DRIVER_LIST = "/api/v1/profile/getDriverList";
        public static final String GET_NEAREST_DRIVER = "/api/v1/profile/getNearestDriver";
        public static final String CALL_TAXI = "/api/v1/order/call";
        public static final String CANCEL_TRIP = "/api/v1/order/cancel";
        public static final String CHECK_ORDER_STATUS = "/api/v1/order/status";
        public static final String GET_OPEN_ORDER = "/api/v1/order/getOpenOrder";
        public static final String ACCEPT_ORDER = "/api/v1/order/accept";
        public static final String UPDATE_COORDINATES = "/api/v1/profile/updateCoordinates";
        public static final String UPDATE_ARRIVE_TIME = "/api/v1/order/arrive";
        public static final String UPDATE_FINISH_TIME = "/api/v1/order/finish";
        public static final String UPDATE_START_TIME = "/api/v1/order/start";
        public static final String RATE_PROFILE = "/api/v1/profile/rate";
        public static final String GET_PROFILE_DETAILS = "/api/v1/profile/detail";

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
        public static final String START_LOCATION = "START_LOCATION";
        public static final String DESTINATION_LOCATION = "DESTINATION_LOCATION";
        public static final String ORDER_MODEL = "ORDER_MODEL";
        public static final String USER_MODEL = "USER_MODEL";
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
        public static final int CALL = 99;
    }

    public class OrderStatusTypes{
        public static final int ACCEPTED = 1;
        public static final int CANCELED = 2;
        public static final int PENDING = 3;
        public static final int ARRIVED_TO_START_LOCATION = 4;
        public static final int STARTED_DRIVE = 5;
        public static final int FINISHED_DRIVE = 6;
    }

    public class CancelTypes{
        public static final int USER_CANCELED = 1;
        public static final int DRIVER_CANCELED = 2;
    }

    public class MainDriverStatus{
        public static final int PENDING = 1;
        public static final int OPEN_ORDER_SHOWED = 2;
        public static final int ORDER_ACCEPTED = 3;
        public static final int START_TRIP = 4;
    }

    public class MainUserStatus{
        public static final int REQUEST_TAXI_SCREEN = 1;
        public static final int ORDER_ACCEPTED = 2;
        public static final int START_TRIP = 4;
    }

    public static final class CacheFolder{
        public static final String APP_FOLDER = "SuperTaxi";
        public static final String TEMP_FOLDER = "temp";
        public static final String IMAGE_CACHE_FOLDER = "Image_cache";
    }

    public static final class ManageOrderType{
        public static final int ARRIVED_TIME = 1;
        public static final int STARTED_TIME = 2;
        public static final int FINISHED_TIME = 3;
        public static final int ACCEPT_ORDER = 4;
        public static final int IGNORE_ORDER = 5;
    }

    public static final class DrawRouteDriverTypes{
        public static final int ON_OPEN_ORDER_SHOWED = 1;
        public static final int ON_ACCEPTED_ORDER = 2;
        public static final int STARTED_DRIVE_WITH_ALTERNATIVES = 3;
        public static final int STARTED_DRIVE_WITHOUT_ALTERNATIVES = 4;
    }

    public static final class DrawRouteUserTypes{
        public static final int PICKUP_AND_DESTINATION_ROUTE = 1;
        public static final int STARTED_DRIVE = 2;
        public static final int ACCEPTED_DRIVE = 3;
    }

    public static final class ApiKeys{
        public static final String TWITTER_CONSUMER_KEY = "fiHB5xfw6DhMPxhkTSQM8ahUv";
        public static final String TWITTER_CONSUMER_SECRET = "cwQR2obnjB53HByEFKCcRc6gdQYPT6qgI2mFs4yP4KXhtRNCMQ";
    }

    public static final class DateFormat{
        public static final String DAY_WITH_TIME_FORMAT = "EEEE, HH:mm";
    }

}
