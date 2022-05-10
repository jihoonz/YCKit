//
//  YCIntroView.m
//  murmuring
//
//  Created by yuri on 2017. 8. 21..
//  Copyright © 2017년 withmind. All rights reserved.
//

#import "YCIntroView.h"

static const CGFloat kPageControlWidth = 150;

@implementation YCIntroView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.masterScrollView.delegate = self;
        self.frame = frame;
        [self initializeViewComponents];
    }
    return self;
}

-(void)initializeViewComponents
{
    self.masterScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.masterScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.masterScrollView.pagingEnabled = YES;
    self.masterScrollView.delegate = self;
    self.masterScrollView.showsHorizontalScrollIndicator = NO;
    self.masterScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.masterScrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width - kPageControlWidth)/2, self.frame.size.height - 48, kPageControlWidth, 37)];
    self.pageControl.currentPage = 0;
    self.pageControl.enabled = NO;
    [self addSubview:self.pageControl];
    
    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.skipButton setBackgroundImage:[UIImage imageNamed:@"btnClose"] forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(didPressSkipButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.skipButton];
    
    if( [YCDevice deviceSize] == IPHONEX )
        self.skipButton.frame = CGRectMake(APPLICATION_SIZE.width - 48, 49, 44, 44);
    else
        self.skipButton.frame = CGRectMake(APPLICATION_SIZE.width - 48, 5, 44, 44);
}

-(void)buildIntroductionWithPanels:(NSArray *)p
{
    panels = p;
    for (YCIntroPanel *panel in panels) {
        panel.parentIntroductionView = self;
    }
    
    [self addOverlayViewWithFrame:self.frame];
    
    //Construct panels
    [self addPanelsToScrollView];
}

-(void)addOverlayViewWithFrame:(CGRect)frame
{
    self.backgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0f,frame.size.width,frame.size.height)];
    self.backgroundColorView.backgroundColor = self.userBackgroundColor;
    [self insertSubview:self.backgroundColorView belowSubview:self.masterScrollView];
}

-(void)addPanelsToScrollView
{
    if (panels)
    {
        if (panels.count > 0)
        {
            self.pageControl.numberOfPages = panels.count;
            
            [self buildScrollViewLeftToRight];
        }
        else
        {
            NSLog(@"error");
        }
    }
    else {
        NSLog(@"error.");
    }
}

-(void)buildScrollViewLeftToRight
{
    CGFloat panelXOffset = 0;
    for (YCIntroPanel *panelView in panels)
    {
        panelView.frame = CGRectMake(panelXOffset, 0, self.frame.size.width, self.frame.size.height);
        [self.masterScrollView addSubview:panelView];
        
        panelXOffset += panelView.frame.size.width;
    }
    
    [self appendCloseViewAtXIndex:&panelXOffset];
    
    [self.masterScrollView setContentSize:CGSizeMake(panelXOffset, self.frame.size.height)];
    
    //Show the information at the first panel with animations
    [self animatePanelAtIndex:0];
    
    //Call first panel view did appear
    if ([panels[0] respondsToSelector:@selector(panelDidAppear)]) {
        [panels[0] panelDidAppear];
    }
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentPanelIndex = scrollView.contentOffset.x/self.masterScrollView.frame.size.width;
    
    if (self.currentPanelIndex == (panels.count))
    {
        if ([panels[self.pageControl.currentPage] respondsToSelector:@selector(panelDidDisappear)])
        {
            [panels[self.pageControl.currentPage] panelDidDisappear];
        }

        if( self.delegate != nil )
            [self.delegate introductionClose];
    }
    else
    {
        lastPanelIndex = self.pageControl.currentPage;
        
        if (self.pageControl.currentPage != self.currentPanelIndex) {
            if ([panels[lastPanelIndex] respondsToSelector:@selector(panelDidDisappear)]) {
                [panels[lastPanelIndex] panelDidDisappear];
            }
        }
        
        self.pageControl.currentPage = self.currentPanelIndex;
        
        if (lastPanelIndex != self.currentPanelIndex)
        {
            if ([(id)self.delegate respondsToSelector:@selector(introduction:didChangeToPanel:withIndex:)]) {
                [self.delegate introduction:self didChangeToPanel:panels[self.currentPanelIndex] withIndex:self.currentPanelIndex];
            }
            
            //Trigger the panel did appear method in the
            if ([panels[self.currentPanelIndex] respondsToSelector:@selector(panelDidAppear)]) {
                [panels[self.currentPanelIndex] panelDidAppear];
            }
            
            //Animate content to pop in nicely! :-)
            [self animatePanelAtIndex:self.currentPanelIndex];
        }
    }
}

//This will handle our changing opacity at the end of the introduction
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.currentPanelIndex = scrollView.contentOffset.x/self.masterScrollView.frame.size.width;
    if (self.currentPanelIndex == (panels.count - 1)) {
        self.alpha = ((self.masterScrollView.frame.size.width*(float)panels.count)-self.masterScrollView.contentOffset.x)/self.masterScrollView.frame.size.width;
    }
}

#pragma mark - Helper Methods

-(void)animatePanelAtIndex:(NSInteger)index
{
    for (YCIntroPanel *panelView in panels)
    {
        [panelView hideContent];
    }
    
    [panels[index] showContent];
}

-(void)appendCloseViewAtXIndex:(CGFloat*)xIndex
{
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, self.frame.size.width, 400)];
    
    [self.masterScrollView addSubview:closeView];
    
    *xIndex += self.masterScrollView.frame.size.width;
}

#pragma mark - Interaction Methods

- (void)didPressSkipButton
{
//    [self skipIntroduction];
    if( self.delegate != nil )
        [self.delegate introductionClose];
}

-(void)skipIntroduction{
    [self hideWithFadeOutDuration:0.3];
}

-(void)hideWithFadeOutDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished){
        
        if( self.delegate != nil )
            [self.delegate introductionClose];
        
    }];
}

-(void)changeToPanelAtIndex:(NSInteger)index
{
    NSInteger currentIndex = self.currentPanelIndex;
    currentIndex = (panels.count-1) - self.currentPanelIndex;
        
    
    if (panels && index < panels.count && currentIndex != index)
    {
        if ([panels[currentIndex] respondsToSelector:@selector(panelDidDisappear)])
        {
            [panels[currentIndex] panelDidDisappear];
        }
        
        CGRect panelRect = [panels[index] frame];
        [self.masterScrollView scrollRectToVisible:panelRect animated:YES];
        self.currentPanelIndex = index;
        [self animatePanelAtIndex:index];
        
        self.pageControl.currentPage = index;
        
        if ([panels[index] respondsToSelector:@selector(panelDidAppear)]) {
            [panels[index] panelDidAppear];
        }
        
        if([(id)self.delegate respondsToSelector:@selector(introduction:didChangeToPanel:withIndex:)]){
            [(id)self.delegate introduction:self didChangeToPanel:panels[index] withIndex:index];
        }
    }
    else
    {
        
    }
}
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.userBackgroundColor = backgroundColor;
    
    if (self.backgroundColorView)
        self.backgroundColorView.backgroundColor = backgroundColor;

}

@end
