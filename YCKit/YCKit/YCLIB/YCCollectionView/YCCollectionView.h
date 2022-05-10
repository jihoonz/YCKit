//
//  YCCollectionView.h
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YCCVState) {
    YCCVStateInit,
    YCCVStateNormal,
    YCCVStateLoading,
    YCCVStateReachEnd
};

typedef void (^YCLoadMoreHandler)(void);

@interface YCCollectionView : UICollectionView

@property (nonatomic) YCCVState rtState;
@property (copy, nonatomic) YCLoadMoreHandler loadMoreHandler;

@property (assign, nonatomic) BOOL reachedEnd;
@property (strong, nonatomic) UIView *loadView;

- (void)dataSetup;
- (void)finishLoading;

- (void)addLoadTarget:(id)target action:(SEL)action;
- (void)reachEnd:(BOOL)isEnd;

@end
