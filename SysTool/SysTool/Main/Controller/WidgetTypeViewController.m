//
//  WidgetTypeViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/21.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "WidgetTypeViewController.h"
#import "WidgetTableViewCell.h"

@import GoogleMobileAds;

@interface WidgetTypeViewController ()<UITableViewDelegate,UITableViewDataSource,GADRewardBasedVideoAdDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSString *didstr;
@end

#define widgetCellid @"widgetCellid"
@implementation WidgetTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWithRGB(222, 222, 222);
    UILabel *titlab = [[UILabel alloc]init];
    titlab.text = @"Widget样式";
    titlab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlab;
    CGRect statusRect=[[UIApplication sharedApplication] statusBarFrame];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WSCREEN, self.navigationController.navigationBar.frame.size.height + statusRect.size.height)];
    headview.backgroundColor = ColorWithRGB(74, 77, 108);
    [self.view addSubview:self.tableview];
    [self.view addSubview:headview];
    [GADRewardBasedVideoAd sharedInstance].delegate = self;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WidgetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:widgetCellid forIndexPath:indexPath];
    cell.index = indexPath;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [ShareTools SaveStateWithValue:[NSString stringWithFormat:@"%ld",(long)indexPath.row] WithKey:WIDGETTYPE];
        [EasyTextView showInfoText:@"选择完成!"];
    }else{
        NSString *str = [ShareTools ChackADWithid:[NSString stringWithFormat:@"typecover%ld",(long)indexPath.row]];
        if (str.intValue < 10) {
            self.didstr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            [self showAlertWithNum:str];
        }else{
            [ShareTools SaveStateWithValue:[NSString stringWithFormat:@"%ld",(long)indexPath.row] WithKey:WIDGETTYPE];
            [EasyTextView showInfoText:@"选择完成!"];
        }
    }
}

-(void)showAlertWithNum:(NSString *)num{
    WeakSelf(self);
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"再观看%d次广告即可解锁样式!",10-num.intValue] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *Sureaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [EasyLoadingView showLoadingText:@"加载中..."];
            [weakself showADWithNum:10];
        });
    }];
    [alt addAction:action];
    [alt addAction:Sureaction];
    [self presentViewController:alt animated:YES completion:^{
    }];
}

-(void)showADWithNum:(int)num{
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [EasyLoadingView hidenLoading];
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    }else{
        if (num <= 0) {
            [EasyLoadingView hidenLoading];
            [EasyTextView showErrorText:@"加载失败,点击重试!"];
        }else{
            num-=1;
            [self performSelector:@selector(showADWithNum:) withObject:@(num) afterDelay:1.0];
        }
    }
}


-(void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didRewardUserWithReward:(GADAdReward *)reward{
    NSString *ty = [NSString stringWithFormat:@"google = %@, amout = %f",reward.type,[reward.amount doubleValue]];
    NSLog(@"zs%@",ty);
    NSString *str = [ShareTools ChackADWithid:[NSString stringWithFormat:@"typecover%@",_didstr]];
    NSString *numstr = [NSString stringWithFormat:@"%d",str.intValue+1];
    [ShareTools AddADWithid:[NSString stringWithFormat:@"typecover%@",_didstr] WithNum:numstr];
    [EasyTextView showSuccessText:[NSString stringWithFormat:@"观看成功!"]];
    [self.tableview reloadData];
}

-(void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    NSLog(@"zs%s",__func__);
}

-(void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    NSLog(@"zs%s",__func__);
}

-(void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    NSLog(@"zs%s",__func__);
}

-(void)rewardBasedVideoAdDidCompletePlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    NSLog(@"zs%s",__func__);
}

-(void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    NSLog(@"zs%s",__func__);
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request] withAdUnitID:GGADID];
}

-(void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    NSLog(@"zs%s",__func__);
}

-(void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didFailToLoadWithError:(NSError *)error{
    NSLog(@"zs%s",__func__);
}


-(UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:(UITableViewStylePlain)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 180.0/667.0*HSCREEN;
        [_tableview registerClass:[WidgetTableViewCell class] forCellReuseIdentifier:widgetCellid];
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
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
