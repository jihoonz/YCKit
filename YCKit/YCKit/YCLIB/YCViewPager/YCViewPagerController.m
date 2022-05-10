//
//  YCViewPagerController.m
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import "YCViewPagerController.h"

#define kTabViewTag 38
#define kContentViewTag 34

#define kIndicatorColor [UIColor colorWithRed:178.0/255.0 green:203.0/255.0 blue:57.0/255.0 alpha:0.75]
#define kTabsViewBackgroundColor [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:0.75]
#define kContentViewBackgroundColor [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:0.75]

static const CGFloat kTabHeight = 46.0f;
static const CGFloat kTabOffset = 49.0f;
static const CGFloat kTabWidth = 128.0;
//static const CGFloat kIndicatorHeight = 5.0;
static const BOOL kStartFromSecondTab = NO;
static const BOOL kCenterCurrentTab = NO;
static const BOOL kFixFormerTabsPositions = NO;
static const BOOL kFixLatterTabsPositions = NO;

#pragma mark - TabView

@interface TabView : UIView

@end

@implementation TabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end


@interface YCViewPagerController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property UIScrollView *tabsView;
@property UIView *contentView;
@property UIPageViewController *pageViewController;
@property(assign) id <UIScrollViewDelegate> actualDelegate;
// Tab and content cache
@property NSMutableArray *tabs;
@property NSMutableArray *contents;
@property(nonatomic) NSUInteger tabCount;
@property(nonatomic) NSUInteger activeTabIndex;
@property(nonatomic) NSUInteger activeContentIndex;
@property(getter = isAnimatingToTab) BOOL animatingToTab;
@property(getter = isDefaultSetupDone) BOOL defaultSetupDone;
@property(nonatomic, strong) UIView *underlineStroke;
@property(nonatomic) BOOL didTapOnTabView;

@end


@implementation YCViewPagerController

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSettings];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self defaultSettings];
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Do setup if it's not done yet
    if (![self isDefaultSetupDone]) {
        [self defaultSetup];
    }
}

- (void)viewWillLayoutSubviews
{
    // Re-layout sub views
    [self layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)layoutSubviews
{
    
    CGFloat topLayoutGuide = 0.0;
    
    CGRect frame = self.tabsView.frame;
    frame.origin.x = 0.0;
    frame.origin.y = self.tabLocation == YCViewPagerTabLocationTop ? topLayoutGuide : CGRectGetHeight(self.view.frame) - self.tabHeight;
    frame.size.width = CGRectGetWidth(self.view.frame);
    frame.size.height = self.tabHeight;
    self.tabsView.frame = frame;
    
    frame = self.contentView.frame;
    frame.origin.x = 0.0;
    frame.origin.y = self.tabLocation == YCViewPagerTabLocationTop ? topLayoutGuide + CGRectGetHeight(self.tabsView.frame) : topLayoutGuide;
    frame.size.width = CGRectGetWidth(self.view.frame);
    frame.size.height = CGRectGetHeight(self.view.frame) - (topLayoutGuide + CGRectGetHeight(self.tabsView.frame)) - (self.tabBarController.tabBar.hidden ? 0 : CGRectGetHeight(self.tabBarController.tabBar.frame));
    self.contentView.frame = frame;
}

#pragma mark - IBAction

- (void)handleTapGesture:(id)sender
{
    // Get the desired page's index
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *) sender;
    UIView *tabView = tapGestureRecognizer.view;
    __block NSUInteger index = [self.tabs indexOfObject:tabView];
    
    if (self.activeTabIndex != index) {
        // Select the tab
        [self selectTabAtIndex:index didSwipe:NO animate:YES];
    }
    
    if( tabView != nil )
    {
        CGRect rect = tabView.frame;
        
        rect.origin.y = self.underlineStroke.frame.origin.y;
        rect.size.height = self.underlineStroke.frame.size.height;
        self.underlineStroke.frame = rect;
    }
}

#pragma mark - Interface rotation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self layoutSubviews];

    self.activeTabIndex = self.activeTabIndex;
}

#pragma mark - Setters

- (void)setTabHeight:(CGFloat)tabHeight
{
    _tabHeight = tabHeight;
}

- (void)setTabOffset:(CGFloat)tabOffset
{
    _tabOffset = tabOffset;
}

- (void)setTabWidth:(CGFloat)tabWidth
{
    _tabWidth = tabWidth;
}

