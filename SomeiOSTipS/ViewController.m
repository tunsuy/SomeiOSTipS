//
//  ViewController.m
//  SomeiOSTipS
//
//  Created by tunsuy on 9/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PresentViewController.h"
#import "ColorAnimator.h"
#import "CustomPresent.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) AVAudioPlayer *backgoundPlayer;
@property (nonatomic, strong) MPNowPlayingInfoCenter *mpNowPlay;

@property (nonatomic, strong) ColorAnimator *colorAnimator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSString *mp3Url = [[NSBundle mainBundle] pathForResource:@"惊鸿一面" ofType:@"mp3"];
    if (!mp3Url) {
        NSLog(@"Could not find the mp3 file: %@", @"惊鸿一面.mp3");
        return;
    }
    
    NSError *error = nil;
    
    /** 该方法会报错：Domain=NSOSStatusErrorDomain Code=-10875 */
//    self.backgoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:mp3Url] error:&error];
    
    self.backgoundPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:mp3Url] error:&error];
    
    if (!self.backgoundPlayer) {
        NSLog(@"Could not create audioPlayer, error: %@-%@", error, error.userInfo);
        return;
    }
    
    self.backgoundPlayer.numberOfLoops = -1;
    [self.backgoundPlayer prepareToPlay];
    [self.backgoundPlayer play];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
    
    /** 设置前进和后退播放 */
    [self mpSkipHandler];
    
    /** 设置锁屏播放信息 */
    [self mpNowPlayInfoHandler];
    
    UIButton *presentBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 80, [UIScreen mainScreen].bounds.size.width-60, 30)];
    [presentBtn setTitle:@"自定义present" forState:UIControlStateNormal];
    presentBtn.backgroundColor = [UIColor orangeColor];
    [presentBtn addTarget:self action:@selector(presentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    presentBtn.layer.cornerRadius = 10;
    [self.view addSubview:presentBtn];
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] resignFirstResponder];
    [self resignFirstResponder];
}

#pragma mark - UIResponder event
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (!event) {
        return;
    }
    
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self.backgoundPlayer play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self.backgoundPlayer pause];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - MPSkipIntervalCommand Event
- (void)skipBackwardEvent:(MPSkipIntervalCommandEvent *)skipEvent {
    NSLog(@"Skip backward by %f", skipEvent.interval);
//    NSMutableDictionary *nowPlayInfo = [self.mpNowPlay.nowPlayingInfo mutableCopy];
//    nowPlayInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.backgoundPlayer.currentTime - skipEvent.interval);
//    self.mpNowPlay.nowPlayingInfo = nowPlayInfo;
    self.backgoundPlayer.currentTime -= skipEvent.interval;
}

- (void)skipForwardEvent:(MPSkipIntervalCommandEvent *)skipEvent {
    NSLog(@"Skip forward by %f", skipEvent.interval);
//    NSMutableDictionary *nowPlayInfo = [self.mpNowPlay.nowPlayingInfo mutableCopy];
//    nowPlayInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.backgoundPlayer.currentTime + skipEvent.interval);
//    self.mpNowPlay.nowPlayingInfo = nowPlayInfo;
    self.backgoundPlayer.currentTime += skipEvent.interval;
}

#pragma mark - MPRemoteCommand Event
- (void)playEvent:(MPRemoteCommandEvent *)playEvent {
    
}

- (void)pauseEvent:(MPRemoteCommandEvent *)pauseEvent {
    
}

#pragma mark Pravite method
- (void)mpSkipHandler {
    MPRemoteCommandCenter *rcc = [MPRemoteCommandCenter sharedCommandCenter];
    
    MPSkipIntervalCommand *skipBackwardIntervalCommand = [rcc skipBackwardCommand];
    skipBackwardIntervalCommand.enabled = YES;
    [skipBackwardIntervalCommand addTarget:self action:@selector(skipBackwardEvent:)];
    skipBackwardIntervalCommand.preferredIntervals = @[@(5)];
    
    MPSkipIntervalCommand *skipForwardIntervalCommand = [rcc skipForwardCommand];
    skipForwardIntervalCommand.enabled = YES;
    [skipForwardIntervalCommand addTarget:self action:@selector(skipForwardEvent:)];
    skipForwardIntervalCommand.preferredIntervals = @[@(5)];
    
    MPRemoteCommand *playCommand = [rcc playCommand];
    playCommand.enabled = YES;
    [playCommand addTarget:self action:@selector(playEvent:)];
    
    MPRemoteCommand *pauseCommand = [rcc pauseCommand];
    pauseCommand.enabled = YES;
    [pauseCommand addTarget:self action:@selector(pauseEvent:)];
}

- (void)mpNowPlayInfoHandler {
    _mpNowPlay = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *nowPlayInfo = [@{MPMediaItemPropertyTitle: @"惊鸿一面",
                                  MPMediaItemPropertyArtwork: [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"IMG.jpg"]],
                                  MPNowPlayingInfoPropertyElapsedPlaybackTime: @(0.0),/** 目前的播放时间 */
                                  MPNowPlayingInfoPropertyPlaybackRate: @(1.0),
                                  MPMediaItemPropertyPlaybackDuration: @(300.0)} mutableCopy]; /** 总时长 */
    _mpNowPlay.nowPlayingInfo = nowPlayInfo;
    
    /** 使用定时器来更新播放的进度 */
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeMPPlaybackTime:) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)changeMPPlaybackTime:(NSTimer *)timer {
    if (self.backgoundPlayer.currentTime > [self.mpNowPlay.nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] doubleValue]) {
        [timer invalidate];
        return;
    }
    
    NSMutableDictionary *nowPlayInfo = [self.mpNowPlay.nowPlayingInfo mutableCopy];
    [nowPlayInfo setObject:@(self.backgoundPlayer.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    self.mpNowPlay.nowPlayingInfo = nowPlayInfo;
}

#pragma mark - Present View Handler
- (void)presentBtnClick:(UIButton *)sender {
    PresentViewController *presentVC = [[PresentViewController alloc] init];
    presentVC.modalPresentationStyle = UIModalPresentationCustom;
    presentVC.transitioningDelegate = self;
    
    [self presentViewController:presentVC animated:YES completion:nil];
    
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.colorAnimator.presenting = true;
    return self.colorAnimator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.colorAnimator.presenting = false;
    return self.colorAnimator;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    CustomPresent *customPresent = [[CustomPresent alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    return customPresent;
}

#pragma mark - Getter method
- (ColorAnimator *)colorAnimator {
    if (!_colorAnimator) {
        _colorAnimator = [[ColorAnimator alloc] init];
    }
    return _colorAnimator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
