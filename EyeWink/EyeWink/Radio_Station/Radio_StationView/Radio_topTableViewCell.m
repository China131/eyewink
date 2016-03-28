//
//  Radio_topTableViewCell.m
//  EyeWink
//
//  Created by dllo on 15/9/29.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Radio_topTableViewCell.h"
#import "Radio_topCollectionViewCell.h"

#import "Radio.h"

#import "UIImageView+WebCache.h"

#define WIDANDHEI 110 * WIDTH

@interface Radio_topTableViewCell() 

//@property (nonatomic,retain) UICollectionViewCell *radioCollectionCell;

@property (nonatomic,retain) UICollectionView *radioCollectionView;


@end

@implementation Radio_topTableViewCell

- (void)dealloc
{
    [_radio_topArray release];
    [_radioCollectionView release];
    [super dealloc];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self creat];
    }
    return self;
}

-(void)creat{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(WIDANDHEI, WIDANDHEI);
    flowLayout.sectionInset = UIEdgeInsetsMake(WIDTH * 5, WIDTH * 10, WIDTH * 5, WIDTH * 10);

    self.radioCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 150) collectionViewLayout:flowLayout];
    [self.contentView addSubview:self.radioCollectionView];
    self.radioCollectionView.delegate = self;
    self.radioCollectionView.dataSource = self;
    [self.radioCollectionView release];
    self.radioCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.radioCollectionView registerClass:[Radio_topCollectionViewCell class] forCellWithReuseIdentifier:@"radio_top"];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.radio_topArray.count == 0){
        return 0;
    }
    else{
        return 3;
    }
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"radio_top";
    Radio_topCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    Radio *radio = [self.radio_topArray objectAtIndex:indexPath.row];
    collectionCell.radio = radio;
        
    return collectionCell;
}

/**
 *  点击Item的时候进入系统协议方法,然后调用自定义协议方法,在controller里面实现,push到下一个页面
 *
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectItemAtIndexPath:indexPath];
}

- (void)setRadio_topArray:(NSMutableArray *)radio_topArray
{
    if (_radio_topArray != radio_topArray) {
        [_radio_topArray release];
        _radio_topArray = [radio_topArray retain];
    }
    [self.radioCollectionView reloadData];
}


@end
