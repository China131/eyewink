//
//  VideoTableViewCell.h
//  EyeWink
//
//  Created by dllo on 15/10/7.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class Video;

@protocol getHeightProtocol <NSObject>

-(void)getHeight:(CGFloat)height;

-(void)play:(NSString *)url;

@end

@interface VideoTableViewCell : UITableViewCell

@property (nonatomic,retain) Video *video;

@property (nonatomic,assign) id < getHeightProtocol > delegate;

@end
