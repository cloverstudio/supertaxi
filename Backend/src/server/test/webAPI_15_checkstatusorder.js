var should = require('should');
var request = require('supertest');
var app = require('../mainTest');

describe('WEB API', function () {

    var req, res;

    describe('/order/status POST', function () {
        
        it('success check status', function (done) {

            request(app)
                .post('/api/v1/order/status')
                .set('access-token', global.user1.token)
                .send({
                    orderId: global.order._id
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

        it('wrong order id', function (done) {

            request(app)
                .post('/api/v1/order/status')
                .set('access-token', global.user1.token)
                .send({
                    orderId: ""
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000026);
                
                done();
            
            });   
            
        });

        it('order not found', function (done) {

            request(app)
                .post('/api/v1/order/status')
                .set('access-token', global.user1.token)
                .send({
                    orderId: "578e11bc5af09b9814cdff7e"
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000034);
                
                done();
            
            });   
            
        });

    });

});