//
//  ReadViewController.h
//  EyeWink
//
//  Created by dllo on 15/9/29.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "BaseViewController.h"
#import "ReadTableViewCell.h"


@class Read;

@interface ReadViewController : BaseViewController < UITableViewDataSource , UITableViewDelegate , selectReadProtocol >


@property (nonatomic,retain) Read *read;

@end
