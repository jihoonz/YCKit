//
//  YCCoverTransition.h
//  yuricooz
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCBaseTransition.h"

enum {
    kYCCoverTransitionUnknown,
    kYCCoverTransitionLeft,
    kYCCoverTransitionRight,
    kYCCoverTransitionTop,
    kYCCoverTransitionBottom,
};
typedef NSUInteger YC_COVER_TRANSITION_TYPE;

@interface YCCoverTransition : YCBaseTransition

@property (nonatomic, assign) YC_COVER_TRANSITION_TYPE type;

@end
