var should = require('should');
var request = require('supertest');
var app = require('../mainTest');

describe('WEB API', function () {

    var req, res;

    describe('/order/call POST', function () {
        
        it('success order', function (done) {

            request(app)
                .post('/api/v1/order/call')
                .set('access-token', global.user1.token)
                .send({
                    latFrom: 89.45454545,
                    lonFrom: 70.45445,
                    addressFrom: 'Test adresa start',
                    latTo: -70.3455,
                    lonTo: -45.94595,
                    addressTo: 'Proba destinacija',
                    crewNum: 4
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

        it('wrong latitude from', function (done) {

            request(app)
                .post('/api/v1/order/call')
                .set('access-token', global.user1.token)
                .send({
                    latFrom: 'test',
                    lonFrom: 70.45445,
                    addressFrom: 'Siget 11 Zagreb',
                    latTo: 235.45454545,
                    lonTo: 100.45454545,
                    addressTo: 'Bučarova 13 Zagreb',
                    crewNum: 4
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000017);
                
                done();
            
            });   
            
        });

        it('wrong longitude from', function (done) {

            request(app)
                .post('/api/v1/order/call')
                .set('access-token', global.user1.token)
                .send({
                    latFrom: 99.45454545,
                    lonFrom: 'test',
                    addressFrom: 'Siget 11 Zagreb',
                    latTo: 235.45454545,
                    lonTo: 100.45454545,
                    addressTo: 'Bučarova 13 Zagreb',
                    crewNum: 4
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000018);
                
                done();
            
            });   
            
        });

        it('no address from', function (done) {

            request(app)
                .post('/api/v1/order/call')
                .set('access-token', global.user1.token)
                .send({
                    latFrom: 99.45454545,
                    lonFrom: 70.45445,
                    addressFrom: '',
                    latTo: 235.45454545,
                    lonTo: 100.45454545,
                    addressTo: 'Bučarova 13 Zagreb',
                    crewNum: 4
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000019);
                
                done();
            
            });   
            
        });

        it('wrong latitude to', function (done) {

            request(app)
                .post('/api/v1/order/call')
                .set('access-token', global.user1.token)
                .send({
                    latFrom: 99.45454545,
                    lonFrom: 70.45445,
                    addressFrom: 'Siget 11 Zagreb',
                    latTo: 'test',
                    lonTo: 100.45454545,
                    addressTo: 'Bučarova 13 Zagreb',
                    crewNum: 4
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000020);
                
                done();
            
            });   
            
        });

        it('wrong longitude to', function (done) {

            request(app)
                .post('/api/v1/order/call')
                .set('access-token', global.user1.token)
                .send({
                    latFrom: 99.45454545,
                    lonFrom: 70.45445,
                    addressFrom: 'Siget 11 Zagreb',
                    latTo: 235.45454545,
                    lonTo: 'test',
                    addressTo: 'Bučarova 13 Zagreb',
                    crewNum: 4
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000021);
                
                done();
            
            });   
            
        });

        it('no address to', function (done) {

            request(app)
                .post('/api/v1/order/call')
                .set('access-token', global.user1.token)
                .send({
                    latFrom: 99.45454545,
                    lonFrom: 70.45445,
                    addressFrom: 'Siget 11 Zagreb',
                    latTo: 235.45454545,
                    lonTo: 100.45454545,                    
                    addressTo: '',
                    crewNum: 4
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000022);
                
                done();
            
            });   
            
        });

        it('wrong crew number', function (done) {

            request(app)
                .post('/api/v1/order/call')
                .set('access-token', global.user1.token)
                .send({
                    latFrom: 99.45454545,
                    lonFrom: 70.45445,
                    addressFrom: 'Siget 11 Zagreb',
                    latTo: 235.45454545,
                    lonTo: 100.45454545,                    
                    addressTo: 'Bučarova 13 Zagreb',        
                    crewNum: 'test'
                })
                .end(function (err, res) {

                if (err) {
                    throw err;
                }

                res.body.code.should.be.exactly(6000023);
                
                done();
            
            });   
            
        });

    });

});