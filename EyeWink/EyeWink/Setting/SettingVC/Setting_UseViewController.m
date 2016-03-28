//
//  Setting_UseViewController.m
//  EyeWink
//
//  Created by dllo on 15/10/8.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Setting_UseViewController.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface Setting_UseViewController ()

@property (nonatomic,retain) UIWebView *myWebView;

@property (nonatomic,retain) UIView *headView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIImageView *userIconImageView;
@property (nonatomic,retain) UILabel *userUnameLabel;
@property (nonatomic,retain) UILabel *addtime_fLabel;

@end

@implementation Setting_UseViewController

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


    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, WIDTH * 70, WIDTH * 375, WIDTH * 667 - WIDTH * 60)];
    [self.view addSubview:self.myWebView];
    self.myWebView.scalesPageToFit = YES;
    self.myWebView.backgroundColor = [UIColor whiteColor];
    self.myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.myWebView.scrollView.showsVerticalScrollIndicator = NO;
    [self.myWebView release];
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, -80 * WIDTH, WIDTH * 375, WIDTH * 80)];
    [self.myWebView.scrollView addSubview:self.headView];
    
    [self getDataFromAFN];
}

-(void)getDataFromAFN{
    
    NSString *url_string = @"http://api2.pianke.me/group/posts_info";
    
    //auth=XMxsEyWx8apDC8l3HMTslDJxQMKtMLPZo2xqWm1E2cWP22NZETxhe7Ps&client=1&contentid=54b5f5458ead0ef15500015f&deviceid=63900960-1ED5-47D0-B561-86C09F41ED08&version=3.0.6
    NSDictionary *para = @{@"auth":@"XMxsEyWx8apDC8l3HMTslDJxQMKtMLPZo2xqWm1E2cWP22NZETxhe7Ps",@"client":@"1",@"contentid":@"54b5f5458ead0ef15500015f",@"deviceid":@"63900960-1ED5-47D0-B561-86C09F41ED08",@"version":@"3.0.6"};
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"PHPSESSID=jdf8ep0aqeglj0nk4fuvuffrm5" forHTTPHeaderField:@"Cookie"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",@"application/x-javascript",nil];
    [manager POST:url_string parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
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
        
        
        
        
        
        
        
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
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
