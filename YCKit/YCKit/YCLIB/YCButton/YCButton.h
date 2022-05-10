//
//  YCButton.h
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCButton : UIButton

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *iconHighlighted;
@property (nonatomic, strong) UILabel *buttonName;

@property (nonatomic, strong) UIColor *normalBGColor;
@property (nonatomic, strong) UIColor *highlightBGColor;

@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *highlightTextColor;

@property (nonatomic) BOOL isSelected;

@end
