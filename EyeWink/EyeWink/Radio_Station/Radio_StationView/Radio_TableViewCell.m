//
//  Radio_TableViewCell.m
//  EyeWink
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Radio_TableViewCell.h"

#import "Radio.h"

#import "UIImageView+WebCache.h"

@interface Radio_TableViewCell ()

@property (retain, nonatomic) UIImageView *radioImageView;
@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *authorLabel;
@property (retain, nonatomic) UILabel *descLabel;
@property (retain, nonatomic) UILabel *countLabel;
@property (retain, nonatomic) UIImageView *isNewImageView;

@end

@implementation Radio_TableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self creat];
    }
    return self;
}

/**
 *  设置Radio_TableViewCell的内容,各种铺页面
 */
-(void)creat{
    self.radioImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 5, WIDTH * 5, WIDTH * 80, WIDTH * 80)];
    [self.contentView addSubview:self.radioImageView];
    [self.radioImageView release];
    self.radioImageView.image = [UIImage imageNamed:@"eyeWink"];
    
    self.isNewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 5, WIDTH * 5, WIDTH * 25, WIDTH * 25)];
    [self.contentView addSubview:self.isNewImageView];
    [self.isNewImageView release];
    self.isNewImageView.image = [UIImage imageNamed:@"iconfont-tubiao103"];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 93, WIDTH * 13, WIDTH * 158, WIDTH * 20)];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel release];

    self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 93, WIDTH * 35, WIDTH * 100, WIDTH * 15)];
    [self.contentView addSubview:self.authorLabel];
    [self.authorLabel release];
    
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 93, WIDTH * 50, WIDTH * 222, WIDTH * 30)];
    [self.contentView addSubview:self.descLabel];
    [self.descLabel release];
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 288, WIDTH * 13, WIDTH * 79, WIDTH * 21)];
    [self.contentView addSubview:self.countLabel];
    [self.countLabel release];
    
    
}


/**
 *  重写radio的set方法,给cell的控件重新赋值
 
 */
-(void)setRadio:(Radio *)radio{
    if(_radio != radio){
        [_radio release];
        _radio = [radio retain];
    }
    
    [self.radioImageView sd_setImageWithURL:[NSURL URLWithString:_radio.coverimg]];
    self.radioImageView.layer.masksToBounds = YES;
    self.radioImageView.layer.cornerRadius = WIDTH * 10;
    self.titleLabel.text = _radio.title;
    
    self.descLabel.text = _radio.desc;
    self.descLabel.font = [UIFont systemFontOfSize:WIDTH * 12];
    self.descLabel.textColor = [UIColor grayColor];
    self.descLabel.numberOfLines = 0;
    
    self.authorLabel.text = [NSString stringWithFormat:@"by:%@",_radio.uname];
    self.authorLabel.font = [UIFont systemFontOfSize:WIDTH * 10];
    self.authorLabel.textColor = [UIColor grayColor];
    
    self.countLabel.text = [NSString stringWithFormat:@"收听:%ld",_radio.count];
    self.countLabel.font = [UIFont systemFontOfSize:WIDTH * 10];
    self.countLabel.textColor = [UIColor grayColor];
    if(!_radio.isnew){
        self.isNewImageView.alpha = 0;
    }
}

- (void)dealloc {
    [_radio release];
    [_radioImageView release];
    [_titleLabel release];
    [_authorLabel release];
    [_descLabel release];
    [_countLabel release];
    [_isNewImageView release];
    [super dealloc];
}


@end
