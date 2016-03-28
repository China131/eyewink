//
//  Chosen.h
//  EyeWink
//
//  Created by dllo on 15/9/30.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chosen : NSObject

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *coverimg;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *enname;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) BOOL islike;
@property (nonatomic,assign) NSInteger view;
@property (nonatomic,assign) NSInteger like;
@property (nonatomic,copy) NSString *uname;
@property (nonatomic,copy) NSString *songid;
@property (nonatomic,copy) NSString *coverimg_wh;
@property (nonatomic,assign) NSInteger hot;

@end
