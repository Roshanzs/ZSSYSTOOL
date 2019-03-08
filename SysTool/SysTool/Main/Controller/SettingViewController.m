//
//  SettingViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/16.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "SettingViewController.h"
#import "SetTableViewCell.h"
#import "LiuliangViewController.h"
#import "DayUseViewController.h"
#import "WidgetTypeViewController.h"
#import "AboutViewController.h"
#import "GuideViewController.h"
#import "OpenViewController.h"

#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>


@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic, strong) YWFeedbackKit *feedbackKit;

@end

#define settingcellid @"settingcellid"

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWithRGB(222, 222, 222);
    UILabel *titlab = [[UILabel alloc]init];
    titlab.text = @"设置";
    titlab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlab;
    CGRect statusRect=[[UIApplication sharedApplication] statusBarFrame];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WSCREEN, self.navigationController.navigationBar.frame.size.height + statusRect.size.height)];
    headview.backgroundColor = ColorWithRGB(74, 77, 108);
    [self.view addSubview:self.tableview];
    [self.view addSubview:headview];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcellid forIndexPath:indexPath];
    cell.index = indexPath;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0/667.0*HSCREEN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0/667.0*HSCREEN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                LiuliangViewController *liuliangVC = [[LiuliangViewController alloc]init];
                [self.navigationController pushViewController:liuliangVC animated:YES];
            }
                break;
            case 1:
            {
                DayUseViewController *DayUseVC = [[DayUseViewController alloc]init];
                [self.navigationController pushViewController:DayUseVC animated:YES];
            }
                break;
            case 2:
            {
                WidgetTypeViewController *widgetVC = [[WidgetTypeViewController alloc]init];
                [self.navigationController pushViewController:widgetVC animated:YES];
            }
                break;
            case 3:
            {
                OpenViewController *openVC = [[OpenViewController alloc]init];
                [self.navigationController pushViewController:openVC animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                GuideViewController *guideVC = [[GuideViewController alloc]init];
                [self.navigationController pushViewController:guideVC animated:YES];
            }
                break;
            case 1:
            {
                NSString * urlStr = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?mt=8",@"1447767824"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            }
                break;
            case 2:
            {
                [self FeedbackView];
            }
                break;
            case 3:
            {
                AboutViewController *aboutVC = [[AboutViewController alloc]init];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
            default:
                break;
        }
    }

}

-(void)FeedbackView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [EasyLoadingView showLoadingText:@"加载中..."];
        self.feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:@"25433811" appSecret:@"9927b3636e5dbd87015ab9767b84024c"];
        WeakSelf(self);
        [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
            [EasyLoadingView hidenLoading];
            if (viewController != nil) {
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
                [weakself presentViewController:nav animated:YES completion:nil];
                [viewController setCloseBlock:^(UIViewController *aParentController){
                    [aParentController dismissViewControllerAnimated:YES completion:nil];
                }];
            } else {
                [EasyTextView showErrorText:@"网络异常,请重试!"];
            }
        }];
    });

}

-(UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.sectionHeaderHeight = 20.0/667.0*HSCREEN;
        _tableview.sectionFooterHeight = 20.0/667.0*HSCREEN;
        _tableview.rowHeight = 50.0/667.0*HSCREEN;
        [_tableview registerClass:[SetTableViewCell class] forCellReuseIdentifier:settingcellid];
        _tableview.backgroundColor = [UIColor clearColor];
    }
    return _tableview;
}

@end
