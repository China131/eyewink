//
//  Carousel.m
//  EyeWink
//
//  Created by dllo on 15/10/6.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Carousel.h"

@implementation Carousel

- (void)dealloc
{
    [_img release];
    [_url release];
    [super dealloc];
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

@end
