//
//  BaseTabbarViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/18.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "BaseTabbarViewController.h"
#import "BaseNavigationController.h"
#import "MainViewController.h"
#import "SpaceViewController.h"
#import "SettingViewController.h"

@interface BaseTabbarViewController ()

@end

@implementation BaseTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SpaceViewController *spacevc = [[SpaceViewController alloc]init];
    BaseNavigationController *spaceNV = [[BaseNavigationController alloc]initWithRootViewController:spacevc];
    spacevc.tabBarItem.image = [UIImage imageNamed:@"xinxiimg"];
    spacevc.tabBarItem.title = @"测速";
    MainViewController *mainvc = [[MainViewController alloc]init];
    BaseNavigationController *mainNV = [[BaseNavigationController alloc]initWithRootViewController:mainvc];
    mainvc.tabBarItem.image = [UIImage imageNamed:@"cesuimg"];
    mainvc.tabBarItem.title = @"信息";
    SettingViewController *settingvc = [[SettingViewController alloc]init];
    BaseNavigationController *settingNV = [[BaseNavigationController alloc]initWithRootViewController:settingvc];
    settingvc.tabBarItem.image = [UIImage imageNamed:@"setimg"];
    settingvc.tabBarItem.title = @"设置";

    self.viewControllers = @[spaceNV,mainNV,settingNV];
    [self setSelectedIndex:1];
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
