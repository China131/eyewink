//
//  Shop_TableViewCell.m
//  EyeWink
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Shop_TableViewCell.h"

#import "Shop.h"

#import "UIImageView+WebCache.h"

@interface Shop_TableViewCell ()
@property (retain, nonatomic) UIImageView *coverImageView;

@property (retain, nonatomic) UILabel *titleLabel;

@property (retain, nonatomic) UIButton *buyButton;



@end

@implementation Shop_TableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self creat];
    }
    return self;
}

-(void)creat{

    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 30, WIDTH * 15, WIDTH * 315, WIDTH * 150)];
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView release];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 30, WIDTH * 184, WIDTH * 224, WIDTH * 26)];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel release];
    
    self.buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyButton.frame = CGRectMake(WIDTH * 289, WIDTH * 179, WIDTH * 49, WIDTH * 32);
    [self.contentView addSubview:self.buyButton];
    [self.buyButton addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.buyButton setImage:[UIImage imageNamed:@"buy"] forState:UIControlStateNormal];
    
}

-(void)setShop:(Shop *)shop{
    if(_shop != shop){
        [_shop release];
        _shop = [shop retain];
    }
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:_shop.coverimg] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.layer.cornerRadius = WIDTH * 20;
    
    self.titleLabel.text = _shop.title;
}

/**
 *  点击购买按钮时,调用自定义协议方法,该方法在controller里面执行
 *
 */
- (void)buyAction:(UIButton *)sender {
    [self.delegate goShopingWithUrl:self.shop.buyurl];
}

- (void)dealloc {
    [_coverImageView release];
    [_titleLabel release];
    [_buyButton release];
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
