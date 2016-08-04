var should = require('should');
var request = require('supertest');
var app = require('../mainTest');

describe('WEB API', function () {

    var req, res;

    describe('/profile/updateCoordinates POST', function () {
        
        it('success update', function (done) {

            request(app)
                .post('/api/v1/profile/updateCoordinates')
                .set('access-token', global.user1.token)
                .send({
                    lat: -19.999907, 
                    lon: 10.000151
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

        it('wrong latitude', function (done) {

            request(app)
                .post('/api/v1/profile/updateCoordinates')
                .set('access-token', global.user1.token)
                .send({
                    lat: 'test',
                    lon: 10
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000024);
                
                done();
            
            });   
            
        });

        it('wrong longitude', function (done) {

            request(app)
                .post('/api/v1/profile/updateCoordinates')
                .set('access-token', global.user1.token)
                .send({
                    lat: -20,
                    lon: 'test'
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000025);
                
                done();
            
            });   
            
        });

    });

});