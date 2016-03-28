//
//  AppDelegate.m
//  EyeWink
//
//  Created by dllo on 15/9/28.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "Radio_StationViewController.h"
#import "DataBaseSingleton.h"

#import "UMSocial.h"
#import "AFNetworking.h"


@interface AppDelegate () < UIScrollViewDelegate >

@property(nonatomic,retain)UIImageView *logoView;
@property(nonatomic ,retain)UIScrollView *myScrollView;
@property(nonatomic,retain)UIPageControl *pageC;
@property(nonatomic,assign)BOOL isOut;

@end

@implementation AppDelegate

- (void)dealloc
{
    [_logoView release];
    [_myScrollView release];
    [_window release];
    [_menuController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self.window release];
    
    
    
    //  判断是否第一次进入这个APP,如果是,在沙盒里面存放一个文件,再次打开这个APP时如果有次文件,则不用加载引导页
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [array lastObject];
    NSString *eyeWinkTxt = [documentPath stringByAppendingPathComponent:@"eyeWink.txt"];
    
    
    NSFileManager *manager=[NSFileManager defaultManager];
    
    BOOL isHasFile=[manager fileExistsAtPath:eyeWinkTxt];
    
    if (isHasFile) {
        NSLog(@"1111");
        //  为真表示已有文件 曾经进入过主页
        [self gotoMain];
    }else{
        //  为假表示没有文件，没有进入过主页
        NSLog(@"2222");
        [self gotoLaunch];
        isHasFile = YES;
    }

    
    [self gotoMain];
    [self gotoLaunch];
    
    return YES;
}

-(void)gotoMain{
    
    /**
     *  调用友盟的分享和登陆的时候在AppDelegate加上这句话
     */
    [UMSocialData setAppKey:@"507fcab25270157b37000010"];

    
    Radio_StationViewController *radioVC = [[Radio_StationViewController alloc] init];
    UINavigationController *naGC = [[UINavigationController alloc] initWithRootViewController:radioVC];
    naGC.navigationBar.tintColor = [UIColor darkGrayColor];
    [naGC.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleView"] forBarMetrics:UIBarMetricsDefault];
    radioVC.navigationItem.title = @"电台";
    
    self.menuController = [[DDMenuController alloc] initWithRootViewController:naGC];
    LeftViewController * leftControler = [[LeftViewController alloc] init];
    self.menuController.leftViewController = leftControler;
    self.menuController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"咨询" image:[UIImage imageNamed:@"consult-disselect"] selectedImage:[UIImage imageNamed:@"consult-select"]];
    
    
    
    self.window.rootViewController = self.menuController;
}

-(void)gotoLaunch{
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [array lastObject];
    NSString *eyeWinkTxt = [documentPath stringByAppendingPathComponent:@"eyeWink.txt"];
    NSString *content = @"存在此文件";
    
    BOOL result = [content writeToFile:eyeWinkTxt atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if(result){
        NSLog(@"写入成功");
    }
    else{
        NSLog(@"写入失败");
    }

    
    self.logoView = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window addSubview:self.logoView];
    self.logoView.image = [UIImage imageNamed:@"launch0.png"];
    [self.logoView release];
    
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(logo:) userInfo:nil repeats:YES];


}

-(void)logo:(NSTimer *)timer{
    [UIView animateWithDuration:1 animations:^{
        //  让logoView   逐渐消失
        self.logoView.alpha = 0;
    } completion:^(BOOL finished){
        //  将logoView   移除
        [self.logoView removeFromSuperview];
        [timer invalidate];
        [self makeLaunchView];
    } ];
    
}

-(void)scroll:(NSTimer *)timer{
    [UIView animateWithDuration:2 animations:^{
        self.myScrollView.alpha=1;
    }completion:^(BOOL finished){
        [timer invalidate];
    }];
}


#pragma mark- 滚动图片和page显示
-(void)makeLaunchView{
    
    NSArray *array = [NSArray arrayWithObjects:@"launch1.png" ,@"launch2.png" ,@"launch3.png" , nil];
    self.myScrollView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.myScrollView.contentSize = CGSizeMake(self.window.frame.size.width*array.count, self.window.frame.size.height);
    
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.delegate = self;
    
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(scroll:) userInfo:nil repeats:YES];
    
    [self.window addSubview:self.myScrollView];
    for(int i = 0; i < array.count ; i++){
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.window.frame.size.width, 0, self.window.frame.size.width, self.window.frame.size.height)];
        imageview.image = [UIImage imageNamed:array[i]];
        [self.myScrollView addSubview:imageview];
        [imageview release];
    }
    
    [self.myScrollView release];
    
    self.pageC = [[UIPageControl alloc]initWithFrame:CGRectMake((WIDTH * (375 / 2)) - WIDTH * 100, WIDTH * 600, WIDTH * 200, WIDTH * 40)];
    
    self.pageC.numberOfPages = array.count;
    self.pageC.currentPage = 0;
    self.pageC.pageIndicatorTintColor = [UIColor grayColor];
    self.pageC.currentPageIndicatorTintColor = [UIColor orangeColor];
//    [[self.inputViewController view] setFrame:[[self window] bounds]];
    [self.window addSubview:self.pageC];
    [self.pageC release];
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //  当图片全部滑完后 又向后多滑了100 的时候就做下一个动作
    self.pageC.currentPage = self.myScrollView.contentOffset.x / (WIDTH * 375);
    if(self.myScrollView.contentOffset.x + WIDTH * 375 - self.myScrollView.contentSize.width > 100 * WIDTH){
     
        [self gotoMain];
    }
    
    
}


@end
