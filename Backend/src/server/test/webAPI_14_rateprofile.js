var should = require('should');
var request = require('supertest');
var app = require('../mainTest');
var Const = require("../lib/consts");

describe('WEB API', function () {

    var req, res;

    describe('/profile/rate POST', function () {
        
        it('success rate user', function (done) {

            request(app)
                .post('/api/v1/profile/rate')
                .set('access-token', global.user1.token)
                .send({
                    id: global.user1._id,
                    type: Const.userTypeNormal,
                    rate: 5
                })
                .end(function (err, res) {

    			if (err) {
    				throw err;
    			}

                res.body.code.should.be.exactly(1);
                res.body.should.have.property('data');
                
                done();
            
            });   
            
        });

        it('success rate driver', function (done) {

            request(app)
                .post('/api/v1/profile/rate')
                .set('access-token', global.user1.token)
                .send({
                    id: global.user1._id,
                    type: Const.userTypeDriver,
                    rate: 4
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(1);
                res.body.should.have.property('data');
                
                done();
            
            });   
            
        });

        it('wrong id', function (done) {

            request(app)
                .post('/api/v1/profile/rate')
                .set('access-token', global.user1.token)
                .send({
                    id: "test"
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000026);
                
                done();
            
            });   
            
        });

        it('wrong type', function (done) {

            request(app)
                .post('/api/v1/profile/rate')
                .set('access-token', global.user1.token)
                .send({
                    id: global.user1._id,
                    type: "test"
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000011);
                
                done();
            
            });   
            
        });

        it('wrong rate number', function (done) {

            request(app)
                .post('/api/v1/profile/rate')
                .set('access-token', global.user1.token)
                .send({
                    id: global.user1._id,
                    type: Const.userTypeNormal,
                    rate: "test"
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000031);
                
                done();
            
            });   
            
        });

        it('user not found', function (done) {

            request(app)
                .post('/api/v1/profile/rate')
                .set('access-token', global.user1.token)
                .send({
                    id: "578e11bc5af09b9814cdff7e",
                    type: Const.userTypeNormal,
                    rate: 3
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000032);
                
                done();
            
            });   
            
        });

        it('driver not found', function (done) {

            request(app)
                .post('/api/v1/profile/rate')
                .set('access-token', global.user1.token)
                .send({
                    id: "578e11bc5af09b9814cdff7e",
                    type: Const.userTypeDriver,
                    rate: 5
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000033);
                
                done();
            
            });   
            
        });

    });

});