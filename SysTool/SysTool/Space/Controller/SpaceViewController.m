//
//  SpaceViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2019/1/9.
//  Copyright © 2019年 stark. All rights reserved.
//

#import "SpaceViewController.h"
#import "NetSpeedView.h"

@interface SpaceViewController()
@property(nonatomic,strong)NetSpeedView *speedview;
@end

@implementation SpaceViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = ColorWithRGB(74, 77, 108);
    UILabel *titlab = [[UILabel alloc]init];
    titlab.text = @"测速";
    titlab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlab;
    CGRect statusRect=[[UIApplication sharedApplication] statusBarFrame];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WSCREEN, self.navigationController.navigationBar.frame.size.height + statusRect.size.height)];
    headview.backgroundColor = ColorWithRGB(74, 77, 108);
    [self.view addSubview:headview];
    [self.view addSubview:self.speedview];
    
    [EasyAlertView alertViewWithPart:^EasyAlertPart *{
        return [EasyAlertPart shared].setTitle(@"提示").setSubtitle(@"网速测试会消耗少量流量,建议不要频繁测速!").setAlertType(AlertViewTypeAlert) ;
    } config:^EasyAlertConfig *{
        return nil;
    } buttonArray:^NSArray<NSString *> *{
        return @[@"好的"] ;
    } callback:^(EasyAlertView *showview, long index) {
    }];
}

-(NetSpeedView *)speedview{
    if (_speedview == nil) {
        _speedview = [[NetSpeedView alloc]initWithFrame:CGRectMake(0, 80.0/667.0*HSCREEN, WSCREEN,HSCREEN- 100.0/667.0*HSCREEN)];
    }
    return _speedview;
}

@end

