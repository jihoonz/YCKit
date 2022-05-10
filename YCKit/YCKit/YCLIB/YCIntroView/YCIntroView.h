//
//  YCIntroView.h
//  murmuring
//
//  Created by yuri on 2017. 8. 21..
//  Copyright © 2017년 withmind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCIntroPanel.h"

@class YCIntroView;

@protocol IntroDelegate

@optional
-(void)introduction:(YCIntroView *)introductionView;
-(void)introduction:(YCIntroView *)introductionView didChangeToPanel:(YCIntroPanel *)panel withIndex:(NSInteger)panelIndex;
-(void)introductionClose;

@end

typedef enum {
    IntroDirectionLeftToRight = 0,
    IntroDirectionRightToLeft
}introDirection;

@interface YCIntroView : UIView <UIScrollViewDelegate>
{
    NSArray *panels;
    NSInteger lastPanelIndex;
}

@property (nonatomic, assign) id <IntroDelegate> delegate;

@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, strong) UIView *backgroundColorView;
@property (strong, nonatomic) UIScrollView *masterScrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIButton *skipButton;
@property (nonatomic, assign) NSInteger currentPanelIndex;
@property (nonatomic, assign) introDirection introDirection;
@property (nonatomic, strong) UIColor *userBackgroundColor;

-(void)buildIntroductionWithPanels:(NSArray *)panels;
-(void)changeToPanelAtIndex:(NSInteger)index;
-(void)setBackgroundColor:(UIColor *)backgroundColor;

@end
