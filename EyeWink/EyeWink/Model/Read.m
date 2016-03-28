//
//  Read.m
//  EyeWink
//
//  Created by dllo on 15/9/30.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Read.h"

@implementation Read

- (void)dealloc
{
    [_coverimg release];
    [_enname release];
    [_name release];
    [_detail_content release];
    [_detail_coverimg release];
    [_detail_id release];
    [_detail_name release];
    [_detail_title release];
    
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

@end