- (void)setActiveTabIndex:(NSUInteger)activeTabIndex
{
    _activeTabIndex = activeTabIndex;

    UIView *tabView = [self tabViewAtIndex:self.activeTabIndex];
    CGRect frame = tabView.frame;
    
    if (self.centerCurrentTab) {
        
        frame.origin.x += (CGRectGetWidth(frame) / 2);
        frame.origin.x -= CGRectGetWidth(self.tabsView.frame) / 2;
        frame.size.width = CGRectGetWidth(self.tabsView.frame);
        
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
        }
        
        if ((frame.origin.x + CGRectGetWidth(frame)) > self.tabsView.contentSize.width) {
            frame.origin.x = (self.tabsView.contentSize.width - CGRectGetWidth(self.tabsView.frame));
        }
    } else {
        
        frame.origin.x -= self.tabOffset;
        frame.size.width = CGRectGetWidth(self.tabsView.frame);
    }
    
    [self.tabsView scrollRectToVisible:frame animated:NO];
}

- (void)setActiveContentIndex:(NSUInteger)activeContentIndex
{
    UIViewController *viewController = [self viewControllerAtIndex:activeContentIndex];
    
    if( !viewController )
        return;
    
    
    if (!viewController) {
        viewController = [[UIViewController alloc] init];
        viewController.view = [[UIView alloc] init];
        viewController.view.backgroundColor = [UIColor clearColor];
    }
    
    __weak UIPageViewController *weakPageViewController = self.pageViewController;
    __weak YCViewPagerController *weakSelf = self;
    
    if (activeContentIndex == self.activeContentIndex) {
        
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                         }];
        
    } else if (!(activeContentIndex + 1 == self.activeContentIndex || activeContentIndex - 1 == self.activeContentIndex)) {
        
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:(activeContentIndex < self.activeContentIndex) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:^(BOOL completed) {
                                             
                                             weakSelf.animatingToTab = NO;
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[viewController]
                                                                                  direction:(activeContentIndex < weakSelf.activeContentIndex) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
        
    } else {
        
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:(activeContentIndex < self.activeContentIndex) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                         }];
    }
    
    NSInteger index;
    index = self.activeContentIndex - 1;
    if (index >= 0 &&
        index != activeContentIndex &&
        index != activeContentIndex - 1) {
        self.contents[index] = NSNull.null;
    }
    index = self.activeContentIndex;
    if (index != activeContentIndex - 1 &&
        index != activeContentIndex &&
        index != activeContentIndex + 1) {
        self.contents[index] = [NSNull null];
    }
    index = self.activeContentIndex + 1;
    if (index < self.contents.count &&
        index != activeContentIndex &&
        index != activeContentIndex + 1) {
        self.contents[index] = [NSNull null];
    }
    
    _activeContentIndex = activeContentIndex;
}

#pragma mark - Public methods

- (void)reloadData
{
    [self defaultSetup];
    
    [self.view setNeedsDisplay];
}

- (void)selectTabAtIndex:(NSUInteger)index
{
    [self selectTabAtIndex:index didSwipe:NO animate:NO];
}

- (void)selectTabAtIndex:(NSUInteger)index animate:(BOOL)animate
{
    [self selectTabAtIndex:index didSwipe:NO animate:animate];
}

- (void)selectTabAtIndex:(NSUInteger)index didSwipe:(BOOL)didSwipe animate:(BOOL)animate
{
    if (index >= self.tabCount) {
        return;
    }
    
    self.didTapOnTabView = !didSwipe;
    self.animatingToTab = animate;
    
    NSUInteger previousIndex = self.activeTabIndex;
    
    self.activeTabIndex = index;
    self.activeContentIndex = index;
    
    if ([self.delegate respondsToSelector:@selector(viewPager:didChangeTabToIndex:)]) {
        [self.delegate viewPager:self didChangeTabToIndex:self.activeTabIndex];
    }
    else if ([self.delegate respondsToSelector:@selector(viewPager:didChangeTabToIndex:fromIndex:)]) {
        [self.delegate viewPager:self didChangeTabToIndex:self.activeTabIndex fromIndex:previousIndex];
    }
    else if ([self.delegate respondsToSelector:@selector(viewPager:didChangeTabToIndex:fromIndex:didSwipe:)]) {
        [self.delegate viewPager:self didChangeTabToIndex:self.activeTabIndex fromIndex:previousIndex didSwipe:didSwipe];
    }
}

