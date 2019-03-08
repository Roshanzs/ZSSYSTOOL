//
//  PresentViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2019/1/30.
//  Copyright © 2019年 stark. All rights reserved.
//

#import "PresentViewController.h"
#import "MainTableViewCell.h"
#import "NetModel.h"
#import "NSObject+NetWorkStateTool.h"

#define maintablecellid @"maintablecellid"


@interface PresentViewController ()<UITableViewDelegate,UITableViewDataSource,BatteryInfoDelegate>
@property(nonatomic,strong)NSIndexPath *index;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)DeviceDataTool *DeviceTool;
@property(nonatomic,strong)BatteryInfoTool *BatteryTool;
@property(nonatomic,strong)NetWorkInfoTool *NetWorkTool;
@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)NSString *dayCanUseData;
@property(nonatomic,strong)NSString *dayCurrUseData;
@property(nonatomic,strong)NSString *dayCurrUsewifiData;

@end

@implementation PresentViewController

-(instancetype)initWithIndex:(NSIndexPath *)index{
    self = [super init];
    if (self) {
        self.DeviceTool = [DeviceDataTool sharedManager];
        self.BatteryTool = [BatteryInfoTool sharedManager];
        self.NetWorkTool = [NetWorkInfoTool sharedManager];
        self.BatteryTool.delegate = self;
        
        self.index = index;
        switch (index.item) {
            case 5:
                [[BatteryInfoTool sharedManager] startBatteryMonitoring];
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *dayCanUseData = @"未设置";
    self.dayCanUseData = dayCanUseData;
    NSString *dayCurrUseData = @"0";
    self.dayCurrUseData = dayCurrUseData;
    NSString *dayCurrUsewifiData = @"0";
    self.dayCurrUsewifiData = dayCurrUsewifiData;
    
    NSObject *obj = [[NSObject alloc]init];
    [self updateNetState:obj];
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateNetState:) userInfo:obj repeats:YES];
    [self setupUI];
}

-(void)reloadAllData{
    [self WillShowBeforGet];
    [self.tableview reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self WillShowBeforGet];
}

//界面显示之前获取
-(void)WillShowBeforGet{
    [[NetWorkInfoTool sharedManager] getDeviceIPAddressesWithBlock:^(NSString * _Nonnull ipStr) {
        [NetModel share].IPSTR = ipStr;
    }];
    [[DeviceDataTool sharedManager] getCPUFrequencyWithBlock:^(NSInteger freIntgeer) {
        [NetModel share].CPUHZ = [NSString stringWithFormat:@"%ldMHz", freIntgeer];
    }];
}

//更新信息
-(void)updateNetState:(NSObject *)obj{
    WeakSelf(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [obj detectionBytes];
        [NetModel share].upspace = [NSString stringWithFormat:@"%@/s",[ShareTools getFileSizeString:obj.nowOBytes*1024]];
        [NetModel share].downspace = [NSString stringWithFormat:@"%@/s",[ShareTools getFileSizeString:obj.nowIBytes*1024]];
        [weakself.NetWorkTool DayUseLiuliang];
        [weakself WillShowBeforGet];
        
        NSDictionary *currdict = [ShareTools getCurrDataLiuliang];
        if ([currdict objectForKey:@"netTotle"]) {
            NSString *str = [currdict objectForKey:@"netTotle"];
            weakself.dayCurrUseData = str;
        }
        if ([currdict objectForKey:@"wifiTotle"]) {
            NSString *str = [currdict objectForKey:@"wifiTotle"];
            weakself.dayCurrUsewifiData = [ShareTools getFileSizeString:[str longLongValue]];
        }
        id dic = [ShareTools ReadDicWithKey:CURRDAYCANUSE];
        if ([dic isKindOfClass:[NSString class]]) {
            weakself.dayCanUseData = dic;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableview reloadData];
        });
    });
}

-(void)batteryStatusUpdated{
    [UIView performWithoutAnimation:^{
        [self.tableview reloadData];
    }];
}

