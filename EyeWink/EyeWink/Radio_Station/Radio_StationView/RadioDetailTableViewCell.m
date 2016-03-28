//
//  RadioDetailTableViewCell.m
//  EyeWink
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "RadioDetailTableViewCell.h"

#import "Radio.h"

#import "UIImageView+WebCache.h"

@interface RadioDetailTableViewCell ()

@property (retain, nonatomic) UIImageView *coverImageView;

@property (retain, nonatomic) UIImageView *isNewImageView;

@property (retain, nonatomic) UILabel *titleLabel;

@property (retain, nonatomic) UILabel *musicVisitLabel;

@property (retain, nonatomic) UIImageView *playImageView;



@end

@implementation RadioDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self creat];
    }
    return self;
}

-(void)creat{
    
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 10,WIDTH * 10, WIDTH * 60, WIDTH * 60)];
    [self.contentView addSubview:self.coverImageView];
    self.coverImageView.image = [UIImage imageNamed:@"eyeWink"];
    [self.coverImageView release];
    
    self.isNewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 10, WIDTH * 10, WIDTH * 25, WIDTH * 25)];
    [self.contentView addSubview:self.isNewImageView];
    self.isNewImageView.image = [UIImage imageNamed:@"iconfont-tubiao103"];
    [self.isNewImageView release];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 78, WIDTH * 12, WIDTH * 230, WIDTH * 25)];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel release];
    
    self.musicVisitLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 78, WIDTH * 39, WIDTH * 90, WIDTH * 21)];
    [self.contentView addSubview:self.musicVisitLabel];
    [self.musicVisitLabel release];
    
    self.playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 322,WIDTH * 25, WIDTH * 30, WIDTH * 30)];
    [self.contentView addSubview:self.playImageView];
    self.playImageView.image = [UIImage imageNamed:@"play"];
    [self.playImageView release];
    

}

-(void)setRadio:(Radio *)radio{
    if(_radio != radio){
        [_radio release];
        _radio = [radio retain];
    }
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:_radio.coverimg] placeholderImage:[UIImage imageNamed:@"eyeWink"]];
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.layer.cornerRadius = WIDTH * 8;
    self.titleLabel.text = _radio.title;
    self.musicVisitLabel.text =  [NSString stringWithFormat:@"收听:%@",_radio.musicVisit];
    self.musicVisitLabel.font = [UIFont systemFontOfSize:WIDTH * 12];
    self.musicVisitLabel.textColor = [UIColor grayColor];
    if(!_radio.isnew){
        self.isNewImageView.alpha = 0;
    }
    
}

- (void)dealloc {
    [_radio release];
    [_coverImageView release];
    [_isNewImageView release];
    [_titleLabel release];
    [_musicVisitLabel release];
    [_playImageView release];
    [super dealloc];
}

@end
