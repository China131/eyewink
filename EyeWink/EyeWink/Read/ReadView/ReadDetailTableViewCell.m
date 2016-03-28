//
//  ReadDetailTableViewCell.m
//  EyeWink
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "ReadDetailTableViewCell.h"

#import "Read.h"

#import "UIImageView+WebCache.h"

@interface ReadDetailTableViewCell ()

@property (retain, nonatomic) UIImageView *coverImageView;

@property (retain, nonatomic) UILabel *titleLabel;

@property (retain, nonatomic) UILabel *contentLabel;


@end

@implementation ReadDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self creat];
    }
    return self;
}

-(void)creat{
    
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 40, WIDTH * 50, WIDTH * 150,WIDTH * 80)];
    [self.contentView addSubview:self.coverImageView];
    self.coverImageView.image = [UIImage imageNamed:@"eyeWink"];
    [self.coverImageView release];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 40, WIDTH * 10, WIDTH * 290, WIDTH * 30)];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:WIDTH * 20];
    [self.titleLabel release];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 200, WIDTH * 60, WIDTH * 160, WIDTH * 60)];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.font = [UIFont systemFontOfSize:WIDTH * 15];
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel release];
    
}


-(void)setRead:(Read *)read{
    if(_read != read){
        [_read release];
        _read = [read retain];
    }
    self.contentLabel.text = _read.detail_content;
    self.titleLabel.text = _read.detail_title;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:_read.detail_coverimg] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.layer.cornerRadius = WIDTH * 15;
    
}

- (void)dealloc {
    [_coverImageView release];
    [_titleLabel release];
    [_contentLabel release];
    [super dealloc];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
