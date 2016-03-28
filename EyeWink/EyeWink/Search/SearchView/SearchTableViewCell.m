//
//  SearchTableViewCell.m
//  EyeWink
//
//  Created by dllo on 15/10/8.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "SearchTableViewCell.h"

#import "Search.h"

@interface SearchTableViewCell ()

@property (nonatomic,retain) UIImageView *leftImageView;
@property (nonatomic,retain) UILabel *titleLabel;

@end

@implementation SearchTableViewCell

- (void)dealloc
{
    [_leftImageView release];
    [_titleLabel release];
    [super dealloc];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 10, WIDTH * 20, WIDTH * 40, WIDTH * 40)];
        [self.contentView addSubview:self.leftImageView];
        [self.leftImageView release];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 60, WIDTH * 30, WIDTH * 300, WIDTH * 20)];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel release];
    }
    return self;
}

-(void)setSearch:(Search *)search{
    if(_search != search){
        [_search release];
        _search = [search retain];
    }
    
    self.titleLabel.text = _search.title;
    self.titleLabel.font = [UIFont systemFontOfSize:WIDTH * 20];
    if(self.searchArray.count != 0){
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[[self.searchArray objectAtIndex:self.indexPath.row] title]];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[[[self.searchArray objectAtIndex:self.indexPath.row] title] rangeOfString:self.text]];
        self.titleLabel.attributedText = att;
    }
    
    if(![_search.playInfo objectForKey:@"title"]){
        self.leftImageView.image = [UIImage imageNamed:@"read"];
    }
    else{
        self.leftImageView.image = [UIImage imageNamed:@"play"];
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
