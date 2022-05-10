//
//  YCViewPagerController.h
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YCViewPagerTabLocation)
{
    YCViewPagerTabLocationTop = 0,
    YCViewPagerTabLocationBottom = 1
};
typedef NS_ENUM(NSUInteger, YCViewPagerIndicator)
{
    YCViewPagerIndicatorAnimationNone = 0,
    YCViewPagerIndicatorAnimationEnd = 1,
    YCViewPagerIndicatorAnimationWhileScrolling = 2
    
};

@class YCViewPagerController;

#pragma mark dataSource

@protocol YCViewPagerDataSource <NSObject>

- (NSUInteger)numberOfTabsForViewPager:(YCViewPagerController *)viewPager;
- (UIView *)viewPager:(YCViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index;

@optional

- (UIViewController *)viewPager:(YCViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index;
- (UIView *)viewPager:(YCViewPagerController *)viewPager contentViewForTabAtIndex:(NSUInteger)index;

@end

#pragma mark delegate

@protocol YCViewPagerDelegate <NSObject>

@optional

- (void)viewPager:(YCViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index;
- (void)viewPager:(YCViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index fromIndex:(NSUInteger)previousIndex;
- (void)viewPager:(YCViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index fromIndex:(NSUInteger)previousIndex didSwipe:(BOOL)didSwipe;

@end


@interface YCViewPagerController : UIViewController

@property (nonatomic, assign) id<YCViewPagerDataSource> dataSource;
@property (nonatomic, assign) id<YCViewPagerDelegate> delegate;

@property (nonatomic) CGFloat tabHeight;
@property (nonatomic) CGFloat tabOffset;
@property (nonatomic) CGFloat tabWidth;
@property (nonatomic) CGFloat indicatorHeight;
@property (nonatomic) CGFloat padding;

@property (nonatomic) YCViewPagerTabLocation tabLocation;
@property (nonatomic) YCViewPagerIndicator shouldAnimateIndicator;

@property (nonatomic) BOOL startFromSecondTab;
@property (nonatomic) BOOL centerCurrentTab;
@property (nonatomic) BOOL fixFormerTabsPositions;
@property (nonatomic) BOOL fixLatterTabsPositions;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *tabsViewBackgroundColor;
@property (nonatomic, strong) UIColor *contentViewBackgroundColor;

#pragma mark Methods

-(void)isLockScroll:(BOOL)isLock;

- (void)reloadData;

- (void)selectTabAtIndex:(NSUInteger)index;
- (void)selectTabAtIndex:(NSUInteger)index animate:(BOOL)animate;

- (void)setNeedsReloadOptions;
- (void)setNeedsReloadColors;

@end
