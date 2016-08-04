var should = require('should');
var request = require('supertest');
var app = require('../mainTest');

describe('WEB API', function () {

    var req, res;

    describe('/order/finish POST', function () {
        
        it('success finish trip', function (done) {

            request(app)
                .post('/api/v1/order/finish')
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
                .post('/api/v1/order/finish')
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

        it('driver already finished drive', function (done) {

            request(app)
                .post('/api/v1/order/finish')
                .set('access-token', global.user1.token)
                .send({
                    orderId: global.order._id
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000030);
                
                done();
            
            });   
            
        });

    });

});