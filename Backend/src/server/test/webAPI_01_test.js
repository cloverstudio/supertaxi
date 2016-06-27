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
    
});