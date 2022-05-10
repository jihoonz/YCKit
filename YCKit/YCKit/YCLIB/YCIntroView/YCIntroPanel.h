//
//  YCIntroPanel.h
//  murmuring
//
//  Created by yuri on 2017. 8. 21..
//  Copyright © 2017년 withmind. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCIntroView;

@interface YCIntroPanel : UIView

@property (nonatomic, strong) YCIntroView *parentIntroductionView;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image;

- (void)panelDidAppear;
- (void)panelDidDisappear;

- (void)hideContent;
- (void)showContent;

@end
