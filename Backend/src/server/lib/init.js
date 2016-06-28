    var path = require('path');
    
    var Config = {};

    Config.host = "localhost";
    Config.port = 8080;
    Config.urlPrefix = '/';
    
    Config.dbCollectionPrefix = '';
    Config.databaseUrl = "mongodb://localhost:27017/supertaxi";
    Config.databaseOptions = {
        mongos: {
            ssl: false,
            sslValidate: false
        }
    }
    
    Config.publicPath = path.resolve(__dirname, "../../..", "public");
    Config.uploadPath = path.resolve(__dirname, "../../..", "public/uploads");

    Config.apnsCertificates = {
        
        dev : {
            key : '',
            cert : ''
        },
        adhoc : {
            key : '',
            cert : ''
        },
        store : {
            key : '',
            cert : ''
        }
          
    };

    Config.gcmAPIKey = "";

    Config.hashSalt = "8zgqvU6LaziThJI1uz3PevYd";
    Config.signinBackDoorSecret = "dontuseit";

    module["exports"] = Config;