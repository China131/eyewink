//
//  Shop_deViewController.m
//  EyeWink
//
//  Created by dllo on 15/10/5.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Shop_deViewController.h"
#import "AppTools.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface Shop_deViewController ()

@property (nonatomic,retain) UIWebView *myWebView;

@property (nonatomic,retain) UIView *headView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIImageView *userIconImageView;
@property (nonatomic,retain) UILabel *userUnameLabel;
@property (nonatomic,retain) UILabel *addtime_fLabel;

@end

@implementation Shop_deViewController

- (void)dealloc
{
    [_myWebView release];
    [_headView release];
    [_titleLabel release];
    [_userIconImageView release];
    [_userUnameLabel release];
    [_addtime_fLabel release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 667 - WIDTH * 60)];
    [self.view addSubview:self.myWebView];
    self.myWebView.opaque = NO;
    self.myWebView.scrollView.contentInset = UIEdgeInsetsMake(80 * WIDTH, 0, 0, 0);
    self.myWebView.scalesPageToFit = YES;
    self.myWebView.backgroundColor = [UIColor whiteColor];
    self.myWebView.scrollView.backgroundColor = [UIColor whiteColor];
    self.myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.myWebView.scrollView.showsVerticalScrollIndicator = NO;
    [self.myWebView release];
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, -80 * WIDTH, WIDTH * 375, WIDTH * 80)];
    [self.myWebView.scrollView addSubview:self.headView];

    [self getDataFromAFN];

}

-(void)getDataFromAFN{

    NSString *url_string = @"http://api2.pianke.me/group/posts_info";
    NSDictionary *para = @{@"auth":@"C807FCuwm36lDC8l3HMTslDJxQMKpNLeNoj1vCGMzcWP22NZLTRhY4fI",@"client":@"1",@"contentid":self.contentid,@"deviceid":@"63900960-1ED5-47D0-B561-86C09F41ED08",@"version":@"3.0.6"};
    NSString *cookie = @"PHPSESSID=rjun93sc1culoivg3ol7evob60";
    
    [AppTools postDataFromAFN:url_string WithParameters:para AndCookie:cookie AndBlock:^(id data) {

        NSDictionary *dic = data;
        NSDictionary *postsinfoDic = [[dic objectForKey:@"data"] objectForKey:@"postsinfo"];
        [self.myWebView loadHTMLString:[postsinfoDic objectForKey:@"html"] baseURL:nil];

#pragma mark-  设置头视图内容
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 10, WIDTH * 10, WIDTH * 350, WIDTH * 30)];
        [self.headView addSubview:self.titleLabel];
        self.titleLabel.text = [[[dic objectForKey:@"data"] objectForKey:@"postsinfo"] objectForKey:@"title"];
        self.titleLabel.font = [UIFont systemFontOfSize:WIDTH * 20];
        [self.titleLabel release];
        
        self.userIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 10, WIDTH * 50, WIDTH * 30, WIDTH * 30)];
        [self.headView addSubview:self.userIconImageView];
        [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:[[[[dic objectForKey:@"data"] objectForKey:@"postsinfo"] objectForKey:@"userinfo"] objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"eyeWink"]];
        self.userIconImageView.layer.masksToBounds = YES;
        self.userIconImageView.layer.cornerRadius = WIDTH * 15;
        [self.userIconImageView release];
        
        self.userUnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 40, WIDTH * 55, WIDTH * 80, WIDTH * 20)];
        [self.headView addSubview:self.userUnameLabel];
        self.userUnameLabel.text = [[[[dic objectForKey:@"data"] objectForKey:@"postsinfo"] objectForKey:@"userinfo"] objectForKey:@"uname"];
        [self.userUnameLabel release];
        
        self.addtime_fLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 250, WIDTH * 55, WIDTH * 120, WIDTH * 20)];
        [self.headView addSubview:self.addtime_fLabel];
        self.addtime_fLabel.text = [[[dic objectForKey:@"data"] objectForKey:@"postsinfo"] objectForKey:@"addtime_f"];
        self.addtime_fLabel.font = [UIFont systemFontOfSize:WIDTH * 15];
        self.addtime_fLabel.textAlignment = NSTextAlignmentRight;
        [self.addtime_fLabel release];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}


@end
