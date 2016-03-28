//
//  ReadTableViewCell.m
//  EyeWink
//
//  Created by dllo on 15/9/30.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "ReadTableViewCell.h"
#import "ReadCollectionViewCell.h"

#import "Read.h"

#import "UIImageView+WebCache.h"

@interface ReadTableViewCell ()

@property (nonatomic,retain) UICollectionView *readCollectionView;

@end

@implementation ReadTableViewCell

- (void)dealloc
{
    [_readArray release];
    [_readCollectionView release];
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
    flowLayout.itemSize = CGSizeMake(WIDTH * 110, WIDTH * 110);
    flowLayout.sectionInset = UIEdgeInsetsMake(WIDTH * 5, WIDTH * 5, WIDTH * 5, WIDTH * 5);

    self.readCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 120) collectionViewLayout:flowLayout];
    [self.contentView addSubview:self.readCollectionView];
    self.readCollectionView.delegate = self;
    self.readCollectionView.dataSource = self;
    self.readCollectionView.scrollEnabled = NO;
    self.readCollectionView.backgroundColor = [UIColor whiteColor];
    [self.readCollectionView release];
    
    [self.readCollectionView registerClass:[ReadCollectionViewCell class] forCellWithReuseIdentifier:@"read"];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.readArray.count == 0){
        return 0;
    }
    else{
        return 3;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ReadCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"read" forIndexPath:indexPath];
    Read *read = [self.readArray objectAtIndex:indexPath.row];
    
    collectionCell.read = read;
    
    
        
    return collectionCell;
}

/**
 *  系统的协议方法,点击Item时调用,然后调用自定义协议方法
 *
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Read *read = [self.readArray objectAtIndex:indexPath.row];
    [self.delegate selectReadWithTypeID:read.type];
}

/**
 *  重写read的set方法,刷新readCollectionView
 *
 */
-(void)setReadArray:(NSMutableArray *)readArray{
    if(_readArray != readArray){
        [_readArray release];
        _readArray = [readArray retain];
    }
    [self.readCollectionView reloadData];

}

@end
