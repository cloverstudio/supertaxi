var should = require('should');
var request = require('supertest');
var app = require('../mainTest');

describe('WEB API', function () {

    var req, res;

    describe('/profile/update POST', function () {
    
        it('success', function (done) {

            request(app)
                .post('/api/v1/proflie/update')
                .set('access-token', global.user1.token)
                .field('type', 'user')
                .field('name', 'test')
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
                .post('/api/v1/proflie/update')
                .set('access-token', global.user1.token)
                .field('type', 'user')
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
                .post('/api/v1/proflie/update')
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

    });

});