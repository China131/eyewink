//
//  Radio_topCollectionViewCell.m
//  EyeWink
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Radio_topCollectionViewCell.h"

#import "Radio.h"

#import "UIImageView+WebCache.h"

#define WIDANDHEI 110 * WIDTH

@interface Radio_topCollectionViewCell ()

@property (nonatomic,retain) UIView *bgView;
@property (nonatomic,retain) UIImageView *bgImageView;

@end

@implementation Radio_topCollectionViewCell

- (void)dealloc
{
    [_radio release];
    [_bgView release];
    [_bgImageView release];
    
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if(self){
        [self creat];
    }
    return self;
}

-(void)setRadio:(Radio *)radio{
    if(_radio != radio){
        [_radio release];
        _radio = [radio retain];
    }
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:_radio.coverimg] placeholderImage:[UIImage imageNamed:@"eyeWink"]];
    
}

-(void)creat{
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDANDHEI, WIDANDHEI)];
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDANDHEI, WIDANDHEI)];
    self.bgImageView.userInteractionEnabled = YES;
    [self.bgView addSubview:self.bgImageView];
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.layer.cornerRadius = WIDTH * 15;
    
    [self.bgImageView release];
    
    [self.contentView addSubview:self.bgView];
    [self.bgView release];

}

@end
