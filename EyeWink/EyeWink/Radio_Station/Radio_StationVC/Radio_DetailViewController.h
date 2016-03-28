//
//  Radio_DetailViewController.h
//  EyeWink
//
//  Created by dllo on 15/9/29.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "BaseViewController.h"

@interface Radio_DetailViewController : BaseViewController < UITableViewDataSource , UITableViewDelegate >

@property (nonatomic,copy) NSString *radioid;

@end
