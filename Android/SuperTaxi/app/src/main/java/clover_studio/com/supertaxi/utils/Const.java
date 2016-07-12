package clover_studio.com.supertaxi.utils;

/**
 * Created by ivoperic on 12/07/16.
 */
public class Const {

    public static final String BASE_URL = "http://107.170.147.230";

    public static final class ErrorCodes{
        public static final int UNKNOWN = 6000000;
        public static final int INVALID_TOKEN = 6000009;
        public static final int NO_NAME = 6000010;
        public static final int WRONG_TYPE = 6000011;
        public static final int WRONG_IMAGE_TYPE = 6000012;
        public static final int FEE_START = 6000013;
        public static final int FEE_KM = 6000014;
        public static final int AGE = 6000015;
        public static final int WRONG_TEL_NUM = 6000016;
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
    }

    public class Server {
        public static final String SIGN_UP = "/api/v1/signup";
    }
}
