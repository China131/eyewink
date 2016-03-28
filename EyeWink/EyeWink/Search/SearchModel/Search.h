//
//  Search.h
//  EyeWink
//
//  Created by dllo on 15/10/8.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Search : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,retain) NSDictionary *playInfo;
@property (nonatomic,copy) NSString *contentid;
@property (nonatomic,copy) NSString *musicUrl;
@property (nonatomic,copy) NSString *imgUrl;

@end
