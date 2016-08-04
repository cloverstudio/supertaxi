var should = require('should');
var request = require('supertest');
var app = require('../mainTest');

describe('WEB API', function () {

    var req, res;

    describe('/profile/detail POST', function () {
        
        it('success get profile detail', function (done) {

            request(app)
                .post('/api/v1/profile/detail')
                .set('access-token', global.user1.token)
                .send({
                    userId: global.user1._id
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

        it('success get profile detail without user id', function (done) {

            request(app)
                .post('/api/v1/profile/detail')
                .set('access-token', global.user1.token)
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(1);
                res.body.should.have.property('data');
                
                done();
            
            });   
            
        });

        it('wrong user id', function (done) {

            request(app)
                .post('/api/v1/profile/detail')
                .set('access-token', global.user1.token)
                .send({
                    userId: "test"
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000026);
                
                done();
            
            });   
            
        });

    });

});