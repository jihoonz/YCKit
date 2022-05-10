//
//  YCIntroPanel.m
//  murmuring
//
//  Created by yuri on 2017. 8. 21..
//  Copyright © 2017년 withmind. All rights reserved.
//

#import "YCIntroPanel.h"

@interface YCIntroPanel ()
{
    UIFont *kTitleFont;
    UIColor *kTitleTextColor;
    UIFont *kDescriptionFont;
    UIColor *kDescriptionTextColor;
}

@property (nonatomic, retain) UIView *PanelHeaderView;
@property (nonatomic, retain) NSString *PanelTitle;
@property (nonatomic, retain) NSString *PanelDescription;
@property (nonatomic, retain) UILabel *PanelTitleLabel;
@property (nonatomic, retain) UILabel *PanelDescriptionLabel;
@property (nonatomic, retain) UIImageView *PanelImageView;

@property (nonatomic, assign) BOOL isCustomPanel;
@property (nonatomic, assign) BOOL hasCustomAnimation;

@end

@implementation YCIntroPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeConstants];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeConstants];
        
        self.PanelTitle = title;
        self.PanelDescription = description;
        self.PanelImageView = [[UIImageView alloc] initWithImage:image];
        [self buildPanelWithFrame:frame];
    }
    return self;
}

-(void)initializeConstants
{
    kTitleFont = [[MMLocalize sharedManager] size:@"R" fontsize:39];
    kTitleTextColor = RGBA(255, 255, 255, 1.0f);
    kDescriptionFont = [[MMLocalize sharedManager] size:@"R" fontsize:14];
    kDescriptionTextColor = RGBA(255, 255, 255, 0.6f);
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)buildPanelWithFrame:(CGRect)frame
{
    if (self.PanelImageView.image)
    {
        self.PanelImageView.frame = CGRectMake(0, 0, APPLICATION_SIZE.width, APPLICATION_SIZE.height);
        [self addSubview:self.PanelImageView];
    }
    
    self.PanelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_SIZE.width/2 - 150/2,
                                                                     539,
                                                                     150, 46)];
    self.PanelTitleLabel.numberOfLines = 0;
    self.PanelTitleLabel.text = self.PanelTitle;
    self.PanelTitleLabel.font = kTitleFont;
    self.PanelTitleLabel.textColor = kTitleTextColor;
    self.PanelTitleLabel.alpha = 0;
    self.PanelTitleLabel.backgroundColor = [UIColor clearColor];
    [self.PanelTitleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.PanelTitleLabel setMinimumScaleFactor:0.5f];
    [self addSubview:self.PanelTitleLabel];
    
    self.PanelDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_SIZE.width/2 - 296/2,
                                                                           595,
                                                                           296, 57)];
    self.PanelDescriptionLabel.numberOfLines = 0;
    self.PanelDescriptionLabel.text = self.PanelDescription;
    self.PanelDescriptionLabel.font = kDescriptionFont;
    self.PanelDescriptionLabel.textColor = kDescriptionTextColor;
    self.PanelDescriptionLabel.alpha = 0;
    self.PanelDescriptionLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.PanelDescriptionLabel];


    
    if (self.isCustomPanel == YES) {
        self.hasCustomAnimation = YES;
    }
}

- (void) hideContent
{
    _PanelTitleLabel.alpha = 0;
    _PanelDescriptionLabel.alpha = 0;
    if (_PanelHeaderView) {
        _PanelHeaderView.alpha = 0;
    }
    _PanelImageView.alpha = 0;
}

- (void) showContent
{
    if (_isCustomPanel && !_hasCustomAnimation) {
        return;
    }
    
    CGRect initialHeaderFrame = CGRectZero;
    if ([self PanelHeaderView]) {
        initialHeaderFrame = [self PanelHeaderView].frame;
    }
    CGRect initialTitleFrame = [self PanelTitleLabel].frame;
    CGRect initialDescriptionFrame = [self PanelDescriptionLabel].frame;
    CGRect initialImageFrame = [self PanelImageView].frame;
    
    //Offset frames
    [[self PanelTitleLabel] setFrame:CGRectMake(initialTitleFrame.origin.x + 10, initialTitleFrame.origin.y, initialTitleFrame.size.width, initialTitleFrame.size.height)];
    [[self PanelDescriptionLabel] setFrame:CGRectMake(initialDescriptionFrame.origin.x + 10, initialDescriptionFrame.origin.y, initialDescriptionFrame.size.width, initialDescriptionFrame.size.height)];
    [[self PanelHeaderView] setFrame:CGRectMake(initialHeaderFrame.origin.x, initialHeaderFrame.origin.y - 10, initialHeaderFrame.size.width, initialHeaderFrame.size.height)];
    [[self PanelImageView] setFrame:CGRectMake(initialImageFrame.origin.x, initialImageFrame.origin.y + 10, initialImageFrame.size.width, initialImageFrame.size.height)];
    
    //Animate title and header
    [UIView animateWithDuration:0.3 animations:^{
        [[self PanelTitleLabel] setAlpha:1];
        [[self PanelTitleLabel] setFrame:initialTitleFrame];
        
        if ([self PanelHeaderView]) {
            [[self PanelHeaderView] setAlpha:1];
            [[self PanelHeaderView] setFrame:initialHeaderFrame];
        }
    } completion:^(BOOL finished) {
        //Animate description
        [UIView animateWithDuration:0.3 animations:^{
            [[self PanelDescriptionLabel] setAlpha:1];
            [[self PanelDescriptionLabel] setFrame:initialDescriptionFrame];
            [[self PanelImageView] setAlpha:1];
            [[self PanelImageView] setFrame:initialImageFrame];
        }];
    }];
}

#pragma mark - Interaction Methods

-(void)panelDidAppear
{

}

-(void)panelDidDisappear
{
    
}

@end
