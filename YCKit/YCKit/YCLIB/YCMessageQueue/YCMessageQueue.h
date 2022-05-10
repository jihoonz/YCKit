//
//  YCMessageQueue.h
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCMessageQueue : NSObject

- (void)addObject:(id)object;
- (id)takeObject;
- (void)clearQueue;
- (BOOL)isEmpty;

@end

