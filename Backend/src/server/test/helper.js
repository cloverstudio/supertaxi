var should = require('should');
var request = require('supertest');
var async = require('async');
var sha1 = require('sha1');

var app = require('../mainTest');

global.hashsalt = "8zgqvU6LaziThJI1uz3PevYd";

global.getRandomStr = function(){

    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for( var i=0; i < 5; i++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;

}

global.user1 = {
    email: "test" + global.getRandomStr() + "@test.com",
    password : "password"
}

global.order = {};

before(function(doneMain){
    
    this.timeout(15000);
    
    setTimeout(function(){

        // do pre test logics here
        doneMain();

    }, 1000);
    
});