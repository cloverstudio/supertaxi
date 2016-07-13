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
        public static final String USER_ID = "USER_ID";
        public static final String _ID = "_ID";
        public static final String EMAIL = "EMAIL";
        public static final String PUSH_TOKEN = "PUSH_TOKEN";
        public static final String CREATED = "CREATED";
        public static final String REMEMBER_ME = "REMEMBER_ME";
        public static final String SHA1_PASSWORD = "SHA1_PASSWORD";
        public static final String EMAIL_LOGIN = "EMAIL_LOGIN";
        public static final String USER_TYPE = "USER_TYPE";
    }

    public class Server {
        public static final String SIGN_UP = "/api/v1/signup";
        public static final String SIGN_IN = "/api/v1/signin";
        public static final String TEST_API = "/api/v1/test";
    }

    public class Secrets {
        public static final String STATIC_SALT = "8zgqvU6LaziThJI1uz3PevYd";
    }

    public class UserType {
        public static final int USER_TYPE_USER = 1;
        public static final int USER_TYPE_DRIVER = 2;
    }
}