- (void)setNeedsReloadOptions
{
    CGFloat contentSizeWidth = 0;
    
    if (self.fixFormerTabsPositions) {
        if (self.centerCurrentTab) {
            contentSizeWidth = (CGRectGetWidth(self.tabsView.frame) - self.tabWidth) / 2.0f;
        } else {
            contentSizeWidth = self.tabOffset;
        }
    }
    
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        
        UIView *tabView = [self tabViewAtIndex:i];
        CGRect frame = tabView.frame;
        frame.origin.x = contentSizeWidth;
        frame.size.width = self.tabWidth;
        tabView.frame = frame;
        
        contentSizeWidth += CGRectGetWidth(tabView.frame) + self.padding;
    }
    
    if (self.fixLatterTabsPositions) {
        
        if (self.centerCurrentTab) {
            contentSizeWidth += (CGRectGetWidth(self.tabsView.frame) - self.tabWidth) / 2.0;
        } else {
            contentSizeWidth += CGRectGetWidth(self.tabsView.frame) - self.tabWidth - self.tabOffset;
        }
    }

    self.tabsView.contentSize = CGSizeMake(contentSizeWidth, self.tabHeight);
}

- (void)setNeedsReloadColors
{
    self.indicatorColor = self.indicatorColor;
    
    self.tabsView.backgroundColor = self.tabsViewBackgroundColor;
    
    self.tabsViewBackgroundColor = self.tabsViewBackgroundColor;
    
    self.contentView.backgroundColor = self.contentViewBackgroundColor;
    
    self.contentViewBackgroundColor = self.contentViewBackgroundColor;
}


#pragma mark - Private methods

-(void)isLockScroll:(BOOL)isLock
{
    for(UIView* view in self.pageViewController.view.subviews)
    {
        if([view isKindOfClass:[UIScrollView class]])
        {
            UIScrollView* scrollView=(UIScrollView*)view;
            [scrollView setScrollEnabled:isLock];
            return;
        }
    }
}

- (void)defaultSettings
{
    self.contentViewBackgroundColor = kContentViewBackgroundColor;
    self.tabsViewBackgroundColor = kTabsViewBackgroundColor;
    self.indicatorColor = kIndicatorColor;
    self.fixLatterTabsPositions = kFixLatterTabsPositions;
    self.fixFormerTabsPositions = kFixFormerTabsPositions;
    self.centerCurrentTab = kCenterCurrentTab;
    self.startFromSecondTab = kStartFromSecondTab;
    self.shouldAnimateIndicator = YCViewPagerIndicatorAnimationWhileScrolling;
    self.tabLocation = YCViewPagerTabLocationTop;
    self.indicatorHeight = 1;
    self.tabOffset = kTabOffset;
    self.tabWidth = kTabWidth;
    self.tabHeight = kTabHeight;
    self.padding = 0.0;
    
    self.didTapOnTabView = NO;
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    
    self.actualDelegate = ((UIScrollView *) self.pageViewController.view.subviews[0]).delegate;
    
    ((UIScrollView *) self.pageViewController.view.subviews[0]).delegate = self;
    [((UIScrollView *) self.pageViewController.view.subviews[0]) setScrollsToTop:NO];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.animatingToTab = NO;
    self.defaultSetupDone = NO;
}

