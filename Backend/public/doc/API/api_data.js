define({ "api": [
  {
    "type": "post",
    "url": "/api/v1/order/accept",
    "title": "Accept Order",
    "name": "Accept_Order",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. Driver accepts open order</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "orderId",
            "description": "<p>(Required) Open order id</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorInvalidId",
            "description": "<p>6000026</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorOrderAlreadyAcceptedOrCanceled",
            "description": "<p>6000027</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Order/AcceptOrderController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/order/call",
    "title": "Call Taxi",
    "name": "Call_Taxi",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. Sent request to taxi driver</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Decimal",
            "optional": false,
            "field": "latFrom",
            "description": "<p>(Required) User start latitude</p>"
          },
          {
            "group": "Parameter",
            "type": "Decimal",
            "optional": false,
            "field": "lonFrom",
            "description": "<p>(Required) User start longitude</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "addressFrom",
            "description": "<p>(Required) User start address</p>"
          },
          {
            "group": "Parameter",
            "type": "Decimal",
            "optional": false,
            "field": "latTo",
            "description": "<p>(Required) User destination latitude</p>"
          },
          {
            "group": "Parameter",
            "type": "Decimal",
            "optional": false,
            "field": "lonTo",
            "description": "<p>(Required) User destination longitude</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "addressTo",
            "description": "<p>(Required) User destination address</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "crewNum",
            "description": "<p>(Required) Number of passengers</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorLatitudeFrom",
            "description": "<p>6000017</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorLongitudeFrom",
            "description": "<p>6000018</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorNoAddressFrom",
            "description": "<p>6000019</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorLatitudeTo",
            "description": "<p>6000020</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorLongitudeTo",
            "description": "<p>6000021</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorNoAddressTo",
            "description": "<p>6000022</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorCrewNumber",
            "description": "<p>6000023</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075,\n    data: { \n        order: { \n            userId: '5784a21a773cfd5e2d58e770',\n            createOrderTs: 1468310044176,\n            crewNum: 4,\n            _id: 5784a21c773cfd5e2d58e771,\n            __v: 0,\n            to: { \n                location: [ 34.4344333, -44.5665333 ],\n                address: 'Bučarova 13 Zagreb' \n            },\n            from: { \n                location: [ 35.4344333, -44.7453333 ],\n                address: 'Siget 11 Zagreb' \n            }\n        }\n    }\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Order/CallOrderController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/order/cancel",
    "title": "Cancel Order",
    "name": "Cancel_Order",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. Cancels order</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "orderId",
            "description": "<p>(Required) Accepted order id</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "allowedValues": [
              "1",
              "2"
            ],
            "optional": false,
            "field": "type",
            "description": "<p>(Required) User type should be 1: user or 2: driver</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": true,
            "field": "reason",
            "description": "<p>Descriptive reason for canceling a order</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorWrongType",
            "description": "<p>6000011</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorInvalidId",
            "description": "<p>6000026</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorDriverAlreadyStartedDriveOrOrderIsCanceled",
            "description": "<p>6000029</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Order/CancelOrderController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/order/status",
    "title": "Check Order Status",
    "name": "Check_Order_Status",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. User check order status (accepted, canceled, pending, arrivedToStartLocation, startedDrive, finishedDrive)</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "orderId",
            "description": "<p>(Required) Order id</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorInvalidId",
            "description": "<p>6000026</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorOrderNotFound",
            "description": "<p>6000034</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "Number",
            "allowedValues": [
              "1",
              "2",
              "3",
              "4",
              "5",
              "6"
            ],
            "optional": false,
            "field": "orderStatus",
            "description": "<p>1 = accepted, 2 = canceled, 3 = pending, 4 = arrivedToStartLocation, 5 = startedDrive, 6 = finishedDrive</p>"
          },
          {
            "group": "Success 200",
            "type": "Number",
            "allowedValues": [
              "1",
              "2"
            ],
            "optional": true,
            "field": "cancelType",
            "description": "<p>1 = user, 2 = driver. Tells who cancel order (user or driver). If order isn't canceled, then cancelType isn't returned to response</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075,\n    data: {\n        orderStatus: 2,\n        driver: {\n            __v: 0,\n            _id: 57875c9c1c1a343769872e7e,\n            created: 1468488860290,\n            currentLocation: [ 10.000151, -19.999907 ],\n            email: 'testsFr2B@test.com',\n            password: '*****',\n            telNum: '+385981234567',\n            token: '*****',\n            token_generated: 1468488860456,\n            avatar: { \n                fileid: 'nJSoPuuRMGwHOjP3n0qwldOB13uLNyPF',\n                thumbfileid: 'qjZn3t0WiD079YuKbRIGMjpjojBD6w2x' \n            },\n            driver: { \n                name: 'test',\n                car_type: 'Caravan',\n                car_registration: 'ZG2344HR',\n                fee_start: 30,\n                fee_km: 5 \n            }\n        },\n        cancelType: 1\n    }\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Order/CheckStatusOrderController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "get",
    "url": "/api/v1/test/error",
    "title": "error",
    "name": "General_Error_Response",
    "group": "WebAPI",
    "description": "<p>Returns error</p>",
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Test/TestController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/signin",
    "title": "SignIn",
    "name": "General_Signin",
    "group": "WebAPI",
    "description": "<p>Signin to backend and generate new token for the user.</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>(Required)  Email Address</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>(Required)  Password</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "secret",
            "description": "<p>(Required)  Secret</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorNoEmail",
            "description": "<p>6000001</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorNoPassword",
            "description": "<p>6000002</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorNoSecret",
            "description": "<p>6000003</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "SignInError",
            "description": "<p>6000008</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "{ code: 6000008, time: 1467124038393 }",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response User:",
          "content": "{\n    code: 1,\n    time: 1467123777463,\n    data: {\n        token_new: 'UpQM5SM2hKyCzKoP',\n        user: {\n            __v: 0,\n            email: 'testT61gb@test.com',\n            password: '*****',\n            created: 1467123777437,\n            _id: '5772884116cc68e662fc072f',\n            user: { \n                name: 'test',\n                age: 0,\n                note: null\n            }\n        }\n    }\n}",
          "type": "json"
        },
        {
          "title": "Success-Response Driver:",
          "content": "{\n    code: 1,\n    time: 1467123777463,\n    data: {\n        token_new: 'UpQM5SM2hKyCzKoP',\n        user: {\n            __v: 0,\n            email: 'testT61gb@test.com',\n            password: '*****',\n            created: 1467123777437,\n            _id: '5772884116cc68e662fc072f',\n            driver: {\n                name: 'test',\n                car_type: 'Caravan',\n                car_registration: 'ZG2344HR',\n                fee_start: 30,\n                fee_km: 5\n            }\n        }\n    }\n}",
          "type": "json"
        },
        {
          "title": "Success-Response Undefined:",
          "content": "{\n    code: 1,\n    time: 1467123777463,\n    data: {\n        token_new: 'UpQM5SM2hKyCzKoP',\n        user: {\n            __v: 0,\n            email: 'testT61gb@test.com',\n            password: '*****',\n            created: 1467123777437,\n            _id: '5772884116cc68e662fc072f'\n        }\n    }\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Signin/SigninGeneralController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/signup",
    "title": "Signup",
    "name": "General_Signup",
    "group": "WebAPI",
    "description": "<p>Reigster new user to database and returns new token.</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>(Required) Email Address</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>(Required) Password</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "secret",
            "description": "<p>(Required) Secret</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorNoEmail",
            "description": "<p>6000001</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorNoPassword",
            "description": "<p>6000002</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorNoSecret",
            "description": "<p>6000003</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorWrongEmail",
            "description": "<p>6000004</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorWrongPassword",
            "description": "<p>6000005</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorEmailExists",
            "description": "<p>6000006</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorWrongSecret",
            "description": "<p>6000007</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "{\n    code: 6000006, \n    time: 1467124038393 \n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{\n\tcode: 1,\n\ttime: 1467123777463,\n\tdata: {\n\t\ttoken_new: 'UpQM5SM2hKyCzKoP',\n\t\tuser: {\n\t\t\t__v: 0,\n\t\t\temail: 'testT61gb@test.com',\n\t\t\tpassword: '*****',\n\t\t\tcreated: 1467123777437,\n\t\t\t_id: '5772884116cc68e662fc072f'\n\t\t}\n\t}\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Signup/SignupGeneralController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/profile/getDriverList",
    "title": "Get Driver List",
    "name": "Get_Driver_List",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. Get driver list within 1000 meters of current user position</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Decimal",
            "optional": false,
            "field": "lat",
            "description": "<p>(Required) Current user latitude</p>"
          },
          {
            "group": "Parameter",
            "type": "Decimal",
            "optional": false,
            "field": "lon",
            "description": "<p>(Required) Current user longitude</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorLatitude",
            "description": "<p>6000024</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorLongitude",
            "description": "<p>6000025</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075,\n    data: { \n        drivers: [\n            {\n                __v: 0,\n                _id: 5788dc42d92859ee355119d6,\n                created: 1468587074518,\n                currentLocation: [ 10, -19.999907 ],\n                email: 'testwjwrO@test.com',\n                password: '*****',\n                telNum: '+385981234567',\n                token: '*****',\n                token_generated: 1468587074837,\n                avatar: { \n                    fileid: 'rpOMhKHbp1vxkAZM4iToBE5YFX321tB0',\n                    thumbfileid: 'UMttVkf3XzxLLaSJVH9QH77zbELnjvNx' \n                },\n                driver: { \n                    name: 'test',\n                    car_type: 'Caravan',\n                    car_registration: 'ZG2344HR',\n                    fee_start: 30,\n                    fee_km: 5\n                }\n            },\n            {\n                __v: 0,\n                _id: 5788dc42d92859ee355119d7,\n                created: 1468587074518,\n                currentLocation: [ 10.00023, -19.999907 ],\n                email: 'testtghD3@test.com',\n                password: '*****',\n                telNum: '+385999876543',\n                token: '*****',\n                token_generated: 1468587074837,\n                avatar: { \n                    fileid: 'rpOMhKHbp1vxkAZM4iToBE5YFX321tB0',\n                    thumbfileid: 'UMttVkf3XzxLLaSJVH9QH77zbELnjvNx' \n                },\n                driver: { \n                    name: 'proba',\n                    car_type: 'Sport',\n                    car_registration: 'ST2344GG',\n                    fee_start: 30,\n                    fee_km: 5\n                }\n            }\n        ]\n    }\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Profile/GetDriverListProfileController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/profile/getNearestDriver",
    "title": "Get Nearest Driver",
    "name": "Get_Nearest_Driver",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. Get nearest driver to current user</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Decimal",
            "optional": false,
            "field": "lat",
            "description": "<p>(Required) Current user latitude</p>"
          },
          {
            "group": "Parameter",
            "type": "Decimal",
            "optional": false,
            "field": "lon",
            "description": "<p>(Required) Current user longitude</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorLatitude",
            "description": "<p>6000024</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorLongitude",
            "description": "<p>6000025</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075,\n    data: { \n        driver: {\n            __v: 0,\n            _id: 5788dc42d92859ee355119d6,\n            created: 1468587074518,\n            currentLocation: [ 10, -19.999907 ],\n            email: 'testwjwrO@test.com',\n            password: '*****',\n            telNum: '+385981234567',\n            token: '*****',\n            token_generated: 1468587074837,\n            avatar: { \n                fileid: 'rpOMhKHbp1vxkAZM4iToBE5YFX321tB0',\n                thumbfileid: 'UMttVkf3XzxLLaSJVH9QH77zbELnjvNx' \n            },\n            driver: { \n                name: 'test',\n                car_type: 'Caravan',\n                car_registration: 'ZG2344HR',\n                fee_start: 30,\n                fee_km: 5,\n                status: 1\n            },\n            averageRate: 4.34\n        }\n    }\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Profile/GetNearestDriverProfileController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/order/getOpenOrder",
    "title": "Get Open Order",
    "name": "Get_Open_Order",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. Get closest open order for taxi driver</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Decimal",
            "optional": false,
            "field": "lat",
            "description": "<p>(Required) Current driver latitude</p>"
          },
          {
            "group": "Parameter",
            "type": "Decimal",
            "optional": false,
            "field": "lon",
            "description": "<p>(Required) Current driver longitude</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorLatitude",
            "description": "<p>6000024</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorLongitude",
            "description": "<p>6000025</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075,\n    data: { \n        order: { \n            userId: '5784a21a773cfd5e2d58e770',\n            createOrderTs: 1468310044176,\n            crewNum: 4,\n            _id: 5784a21c773cfd5e2d58e771,\n            __v: 0,\n            to: { \n                location: [ 34.4344333, -44.5665333 ],\n                address: 'Bučarova 13 Zagreb' \n            },\n            from: { \n                location: [ 35.4344333, -44.7453333 ],\n                address: 'Siget 11 Zagreb' \n            },\n            user: { \n                __v: 0,\n                _id: 5784a21a773cfd5e2d58e770,\n                created: 1468310042789,\n                email: 'testn4eH1@test.com',\n                password: '*****',\n                telNum: '+385981234567',\n                token: '*****',\n                token_generated: 1468310042935,\n                avatar: { \n                    fileid: '7osIqcIYQeCcxoC3FQXwreu0Sj07JkvT',\n                    thumbfileid: 'tIXtp5R6z0aylAYv97ktDRQVK209pRAs' \n                },\n                user: { \n                    name: 'test', \n                    age: 0, \n                    note: null \n                }\n            }\n        }\n    }\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Order/GetOpenOrderController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/profile/detail",
    "title": "Get Profile Detail",
    "name": "Get_Profile_Detail",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. Returns user's data</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": true,
            "field": "userId",
            "description": "<p>User or driver id. If not specified, then return user's data from access-token.</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorInvalidId",
            "description": "<p>6000026</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075,\n    data: { \n        user: { \n            __v: 0,\n            _id: 57875c9c1c1a343769872e7e,\n            created: 1468488860290,\n            currentLocation: [ 10.000151, -19.999907 ],\n            email: 'testsFr2B@test.com',\n            password: '*****',\n            telNum: '+385981234567',\n            token: '*****',\n            token_generated: 1468488860456,\n            avatar: { \n                fileid: 'nJSoPuuRMGwHOjP3n0qwldOB13uLNyPF',\n                thumbfileid: 'qjZn3t0WiD079YuKbRIGMjpjojBD6w2x' \n            },\n            driver: { \n                name: 'test',\n                car_type: 'Caravan',\n                car_registration: 'ZG2344HR',\n                fee_start: 30,\n                fee_km: 5 \n            },\n            user: { \n                age: 0, \n                name: 'test' \n            }\n        }\n    }\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Profile/GetUserDetailProfileController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/profile/rate",
    "title": "Rate Profile",
    "name": "Rate_Profile",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. Rate user or driver profile</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "id",
            "description": "<p>(Required) Profile id to rate</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "allowedValues": [
              "1",
              "2"
            ],
            "optional": false,
            "field": "type",
            "description": "<p>(Required) Profile type should be 1: user or 2: driver. Profile type to rate</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "allowedValues": [
              "1",
              "2",
              "3",
              "4",
              "5"
            ],
            "optional": false,
            "field": "rate",
            "description": "<p>(Required) Rate number</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorWrongType",
            "description": "<p>6000011</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorInvalidId",
            "description": "<p>6000026</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorRateNumber",
            "description": "<p>6000031</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorUserNotFound",
            "description": "<p>6000032</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorDriverNotFound",
            "description": "<p>6000033</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Profile/RateProfileController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "get",
    "url": "/api/v1/test",
    "title": "just test",
    "name": "Test",
    "group": "WebAPI",
    "description": "<p>Returns text &quot;test&quot;</p>",
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "\n{ code: 1, time: 1467125660699, data: 'test' }",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Test/TestController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/profile/update",
    "title": "Update Profile",
    "name": "UpdateProfile",
    "group": "WebAPI",
    "description": "<p>This API receives multipart url-form-encoded request not JSON. Update user's profile, both for taxt driver and user</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "name",
            "description": "<p>(Required) Name of user/driver</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "allowedValues": [
              "1",
              "2"
            ],
            "optional": false,
            "field": "type",
            "description": "<p>(Required) User type should be 1: user or 2: driver</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "telNum",
            "description": "<p>(Required) Telephone number of user/driver (+385981234567, +385 99 1234 655, ...)</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "age",
            "description": "<p>Age of user</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "note",
            "description": "<p>note</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "car_type",
            "description": "<p>CarType</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "car_registration",
            "description": "<p>Car registration number</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "fee_start",
            "description": "<p>Start fee</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "fee_km",
            "description": "<p>Fee per km</p>"
          },
          {
            "group": "Parameter",
            "type": "File",
            "optional": false,
            "field": "file",
            "description": "<p>picture file (png,jpeg,gif)</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorNoName",
            "description": "<p>6000010</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorWrongType",
            "description": "<p>6000011</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorFeeStart",
            "description": "<p>6000013</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorFeeKm",
            "description": "<p>6000014</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorWrongImageType",
            "description": "<p>6000012</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorAge",
            "description": "<p>6000015</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorWrongTelNum",
            "description": "<p>6000016</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response User:",
          "content": "{ \n    code: 1,\n    time: 1468314014075,\n    data: { \n        user: { \n            __v: 0,\n            _id: 57875c9c1c1a343769872e7e,\n            created: 1468488860290,\n            email: 'testsFr2B@test.com',\n            password: '*****',\n            telNum: '+385981234567',\n            token: '*****',\n            token_generated: 1468488860456,\n            avatar: { \n                fileid: 'nJSoPuuRMGwHOjP3n0qwldOB13uLNyPF',\n                thumbfileid: 'qjZn3t0WiD079YuKbRIGMjpjojBD6w2x' \n            },\n            user: { \n                age: 0, \n                name: 'test' \n            }\n        }\n    }\n}",
          "type": "json"
        },
        {
          "title": "Success-Response Driver:",
          "content": "{ \n    code: 1,\n    time: 1468314014075,\n    data: { \n        user: { \n            __v: 0,\n            _id: 57875c9c1c1a343769872e7e,\n            created: 1468488860290,\n            email: 'testsFr2B@test.com',\n            password: '*****',\n            telNum: '+385981234567',\n            token: '*****',\n            token_generated: 1468488860456,\n            avatar: { \n                fileid: 'nJSoPuuRMGwHOjP3n0qwldOB13uLNyPF',\n                thumbfileid: 'qjZn3t0WiD079YuKbRIGMjpjojBD6w2x' \n            },\n            driver: { \n                name: 'test',\n                car_type: 'Caravan',\n                car_registration: 'ZG2344HR',\n                fee_start: 30,\n                fee_km: 5 \n            }\n        }\n    }\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Profile/UpdateProfileController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/order/arrive",
    "title": "Update Driver's Arrive Time",
    "name": "Update_Driver_s_Arrive_Time",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. Update driver's arrive time in accepted order</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "orderId",
            "description": "<p>(Required) Accepted order id</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorInvalidId",
            "description": "<p>6000026</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorDriverAlreadyArrivedOrOrderIsCanceled",
            "description": "<p>6000028</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Order/ArriveOrderController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/order/finish",
    "title": "Update Driver's Finish Time",
    "name": "Update_Driver_s_Finish_Time",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. Update driver's finish time</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "orderId",
            "description": "<p>(Required) Order id</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorInvalidId",
            "description": "<p>6000026</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorDriverAlreadyFinishedDrive",
            "description": "<p>6000030</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Order/FinishTripOrderController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/order/start",
    "title": "Update Driver's Start Time",
    "name": "Update_Driver_s_Start_Time",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. Update driver's start time</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "orderId",
            "description": "<p>(Required) Order id</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorInvalidId",
            "description": "<p>6000026</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorDriverAlreadyStartedDriveOrOrderIsCanceled",
            "description": "<p>6000029</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Order/StartTripOrderController.js",
    "groupTitle": "WebAPI"
  },
  {
    "type": "post",
    "url": "/api/v1/profile/updateCoordinates",
    "title": "Update Profile Coordinates",
    "name": "Update_Profile_Coordinates",
    "group": "WebAPI",
    "description": "<p>This API receives JSON request. Update user's profile coordinates, both for taxt driver and user</p>",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "access-token",
            "description": "<p>Users unique access-token.</p>"
          }
        ]
      }
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Decimal",
            "optional": false,
            "field": "lat",
            "description": "<p>(Required) Current latitude</p>"
          },
          {
            "group": "Parameter",
            "type": "Decimal",
            "optional": false,
            "field": "lon",
            "description": "<p>(Required) Current longitude</p>"
          }
        ]
      }
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "UnknownError",
            "description": "<p>6000000</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "TokenInvalid",
            "description": "<p>6000009</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorLatitude",
            "description": "<p>6000024</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "ParamErrorLongitude",
            "description": "<p>6000025</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "{ \n    code: 1,\n    time: 1468314014075\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "src/server/WebAPI/Backend/Controllers/Profile/UpdateCoordinatesProfileController.js",
    "groupTitle": "WebAPI"
  }
] });
