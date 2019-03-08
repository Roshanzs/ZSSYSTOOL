//
//  LiuliangViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/16.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "LiuliangViewController.h"
#import "MainTableViewCell.h"
#import "LiuliangNumViewController.h"

#define liuliangcellid @"liuliangcellid"

@interface LiuliangViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@end

@implementation LiuliangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWithRGB(222, 222, 222);
    UILabel *titlab = [[UILabel alloc]init];
    titlab.text = @"流量设置";
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
        return 3;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:liuliangcellid forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"套餐流量";
                cell.detailTextLabel.text = nil;
                id dic = [ShareTools ReadDicWithKey:TOTLENETDATE];
                if ([dic isKindOfClass:[NSString class]]) {
                    cell.detailTextLabel.text = [ShareTools getFileSizeString:[dic longLongValue]];
                }
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"本月已用流量";
                cell.detailTextLabel.text = [ShareTools checkNetLiuliang];
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"每日可用流量";
                cell.detailTextLabel.text = nil;
                id dic = [ShareTools ReadDicWithKey:CURRDAYCANUSE];
                if ([dic isKindOfClass:[NSString class]]) {
                    cell.detailTextLabel.text = [ShareTools getFileSizeString:[dic longLongValue]];
                }
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"流量月底清零";
                UISwitch *switchOpen= [[UISwitch alloc]init];
                [switchOpen addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                id dic = [ShareTools ReadDicWithKey:SWITCHBTN];
                switchOpen.on = [dic intValue] == 1?YES:NO;
                cell.accessoryView = switchOpen;
            }
                break;
            case 1:
                cell.textLabel.text = @"流量手动清零";
                break;
            default:
                break;
        }
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                LiuliangNumViewController *liuliangnumVC = [[LiuliangNumViewController alloc]initWithTitle:@"套餐流量" WithNoticeStr:@"设置套餐总流量"];
                [self.navigationController pushViewController:liuliangnumVC animated:YES];
            }
                break;
            case 1:
            {
                LiuliangNumViewController *liuliangnumVC = [[LiuliangNumViewController alloc]initWithTitle:@"本月已用流量" WithNoticeStr:@"当前已用的流量"];
                [self.navigationController pushViewController:liuliangnumVC animated:YES];
            }
                break;
            case 2:
            {
                LiuliangNumViewController *liuliangnumVC = [[LiuliangNumViewController alloc]initWithTitle:@"每日可用数据流量" WithNoticeStr:@"每日可用数据流量"];
                [self.navigationController pushViewController:liuliangnumVC animated:YES];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
            }
                break;
            case 1:
            {
                [self ClearWifiNetData];
            }
                break;
            default:
                break;
        }
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0/667.0*HSCREEN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0/667.0*HSCREEN;
}

-(void)switchAction:(UISwitch *)sw{
    [ShareTools SaveStateWithValue:@(sw.isOn) WithKey:SWITCHBTN];
}

-(void)ClearWifiNetData{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清空wifi和移动数据的统计?" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *clearAct = [UIAlertAction actionWithTitle:@"清空" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [self clearLiuliang];
    }];
    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alter addAction:clearAct];
    [alter addAction:cancelAct];
    [self presentViewController:alter animated:YES completion:^{
    }];
}

//手动流量清零
-(void)clearLiuliang{
    if ([ShareTools MonthClearLiuliangData]) {
        [EasyTextView showSuccessText:@"清零成功!"];
        [self.tableview reloadData];
    }else{
        [EasyTextView showErrorText:@"清零失败!再来一次吧!"];
    }
}


-(UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.sectionHeaderHeight = 20.0/667.0*HSCREEN;
        _tableview.sectionFooterHeight = 20.0/667.0*HSCREEN;
        _tableview.rowHeight = 50.0/667.0*HSCREEN;
        [_tableview registerClass:[MainTableViewCell class] forCellReuseIdentifier:liuliangcellid];
        _tableview.backgroundColor = [UIColor clearColor];
    }
    return _tableview;
}


@end
