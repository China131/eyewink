//
//  Shop.m
//  EyeWink
//
//  Created by dllo on 15/9/30.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Shop.h"

@implementation Shop

- (void)dealloc
{
    [_contentid release];
    [_title release];
    [_coverimg release];
    [_buyurl release];
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

@end