- (void)defaultSetup
{
    for (UIView *tabView in self.tabs) {
        [tabView removeFromSuperview];
    }
    self.tabsView.contentSize = CGSizeZero;
    
    [self.tabs removeAllObjects];
    [self.contents removeAllObjects];
    
    self.tabCount = [self.dataSource numberOfTabsForViewPager:self];
    
    self.tabs = [NSMutableArray arrayWithCapacity:self.tabCount];
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        [self.tabs addObject:[NSNull null]];
    }
    
    self.contents = [NSMutableArray arrayWithCapacity:self.tabCount];
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        [self.contents addObject:[NSNull null]];
    }
    
    self.tabsView = (UIScrollView *) [self.view viewWithTag:kTabViewTag];
    
    if (!self.tabsView) {
        
        self.tabsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), self.tabHeight)];
        self.tabsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.tabsView.backgroundColor = self.tabsViewBackgroundColor;
        self.tabsView.scrollsToTop = NO;
        self.tabsView.showsHorizontalScrollIndicator = NO;
        self.tabsView.showsVerticalScrollIndicator = NO;
        self.tabsView.tag = kTabViewTag;
        
        [self.view insertSubview:self.tabsView atIndex:0];
        
        self.underlineStroke = [UIView new];
        [self.tabsView addSubview:self.underlineStroke];
    }
    
    CGFloat contentSizeWidth = 0;
    
    if (self.fixFormerTabsPositions) {
    
        if (self.centerCurrentTab) {
            contentSizeWidth = (CGRectGetWidth(self.tabsView.frame) - self.tabWidth) / 2.0f;
        } else {
            contentSizeWidth = self.tabOffset;
        }
    }
    
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        
        UIView *tabView = [self tabViewAtIndex:i];
        CGRect frame = tabView.frame;
        frame.origin.x = contentSizeWidth;
        frame.size.width = self.tabWidth;
        tabView.frame = frame;
        
        [self.tabsView addSubview:tabView];
        
        contentSizeWidth += CGRectGetWidth(tabView.frame) + self.padding;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [tabView addGestureRecognizer:tapGestureRecognizer];
    }
    
    if (self.fixLatterTabsPositions) {
        
        if (self.centerCurrentTab) {
            contentSizeWidth += (CGRectGetWidth(self.tabsView.frame) - self.tabWidth) / 2.0;
        } else {
            contentSizeWidth += CGRectGetWidth(self.tabsView.frame) - self.tabWidth - self.tabOffset;
        }
    }
    
    self.tabsView.contentSize = CGSizeMake(contentSizeWidth, self.tabHeight);
    
    self.contentView = [self.view viewWithTag:kContentViewTag];
    
    if (!self.contentView) {
        
        self.contentView = self.pageViewController.view;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = self.contentViewBackgroundColor;
        self.contentView.bounds = self.view.bounds;
        self.contentView.tag = kContentViewTag;
        
        [self.view insertSubview:self.contentView atIndex:0];
    }
    
    NSUInteger index = self.startFromSecondTab ? 1 : 0;
    [self selectTabAtIndex:index didSwipe:NO animate:NO];

    CGRect rect = [self tabViewAtIndex:self.activeContentIndex].frame;
    rect.origin.y = rect.size.height - self.indicatorHeight;
    rect.size.height = self.indicatorHeight;
    self.underlineStroke.frame = rect;
    self.underlineStroke.backgroundColor = self.indicatorColor;
    
//    if( self.tabLocation == YCViewPagerTabLocationTop )
//    {
//        CGRect rect = [self tabViewAtIndex:self.activeContentIndex].frame;
//        rect.origin.y = rect.size.height - self.indicatorHeight;
//        rect.size.height = self.indicatorHeight;
//        self.underlineStroke.frame = CGRectMake(rect.origin.x, self.tabHeight - 1, self.tabWidth, rect.size.height);
//        self.underlineStroke.backgroundColor = self.indicatorColor;
//    }
//    else
//    {
//        CGRect rect = [self tabViewAtIndex:self.activeContentIndex].frame;
//        rect.origin.y = rect.size.height - self.indicatorHeight;
//        rect.size.height = self.indicatorHeight;
//        self.underlineStroke.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/self.tabCount, rect.size.height);
//        self.underlineStroke.backgroundColor = self.indicatorColor;
//    }
    
    self.defaultSetupDone = YES;
}

- (TabView *)tabViewAtIndex:(NSUInteger)index
{
    if (index >= self.tabCount) {
        return nil;
    }
    
    if ([self.tabs[index] isEqual:[NSNull null]]) {
        
        UIView *tabViewContent = [self.dataSource viewPager:self viewForTabAtIndex:index];
        tabViewContent.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        TabView *tabView = [[TabView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tabWidth, self.tabHeight)];
        [tabView addSubview:tabViewContent];
        [tabView setClipsToBounds:YES];
        
        tabViewContent.center = tabView.center;
        
        self.tabs[index] = tabView;
    }
    
    return self.tabs[index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= self.tabCount) {
        return nil;
    }
    
    if ([self.contents[index] isEqual:[NSNull null]]) {
        
        UIViewController *viewController = nil;
        
        if ([self.dataSource respondsToSelector:@selector(viewPager:contentViewControllerForTabAtIndex:)])
        {
            viewController = [self.dataSource viewPager:self contentViewControllerForTabAtIndex:index];
            
            if( viewController == nil )
                return nil;
        }
        else if ([self.dataSource respondsToSelector:@selector(viewPager:contentViewForTabAtIndex:)])
        {
            
            UIView *view = [self.dataSource viewPager:self contentViewForTabAtIndex:index];
            
            UIView *pageView = [self.view viewWithTag:kContentViewTag];
            view.frame = pageView.bounds;
            
            viewController = [UIViewController new];
            viewController.view = view;
        } else {
            viewController = [[UIViewController alloc] init];
            viewController.view = [[UIView alloc] init];
        }
        
        self.contents[index] = viewController;
    }
    
    return self.contents[index];
}

