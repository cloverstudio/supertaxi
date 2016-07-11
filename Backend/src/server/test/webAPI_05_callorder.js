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
                    latFrom: 99.45454545,
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

       // it('wrong type', function (done) {

       //      request(app)
       //          .post('/api/v1/profile/update')
       //          .set('access-token', global.user1.token)
       //          .field('type', 'wrong')
       //          .field('name', 'test')
       //          .attach('file', 'src/server/test/samplefiles/max.jpg')
       //          .end(function (err, res) {

    			// if (err) {
    			// 	throw err;
    			// }

       //          res.body.code.should.be.exactly(6000011);
                
       //          done();
            
       //      });   
            
       //  });

       // it('wrong file', function (done) {

       //      request(app)
       //          .post('/api/v1/profile/update')
       //          .set('access-token', global.user1.token)
       //          .field('type', 'user')
       //          .field('name', 'test')
       //          .attach('file', 'src/server/test/samplefiles/test.text')
       //          .end(function (err, res) {

    			// if (err) {
    			// 	throw err;
    			// }

       //          res.body.code.should.be.exactly(6000012);
                
       //          done();
            
       //      });   
            
       //  });

       // it('wrong age', function (done) {

       //      request(app)
       //          .post('/api/v1/profile/update')
       //          .set('access-token', global.user1.token)
       //          .field('type', 'user')
       //          .field('name', 'test')
       //          .field('age', 'test')
       //          .attach('file', 'src/server/test/samplefiles/test.text')
       //          .end(function (err, res) {

    			// if (err) {
    			// 	throw err;
    			// }

       //          res.body.code.should.be.exactly(6000015);
                
       //          done();
            
       //      });   
            
       //  });


       // it('wrong fee', function (done) {

       //      request(app)
       //          .post('/api/v1/profile/update')
       //          .set('access-token', global.user1.token)
       //          .field('type', 'driver')
       //          .field('name', 'test')
       //          .field('fee_start', 'test')
       //          .field('fee_km', 5)
       //          .attach('file', 'src/server/test/samplefiles/test.text')
       //          .end(function (err, res) {

    			// if (err) {
    			// 	throw err;
    			// }

       //          res.body.code.should.be.exactly(6000013);
                
       //          done();
            
       //      });   
            
       //  });

       // it('wrong fee km', function (done) {

       //      request(app)
       //          .post('/api/v1/profile/update')
       //          .set('access-token', global.user1.token)
       //          .field('type', 'driver')
       //          .field('name', 'test')
       //          .field('fee_start', 35)
       //          .field('fee_km', 'test')
       //          .attach('file', 'src/server/test/samplefiles/test.text')
       //          .end(function (err, res) {

    			// if (err) {
    			// 	throw err;
    			// }

       //          res.body.code.should.be.exactly(6000014);
                
       //          done();
            
       //      });   
            
       //  });

       //  it('wrong telNum', function (done) {

       //      request(app)
       //          .post('/api/v1/profile/update')
       //          .set('access-token', global.user1.token)
       //          .field('type', 'user')
       //          .field('name', 'test')
       //          .field('telNum', '')
       //          .attach('file', 'src/server/test/samplefiles/max.jpg')
       //          .end(function (err, res) {

       //          if (err) {
       //              throw err;
       //          }

       //          res.body.code.should.be.exactly(6000016);
                
       //          done();
            
       //      });   
            
       //  });

    });

});