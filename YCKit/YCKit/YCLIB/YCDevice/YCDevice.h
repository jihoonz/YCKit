//
//  YCDevice.h
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <sys/utsname.h>

typedef NS_ENUM(NSInteger, DeviceVersion)
{
    IPHONE4 = 3,
    IPHONE4S = 4,
    IPHONE5 = 5,
    IPHONE5C = 5,
    IPHONE5S = 6,
    IPHONE6= 7,
    IPHONE6PLUS = 8,
    IPHONE6S= 9,
    IPHONE6SPLUS = 10,
    IPHONESE = 11,
    IPHONE7 = 12,
    IPHONE7PLUS = 13,
    IPHONE8 = 14,
    IPHONE8PLUS = 15,
    IPHONEX = 16,
    IPHONEXS = 17,
    IPHONEXSMAX = 18,
    IPHONEXR = 19,
    IPHONESIMULATOR = 0
};

typedef NS_ENUM(NSInteger, DeviceSize)
{
    IPHONE35INCH = 1,
    IPHONE4INCH = 2,
    IPHONE = 3,
    IPHONEPLUS = 4,
    IPHONEXSIZE = 5,
    IPHONEXSMAXSIZE = 6,
    IPHONEXRSIZE = 7
};

@interface YCDevice : NSObject

+(DeviceVersion)deviceVersion;
+(DeviceSize)deviceSize;
+(NSString*)deviceName;

@end
