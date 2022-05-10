//
//  YCUserDefaultManager.m
//  YCKit
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import "YCUserDefaultManager.h"

@implementation YCUserDefaultManager

+ (YCUserDefaultManager *)sharedManager {
    
    static YCUserDefaultManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[YCUserDefaultManager alloc] init];
    });
    
    return _sharedManager;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)setUserdefault:(NSString*)key value:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)getUserDefault:(NSString*)key
{
    NSString* value = @"";
    value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if( value == nil )
        value = @"";
    
    return value;
}

- (void)setUserdefaultWithArray:(NSString*)key value:(NSArray*)value
{
    NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:value.count];
    
    for (id dict in value)
    {
        NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [archiveArray addObject:personEncodedObject];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:archiveArray forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray*)getUserDefaultWithArray:(NSString*)key
{
    NSArray *arr = [NSArray array];
    arr = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    NSMutableArray *unArchiveArray = [NSMutableArray arrayWithCapacity:arr.count];
    
    for (NSData *data in arr)
    {
        id personEncodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [unArchiveArray addObject:personEncodedObject];
    }
    
    if( arr == nil )
    {
        arr = @[];
        return arr;
    }
    else
    {
        return unArchiveArray;
    }
}

- (void)clearUserDefault:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
