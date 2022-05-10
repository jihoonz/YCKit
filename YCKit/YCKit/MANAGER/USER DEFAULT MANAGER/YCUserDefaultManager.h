//
//  YCUserDefaultManager.h
//  YCKit
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCUserDefaultManager : NSObject

+ (YCUserDefaultManager *)sharedManager;

- (void)setUserdefault:(NSString*)key value:(NSString*)value;
- (NSString*)getUserDefault:(NSString*)key;

- (void)setUserdefaultWithArray:(NSString*)key value:(NSArray*)value;
- (NSArray*)getUserDefaultWithArray:(NSString*)key;

- (void)clearUserDefault:(NSString*)key;


@end
