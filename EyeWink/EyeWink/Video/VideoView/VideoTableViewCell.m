//
//  VideoTableViewCell.m
//  EyeWink
//
//  Created by dllo on 15/10/7.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "AppTools.h"

#import "Video.h"

#import "UIImageView+WebCache.h"

@interface VideoTableViewCell ()

@property (nonatomic,retain) UIImageView *userIconImageView;
@property (nonatomic,retain) UILabel *user_nameLabel;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIImageView *playImageView;
//@property (nonatomic,retain) MPMoviePlayerViewController *moviePlayerVC;

@end

@implementation VideoTableViewCell

- (void)dealloc
{
    [_video release];
    [_userIconImageView release];
    [_user_nameLabel release];
    [_titleLabel release];
    [_playImageView release];
    
    [super dealloc];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.userIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 5, WIDTH * 5, WIDTH * 25, WIDTH * 25)];
        [self.contentView addSubview:self.userIconImageView];
        self.userIconImageView.layer.masksToBounds = YES;
        self.userIconImageView.layer.cornerRadius = WIDTH * 12;
        [self.userIconImageView release];
        
        self.user_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 35, WIDTH * 8, WIDTH * 100, WIDTH * 19)];
        [self.contentView addSubview:self.user_nameLabel];
        self.user_nameLabel.font = [UIFont systemFontOfSize:WIDTH * 15];
        [self.user_nameLabel release];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 5, WIDTH * 35, WIDTH * 350, WIDTH * 20)];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.numberOfLines = 0;
        [self.titleLabel release];
        
        self.playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 5, WIDTH * 55, WIDTH * 365, WIDTH * 200)];
        [self.contentView addSubview:self.playImageView];
        self.playImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.playImageView addGestureRecognizer:tap];
        self.playImageView.layer.masksToBounds = YES;
        self.playImageView.layer.cornerRadius = WIDTH * 15;
        [self.playImageView release];
    }
    return self;
}

-(void)tapAction{
    [self.delegate play:_video.mp4_url];
}

/**
 *  重写video的set方法,根据传进来的模型的参数title的多少,来定义titleLabel的高度,也就是自适应高度
 *
 */
-(void)setVideo:(Video *)video{

    if(_video != video){
        [_video release];
        _video = [video retain];
    }
    
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:_video.user_avatar_url] placeholderImage:[UIImage imageNamed:@"eyeWink"]];
    
    self.user_nameLabel.text = _video.user_name;
    
    self.titleLabel.text = _video.title;
    CGFloat titleHeight = [AppTools heightWithText:_video.title width:WIDTH * 350 font:[UIFont systemFontOfSize:WIDTH * 17]];
    CGRect titleTemp = self.titleLabel.frame;
    titleTemp.size.height = titleHeight;
    self.titleLabel.frame = titleTemp;
    
    [self.playImageView sd_setImageWithURL:[NSURL URLWithString:_video.url] placeholderImage:[UIImage imageNamed:@"eyeWink"]];
    self.playImageView.frame = CGRectMake(WIDTH * 5, WIDTH * 35 + titleHeight, WIDTH * 365, WIDTH * 200);

    
    [self.delegate getHeight:(WIDTH * 235 + WIDTH * titleHeight)];
   
}


@end
