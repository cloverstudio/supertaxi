//
//  ServerCommunication.m
//  Occupie
//
//  Created by Sky on 2/3/16.
//  Copyright (c) 2016 Occupie. All rights reserved.
//

#import "ServerCommunication.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@implementation ServerCommunication

#pragma mark - Shared Functions
+ ( ServerCommunication* ) sharedManager
{
    __strong static ServerCommunication* sharedObject = nil ;
    static dispatch_once_t onceToken ;
    
    dispatch_once( &onceToken, ^{
        sharedObject = [ [ ServerCommunication alloc ] init ] ;
    } ) ;
    return sharedObject;
}

- (void)basicURL:(NSString *)url dict:(NSDictionary *)dict
               imagedata:(NSData *)imagedata
                success : ( void (^)( id _responseObject ) ) _success
                failure : ( void (^)( NSError* _error ) ) _failure
{
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeGradient ];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        if(imagedata != nil)
            [formData appendPartWithFileData:imagedata name:@"user_image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if(_success)
            _success(responseObject);
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        if(_failure)
            _failure(error);
        [SVProgressHUD dismiss];
    }];
    [op start];
}

@end
