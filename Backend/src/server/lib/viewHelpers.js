var _ = require('lodash');
var U = require('./utils.js');
var LocalizationManager = require('./LocalizationManager');
var init = require('./init.js');
var DatabaseManager = require('./DatabaseManager');
var Const = require("./consts");

var helpers = {
    "formatDate" : function(ut) {
      return  U.formatDate(ut,false,false);
    },
    "length" : function(ary) {
      return  ary.length;
    },
    "showAvatar" : function (fileID) {

        if(_.isEmpty(fileID)){
            return init.BaseURL + "/img/noavatar.png"
        }else{
            return init.BaseURL + "/uploads/" + fileID;
        }

        return "";
    },
    "l10n" : function(text) {
        return  LocalizationManager.localize(text,this.lang);
    },
    "size" : function(size) {
      return  U.readableSize(size);
    },
    "sizeGB" : function(size) {
      return  U.readableSizeGB(size);
    },
    "checkbox" : function(form,value) {

        if(form == value)
            return 'checked="checked"';
    },
    "permissionCheckBox" : function(folderModel,groupID,type){

        var hasPermisssion = false;

        _.forEach(folderModel.permissions,function(value,key){

            if(value.groupID == groupID){

                if(!_.isUndefined(value[type])){

                    if(value[type] == true){

                        hasPermisssion = true;

                    }

                }

            }

        });

        if(hasPermisssion)
            return 'checked="checked"';

    },
    "checkboxUserGroup" : function(form,namePrefix,nameSuffix){

        if(_.isEmpty(form))
            return;

        var key = namePrefix + nameSuffix;

        if(!_.isEmpty(form[key]))
            return "checked=checked";

        if(_.isEmpty(form.permission))
            return;

        if(_.isEmpty(form.permission.groups))
            return;

        var find = false;

        _.forEach(form.permission.groups,function(groupID){

            if(groupID.toString() == nameSuffix)
                find = true;

        });

        if(find)
            return "checked=checked";

    },
    "selectedOnEqual" : function(first,second){
        
        if(_.isObject(first))
            first = first.toString();

        if(_.isObject(second))
            second = second.toString();
         
                 
        if(first == second)
            return 'selected="selected"'
    },
    "checkIfExisted" : function(array, value) {
        
        var html = "checked='checked'";
        var checked = false;

        if (!_.isArray(array)) {

            if (array == value) checked = true;

        } else {

            _.forEach(array, function(key) { 
                if (key == value) checked = true;
            });

        }

        if (checked) return html;

    },
    "disableIfExisted" : function(array, value) {
        
        var html = "disabled='disabled'";
        var disabled = false;

        if (!_.isArray(array)) {

            if (array == value) disabled = true;

        } else {

            _.forEach(array, function(key) { 
                if (key == value) disabled = true;
            });

        }

        if (disabled) return html;

    },
    "time" : function(){
        
        return Date.now();

    },
    "checksame" : function(arg1,arg2,output){
        
        if(arg1 == arg2)
            return output;
        
    },
    "printIfEqual" : function(first,second,value){
        
        if(_.isObject(first))
            first = first.toString();

        if(_.isObject(second))
            second = second.toString();
         
                 
        if(first == second)
            return value
    },
    "showPaging" : function(params){

        if(_.isUndefined(params.rows) ||
            _.isUndefined(params.count) ||
            _.isUndefined(params.page) ||
            _.isUndefined(params.baseURL))
            
            return;
            
        var rows = params.rows;
        var count = params.count;
        var page = params.page / 1;
        var baseURL = params.baseURL;      
        
        var pages = Math.ceil(count / rows);
        var html = "";

        var maxPages = 12;
        
        if(pages < maxPages)
            maxPages = pages;
            
        // next and prev
        var next = page + 1;
        var prev = page - 1;
        
        if(next >= pages)
            next = pages;
        
        if(prev <= 1)
            prev = 1
        
        // prev
        html += '<li><a href="' + baseURL + prev + '" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>';
        
        var from = page - maxPages / 2;
        if(from <= 1)
            from = 1
        if(from + maxPages > pages)
            from = pages - maxPages + 1;
            
        // first page 
        if(from > 3){
            
            html += '<li><a href="' + baseURL + '1">' + 1 + '</a></li>';
            html += '<li><a href="#">...</a></li>';  
        }
        
        for(var i = 0 ; i < maxPages ; i++){
            
            var pageNum = from + i;

            // current selected page is colored
            if (pageNum == page)
                html += '<li><a class="selected-page" href="' + baseURL + pageNum + '">' + pageNum + '</a></li>';
            else
                html += '<li><a href="' + baseURL + pageNum + '">' + pageNum + '</a></li>';
            
        }
        
        if(from + maxPages <= pages - 1){

            html += '<li><a href="#">...</a></li>';  
            html += '<li><a href="' + baseURL + pages + '">' + pages + '</a></li>';
            
        }
        
        // prev
        html += '<li><a href="' + baseURL + next + '" aria-label="Next"><span aria-hidden="true">&raquo;</span></a></li>';
        
        
        return html;
        
    },
    "checkedIfEqual" : function(param1, param2){

        if(param1 == param2)
            return 'checked="checked"';

    },
    "selectedIfEqual" : function(param1, param2){

        if(param1 == param2) 
            return 'selected="selected"';

    },
    "createTreeGridDepartment" : function(data) {

        var tableHeader =  
            '<table class="table table-hover tree">' + 
                '<thead>' +
                    '<tr>' +
                        '<th>' + helpers.l10n("Name") + '</th>' +
                        '<th width="15%">' + helpers.l10n("Description") + '</th>' +
                        '<th width="15%">' + helpers.l10n("Created At") + '</th>' +
                        '<th width="5%"></th>' +
                        '<th width="5%"></th>' +
                        '<th width="5%"></th>' +
                    '</tr>' +
                '</thead>' +
                '<tbody>';

        var tableBody = "";
        var tableFooter = "</tbody></table>";
            
        var parentNodes = [];

        // filter parent nodes
        _.forEach(data, function(value) { 

            if (_.isEmpty(_.filter(data, { _id: DatabaseManager.toObjectId(value.parentId) }))) {

                value.parentId = "";
                parentNodes.push(value);

            };

        });

        var childNodes = [];

        return createTreeGrid(parentNodes);

        function createTreeGrid(treeGridData) {

            _.forEach(treeGridData, function(value, index) { 

                if (_.isEmpty(value.parentId))
                    tableBody += '<tr class="treegrid-' + value._id + '">'
                else
                    tableBody += '<tr class="treegrid-' + value._id + ' treegrid-parent-' + value.parentId + '">'

                var deleteButton = 
                    (!value.default) ? '<button type="button" class="buttonRedGhoust" onclick=\'location.href="/admin/department/delete/' + value._id + '"\'>' + helpers.l10n("Delete") + '</button>' : "";

                tableBody +=  
                    '<td class="list-edit-link">' + 
                        '<img class="list-tree-thumbnail img-rounded" src="/admin/file/' + value.avatar.thumbnail.nameOnServer + '" />' + 
                        '<a href="/admin/department/edit/' + value._id + '">' + 
                            '<strong>' + value.name + '</strong>' +
                        '</a>' + 
                    '</td>' + 
                    '<td>' + value.description + '</td>' + 
                    '<td>' + helpers.formatDate(value.created) + '</td>' + 
                    '<td>' + 
                        '<button type="button" class="buttonGreenGhoust" onclick=\'location.href="/admin/department/userlist/' + value._id + '"\'>' + helpers.l10n("Members") + '</button>' + 
                    '</td>' + 
                    '<td>' + 
                        '<button type="button" class="buttonGreenGhoust" onclick=\'location.href="/admin/department/edit/' + value._id + '"\'>' + helpers.l10n("Edit") + '</button>' + 
                    '</td>' + 
                    '<td>' + 
                        deleteButton + 
                    '</td>' + 
                '</tr>';
                
                childNodes = _.filter(data, { parentId: value._id.toString() });
            
                if (!_.isEmpty(childNodes)) createTreeGrid(childNodes);

            });

            return tableHeader + tableBody + tableFooter;
        };
        
    },
    "getMainPicture" : function(pictures) {

        var picture = _.find(pictures, "main");
        
        if (picture) return picture.thumbnail.nameOnServer;
        
    },
    "getStatusName" : function(value) {

        var statusName = "";
        
        if (value)
            statusName = "Enabled"
        else
            statusName = "Disabled"

        return helpers.l10n(statusName);
        
    },
    "checkIfUserIsOrganizationAdmin" : function(permission) {

        return (Const.userPermission.organizationAdmin == permission);
        
    },
    "setFocus" : function(fieldName, value) {

        if (fieldName == value) return 'autofocus="autofocus"';

    },
    "getImageNote": function() {

        return helpers.l10n("Recommended minimum image size is ") + Const.thumbSize + " x " + Const.thumbSize + ".";

    },
    "getStickerNote": function() {

        return helpers.l10n("*.zip only.");

    }
}

module["exports"] = helpers;
