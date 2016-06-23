var express = require('express');
var http = require('http');

var Conf = require('./init.js');

// initialization
var app = express();
var server = http.createServer(app);
var port = Conf.port;

//var DatabaseManager = require('./lib/DatabaseManager');

console.log('Starting SuperTaxi Server...');

DatabaseManager.init(function(success){

    if(!success){

        console.log('Failed to connect DB');
        process.exit(1);

    } else {

        app.all('*', function(req, res, next) {
            res.header('Access-Control-Allow-Origin', '*');
            res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS');
            res.header('Access-Control-Allow-Headers', 'Content-Type');
            next();
        });


        WebAPI.init(app);
        SocketAPI.init(io);
        
        if(!SocketConnectionHandler.init()){
	        process.exit(1);
        }
        
        SpikaBridge.init(app,SocketAPI.io);
        
        OnlineStatusChecker.start();
        
        // start signaling server
        signaling(io, Conf.webRTCConfig);  

        // not found URL error handle
        app.get('*', function(request, response) {

            var defaultParameters = {
                Config: Conf,
                AssetURL: "/assets",
                layout: "Front/Views/FrontLayout"
            };

            response.status(404).render("Front/Views/NotFound/NotFound", defaultParameters);

        });

        server.on('connection', function(socket) {
            socket.setTimeout(30000);
        })

        server.listen(Conf.port, function(){
            console.log('Server listening on port ' + Conf.port + '!');
        });

    }

});
