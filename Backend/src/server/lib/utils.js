var _ = require('lodash');
var nodemailer = require('nodemailer');
var smtpPool = require('nodemailer-smtp-pool');
var init = require('./init');
var mongoose = require('mongoose');
var md5 = require('md5');
var util = require('util');
var sha1 = require('sha1');
var Const = require('../lib/consts');

(function(global) {
    "use strict;"

    // Class ------------------------------------------------
    function Utils() {
    };

    // Header -----------------------------------------------
    Utils.prototype.getRandomString = getRandomString;
    Utils.prototype.now = now;
    Utils.prototype.sendEmail = sendEmail;
    Utils.prototype.toObjectId = toObjectId;
    Utils.prototype.shorten = shorten;
    Utils.prototype.generateSecret = generateSecret;
    Utils.prototype.generateYYYYMMDDHHMMSS = generateYYYYMMDDHHMMSS;
    Utils.prototype.isObjectId = isObjectId;
    Utils.prototype.hash = hash;
    Utils.prototype.log = log;
    Utils.prototype.isPrivateChannel = isPrivateChannel;
    Utils.prototype.getPrivateChannelIDByRoomID = getPrivateChannelIDByRoomID;
    Utils.prototype.formatDate = formatDate;
    Utils.prototype.getHash = getHash;
    Utils.prototype.getCIString = getCIString;
    Utils.prototype.getObjectIdFromRoomID = getObjectIdFromRoomID;
    Utils.prototype.escapeRegExp = escapeRegExp;
    Utils.prototype.chatIdByUser = chatIdByUser;
    Utils.prototype.chatIdByGroup = chatIdByGroup;
    Utils.prototype.chatIdByRoom = chatIdByRoom;
    Utils.prototype.stripPrivateData = stripPrivateData;
    Utils.prototype.isNumeric = isNumeric;
    // Implementation ---------------------------------------
    
    function formatDate(ut,useUserFriendlyText,showTime){

        var date = new Date(ut);
        
        // hours part from the timestamp
        var hours = date.getHours();
        // minutes part from the timestamp
        var minutes = date.getMinutes();
        // seconds part from the timestamp
        var seconds = date.getSeconds();
        
        // will display time in 10:30:23 format
        var month = date.getMonth() + 1;
        var day = date.getDate();
        var year = date.getYear();
        
        // dont want include browser detaction library so use this dumb style.
        if(year < 1000){
            year += 1900;
        }
        
        if(hours < 10)
            hours = '0' + hours;
            
        if(minutes < 10)
            minutes = '0' + minutes;
            
        if(seconds < 10)
            seconds = '0' + seconds;
        
        
        if(month < 10)
            month = '0' + month;
        
        if(day < 10)
            day = '0' + day;
        
        var formattedTime;
        
        if(showTime)
           formattedTime = year + '/' + month + '/' + day + ' ' + hours + ':' + minutes + ':' + seconds;
        else
           formattedTime = year + '/' + month + '/' + day;
           
        return formattedTime;

        
    }
    function getRandomString(length){
    
        var text = "";
        var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        
        if(!length){
            length = 32;
        }
        
        for( var i=0; i < length; i++ )
            text += possible.charAt(Math.floor(Math.random() * possible.length));
    
        return text;
    }
    
    function now(){
        Date.now = Date.now || function() { return +new Date; }; 
        
        return Date.now();
        
    }
    
    function generateSecret(time){
        
        var dateStr = this.generateYYYYMMDDHHMMSS(time);
        var dateStrWithSecret = dateStr + init.secretSeed;
        
        return md5(dateStrWithSecret);
        
    }
    
    function generateYYYYMMDDHHMMSS(timestamp){
        
        var date = new Date(timestamp);
        
        var Y = date.getUTCFullYear();
                
        var MM = date.getUTCMonth() + 1;
        if(MM < 10)
            MM = "0"+MM;
        
        var DD = date.getUTCDate();
        if(DD < 10)
            DD = "0"+DD;
        
        var HH = date.getUTCHours();
        if(HH < 10)
            HH = "0"+HH;
        
        var Min = date.getMinutes();
        if(Min < 10)
            Min = "0"+Min;

        var SS = date.getSeconds();
        if(SS < 10)
            SS = "0"+SS;
            
        return Y.toString() + MM.toString() + DD.toString() + HH.toString() + Min.toString() + SS.toString();
        
    }
    
    function sendEmail(to, subject, body, isHTML, callback) {
        
        var transport = nodemailer.createTransport(smtpPool({
            host: init.smtp.host,
            port: init.smtp.port,
            secure: true,
            auth: {
                user: init.smtp.username,
                pass: init.smtp.password
            },
            // use up to 5 parallel connections
            maxConnections: 5,
            // do not send more than 10 messages per connection
            maxMessages: 10,
            // no not send more than 5 messages in a second
            rateLimit: 5
        }));

        var mailOptions = {
            from: init.email.from,
            to: to,
            subject: subject
        };

        if (isHTML) 
            mailOptions.html = body;
        else 
            mailOptions.text = body;

        // send mail
        transport.sendMail(mailOptions, (err, info) => {

            callback(err, info);
            
        });

    }

    function toObjectId(id){
        
        return mongoose.Types.ObjectId(id);
        
    }

    function shorten(str,limit){
        
        if(!limit)
            limit = 20;
            
        if(str.length > limit)
            str = str.substring(0,limit - 3) + "...";
        
        return str;
        
    }
    
    function isObjectId(str){
        var checkForHexRegExp = /^(?=[a-f\d]{24}$)(\d+[a-f]|[a-f]+\d)/i;
        return checkForHexRegExp.test(str);
    }

    function hash(string){

        return sha1(string + init.hashSalt);
        
    }
    
    function log(tag,obj){
        console.log(tag,util.inspect(obj, {showHidden: false, depth: null}));
    }

    function isPrivateChannel(channelID){
        
        if(!channelID)
            return false;
       
        return channelID.length > 24;
        
    }
    
    function getPrivateChannelIDByRoomID(roomID){

        if(!roomID)
            return null;
            
        return roomID.substr(0,24);
        
    }
    
    function getHash(string) {

        return sha1(string + init.hashSalt);
        
    }
    
    // returns case insensitive string
    function getCIString(string) {

        return new RegExp("^" + escapeRegExp(string) + "$", "i");

    }
    
    function getObjectIdFromRoomID(roomID){
        
        var splited = roomID.split("-");
        if(splited.length > 1)
            return splited[1];
        
        return null;
        
    }

    function escapeRegExp(str) {
        return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
    }

    function chatIdByUser(user1,user2){

            
        var chatId = "";
        
        if(user1.created < user2.created){
            
            chatId = Const.chatTypePrivate + "-" + user1._id + "-" + user2._id;
            
        } else {
            
            chatId = Const.chatTypePrivate + "-" + user2._id + "-" + user1._id;
            
        }
        
        return chatId;
        
    }

    function chatIdByGroup(group){
        return Const.chatTypeGroup + "-" + group._id;
    }
    
    function chatIdByRoom(room){
        return Const.chatTypeRoom + "-" + room._id;
    }
    
    function stripPrivateData(obj){
        
        _.forEach(obj,function(child,key,list){
            
            if(_.isObject(child))
                stripPrivateData(child);
            else{
            // delete keys to hide
            if(key == 'password')
                list[key] = "*****";
                
            if(key == 'token')
                list[key] = "*****";

            }
            
        });
        
    }

    function isNumeric(obj) {

        return _.isNumber(obj) || !isNaN(parseFloat(obj));

    }

    // Exports ----------------------------------------------
    module["exports"] = new Utils();

})((this || 0).self || global);