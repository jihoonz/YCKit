//
//  YCTableView.h
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YCTBState) {
    YCTBStateInit,
    YCTBStateNormal,
    YCTBStateLoading,
    YCTBStateReachEnd
};

typedef void (^LoadMoreHandler)(void);

@interface YCTableView : UITableView

@property (nonatomic) YCTBState rtState;
@property (copy, nonatomic) LoadMoreHandler loadMoreHandler;

@property (assign, nonatomic) BOOL reachedEnd;
@property (strong, nonatomic) UIView *loadView;

- (void)dataSetup;
- (void)finishLoading;

- (void)addLoadTarget:(id)target action:(SEL)action;
- (void)reachEnd:(BOOL)isEnd;

@end
