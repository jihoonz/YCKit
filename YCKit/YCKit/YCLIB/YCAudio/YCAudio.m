//
//  YCAudio.m
//  YCKit
//
//  Created by yuri on 2017. 1. 1..
//  Copyright © 2017년 yuricooz. All rights reserved.
//

#import "YCAudio.h"

@interface YCAudio() <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    AVAudioRecorder *_recorder;
    AVAudioPlayer *_player;
}
@end

@implementation YCAudio

#pragma mark - shared Instance

+ (YCAudio *)sharedInstance
{
    static YCAudio *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YCAudio alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - object initialize

- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

#pragma mark - RECORDER

- (void)initRecorder:(NSURL*)url settings:(NSDictionary*)settings
{
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
    [_recorder setDelegate:self];
    [_recorder setMeteringEnabled:YES];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    [_recorder prepareToRecord];
}
- (BOOL)isRecorderState
{
    return _recorder.isRecording;
}
- (CGFloat)currentRecorderTime
{
    return _recorder.currentTime;
}
- (void)recorderStart:(CGFloat)duration
{
    [_recorder recordForDuration:duration];
}
- (void)recorderStop
{
    [_recorder stop];
}
- (void)recorderRelease
{
    [_recorder setDelegate:nil];
    [_recorder stop];
    _recorder = nil;
}

#pragma mark - PLAYER 

- (void)initPlayer:(NSURL*)url 
{
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_player setDelegate:self];
    [_player setMeteringEnabled:YES];
}
- (BOOL)isPlayerState
{
    return _player.isPlaying;
}
- (CGFloat)currentPlayerTime
{
    return _player.currentTime;
}
- (CGFloat)durationPlayerTime
{
    return _player.duration;
}
- (void)playerReady
{
    if( self.delegate != nil )
        [self.delegate audioPlayerReadyPlaying];
}
- (void)playerStart
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [_player prepareToPlay];
    [_player play];
}
- (void)playerStartWithDelay:(CGFloat)time
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [_player prepareToPlay];
    [self performSelector:@selector(delayPlay) withObject:nil afterDelay:time];
}
- (void)playerPause
{
    if ( _player.isPlaying )
        [_player pause];
}
- (void)playerStop
{
    [_player stop];
}
- (void)playerRelease
{
    [_player setDelegate:nil];
    [_player stop];
    _player = nil;
}

#pragma mark - DELAY PLAY

-(void)delayPlay
{
    [_player play];
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if( self.delegate != nil )
        [self.delegate audioRecorderDidFinishRecording];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"%@: %@",NSStringFromSelector(_cmd),error);
    
    if( self.delegate != nil )
        [self.delegate audioRecorderEncodeErrorDidOccur:error];
}

#pragma mark - AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if( self.delegate != nil )
        [self.delegate audioPlayerDidFinishPlaying];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    NSLog(@"%@: %@",NSStringFromSelector(_cmd),error);
    
    if( self.delegate != nil )
        [self.delegate audioPlayerDecodeErrorDidOccur:error];
}

@end
