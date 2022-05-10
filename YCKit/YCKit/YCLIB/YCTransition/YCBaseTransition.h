//
//  YCBaseTransition.h
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCBaseTransition : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, readwrite, assign, getter = isPresenting) BOOL presenting;

@end
