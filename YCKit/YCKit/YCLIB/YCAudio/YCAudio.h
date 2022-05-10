//
//  YCAudio.h
//  YCKit
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol YCAudioProtocol <NSObject>

@optional
- (void)audioRecorderDidFinishRecording;
- (void)audioRecorderEncodeErrorDidOccur:(NSError * __nullable)error;

- (void)audioPlayerReadyPlaying;
- (void)audioPlayerDidFinishPlaying;
- (void)audioPlayerDecodeErrorDidOccur:(NSError * __nullable)error;

@end

@interface YCAudio : NSObject

@property(nonatomic, assign) id <YCAudioProtocol>_Nullable delegate;

+ (YCAudio *_Nullable)sharedInstance;

- (void)initRecorder:(NSURL*_Nullable)url settings:(NSDictionary*_Nonnull)settings;
- (BOOL)isRecorderState;
- (CGFloat)currentRecorderTime;
- (void)recorderStart:(CGFloat)duration;
- (void)recorderStop;
- (void)recorderRelease;

- (void)initPlayer:(NSURL*_Nullable)url;
- (BOOL)isPlayerState;
- (CGFloat)currentPlayerTime;
- (CGFloat)durationPlayerTime;
- (void)playerReady;
- (void)playerStart;
- (void)playerStartWithDelay:(CGFloat)time;
- (void)playerPause;
- (void)playerStop;
- (void)playerRelease;

@end
