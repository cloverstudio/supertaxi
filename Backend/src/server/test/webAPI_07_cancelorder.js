var should = require('should');
var request = require('supertest');
var app = require('../mainTest');

describe('WEB API', function () {

    var req, res;

    describe('/order/cancel POST', function () {
        
        it('success user cancel order', (done) => {

            request(app)
                .post('/api/v1/order/cancel')
                .set('access-token', global.user1.token)
                .send({
                    type: "user",
                    reason: "Odustao"
                })
                .end((err, res) => {

    			if (err) {
    				throw err;
    			}

                res.body.code.should.be.exactly(1);
                res.body.should.have.property('data');
                
                done();
            
            });   
            
        });

        it('success driver cancel order', (done) => {

            request(app)
                .post('/api/v1/order/cancel')
                .set('access-token', global.user1.token)
                .send({
                    type: "driver",
                    reason: "Canceled"
                })
                .end((err, res) => {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(1);
                res.body.should.have.property('data');
                
                done();
            
            });   
            
        });

        it('wrong type', function (done) {

            request(app)
                .post('/api/v1/order/cancel')
                .set('access-token', global.user1.token)
                .send({
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

    });

});