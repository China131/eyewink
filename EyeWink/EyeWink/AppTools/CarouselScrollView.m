//
//  CarouselScrollView.m
//  EyeWink
//
//  Created by dllo on 15/10/5.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "CarouselScrollView.h"

#import "AppTools.h"

#import "UIImageView+WebCache.h"

@interface CarouselScrollView () < UIScrollViewDelegate >

@property (nonatomic,retain) NSTimer *timer;

@property (nonatomic,assign) NSInteger index;

@end

@implementation CarouselScrollView

- (void)dealloc
{
    [_timer release];
    [_carouselArray release];
    
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

-(void)creat{
    self.contentSize = CGSizeMake(WIDTH * 375 * (self.carouselArray.count + 2), self.frame.size.height);
    self.contentOffset = CGPointMake(WIDTH * 375, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
    for(int i = 0 ; i < (self.carouselArray.count + 2) ; i++){
        UIImageView *carouselImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * WIDTH * 375, 0, WIDTH * 375, self.frame.size.height)];
        [self addSubview:carouselImageView];
        NSMutableArray *imageNameArray = [AppTools getImageArrayWithCarouselArray:self.carouselArray];
        [carouselImageView sd_setImageWithURL:[NSURL URLWithString:[imageNameArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"icon"]];
        
        [carouselImageView release];
    }
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
//    });
    
}

-(void)timeAction{
    if(self.contentOffset.x == (self.carouselArray.count + 1) * WIDTH * 375){
        self.contentOffset = CGPointMake(WIDTH * 375, 0);
    }
    else if (self.contentOffset.x == 0){
        self.contentOffset = CGPointMake(self.carouselArray.count * WIDTH * 375, 0);
    }

    self.index = self.contentOffset.x / (WIDTH * 375);
    self.index++;
    self.contentOffset = CGPointMake(self.index * WIDTH * 375, 0);
}

-(void)setCarouselArray:(NSMutableArray *)carouselArray{
    if(_carouselArray != carouselArray){
        [_carouselArray release];
        _carouselArray = [carouselArray retain];
    }
    if(_carouselArray.count != 0){
        [self creat];
    }
}

/**
 *  正在滑动时调用,重置timer
        作用是当滑动的时候不会让轮播图自动跳到下一张图片
 *
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
}

/**
 *  当滑动已经减速时调用
        当滑动到第一张或最后一张的时候,重置偏移量,实现无限滚动
 *
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(self.contentOffset.x == (self.carouselArray.count + 1) * WIDTH * 375){
        self.contentOffset = CGPointMake(WIDTH * 375, 0);
    }
    else if (self.contentOffset.x == 0){
        self.contentOffset = CGPointMake(self.carouselArray.count * WIDTH * 375, 0);
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
