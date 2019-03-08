//
//  DayUseViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/16.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "DayUseViewController.h"
#import "DayUseTableViewCell.h"
#import "DayUseModel.h"

#define dayusecellid @"dayusecellid"
#define headw (WSCREEN/3.0)
@interface DayUseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSArray *DayDataArr;
@end

@implementation DayUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWithRGB(222, 222, 222);
    UILabel *titlab = [[UILabel alloc]init];
    titlab.text = @"流量详情";
    titlab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlab;
    CGRect statusRect=[[UIApplication sharedApplication] statusBarFrame];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WSCREEN, self.navigationController.navigationBar.frame.size.height + statusRect.size.height)];
    headview.backgroundColor = ColorWithRGB(74, 77, 108);
    [self.view addSubview:self.tableview];
    [self.view addSubview:headview];
    [self getAllData];
}

-(void)getAllData{
    NSArray *DayUseArr = [ShareTools DayUseEveryData];
    NSMutableArray *Marr = [NSMutableArray array];
    for (NSDictionary *dic in DayUseArr) {
        DayUseModel *model = [DayUseModel modelWithDic:dic];
        [Marr addObject:model];
    }
    self.DayDataArr = Marr.copy;
    [self.tableview.mj_header endRefreshing];
    [self.tableview reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DayDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DayUseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dayusecellid forIndexPath:indexPath];
    cell.model = self.DayDataArr[indexPath.row];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

-(UIView *)CreatheadView{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 50.0/667.0*HSCREEN)];
    headV.backgroundColor = [UIColor whiteColor];
    UILabel *timelab = [self creatLabWithStr:@"时间"];
    [headV addSubview:timelab];
    [timelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.mas_equalTo(headV);
        make.width.mas_equalTo(headw);
    }];
    UILabel *wifilab = [self creatLabWithStr:@"WIFI"];
    [headV addSubview:wifilab];
    [wifilab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timelab);
        make.left.mas_equalTo(timelab.mas_right);
        make.width.mas_equalTo(headw);
    }];
    UILabel *Netlab = [self creatLabWithStr:@"流量数据"];
    [headV addSubview:Netlab];
    [Netlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(wifilab);
        make.left.mas_equalTo(wifilab.mas_right);
        make.width.mas_equalTo(headw);
    }];
    
    UIView *marginv = [[UIView alloc]init];
    marginv.backgroundColor = ColorWithRGB(199, 199, 199);
    [headV addSubview:marginv];
    [marginv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(headV);
        make.height.mas_equalTo(0.5);
    }];
    
    return headV;
}

-(UILabel *)creatLabWithStr:(NSString *)str{
    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15.0/375.0*WSCREEN];
    lab.text = str;
    return lab;
}



-(UITableView *)tableview{
    WeakSelf(self);
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:(UITableViewStylePlain)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 60.0/667.0*HSCREEN;
        _tableview.tableHeaderView = [self CreatheadView];
        [_tableview registerClass:[DayUseTableViewCell class] forCellReuseIdentifier:dayusecellid];
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself getAllData];
        }];
    }
    return _tableview;
}




@end