- (NSUInteger)indexForViewController:(UIViewController *)viewController
{
    return [self.contents indexOfObject:viewController];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexForViewController:viewController];
    index++;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexForViewController:viewController];
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    UIViewController *viewController = self.pageViewController.viewControllers[0];
    
    NSUInteger index = [self indexForViewController:viewController];
    [self selectTabAtIndex:index didSwipe:NO animate:NO];
}

#pragma mark - UIScrollViewDelegate, Responding to Scrolling and Dragging

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.actualDelegate scrollViewDidScroll:scrollView];
    }
    UIView *tabView = [self tabViewAtIndex:self.activeTabIndex];
    
    if (![self isAnimatingToTab]) {
        
        CGRect frame = tabView.frame;
        CGFloat movedRatio = (scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame)) - 1;
        frame.origin.x += movedRatio * CGRectGetWidth(frame);
        
        if (self.centerCurrentTab) {
            
            frame.origin.x += (frame.size.width / 2);
            frame.origin.x -= CGRectGetWidth(self.tabsView.frame) / 2;
            frame.size.width = CGRectGetWidth(self.tabsView.frame);
            
            if (frame.origin.x < 0) {
                frame.origin.x = 0;
            }
            
            if ((frame.origin.x + frame.size.width) > self.tabsView.contentSize.width) {
                frame.origin.x = (self.tabsView.contentSize.width - CGRectGetWidth(self.tabsView.frame));
            }
        } else {
            
            frame.origin.x -= self.tabOffset;
            frame.size.width = CGRectGetWidth(self.tabsView.frame);
        }
        
        [self.tabsView scrollRectToVisible:frame animated:NO];
    }
    
    __block CGFloat newX;
    __block CGRect rect = tabView.frame;
    void (^updateIndicator)(void) = ^void() {
        rect.origin.x = newX;
        rect.origin.y = self.underlineStroke.frame.origin.y;
        rect.size.height = self.underlineStroke.frame.size.height;
        self.underlineStroke.frame = rect;
    };
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat distance = tabView.frame.size.width + self.padding;
    
    if (self.shouldAnimateIndicator == YCViewPagerIndicatorAnimationWhileScrolling && !self.didTapOnTabView) {
        if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x > 0) {
            CGFloat mov = width - scrollView.contentOffset.x;
            newX = rect.origin.x - ((distance * mov) / width);
        } else {
            CGFloat mov = scrollView.contentOffset.x - width;
            newX = rect.origin.x + ((distance * mov) / width);
        }
        updateIndicator();
    } else if (self.shouldAnimateIndicator == YCViewPagerIndicatorAnimationNone) {
        newX = tabView.frame.origin.x;
        updateIndicator();
    } else if (self.shouldAnimateIndicator == YCViewPagerIndicatorAnimationEnd || self.didTapOnTabView) {
        newX = tabView.frame.origin.x;
        [UIView animateWithDuration:.35f animations:^{
            updateIndicator();
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.actualDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.actualDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.actualDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    self.didTapOnTabView = NO;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.actualDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return NO;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.actualDelegate scrollViewDidScrollToTop:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.actualDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.actualDelegate scrollViewDidEndDecelerating:scrollView];
    }
    self.didTapOnTabView = NO;
}

#pragma mark - UIScrollViewDelegate, Managing Zooming

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([self.actualDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.actualDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.actualDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.actualDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.actualDelegate scrollViewDidZoom:scrollView];
    }
}

#pragma mark - UIScrollViewDelegate, Responding to Scrolling Animations

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.actualDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
    self.didTapOnTabView = NO;
}

@end




