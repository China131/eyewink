//
//  Read_ArticleViewController.m
//  EyeWink
//
//  Created by dllo on 15/10/6.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Read_ArticleViewController.h"
#import "AppTools.h"

#import "AFNetworking.h"

@interface Read_ArticleViewController ()

@property (nonatomic,retain) UIWebView *myWebView;

@end

@implementation Read_ArticleViewController

- (void)dealloc
{
    [_myWebView release];
    [_contentid release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 667)];
    [self.view addSubview:self.myWebView];
    self.myWebView.scalesPageToFit = YES;
    self.myWebView.backgroundColor = [UIColor whiteColor];
    self.myWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [self getDataFromAFN];

}

-(void)getDataFromAFN{
    NSString *url_string = @"http://api2.pianke.me/article/info";
    NSDictionary *para = @{@"auth":@"C807FCuwm36lDC8l3HMTslDJxQMKpNLeNoj1vCGMzcWP22NZLTRhY4fI",@"client":@"1",@"contentid":self.contentid,@"deviceid":@"63900960-1ED5-47D0-B561-86C09F41ED08",@"version":@"3.0.6"};
    NSString *cookie = @"PHPSESSID=1t0dhk4gtdibh9r2ce80dolpr1";
    
    [AppTools postDataFromAFN:url_string WithParameters:para AndCookie:cookie AndBlock:^(id data) {
        
        NSDictionary *dic = data;
        NSString *html = [[dic objectForKey:@"data"] objectForKey:@"html"];
        [self.myWebView loadHTMLString:html baseURL:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
}


@end
