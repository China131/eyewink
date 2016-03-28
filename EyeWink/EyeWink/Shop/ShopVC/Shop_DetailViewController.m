//
//  Shop_DetailViewController.m
//  EyeWink
//
//  Created by dllo on 15/9/30.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Shop_DetailViewController.h"

@interface Shop_DetailViewController ()

@property (nonatomic,retain) UIWebView *myWebView;

@end

@implementation Shop_DetailViewController

- (void)dealloc
{
    [_myWebView release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *buyUrl = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:buyUrl];

    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 667)];
    [self.view addSubview:self.myWebView];
    self.myWebView.backgroundColor = [UIColor whiteColor];
    self.myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.myWebView.scrollView.showsVerticalScrollIndicator = NO;
    [self.myWebView loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
