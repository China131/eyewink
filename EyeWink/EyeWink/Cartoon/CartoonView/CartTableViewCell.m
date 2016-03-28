//
//  CartTableViewCell.m
//  EyeWink
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "CartTableViewCell.h"
#import "DataBaseSingleton.h"

#import "Cartoon.h"

#import "UIImageView+WebCache.h"
#import "UMSocial.h"

@interface CartTableViewCell ()

/**
 *  漫画Cell的相关属性
 */
@property (retain, nonatomic) UIImageView *topic_cover_image_urlImageView;
@property (retain, nonatomic) UIImageView *user_avatar_urlImageView;
@property (retain, nonatomic) UILabel *user_nicknameLabel;
@property (retain, nonatomic) UILabel *topic_titleLabel;
@property (retain, nonatomic) UIView *dujiaView;
@property (retain, nonatomic) UILabel *dujiaLabel;
@property (retain, nonatomic) UIView *shareView;
@property (retain, nonatomic) UILabel *shareLabel;
@property (retain, nonatomic) UIImageView *shareImageView;
@property (retain, nonatomic) UIView *likeView;
@property (retain, nonatomic) UILabel *likeLabel;
@property (retain, nonatomic) UIImageView *likeImageView;
@property (retain, nonatomic) UILabel *zhuantiLabel;
@property (assign, nonatomic) BOOL isDujia;


@end


@implementation CartTableViewCell

- (void)dealloc {
    [_topic_cover_image_urlImageView release];
    [_user_avatar_urlImageView release];
    [_user_nicknameLabel release];
    [_topic_titleLabel release];
    [_dujiaView release];
    [_dujiaLabel release];
    [_shareView release];
    [_shareLabel release];
    [_likeView release];
    [_likeLabel release];
    [_likeImageView release];
    [_zhuantiLabel release];
    [super dealloc];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self creat];
    }
    return self;
}

/**
 *  铺漫画Cell的页面
 */
-(void)creat{
    self.topic_cover_image_urlImageView =[[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 5, WIDTH * 35, WIDTH * 365, WIDTH * 175)];
    [self.contentView addSubview:self.topic_cover_image_urlImageView];
    [self.topic_cover_image_urlImageView release];
    
    self.user_avatar_urlImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 5, 0, WIDTH * 35, WIDTH * 35)];
    [self.contentView addSubview:self.user_avatar_urlImageView];
    [self.user_avatar_urlImageView release];
    
    self.user_nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 48, WIDTH * 8, WIDTH * 132, WIDTH * 21)];
    [self.contentView addSubview:self.user_nicknameLabel];
    [self.user_nicknameLabel release];
    
    self.topic_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 190, WIDTH * 8, WIDTH * 140, WIDTH * 21)];
    [self.contentView addSubview:self.topic_titleLabel];
    [self.topic_titleLabel release];
    
    self.zhuantiLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 335, WIDTH * 8, WIDTH * 30, WIDTH * 21)];
    [self.contentView addSubview:self.zhuantiLabel];
    self.zhuantiLabel.text = @"专题";
    self.zhuantiLabel.font = [UIFont systemFontOfSize:WIDTH * 15];
    self.zhuantiLabel.textColor = [UIColor orangeColor];
    [self.zhuantiLabel release];
    
    self.dujiaView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH * 250, WIDTH * 35, WIDTH * 100, WIDTH * 30)];
    [self.contentView addSubview:self.dujiaView];
    self.dujiaView.alpha = 0.4;
    self.dujiaView.backgroundColor = [UIColor lightGrayColor];
    [self.dujiaView release];
    
    self.dujiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 250, WIDTH * 35, WIDTH * 100, WIDTH * 30)];
    [self.contentView addSubview:self.dujiaLabel];
    self.dujiaLabel.text = @"独家";
    self.dujiaLabel.textAlignment = NSTextAlignmentCenter;
    [self.dujiaLabel release];
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, WIDTH * 215, WIDTH * 188, WIDTH * 35)];
    [self.contentView addSubview:self.shareView];
    [self.shareView release];
    
    self.shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 50, WIDTH * 3, WIDTH * 29, WIDTH * 29)];
    [self.shareView addSubview:self.shareImageView];
    self.shareImageView.image = [UIImage imageNamed:@"share"];
    [self.shareImageView release];
    
    self.shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 87, WIDTH * 8, WIDTH * 60, WIDTH * 20)];
    [self.shareView addSubview:self.shareLabel];
    [self.shareLabel release];
    
    self.likeView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH * 188, WIDTH * 215, WIDTH * 188, WIDTH * 35)];
    [self.contentView addSubview:self.likeView];
    [self.likeView release];
    
    self.likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 50, WIDTH * 3, WIDTH * 29, WIDTH * 29)];
    [self.likeView addSubview:self.likeImageView];
    self.likeImageView.image = [UIImage imageNamed:@"like_half"];
    [self.likeImageView release];
    
    self.likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 87, WIDTH * 8, WIDTH * 60, WIDTH * 20)];
    [self.likeView addSubview:self.likeLabel];
    [self.likeLabel release];
    

}

