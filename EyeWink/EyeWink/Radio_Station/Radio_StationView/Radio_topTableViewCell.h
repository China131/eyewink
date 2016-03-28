//
//  Radio_topTableViewCell.h
//  EyeWink
//
//  Created by dllo on 15/9/29.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectProtocol < UICollectionViewDelegate >

-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface Radio_topTableViewCell : UITableViewCell < UICollectionViewDataSource , UICollectionViewDelegate >

@property (nonatomic,retain) NSMutableArray *radio_topArray;

@property (nonatomic,assign) id < selectProtocol > delegate;

@end
