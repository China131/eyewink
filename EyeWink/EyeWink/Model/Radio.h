//
//  Radio.h
//  EyeWink
//
//  Created by dllo on 15/9/28.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Radio : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,assign) BOOL isnew;
@property (nonatomic,copy) NSString *coverimg;
@property (nonatomic,copy) NSString *uname;
@property (nonatomic,copy) NSString *radioid;
@property (nonatomic,copy) NSString *musicVisit;
@property (nonatomic,copy) NSString *tingid;
@property (nonatomic,copy) NSString *musicUrl;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,assign) NSInteger musicvisitnum;
@property (nonatomic,copy) NSString *sharetext;
@property (nonatomic,copy) NSString *shareurl;


@end
