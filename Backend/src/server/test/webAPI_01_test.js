var should = require('should');
var request = require('supertest');
var app = require('../mainTest');

describe('WEB API', function () {

    var req, res;

    describe('/test GET', function () {
    
        it('should be test', function (done) {

            request(app)
                .get('/api/v1/test')
                .end(function (err, res) {

    			if (err) {
    				throw err;
    			}

                res.body.data.should.be.exactly("test");
                
                done();
            
            });   
            
        });
        
    });

    describe('/test/error GET', function () {
    
        it('should be error', function (done) {

            request(app)
                .get('/api/v1/test/error')
                .end(function (err, res) {

    			if (err) {
    				throw err;
    			}

                res.body.code.should.be.exactly(6000000);
                
                done();
            
            });   
            
        });
        
    });

});