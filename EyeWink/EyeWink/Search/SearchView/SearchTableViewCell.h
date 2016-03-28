//
//  SearchTableViewCell.h
//  EyeWink
//
//  Created by dllo on 15/10/8.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Search;

@interface SearchTableViewCell : UITableViewCell

@property (nonatomic,retain) Search *search;

@property (nonatomic,retain) NSMutableArray *searchArray;
@property (nonatomic,retain) NSIndexPath *indexPath;
@property (nonatomic,copy) NSString *text;


@end
