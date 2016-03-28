//
//  Video.m
//  EyeWink
//
//  Created by dllo on 15/10/7.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Video.h"

@implementation Video

- (void)dealloc
{
    [_mp4_url release];
    [_title release];
    [_user_avatar_url release];
    [_user_name release];
    [_url release];
    
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

@end
