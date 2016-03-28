//
//  LeftViewController.m
//  UI_Custom
//
//  Created by yutao on 15/2/12.
//  Copyright (c) 2015年 yutao. All rights reserved.
//

#import "LeftViewController.h"
#import "DDMenuController.h"
#import "AppDelegate.h"

#import "Radio_StationViewController.h"
#import "ReadViewController.h"
#import "ShopViewController.h"
#import "SettingViewController.h"
#import "CartoonViewController.h"
#import "VideoViewController.h"
#import "SearchViewController.h"



@interface LeftViewController () < UIImagePickerControllerDelegate , UINavigationControllerDelegate >

@property (nonatomic,retain) UIView *headView;
@property (nonatomic,retain) UIImageView *iconImageView;
@property (nonatomic,retain) UILabel *userNameLabel;
@property (nonatomic,retain) UIButton *downloadButton;
@property (nonatomic,retain) UIButton *likeButton;
@property (nonatomic,retain) UIButton *searchButton;

@end

@implementation LeftViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, HEIGHT * 667) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor grayColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;

    
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 7 * MINLENGHT)];
//        CGFloat a1;
//        for(double i = 0 ;i < WIDTH - 50 ; i++){
//            a1 = i / (WIDTH - 50);
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i, 0, 1, 7* MINLENGHT)];
//            view.backgroundColor = [UIColor colorWithRed:a1 green:a1 blue:a1 alpha:a1];
//            [cellView addSubview:view];
//        }
//        [cell addSubview:cellView];
    }
    
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"radio_station"];
        cell.textLabel.text = @"  电台";
    }
    if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"read"];
        cell.textLabel.text = @"  阅读";
    }
    if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"fragment"];
        cell.textLabel.text = @"  漫画";
    }
    if (indexPath.row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"shop"];
        cell.textLabel.text = @"  良品";
    }
    if (indexPath.row == 4) {
        cell.imageView.image = [UIImage imageNamed:@"video"];
        cell.textLabel.text = @"  视频";
    }
    if (indexPath.row == 5) {
        cell.imageView.image = [UIImage imageNamed:@"setting"];
        cell.textLabel.text = @"  设置";
    }
    cell.backgroundColor = [UIColor grayColor];
    cell.textLabel.textColor = [UIColor cyanColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20 * WIDTH];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70 * WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, 180 * WIDTH)];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, 180 * WIDTH)];
    CGFloat a1;
    for(double i = 0 ;i < WIDTH * 375 - 80 * WIDTH ; i++){
        a1 = i / (WIDTH * 375 - 50 * WIDTH);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i, 0, 1, 180 * WIDTH)];
        view.backgroundColor = [UIColor colorWithRed:a1 green:a1 blue:a1 alpha:a1];
        [headView addSubview:view];
    }
    [self.headView addSubview:headView];

    
    self.headView.backgroundColor = [UIColor grayColor];
    
    //  头像
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30 * WIDTH, 30 * WIDTH, 50 * WIDTH, 50 * WIDTH)];
    [self.headView addSubview:self.iconImageView];
    self.iconImageView.image = [UIImage imageNamed:@"icon"];
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.iconImageView addGestureRecognizer:tap];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 25 * WIDTH;
    
    
    //  搜索
    self.searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.headView addSubview:self.searchButton];
    self.searchButton.frame = CGRectMake(30 * WIDTH, 120 * WIDTH, 230 * WIDTH, 30 * WIDTH);
    UIImage *mImage = [UIImage imageNamed:@"searchBar"];
    mImage = [mImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.searchButton setImage:mImage forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    self.searchButton.layer.masksToBounds = YES;
    self.searchButton.layer.cornerRadius = 15 * WIDTH;
    
    return self.headView;
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    NSLog(@"点击了头像");
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pick.delegate =self;
    pick.allowsEditing = YES;
    [self presentViewController:pick animated:YES completion:^{
        
    }];

}

/**
 *  系统协议方法
 *      更换本地图片
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.iconImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)searchAction{

    SearchViewController *controller = [[SearchViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleView"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:navController animated:YES completion:^{
        
        
    }];
    
//    controller.title = [NSString stringWithFormat:@"搜索"];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
//    navController.navigationBar.tintColor = [UIColor darkGrayColor];
//    [menuController setRootController:navController animated:YES];
    
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 180 * WIDTH;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    
    // 设置根视图
    if (indexPath.row == 0) {
        
        Radio_StationViewController *controller = [[Radio_StationViewController alloc] init];
        controller.title = [NSString stringWithFormat:@"电台"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        navController.navigationBar.tintColor = [UIColor darkGrayColor];
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleView"] forBarMetrics:UIBarMetricsDefault];
        
        [menuController setRootController:navController animated:YES];

    }
    if (indexPath.row == 1) {
        
        ReadViewController *controller = [[ReadViewController alloc] init];
        controller.title = [NSString stringWithFormat:@"阅读"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        navController.navigationBar.tintColor = [UIColor darkGrayColor];
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleView"] forBarMetrics:UIBarMetricsDefault];
        
        [menuController setRootController:navController animated:YES];
        
    }
    if (indexPath.row == 2) {
        
        CartoonViewController *controller = [[CartoonViewController alloc] init];
        controller.title = [NSString stringWithFormat:@"漫画"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        navController.navigationBar.tintColor = [UIColor darkGrayColor];
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleView"] forBarMetrics:UIBarMetricsDefault];
        
        [menuController setRootController:navController animated:YES];
        
    }

    if (indexPath.row == 3) {
        
        ShopViewController *controller = [[ShopViewController alloc] init];
        controller.title = [NSString stringWithFormat:@"良品"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        navController.navigationBar.tintColor = [UIColor darkGrayColor];
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleView"] forBarMetrics:UIBarMetricsDefault];
        
        [menuController setRootController:navController animated:YES];
        
    }
    if (indexPath.row == 4) {
        VideoViewController *controller = [[VideoViewController alloc] init];
        controller.title = [NSString stringWithFormat:@"视频"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        navController.navigationBar.tintColor = [UIColor darkGrayColor];
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleView"] forBarMetrics:UIBarMetricsDefault];
        
        [menuController setRootController:navController animated:YES];
    }
    if (indexPath.row == 5) {
        
        SettingViewController *controller = [[SettingViewController alloc] init];
        controller.title = [NSString stringWithFormat:@"设置"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        navController.navigationBar.tintColor = [UIColor darkGrayColor];
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleView"] forBarMetrics:UIBarMetricsDefault];
        
        [menuController setRootController:navController animated:YES];
        
    }
    
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
