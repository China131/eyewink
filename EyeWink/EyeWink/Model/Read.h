//
//  Read.h
//  EyeWink
//
//  Created by dllo on 15/9/30.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Read : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *enname;
@property (nonatomic,copy) NSString *coverimg;
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,copy) NSString *detail_coverimg;
@property (nonatomic,copy) NSString *detail_name;
@property (nonatomic,copy) NSString *detail_title;
@property (nonatomic,copy) NSString *detail_content;
@property (nonatomic,copy) NSString *detail_id;

@end
