//
//  RadioPlayerViewController.m
//  EyeWink
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "RadioPlayerViewController.h"

#import "Radio.h"

#import "STKAudioPlayer.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Blur.h"

@interface RadioPlayerViewController ()

@property (retain, nonatomic) UIImageView *coverImageView;
@property (retain, nonatomic) UILabel *descLabel;
@property (retain, nonatomic) UISlider *timeSlider;
@property (retain, nonatomic) UILabel *timeLabel;
@property (retain, nonatomic) UIImageView *downloadImageView;
@property (retain, nonatomic) UIButton *playButton;
@property (retain, nonatomic) UIButton *nextButton;
@property (retain, nonatomic) UIButton *beforeButton;
@property (retain, nonatomic) UIImageView *bgImageView;

@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,retain) STKAudioPlayer *player;
@property (nonatomic,assign) BOOL isRun;

@end

@implementation RadioPlayerViewController

-(void)viewWillAppear:(BOOL)animated{
    /**
     *  当视图即将出现的时候,判断是否是同一首歌的路径
        如果是,不做任何变化,继续播放
        如果不是,切歌
     */
    if(![self.musicUrl isEqualToString:self.radio.musicUrl]){
        [self.player stop];
        [self.timer invalidate];
        [self creat];
        self.timeLabel.text = @"00:00/00:00";
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    //    [self.player stop];
    //    [self.timer invalidate];
    
    self.player = [[STKAudioPlayer alloc] init];
    self.player.volume = 0.5;
    
    [self creatView];
    
    [self creat];

}

/**
 *  铺出播放界面
 */
-(void)creatView{
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 667)];
    [self.view addSubview:self.bgImageView];
    [self.bgImageView release];
    
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 37, WIDTH * 65, WIDTH * 300, WIDTH * 300)];
    [self.view addSubview:self.coverImageView];
    self.coverImageView.image = [UIImage imageNamed:@"eyeWink"];
    [self.coverImageView release];
    
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 50, WIDTH * 380, WIDTH * 275, WIDTH * 40)];
    [self.view addSubview:self.descLabel];
    [self.descLabel release];
    
    self.timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(WIDTH * 37, WIDTH * 457, WIDTH * 290, WIDTH * 31)];
    [self.view addSubview:self.timeSlider];
    [self.timeSlider release];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 117, WIDTH * 495, WIDTH * 141, WIDTH * 25)];
    [self.view addSubview:self.timeLabel];
    self.timeLabel.text = @"00:00";
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.timeLabel release];
    
    self.beforeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beforeButton.frame = CGRectMake(WIDTH * 50, WIDTH * 532, WIDTH * 30, WIDTH * 30);
    [self.view addSubview:self.beforeButton];
    [self.beforeButton addTarget:self action:@selector(beforeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.beforeButton setImage:[UIImage imageNamed:@"before"] forState:UIControlStateNormal];
    self.beforeButton.layer.masksToBounds = YES;
    self.beforeButton.layer.cornerRadius = WIDTH * 15;
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake(WIDTH * 294, WIDTH * 531, WIDTH * 30, WIDTH * 30);
    [self.view addSubview:self.nextButton];
    [self.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.layer.cornerRadius = WIDTH * 15;
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = CGRectMake(WIDTH * 171, WIDTH * 531, WIDTH * 32, WIDTH * 32);
    [self.view addSubview:self.playButton];
    [self.playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    self.playButton.layer.masksToBounds = YES;
    self.playButton.layer.cornerRadius = WIDTH * 16;
    

}

-(void)creat{
    
    self.isRun = YES;
    
    
    Radio *radio = [self.allMusicArray objectAtIndex:self.indexPath];
    /**
     *  如果进  if  判断, 说明是从电台详情跳转过来的
     */
    if(radio.coverimg){
        self.imgUrl = radio.coverimg;
    }
    /**
     *  如果进  else  判断,说明是从搜索跳转过来的,那么隐藏上一首和下一首
     */
    else{
        self.beforeButton.enabled = NO;
        self.nextButton.enabled = NO;
    }
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]];
    self.bgImageView.image = [self.bgImageView.image boxblurImageWithBlur:0.5];
    self.bgImageView.alpha = 0.6;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"eyeWink"]];
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.layer.cornerRadius = WIDTH * 150;
    self.coverImageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.coverImageView.layer.borderWidth = WIDTH * 5;
    
    [self move];
    
    self.coverImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.coverImageView addGestureRecognizer:tap];
    [tap release];
    
    self.descLabel.text = radio.title;
    
}

