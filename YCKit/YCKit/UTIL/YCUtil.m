//
//  YCUtil.m
//  YCKit
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import "YCUtil.h"
#import "KeychainItemWrapper.h"

@implementation YCUtil

#pragma mark - COLOR IMAGE

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - DEVICE UUID

+ (void)setUuid:(NSString *)uuid identifier:(NSString *)identifier
{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    [wrapper setObject:uuid forKey:(__bridge id)(kSecAttrAccount)];
}

+ (NSString *)uuid:(NSString *)identifier
{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    
    NSString *uuid = [wrapper objectForKey:(__bridge id)(kSecAttrAccount)];
    
    if (uuid.length > 0)
    {
        return uuid;
    }
    return nil;
}

#pragma mark - STRING CHECK

+ (NSString*)validString:(NSString*)string
{
    NSString *strReturn = @"";
    
    if( string == nil )
        strReturn = @"";
    else if( [string isEqual:[NSNull null]] )
        strReturn = @"";
    else if( [string isEqualToString:@"null"] )
        strReturn = @"";
    else if( [string isEqualToString:@"<null>"] )
        strReturn = @"";
    else
        strReturn = string;
    
    return strReturn;
}

#pragma mark - NUMBER COMMA

+ (NSString*)currencyFormatString:(NSString*)string
{
    if ([string length] == 0)
        return @"0";
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *formatedString = [fmt stringFromNumber:@([string integerValue])];
    
    return formatedString;
}

@end
