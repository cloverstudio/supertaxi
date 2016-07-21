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
                    latFrom: '45.81143500048897',
                    lonFrom: 15.97635893988804,
                    addressFrom: 'Gajeva ulica 7\U20139, City of Zagreb, Croatia',
                    latTo: 45.79635910671964,
                    lonTo: 15.97025768768202,
                    addressTo: 'Ivana Lucica 4, City of Zagreb, Croatia',
                    crewNum: 1
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
                    lonFrom: 15.97635893988804,
                    addressFrom: 'Siget 11 Zagreb',
                    latTo: 45.79635910671964,
                    lonTo: 15.97025768768202,
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
                    latFrom: 45.81143500048897,
                    lonFrom: 'test',
                    addressFrom: 'Siget 11 Zagreb',
                    latTo: 45.79635910671964,
                    lonTo: 15.97025768768202,
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
                    latFrom: 45.81143500048897,
                    lonFrom: 15.97635893988804,
                    addressFrom: '',
                    latTo: 45.79635910671964,
                    lonTo: 15.97025768768202,
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
                    latFrom: 45.81143500048897,
                    lonFrom: 15.97635893988804,
                    addressFrom: 'Siget 11 Zagreb',
                    latTo: 'test',
                    lonTo: 15.97025768768202,
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
                    latFrom: 45.81143500048897,
                    lonFrom: 15.97635893988804,
                    addressFrom: 'Siget 11 Zagreb',
                    latTo: 45.79635910671964,
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
                    latFrom: 45.81143500048897,
                    lonFrom: 15.97635893988804,
                    addressFrom: 'Siget 11 Zagreb',
                    latTo: 45.79635910671964,
                    lonTo: 15.97025768768202,
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
                    latFrom: 45.81143500048897,
                    lonFrom: 15.97635893988804,
                    addressFrom: 'Siget 11 Zagreb',
                    latTo: 45.79635910671964,
                    lonTo: 15.97025768768202,
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