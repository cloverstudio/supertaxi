//
//  ServerCommunication.h
//  Occupie
//
//  Created by Sky on 2/3/16.
//  Copyright (c) 2016 Occupie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerCommunication : NSObject

+ ( ServerCommunication* ) sharedManager ;

- (void)basicURL:(NSString *)url dict:(NSDictionary *)dict
                imagedata:(NSData *)imagedata
                 success : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure;

@end
