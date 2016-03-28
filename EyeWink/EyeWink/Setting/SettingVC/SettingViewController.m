//
//  SettingViewController.m
//  EyeWink
//
//  Created by dllo on 15/9/30.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "SDImageCache.h"
#import "SettingViewController.h"
#import "Setting_UseViewController.h"
#import "MyViewController.h"

#import "UMSocial.h"

@interface SettingViewController () < UITableViewDataSource , UITableViewDelegate , UMSocialUIDelegate , UIAlertViewDelegate >

@property (nonatomic,retain) UITableView *myTableView;

@property (nonatomic,retain) NSArray *settingArray;
@property (nonatomic,retain) NSArray *aboutArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.settingArray = @[@"推荐片刻",@"我的收藏"];
    self.aboutArray = @[@"使用指南",@"清除缓存"];

    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 667 + WIDTH * 30) style:UITableViewStyleGrouped];
    [self.view addSubview:self.myTableView];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.myTableView release];

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.settingArray.count;
    }
    else if (section == 1){
        return self.aboutArray.count;
    }
    else{
        return 1;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
    
        /**
         *  推荐片刻
         */
        if(indexPath.row == 0){
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"507fcab25270157b37000010"
                                              shareText:@"你要分享的文字"
                                             shareImage:[UIImage imageNamed:@"Icon-29.png"]
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                               delegate:self];
        }
        /**
         *  我的收藏
         */
        if(indexPath.row == 1){
            MyViewController *myVC = [[MyViewController alloc] init];
            [self.navigationController pushViewController:myVC animated:YES];
            
            [myVC release];

        }
    }
    if(indexPath.section == 1){
        /**
         *  使用指南
         */
        if(indexPath.row == 0){
            Setting_UseViewController *setting_UseVC = [[Setting_UseViewController alloc] init];
            [self.navigationController pushViewController:setting_UseVC animated:YES];
            
            [setting_UseVC release];
            
        }
        /**
         *  清除缓存
         */
        if(indexPath.row == 1){
            NSInteger size = [[SDImageCache sharedImageCache] getSize];
            float totalSize = size / 1024.0 / 1024.0;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"共缓存了 %.2f M,确定清除么?",totalSize] delegate:self cancelButtonTitle:@"我要清除" otherButtonTitles:@"我误点了", nil];
            alert.delegate = self;
            [alert show];
            [alert release];
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == alertView.cancelButtonIndex){
        [[SDImageCache sharedImageCache] clearDisk];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"setting";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if(indexPath.section == 0){
        cell.textLabel.text = [self.settingArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 1){
        cell.textLabel.text = [self.aboutArray objectAtIndex:indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return WIDTH * 50;
    }
    return 0;
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
