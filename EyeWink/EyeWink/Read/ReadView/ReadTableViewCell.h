//
//  ReadTableViewCell.h
//  EyeWink
//
//  Created by dllo on 15/9/30.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectReadProtocol < UICollectionViewDelegate >

-(void)selectReadWithTypeID:(NSInteger)typeID;

@end

@interface ReadTableViewCell : UITableViewCell < UICollectionViewDataSource , UICollectionViewDelegate >

@property (nonatomic,retain) NSMutableArray *readArray;

@property (nonatomic,assign) id < selectReadProtocol > delegate;


@end