-(void)move{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.duration = 20;
    //  开始动画的起始位置
    basicAnimation.fromValue = [NSNumber numberWithInt:0];
    
    //  M_PI是180°
    basicAnimation.toValue = [NSNumber numberWithInt:M_PI * 2];
    //  动画重复次数,NSIntegerMax是无限次
    [basicAnimation setRepeatCount:NSIntegerMax];
    //  播放完毕之后是否逆向播放回到原来位置
    [basicAnimation setAutoreverses:NO];
    //  是否叠加(追加)动画效果
    [basicAnimation setCumulative:YES];
    [self.coverImageView.layer addAnimation:basicAnimation forKey:@"basicAnimation"];
}

-(void)tapAction{
    if(self.isRun){
        //  获得点击图片时的动画时间,为了下次开始动画用
        CFTimeInterval stopTime = [self.coverImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        //  停止动画,速度设置为0
        self.coverImageView.layer.speed = 0;
        //  设置时间偏移量
        self.coverImageView.layer.timeOffset = stopTime;
    }
    else{
        //  开始旋转
        //  得到view当前动画时间偏移量
        CFTimeInterval stopTime = [self.coverImageView.layer timeOffset];
        //  初始化开始时间
        self.coverImageView.layer.beginTime = 0;
        //  初始化时间偏移量
        self.coverImageView.layer.timeOffset = 0;
        //  设置动画速度
        self.coverImageView.layer.speed = 1.0;
        //  计算时间差
        CFTimeInterval tempTime = [self.coverImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - stopTime;
        //  重新设置动画开始时间
        self.coverImageView.layer.beginTime = tempTime;
    }
    self.isRun = !self.isRun;
    
    //    [self playAction:self.playButton];
    
}

-(void)playMusic{
    if(self.allMusicArray.count != 0){
        Radio *radio = [self.allMusicArray objectAtIndex:self.indexPath];
        NSLog(@"****%@",radio.musicUrl);
        self.musicUrl = radio.musicUrl;
    }
    
    [self.player play:self.musicUrl];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(track) userInfo:nil repeats:YES];
}

/**
 *  定时器方法,每隔1S调用一次,判断此电台是否处于播放状态
    更新播放进度
        1. timeSlider
        2. timeLabel
 */
-(void)track{
    
    if(self.player.state == STKAudioPlayerStatePaused){
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else if (self.player.state == STKAudioPlayerStatePlaying){
        [self.playButton setImage:[UIImage imageNamed:@"suspend"] forState:UIControlStateNormal];
    }

    self.timeSlider.maximumValue = self.player.duration;
    self.timeSlider.value = self.player.progress;
    
    //  当前时长进度
    NSInteger proMin = (NSInteger)self.player.progress / 60;
    NSInteger proSec = (NSInteger)self.player.progress % 60;
    
    //  duration总时长
    NSInteger durMin = (NSInteger)self.player.duration / 60;
    NSInteger durSec = (NSInteger)self.player.duration % 60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", proMin, proSec, durMin, durSec];
    
    /**
     *  当某一首歌播放结束时,自动播放下一首
     *
     *  @param .player.progress 播放进度
     *
     */
    if((self.player.duration == self.player.progress) && (self.player.duration != 0)){
        [self nextAction];
    }
    
}

- (void)progress:(UISlider *)sender {
    if(self.player){
        [self.player seekToTime:sender.value];
    }
}

/**
 *  点击播放时触发,并判断此时的播放状态
        1.如果此时处于暂停状态,则继续播放
        2.如果此时处于播放状态,则暂停
        3.如果此时处于停止状态,则调用playMusic
 *
 */
- (void)playAction:(UIButton *)sender {
    if(self.player.state == STKAudioPlayerStatePaused){
        [self.player resume];
    }
    else if (self.player.state == STKAudioPlayerStatePlaying){
        [self.player pause];
    }
    else{
        [self playMusic];
    }
    
}

+(instancetype)shareRadio_PlayerViewController{
    static RadioPlayerViewController *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[RadioPlayerViewController alloc] init];
    });
    return player;
}

/**
 *  点击以下首,如果是最后一首,则播放第一首
 */
- (void)nextAction{
    self.indexPath++;
    if(self.indexPath == self.allMusicArray.count){
        self.indexPath = 0;
    }
    [self creat];
    [self playMusic];
}

/**
 *  点击上一首,如果是第一首,则播放最后一首
 *
 */
- (void)beforeAction:(UIButton *)sender {
    self.indexPath--;
    if(self.indexPath == -1){
        self.indexPath = self.allMusicArray.count - 1;
    }
    [self creat];
    [self playMusic];
}



@end
