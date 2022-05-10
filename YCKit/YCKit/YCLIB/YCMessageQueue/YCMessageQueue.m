//
//  YCMessageQueue.m
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import "YCMessageQueue.h"

@interface YCMessageQueue ()
{
    NSMutableArray* objects;
}
@end

@implementation YCMessageQueue

- (id)init
{
    if ((self = [super init]))
    {
        objects = [NSMutableArray array];
    }
    return self;
}

- (void)addObject:(id)object
{
    @synchronized(self)
    {
        [objects addObject:object];
    }
}

- (id)takeObject
{
    id object = nil;
    
    @synchronized(self)
    {
        if ([objects count] > 0)
        {
            object = [objects objectAtIndex:0];
            [objects removeObjectAtIndex:0];
        }
    }
    return object;
}

- (void)clearQueue
{
    @synchronized(self)
    {
        [objects removeAllObjects];
        objects = nil;
        objects = [NSMutableArray array];
    }
}

- (BOOL)isEmpty
{
    @synchronized(self)
    {
        if([objects count] > 0)
            return NO;
        
        return YES;
    }
}



@end
