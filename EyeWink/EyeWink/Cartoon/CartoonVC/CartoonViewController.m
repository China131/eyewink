//
//  CartoonViewController.m
//  EyeWink
//
//  Created by dllo on 15/9/30.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "CartoonViewController.h"
#import "CartTableViewCell.h"
#import "DataBaseSingleton.h"
#import "Shop_DetailViewController.h"
#import "Cartoon.h"

#import "MJRefresh.h"
#import "AFNetworking.h"
#import "UMSocial.h"

@interface CartoonViewController () < UITableViewDataSource , UITableViewDelegate , shareProtocol , UMSocialUIDelegate >

@property (nonatomic,retain) UITableView *myTableView;

@property (nonatomic,retain) NSMutableArray *comicsArray;
@property (nonatomic,assign) BOOL isUploading;
@property (nonatomic,assign) NSInteger dataIndex;

@property (nonatomic,retain) UIView *likeView;
@property (nonatomic,retain) UILabel *likeLabel;

@end

@implementation CartoonViewController

- (void)dealloc
{
    [_myTableView release];
    [_comicsArray release];
    [super dealloc];
}

/**
    自定义协议方法
 *      显示点击收藏按钮之后的提示框
 */
-(void)showLikeAction:(NSString *)info{
    
    self.likeView.center = CGPointMake(375 / 2 * WIDTH, 667 * WIDTH / 2);
    self.likeLabel.center = CGPointMake(375 / 2 * WIDTH, 667 * WIDTH / 2);
    
    self.likeView.backgroundColor = [UIColor grayColor];
    self.likeView.alpha = 0.3;
    self.likeView.layer.masksToBounds = YES;
    self.likeView.layer.cornerRadius = 10 * WIDTH;
    
    self.likeLabel.text = info;
    self.likeLabel.alpha = 1;
    
    [UIView animateWithDuration:2 animations:^{
        
        self.likeView.alpha = 0;
        self.likeLabel.alpha = 0;
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isUploading = NO;
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 667 - WIDTH * 30) style:UITableViewStyleGrouped];
    [self.view addSubview:self.myTableView];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    [self.myTableView release];
    
    self.likeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.view addSubview:self.likeView];
    [self.likeView release];
    
    self.likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.view addSubview:self.likeLabel];
    [self.likeLabel release];


    [[DataBaseSingleton shareDataBaseSingleton] creatComicTable];
    self.comicsArray = [[DataBaseSingleton shareDataBaseSingleton] selectAllComic];
    
    [self headerFresh];
    [self footerFresh];

}

-(void)headerFresh{
    [self.myTableView addHeaderWithCallback:^{
        self.isUploading = YES;
        self.dataIndex = 0;
        
        [self getDataFromAFN];
    }];
    [self.myTableView headerBeginRefreshing];
}

-(void)footerFresh{
    [self.myTableView addFooterWithCallback:^{
        self.isUploading = NO;
        self.dataIndex += 20;
        
        [self getDataFromAFN];
    }];
}

-(void)getDataFromAFN{
    
    NSString *url_string = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/comic_lists/1?limit=20&offset=%ld",self.dataIndex];
    
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"session=f4406884-e053-4c4f-b9ff-8d3910b02254" forHTTPHeaderField:@"Cookie"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [manager GET:url_string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(self.isUploading){
            [[DataBaseSingleton shareDataBaseSingleton] dropComicTable];
            [[DataBaseSingleton shareDataBaseSingleton] creatComicTable];
            [self.comicsArray removeAllObjects];
        }

        /**
         *  每次刷新漫画数据时,在插入到漫画表里面之前,判断一下漫画收藏表里面是否存在这个漫画Model,如果不存在,插入到漫画表里面,如果存在,修改一下isLike的值,再插入到漫画表里面
         */
        NSArray *likeArarry = [[DataBaseSingleton shareDataBaseSingleton] selectAllisLikeComic];
        
        NSDictionary *dic = responseObject;
        NSArray *comicsArray = [[dic objectForKey:@"data"] objectForKey:@"comics"];
        for(NSDictionary *dictionary in comicsArray){
            Cartoon *cartoon = [[Cartoon alloc] init];
            [cartoon setValuesForKeysWithDictionary:dictionary];
            cartoon.isLike = [[dictionary objectForKey:@"is_liked"] boolValue];
            NSDictionary *topicDic = [dictionary objectForKey:@"topic"];
            cartoon.topic_comics_count = [[topicDic objectForKey:@"comics_count"] integerValue];
            cartoon.topic_cover_image_url = [topicDic objectForKey:@"cover_image_url"];
            cartoon.topic_description = [topicDic objectForKey:@"description"];
            cartoon.topic_title = [topicDic objectForKey:@"title"];
            NSDictionary *userDic = [topicDic objectForKey:@"user"];
            cartoon.user_avatar_url = [userDic objectForKey:@"avatar_url"];
            cartoon.user_nickname = [userDic objectForKey:@"nickname"];
            
            /**
             *  判断漫画收藏表里面是否存在此Model
             */
            for(Cartoon *cart in likeArarry){
                if([cart.title isEqualToString:cartoon.title]){
                    cartoon.isLike = YES;
                }
            }

            [[DataBaseSingleton shareDataBaseSingleton] insertComicTable:cartoon];
            [cartoon release];
        }
        self.comicsArray = [[DataBaseSingleton shareDataBaseSingleton] selectAllComic];
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.comicsArray = [[DataBaseSingleton shareDataBaseSingleton] selectAllComic];
    
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];
    
    }];
    
}

/**
 *  友盟分享
 *
 */
-(void)share:(NSString *)url{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:[NSString stringWithFormat:@"%@",url]
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToQQ,nil]
                                       delegate:self];
}

#pragma mark-  设置cell

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return WIDTH * 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 100, WIDTH * 30)];
    label.text = @"  今日推荐";
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor lightGrayColor];
    return label;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Shop_DetailViewController *shop_DetailVC = [[Shop_DetailViewController alloc] init];
    Cartoon *cartoon = [self.comicsArray objectAtIndex:indexPath.row];
    shop_DetailVC.url = cartoon.url;
    [self.navigationController pushViewController:shop_DetailVC animated:YES];
    
    [shop_DetailVC release];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH * 250;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comicsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cart";
    CartTableViewCell *cartoonCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cartoonCell == nil){
        cartoonCell = [[CartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cartoonCell.cartoon = [self.comicsArray objectAtIndex:indexPath.row];
    cartoonCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cartoonCell.delegate = self;
    
    return cartoonCell;
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
