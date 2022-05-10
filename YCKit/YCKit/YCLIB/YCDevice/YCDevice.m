//
//  YCDevice.m
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import "YCDevice.h"

@implementation YCDevice

+(NSDictionary*)deviceNamesByCode
{
    static NSDictionary* deviceNamesByCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceNamesByCode = @{
                              @"iPhone3,1" :[NSNumber numberWithInteger:IPHONE4],
                              @"iPhone4,1" :[NSNumber numberWithInteger:IPHONE4S],
                              @"iPhone5,1" :[NSNumber numberWithInteger:IPHONE5],
                              @"iPhone5,2" :[NSNumber numberWithInteger:IPHONE5],
                              @"iPhone5,3" :[NSNumber numberWithInteger:IPHONE5C],
                              @"iPhone5,4" :[NSNumber numberWithInteger:IPHONE5C],
                              @"iPhone6,1" :[NSNumber numberWithInteger:IPHONE5S],
                              @"iPhone6,2" :[NSNumber numberWithInteger:IPHONE5S],
                              @"iPhone7,1" :[NSNumber numberWithInteger:IPHONE6PLUS],
                              @"iPhone7,2" :[NSNumber numberWithInteger:IPHONE6],
                              @"iPhone8,1" :[NSNumber numberWithInteger:IPHONE6S],
                              @"iPhone8,2" :[NSNumber numberWithInteger:IPHONE6SPLUS],
                              @"iPhone8,4" :[NSNumber numberWithInteger:IPHONESE],
                              @"iPhone9,1" :[NSNumber numberWithInteger:IPHONE7],
                              @"iPhone9,2" :[NSNumber numberWithInteger:IPHONE7PLUS],
                              @"iPhone9,3" :[NSNumber numberWithInteger:IPHONE7],
                              @"iPhone9,4" :[NSNumber numberWithInteger:IPHONE7PLUS],
                              @"iPhone10,1" :[NSNumber numberWithInteger:IPHONE8],
                              @"iPhone10,2" :[NSNumber numberWithInteger:IPHONE8PLUS],
                              @"iPhone10,3" :[NSNumber numberWithInteger:IPHONEX],
                              @"iPhone10,4" :[NSNumber numberWithInteger:IPHONE8],
                              @"iPhone10,5" :[NSNumber numberWithInteger:IPHONE8PLUS],
                              @"iPhone10,6" :[NSNumber numberWithInteger:IPHONEX],
                              @"iPhone11,2" :[NSNumber numberWithInteger:IPHONEXS],
                              @"iPhone11,4" :[NSNumber numberWithInteger:IPHONEXSMAX],
                              @"iPhone11,6" :[NSNumber numberWithInteger:IPHONEXSMAX],
                              @"iPhone11,8" :[NSNumber numberWithInteger:IPHONEXR],
                              @"i386"      :[NSNumber numberWithInteger:IPHONESIMULATOR],
                              @"x86_64"    :[NSNumber numberWithInteger:IPHONESIMULATOR]
                              };
    });
    
    return deviceNamesByCode;
}

+(DeviceVersion)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    DeviceVersion version = (DeviceVersion)[[self.deviceNamesByCode objectForKey:code] integerValue];
    
    return version;
}

+(DeviceSize)deviceSize
{
//       8  375 667
//      8P  414 736
//       X  375 812
//      XR  414 896
//      XS  375 812
//  XS MAX  414 896
//
//    xs Max : 1242 2688
//    xr : 828 1792
//    xs : 1125 2436
//    8+ : 1242 2208
//    8 : 750 1334

    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    if (screenHeight == 480)
        return IPHONE35INCH;
    else if(screenHeight == 568)
        return IPHONE4INCH;
    else if(screenHeight == 667)
        return  IPHONE;
    else if(screenHeight == 736)
        return IPHONEPLUS;
    else if(screenHeight == 812)
        return IPHONEXSIZE;
    else if(screenHeight == 896)
        return IPHONEXSMAXSIZE;
    else
        return 0;
}

+(NSString*)deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([code isEqualToString:@"x86_64"] || [code isEqualToString:@"i386"]) {
        code = @"Simulator";
    }
    
    return code;
}

@end
