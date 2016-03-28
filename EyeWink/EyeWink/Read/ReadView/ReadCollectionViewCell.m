//
//  ReadCollectionViewCell.m
//  EyeWink
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "ReadCollectionViewCell.h"

#import "Read.h"

#import "UIImageView+WebCache.h"

@interface ReadCollectionViewCell ()

@property (nonatomic,retain) UIImageView *coverImageView;
@property (nonatomic,retain) UIView *labelView;
@property (nonatomic,retain) UILabel *namelabel;

@end

@implementation ReadCollectionViewCell

- (void)dealloc
{
    [_read release];
    [_coverImageView release];
    [_labelView release];
    [_namelabel release];
    
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if(self){
        [self creat];
    }
    return self;
}

-(void)setRead:(Read *)read{
    if(_read != read){
        [_read release];
        _read = [read retain];
    }

    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:_read.coverimg] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    NSString *desc = [NSString stringWithFormat:@"%@ %@",_read.name,_read.enname];
    self.namelabel.text = desc;
    
}

-(void)creat{
    
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, WIDTH * 112, WIDTH * 108)];
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.layer.cornerRadius = WIDTH * 10;
    
    self.labelView = [[UIView alloc] initWithFrame:CGRectMake(0, WIDTH * 90, WIDTH * 112, WIDTH * 16)];
    [self.coverImageView addSubview:self.labelView];
    self.labelView.alpha = 0.2;
    self.labelView.backgroundColor = [UIColor whiteColor];
    self.labelView.layer.masksToBounds = YES;
    self.labelView.layer.cornerRadius = WIDTH * 10;
    
    self.namelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, WIDTH * 90, WIDTH * 112, WIDTH * 16)];
    [self.coverImageView addSubview:self.namelabel];
    self.namelabel.textColor = [UIColor whiteColor];
    self.namelabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView release];

}

@end
