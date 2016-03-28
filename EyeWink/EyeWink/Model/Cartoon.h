//
//  Cartoon.h
//  EyeWink
//
//  Created by dllo on 15/10/5.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cartoon : NSObject

@property (nonatomic,copy) NSString *user_nickname;
@property (nonatomic,copy) NSString *user_avatar_url;
@property (nonatomic,copy) NSString *topic_title;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *topic_cover_image_url;
@property (nonatomic,copy) NSString *topic_description;   //  判断是否是独家
@property (nonatomic,assign) NSInteger topic_comics_count;
@property (nonatomic,assign) NSInteger shared_count;
@property (nonatomic,assign) NSInteger likes_count;
@property (nonatomic,assign) NSInteger comments_count;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,assign) BOOL isLike;

@end