/**
 *  重写模型cartoon的set方法,并且给Cell里面的控件重新赋值
 *
 */
-(void)setCartoon:(Cartoon *)cartoon{
    if(_cartoon != cartoon){
        [_cartoon release];
        _cartoon = [cartoon retain];
    }
    
    _cartoon.topic_cover_image_url = [[_cartoon.topic_cover_image_url componentsSeparatedByString:@"-"] objectAtIndex:0];
    [self.topic_cover_image_urlImageView sd_setImageWithURL:[NSURL URLWithString:_cartoon.topic_cover_image_url] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.topic_cover_image_urlImageView.layer.masksToBounds = YES;
    self.topic_cover_image_urlImageView.layer.cornerRadius = WIDTH * 24;
    
    _cartoon.user_avatar_url = [[_cartoon.user_avatar_url componentsSeparatedByString:@"-"] objectAtIndex:0];
    
    [self.user_avatar_urlImageView sd_setImageWithURL:[NSURL URLWithString:_cartoon.user_avatar_url] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.user_avatar_urlImageView.layer.masksToBounds = YES;
    self.user_avatar_urlImageView.layer.cornerRadius = WIDTH * 17;
    
    self.user_nicknameLabel.text = _cartoon.user_nickname;
    self.user_nicknameLabel.font = [UIFont systemFontOfSize:WIDTH * 15];
    
    self.topic_titleLabel.text = _cartoon.topic_title;
    self.topic_titleLabel.font = [UIFont systemFontOfSize:WIDTH * 15];
    
    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareTap)];
    [self.shareView addGestureRecognizer:shareTap];
    self.shareLabel.text = [NSString stringWithFormat:@"%ld",_cartoon.shared_count];
    
    UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap)];
    [self.likeView addGestureRecognizer:likeTap];
    self.likeLabel.text = [NSString stringWithFormat:@"%ld",_cartoon.likes_count];
    if(_cartoon.isLike){
        self.likeImageView.image = [UIImage imageNamed:@"like_full"];
    }
    else{
        self.likeImageView.image = [UIImage imageNamed:@"like_half"];
    }
    
}

/**
 *  分享手势方法,里面调用一个协议方并且将title传过去,显示在分享框里面
 */
-(void)shareTap{
    [self.delegate share:self.cartoon.topic_title];
}

/**
 *  收藏手势方法
        1.如果未收藏,变成收藏的图片,likeLabel + 1
        2.如果已收藏,变成未收藏图片,likeLabel - 1
 */
-(void)likeTap{
    if(!_cartoon.isLike){
        _cartoon.likes_count += 1;
        self.likeImageView.image = [UIImage imageNamed:@"like_full"];
        NSLog(@"收藏成功");
        [self.delegate showLikeAction:@"😊收藏成功"];
        _cartoon.isLike = YES;
        [[DataBaseSingleton shareDataBaseSingleton] creatisLikeComicTable];
        [[DataBaseSingleton shareDataBaseSingleton] insertisLikeComicTable:_cartoon];
    }
    else{
        _cartoon.likes_count -= 1;
        self.likeImageView.image = [UIImage imageNamed:@"like_half"];
        NSLog(@"取消收藏");
        [self.delegate showLikeAction:@"😭取消收藏"];
        _cartoon.isLike = NO;
        [[DataBaseSingleton shareDataBaseSingleton] deleteisLikeComicWithTitle:_cartoon.title];
    }
    self.likeLabel.text = [NSString stringWithFormat:@"%ld",_cartoon.likes_count];
    [[DataBaseSingleton shareDataBaseSingleton] updateTable:_cartoon];
}



@end
