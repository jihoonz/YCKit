//
//  YCButton.m
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import "YCButton.h"

@implementation YCButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView* ic = [[UIImageView alloc] initWithFrame:CGRectZero];
        [ic setBackgroundColor:[UIColor clearColor]];
        self.icon = ic;
        
        [self addSubview:self.icon];
        
        UIImageView* icH = [[UIImageView alloc] initWithFrame:CGRectZero];
        [icH setBackgroundColor:[UIColor clearColor]];
        
        self.iconHighlighted = icH;
        
        [self addSubview:self.iconHighlighted];
        
        [self.iconHighlighted setHidden:YES];
        
        UILabel* lb = [[UILabel alloc] initWithFrame:CGRectZero];
        [lb setBackgroundColor:[UIColor clearColor]];
        [lb setFont:[UIFont systemFontOfSize:13.0f]];
        [lb setTextColor:[UIColor whiteColor]];
        [lb setHighlightedTextColor:[UIColor lightGrayColor]];
        [lb setTextAlignment:NSTextAlignmentCenter];
        self.buttonName = lb;
        
        [self addSubview:self.buttonName];
        
        self.isSelected = NO;
    }
    return self;
}

#pragma mark - TOUCH RECOGNIZING

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected)
    {
        [self setBackgroundColor:self.highlightBGColor];
        [self.buttonName setTextColor:self.highlightTextColor];
        
        [self.iconHighlighted setHidden:NO];
        [self.icon setHidden:YES];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if(highlighted)
    {
        [self setBackgroundColor:self.highlightBGColor];
        [self.buttonName setTextColor:self.highlightTextColor];
        
        [self.iconHighlighted setHidden:NO];
        [self.icon setHidden:YES];
    }
    else
    {
        [self setBackgroundColor:self.normalBGColor];
        [self.buttonName setTextColor:self.normalTextColor];
        
        [self.iconHighlighted setHidden:YES];
        [self.icon setHidden:NO];
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayTouchEnd) object:nil];
    [self performSelector:@selector(delayTouchEnd) withObject:nil afterDelay:0.05f];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayTouchEnd) object:nil];
    [self performSelector:@selector(delayTouchEnd) withObject:nil afterDelay:0.05f];
}

-(void)delayTouchEnd
{
    [self setBackgroundColor:self.normalBGColor];
    [self.buttonName setTextColor:self.normalTextColor];
    
    [self.iconHighlighted setHidden:YES];
    [self.icon setHidden:NO];
}

- (void)dealloc
{
    if(self.buttonName != nil) {
        [self.buttonName removeFromSuperview];
        self.buttonName = nil;
    }
    
    if(self.icon != nil) {
        [self.icon removeFromSuperview];
        self.icon = nil;
    }
    
    if(self.iconHighlighted != nil) {
        [self.iconHighlighted removeFromSuperview];
        self.iconHighlighted = nil;
    }
}

@end
