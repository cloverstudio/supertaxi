var should = require('should');
var request = require('supertest');
var app = require('../mainTest');

describe('WEB API', function () {

    var req, res;

    describe('/signup POST', function () {
    
        it('should be test', function (done) {

            request(app)
                .post('/api/v1/signup')
                .send({
                })
                .end(function (err, res) {

    			if (err) {
    				throw err;
    			}

                res.body.code.should.be.exactly(1);

                done();
            
            });   
            
        });
        
    });

});