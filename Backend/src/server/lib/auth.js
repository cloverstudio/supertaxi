function checkUserAdmin(request, response, next) {

    if (!request.session.user) {
        response.redirect('/admin/signin?originalUrl=' + request.originalUrl);
    } else {
        next();
    }

}

module.exports.checkUserAdmin = checkUserAdmin;