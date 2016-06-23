    var path = require('path');
    
    var Config = {};

    Config.host = "localhost";
    Config.port = 80;
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

    module["exports"] = Config;