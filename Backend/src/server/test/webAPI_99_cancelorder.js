var should = require('should');
var request = require('supertest');
var app = require('../mainTest');

describe('WEB API', function () {

    var req, res;

    describe('/order/cancel POST', function () {
        
        it('success cancel order', (done) => {

            request(app)
                .post('/api/v1/order/cancel')
                .set('access-token', global.user1.token)
                .send({
                    orderId: global.orderId,
                    type: 1,
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

        it('wrong order id', function (done) {

            request(app)
                .post('/api/v1/order/cancel')
                .set('access-token', global.user1.token)
                .send({
                    orderId: "test"
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000026);
                
                done();
            
            });   
            
        });

        it('wrong type', function (done) {

            request(app)
                .post('/api/v1/order/cancel')
                .set('access-token', global.user1.token)
                .send({
                    orderId: global.orderId,
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

        it('order already accepted or canceled', function (done) {

            request(app)
                .post('/api/v1/order/cancel')
                .set('access-token', global.user1.token)
                .send({
                    orderId: global.orderId,
                    type: 1
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