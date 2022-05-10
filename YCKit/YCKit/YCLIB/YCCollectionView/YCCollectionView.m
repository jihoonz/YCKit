//
//  YCCollectionView.m
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import "YCCollectionView.h"

@interface YCCollectionView()
{
    
}

@property (assign, nonatomic) CGFloat orignContentOffsetY;
@property (assign, nonatomic) CGFloat orignContentInsetTop;

@property (weak, nonatomic) id loadTarget;
@property (assign, nonatomic) SEL loadAction;

@end

@implementation YCCollectionView

- (void)dataSetup
{
    self.rtState = YCCVStateInit;
    self.reachedEnd = NO;
    
    self.orignContentOffsetY = -CGFLOAT_MAX;
    self.orignContentInsetTop = -CGFLOAT_MAX;
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didChangeValueForKey:(NSString *)key
{
    if ( self.rtState == YCCVStateInit )
        return;
    
    if ([key isEqualToString:@"contentOffset"] && !CGPointEqualToPoint(self.contentOffset, CGPointZero))
    {
        if ((self.contentOffset.y + 400 > (self.contentSize.height - self.frame.size.height) )
            || (self.contentOffset.x > (self.contentSize.width - self.frame.size.width)))
        {
            if ( !self.reachedEnd )
            {
                if ( self.rtState == YCCVStateLoading )
                    return;
                
                self.rtState = YCCVStateLoading;
                
                if ( self.loadMoreHandler )
                {
                    self.loadMoreHandler();
                }
                else if ( self.loadTarget && [self.loadTarget respondsToSelector:self.loadAction])
                {
                    ((void (*)(id, SEL))[self.loadTarget methodForSelector:self.loadAction])(self.loadTarget, self.loadAction);
                }
            }
        }
    }
}

- (void)addLoadTarget:(id)target action:(SEL)action
{
    self.loadTarget = target;
    self.loadAction = action;
}

- (void)reachEnd:(BOOL)isEnd
{
    self.reachedEnd = isEnd;
    
    if( self.reachedEnd )
    {
        self.rtState = YCCVStateReachEnd;
    }
}

- (void)finishLoading
{
    if ( self.rtState == YCCVStateLoading )
    {
        self.rtState = YCCVStateNormal;
    }
    else if ( self.rtState == YCCVStateReachEnd )
    {
        [self.loadView setHidden:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

@end