-(void)setupUI{
    self.view.backgroundColor = ColorWithRGB(222, 222, 222);
    [self.view addSubview:self.tableview];
    
    UIButton *backbtn = [[UIButton alloc]init];
    [backbtn setTitle:@"返回" forState:(UIControlStateNormal)];
    backbtn.titleLabel.font = [UIFont systemFontOfSize:16.0/375.0*WSCREEN];
    [backbtn addTarget:self action:@selector(backbtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backbtn];
    [backbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20.0/375.0*WSCREEN);
        make.top.mas_equalTo(self.view).offset(30.0/667.0*HSCREEN+statesHeight);
        make.width.mas_equalTo(40.0/375.0*WSCREEN);
        make.height.mas_equalTo(30.0/667.0*HSCREEN);
    }];
}

-(void)backbtnClick{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (_index.item) {
        case 0:
            return 9;
            break;
        case 1:
            return 8;
            break;
        case 2:
            return 7;
            break;
        case 3:
            return 7;
            break;
        case 4:
            return 3;
            break;
        case 5:
            return 6;
            break;
        case 6:
            return 6;
            break;
        case 7:
            return 6;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:maintablecellid forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
    if (_index.item == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"WIFI名称";
                cell.detailTextLabel.text = [[NetWorkInfoTool sharedManager] getWifiName];;
                break;
            case 1:
                cell.textLabel.text = @"实时上行速度";
                cell.detailTextLabel.text = [NetModel share].upspace;
                break;
            case 2:
                cell.textLabel.text = @"实时下行速度";
                cell.detailTextLabel.text = [NetModel share].downspace;
                break;
            case 3:
                cell.textLabel.text = @"今日已用数据流量";
                cell.detailTextLabel.text = [ShareTools getFileSizeString:[_dayCurrUseData longLongValue]];
                break;
            case 4:
                cell.textLabel.text = @"今日设置可用数据流量";
                cell.detailTextLabel.text = [ShareTools getFileSizeString:[_dayCanUseData longLongValue]];
                if ([_dayCanUseData isEqualToString:@"未设置"]) {
                    cell.detailTextLabel.text = @"未设置";
                }
                break;
            case 5:
                cell.textLabel.text = @"本月已用数据流量";
                cell.detailTextLabel.text = [ShareTools checkNetLiuliang];
                break;
            case 6:
                cell.textLabel.text = @"本月设置可用数据流量";
                cell.detailTextLabel.text = [ShareTools checkTotleNetLiuliang];
                break;
            case 7:
                cell.textLabel.text = @"今日已用WIFI流量";
                cell.detailTextLabel.text = _dayCurrUsewifiData;
                break;
            case 8:
                cell.textLabel.text = @"本月已用WIFI流量";
                cell.detailTextLabel.text = [ShareTools checkWifiLiuliang];
                break;
            default:
                break;
        }
    }else if (_index.item == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"设备名称";
                cell.detailTextLabel.text = [_DeviceTool getiPhoneName];
                break;
            case 1:
                cell.textLabel.text = @"设备型号";
                cell.detailTextLabel.text = [_DeviceTool getDiviceName];
                break;
            case 2:
                cell.textLabel.text = @"系统名称";
                cell.detailTextLabel.text = [_DeviceTool getSystemName];
                break;
            case 3:
                cell.textLabel.text = @"系统版本";
                cell.detailTextLabel.text = [_DeviceTool getSystemVersion];
                break;
            case 4:
                cell.textLabel.text = @"屏幕亮度";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f%%",[_DeviceTool getScreenBrightness]*100];
                break;
            case 5:
                cell.textLabel.text = @"屏幕分辨率";
                cell.detailTextLabel.text = [_DeviceTool screenResolution];
                break;
            case 6:
                cell.textLabel.text = @"屏幕DPI";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0fdpi",[_DeviceTool getScreenDpi]];
                break;
            case 7:
                cell.textLabel.text = @"设备标识";
                cell.detailTextLabel.text = [_DeviceTool getDeviceModel];
                break;
                
            default:
                break;
        }
    }else if (_index.item == 2){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"CPU核数";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[_DeviceTool getNuclearCount]];
                break;
            case 1:
                cell.textLabel.text = @"活跃核数";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[_DeviceTool getActiveNuclearCount]];
                break;
            case 2:
                cell.textLabel.text = @"CPU最大频率";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ldMHz", (long)[_DeviceTool getCpuMax]];
                break;
            case 3:{
                cell.textLabel.text = @"CPU当前频率";
                cell.detailTextLabel.text = [NetModel share].CPUHZ;
            }
                break;
            case 4:
                cell.textLabel.text = @"CPU使用百分比";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f%%", [_DeviceTool getCPUUsage]*100];
                break;
            case 5:
                cell.textLabel.text = @"CPU名称";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [_DeviceTool getCPUProcessor]];
                break;
            case 6:
                cell.textLabel.text = @"内核版本";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [_DeviceTool getKernelVersion]];
                break;
            default:
                break;
        }
    }else if (_index.item == 3){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"总内存";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[ShareTools getFileSizeString:[_DeviceTool getTotalMemory]]];
                break;
            case 1:
                cell.textLabel.text = @"活跃内存";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[ShareTools getFileSizeString:[_DeviceTool getActiveMemory]]];
                break;
            case 2:
                cell.textLabel.text = @"不活跃内存";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[ShareTools getFileSizeString:[_DeviceTool getInActiveMemory]]];
                break;
            case 3:
                cell.textLabel.text = @"空闲内存";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[ShareTools getFileSizeString:[_DeviceTool getFreeMemory]]];
                break;
            case 4:
                cell.textLabel.text = @"正在使用的内存";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[ShareTools getFileSizeString:[_DeviceTool getUsedMemory]]];
                break;
            case 5:
                cell.textLabel.text = @"存放内核的内存";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[ShareTools getFileSizeString:[_DeviceTool getWiredMemory]]];
                break;
            case 6:
                cell.textLabel.text = @"可释放的内存";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[ShareTools getFileSizeString:[_DeviceTool getPurgableMemory]]];
                break;
            default:
                break;
        }
    }else if (_index.item == 4){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"总磁盘";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[ShareTools getFileSizeString:[_DeviceTool getTotalDiskSpace]]];
                break;
            case 1:
                cell.textLabel.text = @"未使用的磁盘";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[ShareTools getFileSizeString:[_DeviceTool getFreeDiskSpace]]];
                break;
            case 2:
                cell.textLabel.text = @"已使用的磁盘";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[ShareTools getFileSizeString:[_DeviceTool getUsedDiskSpace]]];
                break;
            default:
                break;
        }
    }else if (_index.item == 5){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"电池是否允许监测";
                cell.detailTextLabel.text = [_BatteryTool isAllowMonitorBattery] == 1?@"是":@"否";
                break;
            case 1:
                cell.textLabel.text = @"电池状态";
                cell.detailTextLabel.text = _BatteryTool.status;
                break;
            case 2:
                cell.textLabel.text = @"当前电量";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%lumAh",(unsigned long)_BatteryTool.levelMAH];
                break;
            case 3:
                cell.textLabel.text = @"电池百分比";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu%%",(unsigned long)_BatteryTool.levelPercent];
                break;
            case 4:
                cell.textLabel.text = @"电池容量";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%lumAh",(unsigned long)_BatteryTool.capacity];
                break;
            case 5:
                cell.textLabel.text = @"电池电压";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f V",_BatteryTool.voltage];
                break;
            default:
                break;
        }
    }else if (_index.item == 6){
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"外网IP地址";
                cell.detailTextLabel.text = [NetModel share].IPSTR;
            }
                break;
            case 1:
                cell.textLabel.text = @"局域网IP地址";
                cell.detailTextLabel.text = [_NetWorkTool getIPAddresses];
                break;
            case 2:
                cell.textLabel.text = @"Wifi名称";
                cell.detailTextLabel.text = [_NetWorkTool getWifiName];
                break;
            case 3:
                cell.textLabel.text = @"Wifi地址";
                cell.detailTextLabel.text = [_NetWorkTool getIpAddressWIFI];
                break;
            case 4:
                cell.textLabel.text = @"手机IP地址";
                cell.detailTextLabel.text = [_NetWorkTool getIpAddressCell];
                break;
            case 5:
                cell.textLabel.text = @"是否代理";
                cell.detailTextLabel.text = [NetWorkInfoTool ifConnectDelegate] == YES ? @"是":@"否";
                break;
            case 6:
                cell.textLabel.text = @"代理";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[NetWorkInfoTool getCurrentDelegateSettings]];
                break;
            default:
                break;
        }
    }else if (_index.item == 7){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"语言";
                cell.detailTextLabel.text = [DeviceDataTool getDeviceLanguage];
                break;
            case 1:
                cell.textLabel.text = @"系统启动时间";
                cell.detailTextLabel.text = [_DeviceTool getSystemUptime];
                break;
            case 2:
                cell.textLabel.text = @"运营商";
                cell.detailTextLabel.text = [DeviceDataTool getCurrentPhoneOperatorName];
                break;
            case 3:
                cell.textLabel.text = @"移动国家码";
                cell.detailTextLabel.text = [DeviceDataTool getMobileCountryCode];
                break;
            case 4:
                cell.textLabel.text = @"国家代码";
                cell.detailTextLabel.text = [_DeviceTool getCurrentCountyNum];
                break;
            case 5:
                cell.textLabel.text = @"时区";
                cell.detailTextLabel.text = [_DeviceTool getCurrentTime];
                break;
            default:
                break;
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 74.0/667.0*HSCREEN+statesHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 6) {
        return 100.0/667.0*HSCREEN;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 6) {
        UIView *footv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 100.0/667.0*HSCREEN)];
        footv.backgroundColor = ColorWithRGB(222, 222, 222);
        return footv;
    }
    return [[UIView alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headv = [[UIView alloc]init];
    headv.backgroundColor = ColorWithRGB(74, 77, 108);
    UILabel *titlelab = [[UILabel alloc]init];
    titlelab.font = [UIFont systemFontOfSize:20.0/375.0*WSCREEN];
    titlelab.textColor = [UIColor whiteColor];
    [headv addSubview:titlelab];
    [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headv).offset(10.0/375.0*WSCREEN);
        make.bottom.mas_equalTo(headv).offset(-10.0/667.0*HSCREEN);
    }];
    
    switch (_index.item) {
        case 0:
            titlelab.text = @"流量信息";
            break;
        case 1:
            titlelab.text = @"硬件信息";
            break;
        case 2:
            titlelab.text = @"CPU信息";
            break;
        case 3:
            titlelab.text = @"内存信息";
            break;
        case 4:
            titlelab.text = @"磁盘信息";
            break;
        case 5:
            titlelab.text = @"电池信息";
            break;
        case 6:
            titlelab.text = @"网络信息";
            break;
        case 7:
            titlelab.text = @"本地化信息";
            break;
        default:
            break;
    }
    return headv;
}


-(UITableView *)tableview{
    if (_tableview == nil) {
        CGRect temp = self.view.frame;
        temp.origin.y -= (24+statesHeight);
        _tableview = [[UITableView alloc]initWithFrame:temp style:(UITableViewStyleGrouped)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.sectionHeaderHeight = 70.0/667.0*HSCREEN;
        _tableview.estimatedRowHeight = 40.0/667.0*HSCREEN;
        _tableview.rowHeight = 40.0/667.0*HSCREEN;
        [_tableview registerClass:[MainTableViewCell class] forCellReuseIdentifier:maintablecellid];
        _tableview.backgroundColor = [UIColor clearColor];
    }
    return _tableview;
}

@end

