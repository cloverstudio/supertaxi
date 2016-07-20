var should = require('should');
var request = require('supertest');
var app = require('../mainTest');

describe('WEB API', function () {

    var req, res;

    describe('/order/accept POST', function () {
        
        it('success accept order', function (done) {

            request(app)
                .post('/api/v1/order/accept')
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
                .post('/api/v1/order/accept')
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

        it('order already accepted or canceled', function (done) {

            request(app)
                .post('/api/v1/order/accept')
                .set('access-token', global.user1.token)
                .send({
                    orderId: global.order._id
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000027);
                
                done();
            
            });   
            
        });

    });

});