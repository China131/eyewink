//
//  Radio.m
//  EyeWink
//
//  Created by dllo on 15/9/28.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Radio.h"

@implementation Radio

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

- (void)dealloc
{
    [_title release];
    [_desc release];
    [_coverimg release];
    [_uname release];
    [_radioid release];
    [_musicVisit release];
    [_tingid release];
    [_musicUrl release];
    [_icon release];
    [_sharetext release];
    [_shareurl release];
    
    
    [super dealloc];
    
}

@end
