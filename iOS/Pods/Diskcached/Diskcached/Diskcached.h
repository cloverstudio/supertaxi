//
//  Diskcached.h
//  Diskcached
//
//  Created by Hirohisa Kawasaki on 2014/02/24.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface NSString (Encode)

- (NSString *)diskcached_stringByEscapesUsingEncoding:(NSStringEncoding)enc;

@end

@interface NSString (Decode)

- (NSString *)diskcached_stringByEscapesUsingDecoding:(NSStringEncoding)enc;

@end

@interface Diskcached : NSObject

// default is YES, if `setObject:forKey:` and `objectForKey:`, then use NSKeyedArchiver, NSKeyedUnarchiver
// if useArchiver is NO, case objects' class for saving are NSData
@property (nonatomic) BOOL useArchiver;

@property (nonatomic) BOOL keepData; // default is NO, if dealloc or application background, clean data and directory
@property (nonatomic, readonly) NSString *directoryPath; // directory's path for saving objects

+ (instancetype)defaultCached;

- (id)initAtPath:(NSString *)path inUserDomainDirectory:(NSSearchPathDirectory)directory;

- (NSArray *)allKeys;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;
- (void)removeAllObjects;

@end