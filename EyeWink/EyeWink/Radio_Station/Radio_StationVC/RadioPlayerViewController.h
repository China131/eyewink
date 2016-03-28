//
//  RadioPlayerViewController.h
//  EyeWink
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "BaseViewController.h"
@class Radio;

@interface RadioPlayerViewController : BaseViewController

@property (nonatomic,retain) NSMutableArray *allMusicArray;
@property (nonatomic,assign) NSInteger indexPath;
@property (nonatomic,copy) NSString *musicUrl;
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,retain) Radio *radio;

/**
 *  电台为单例,可以后台运行,每次进入这个页面的时候都调用这个方法
 *
 *  @return 返回一个电台对象
 */
+(instancetype)shareRadio_PlayerViewController;

@end
