//
//  YCUtil.h
//  YCKit
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCUtil : NSObject

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (void)setUuid:(NSString *)uuid identifier:(NSString *)identifier;
+ (NSString *)uuid:(NSString *)identifier;

+ (NSString*)validString:(NSString*)string;
+ (NSString*)currencyFormatString:(NSString*)string;

@end
