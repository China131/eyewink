//
//  Cartoon.m
//  EyeWink
//
//  Created by dllo on 15/10/5.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Cartoon.h"

@implementation Cartoon

- (void)dealloc
{
    [_user_nickname release];
    [_user_avatar_url release];
    [_topic_title release];
    [_title release];
    [_topic_cover_image_url release];
    [_topic_description release];
    [_url release];
    
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

@end
