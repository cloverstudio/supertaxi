var should = require('should');
var request = require('supertest');
var app = require('../mainTest');

describe('WEB API', function () {

    var req, res;

    describe('/profile/update POST', function () {
        
        it('success user', function (done) {

            request(app)
                .post('/api/v1/profile/update')
                .set('access-token', global.user1.token)
                .field('type', 1)
                .field('name', 'test')
                .field('telNum', '+385 98 9057 351')
                .attach('file', 'src/server/test/samplefiles/max.jpg')
                .end(function (err, res) {

    			if (err) {
    				throw err;
    			}

                res.body.code.should.be.exactly(1);
                res.body.should.have.property('data');
                
                done();
            
            });   
            
        });

        it('success driver', function (done) {

            request(app)
                .post('/api/v1/profile/update')
                .set('access-token', global.user1.token)
                .field('type', 2)
                .field('name', 'test')
                .field('telNum', '+385 98 1234 567')
                .field('fee_start', 30)
                .field('fee_km', 5)
                .field('car_type', 'Caravan')
                .field('car_registration', 'ZG2344HR')
                .attach('file', 'src/server/test/samplefiles/max.jpg')
                .end(function (err, res) {

    			if (err) {
    				throw err;
    			}

                res.body.code.should.be.exactly(1);
                res.body.should.have.property('data');
                
                done();
            
            });   
            
        });

        it('no name', function (done) {

            request(app)
                .post('/api/v1/profile/update')
                .set('access-token', global.user1.token)
                .field('type', 1)
                .field('name', '')
                .attach('file', 'src/server/test/samplefiles/max.jpg')
                .end(function (err, res) {

    			if (err) {
    				throw err;
    			}

                res.body.code.should.be.exactly(6000010);
                
                done();
            
            });   
            
        });

       it('wrong type', function (done) {

            request(app)
                .post('/api/v1/profile/update')
                .set('access-token', global.user1.token)
                .field('type', 'wrong')
                .field('name', 'test')
                .attach('file', 'src/server/test/samplefiles/max.jpg')
                .end(function (err, res) {

    			if (err) {
    				throw err;
    			}

                res.body.code.should.be.exactly(6000011);
                
                done();
            
            });   
            
        });

       it('wrong file', function (done) {

            request(app)
                .post('/api/v1/profile/update')
                .set('access-token', global.user1.token)
                .field('type', 1)
                .field('name', 'test')
                .attach('file', 'src/server/test/samplefiles/test.text')
                .end(function (err, res) {

    			if (err) {
    				throw err;
    			}

                res.body.code.should.be.exactly(6000012);
                
                done();
            
            });   
            
        });

       it('wrong age', function (done) {

            request(app)
                .post('/api/v1/profile/update')
                .set('access-token', global.user1.token)
                .field('type', 1)
                .field('name', 'test')
                .field('age', 'test')
                .attach('file', 'src/server/test/samplefiles/test.text')
                .end(function (err, res) {

    			if (err) {
    				throw err;
    			}

                res.body.code.should.be.exactly(6000015);
                
                done();
            
            });   
            
        });


       it('wrong fee', function (done) {

            request(app)
                .post('/api/v1/profile/update')
                .set('access-token', global.user1.token)
                .field('type', 2)
                .field('name', 'test')
                .field('fee_start', 'test')
                .field('fee_km', 5)
                .attach('file', 'src/server/test/samplefiles/test.text')
                .end(function (err, res) {

    			if (err) {
    				throw err;
    			}

                res.body.code.should.be.exactly(6000013);
                
                done();
            
            });   
            
        });

       it('wrong fee km', function (done) {

            request(app)
                .post('/api/v1/profile/update')
                .set('access-token', global.user1.token)
                .field('type', 2)
                .field('name', 'test')
                .field('fee_start', 35)
                .field('fee_km', 'test')
                .attach('file', 'src/server/test/samplefiles/test.text')
                .end(function (err, res) {

    			if (err) {
    				throw err;
    			}

                res.body.code.should.be.exactly(6000014);
                
                done();
            
            });   
            
        });

        it('wrong telNum', function (done) {

            request(app)
                .post('/api/v1/profile/update')
                .set('access-token', global.user1.token)
                .field('type', 1)
                .field('name', 'test')
                .field('telNum', '')
                .attach('file', 'src/server/test/samplefiles/max.jpg')
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000016);
                
                done();
            
            });   
            
        });

    });

});