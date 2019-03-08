//
//  TodayViewController.m
//  SysToolWidget
//
//  Created by 紫贝壳 on 2018/12/17.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "NSObject+NetWorkStateTool.h"
#import "widgetView.h"
#import "LiuliangWidgetView.h"
#import "OnlyLiuliangView.h"

#define openbtnW (WSCREENWidget-marginW*6)/5.0
#define marginW (35.0/375.0*WSCREENWidget)

@interface TodayViewController () <NCWidgetProviding>
@property(nonatomic,strong)widgetView *widgetView;
@property(nonatomic,strong)LiuliangWidgetView *LiuliangwidgetView;
@property(nonatomic,strong)OnlyLiuliangView *onlyliuliangview;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSString *cpuHz;
@property(nonatomic,assign)int numInt;

@property(nonatomic,strong)NSArray *openUrlArr;
@property(nonatomic,strong)NSString *arrNum;

@property(nonatomic,strong)DeviceDataTool *DeviceTool;
@property(nonatomic,strong)BatteryInfoTool *BatteryTool;
@property(nonatomic,strong)NetWorkInfoTool *NetWorkTool;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DeviceTool = [DeviceDataTool sharedManager];
    self.BatteryTool = [BatteryInfoTool sharedManager];
    self.NetWorkTool = [NetWorkInfoTool sharedManager];
    self.numInt = 1;
    if ([[UIDevice currentDevice] systemVersion].intValue >= 10) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }else{
        self.preferredContentSize = CGSizeMake(0, 110);
    }
    [self.timer invalidate];
    self.timer = nil;
    NSObject *obj = [[NSObject alloc]init];
    [self updateNetState:obj];
    [self WillShowBeforGet];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateNetState:) userInfo:obj repeats:YES];
    
    NSDictionary *urldic = [ShareTools openUrlArrDic];
    self.openUrlArr = [NSArray arrayWithArray:[urldic objectForKey:@"urlarr"]];
    self.arrNum = [urldic objectForKey:@"state"];
    self.arrNum = self.arrNum.intValue>5?@"5":self.arrNum;
    [self setupUI];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self MonthClearLiuliangData];
}

-(void)setupUI{
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openURLContainingAPP)];
    NSString *widgetype = [ShareTools ReadDicWithKey:WIDGETTYPE];
    if (widgetype.intValue == 0) {
        self.widgetView = [[widgetView alloc]init];
        [self.view addSubview:_widgetView];
        [_widgetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(110);
        }];
        [self.widgetView addGestureRecognizer:ges];
    }else if(widgetype.intValue == 1){
        self.LiuliangwidgetView = [[LiuliangWidgetView alloc]init];
        [self.view addSubview:_LiuliangwidgetView];
        [_LiuliangwidgetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(110);
        }];
        [self.LiuliangwidgetView addGestureRecognizer:ges];
    }else{
        self.onlyliuliangview = [[OnlyLiuliangView alloc]init];
        [self.view addSubview:_onlyliuliangview];
        [_onlyliuliangview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(110);
        }];
        [self.onlyliuliangview addGestureRecognizer:ges];
    }
    
    
    if (self.arrNum.intValue <= 0) {
        UILabel *lab = [[UILabel alloc]init];
        lab.text = @"暂无快捷打开,快去添加吧!";
        lab.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
        [self.view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(130);
        }];
    }else{
    CGFloat marg = marginW;
    marg = (WSCREENWidget-self.arrNum.intValue*openbtnW - (self.arrNum.intValue-1)*marginW)*0.5;
    for (int i=0; i<self.arrNum.intValue; i++) {
        UIButton *btn = [[UIButton alloc]init];
        NSDictionary *opendic = self.openUrlArr[i];
        [btn setBackgroundImage:[UIImage imageNamed:[opendic objectForKey:@"imgWidget"]] forState:(UIControlStateNormal)];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SchemesWithBtn:)];
        [ShareTools ZScorner:btn WithFlote:12.0/375.0*WSCREEN];
        [btn addGestureRecognizer:ges];
        btn.tag = i + 408;
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(openbtnW);
            make.left.mas_equalTo(self.view).offset(marg + i*(openbtnW+marginW));
            make.top.mas_equalTo(self.view).offset(120);
            make.height.mas_equalTo(openbtnW);
        }];
        
        UILabel *titlelab = [[UILabel alloc]init];
        titlelab.text = [opendic objectForKey:@"title"];
        titlelab.font = [UIFont systemFontOfSize:10.0/375.0*WSCREEN];
        titlelab.textColor = [UIColor blackColor];
        [self.view addSubview:titlelab];
        [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(btn);
            make.top.mas_equalTo(btn.mas_bottom).offset(3);
        }];
    }
    }
}

//快捷打开
-(void)SchemesWithBtn:(UITapGestureRecognizer *)gest{
    UIButton *btn = (UIButton *)gest.view;
    NSDictionary *opendic = self.openUrlArr[btn.tag-408];
    NSString *openstr = [opendic objectForKey:@"url"];
    [self.extensionContext openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://",openstr]]
                 completionHandler:^(BOOL success) {
                 }];
}

//通过openURL的方式启动Containing APP
- (void)openURLContainingAPP
{
    [self.extensionContext openURL:[NSURL URLWithString:@"ForSYSZS://"]
                 completionHandler:^(BOOL success) {
                 }];
}

//界面显示之前获取
-(void)WillShowBeforGet{
    [_DeviceTool getCPUFrequencyWithBlock:^(NSInteger freIntgeer) {
        self.cpuHz = [NSString stringWithFormat:@"%ldMHz", freIntgeer];
    }];
}

//更新信息
-(void)updateNetState:(NSObject *)obj{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [obj detectionBytes];
        [NetModel share].upspace = [NSString stringWithFormat:@"%@/s",[ShareTools getFileSizeString:obj.nowOBytes*1024]];
        [NetModel share].downspace = [NSString stringWithFormat:@"%@/s",[ShareTools getFileSizeString:obj.nowIBytes*1024]];
        [NetModel share].CPUHZ = self.cpuHz == nil ? [NSString stringWithFormat:@"%ldMHz",[self.DeviceTool getCpuMax]]:self.cpuHz;
        [NetModel share].memoryUse = [NSString stringWithFormat:@"%@/%@",[ShareTools getFileSizeString:[self.DeviceTool getUsedMemory]],[ShareTools getFileSizeString:[self.DeviceTool getTotalMemory]]];
        [NetModel share].diskUse = [NSString stringWithFormat:@"%@/%@",[ShareTools getFileSizeString:[self.DeviceTool getUsedDiskSpace]],[ShareTools getFileSizeString:[self.DeviceTool getTotalDiskSpace]]];
        NSString *widgetype = [ShareTools ReadDicWithKey:WIDGETTYPE];
        if (self.numInt%5 == 0) {
            [self.NetWorkTool DayUseLiuliang];
            [self WillShowBeforGet];
            self.numInt = 1;
        }else{
            self.numInt+=1;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (widgetype.intValue == 0) {
                self.widgetView.model = [NetModel share];
            }else if (widgetype.intValue == 1){
                self.LiuliangwidgetView.model = [NetModel share];
            }else{
                self.onlyliuliangview.model = [NetModel share];
            }
        });
    });
    
}

-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake(maxSize.width, 110);
    }else {
        self.preferredContentSize = CGSizeMake(maxSize.width, 175);
    }
}

//月初清零流量
-(void)MonthClearLiuliangData{
    [ShareTools CreatDBdate];
    id dic = [ShareTools ReadDicWithKey:SWITCHBTN];
    if ([dic isKindOfClass:[NSString class]] && [dic intValue] == 1) {
        NSString *daystr = [ShareTools getNowTimeFromDate];
        NSRange dayrange = NSMakeRange(daystr.length - 2, 2);
        daystr = [daystr substringWithRange:dayrange];
        id clearDic = [ShareTools ReadDicWithKey:DAYMONTHCLEARBOOL];
        if (daystr.intValue == 1 && [clearDic intValue] == 0) {
            [ShareTools MonthClearLiuliangData];
            [ShareTools SaveStateWithValue:@"1" WithKey:DAYMONTHCLEARBOOL];
        }else{
            [ShareTools SaveStateWithValue:@"0" WithKey:DAYMONTHCLEARBOOL];
        }
    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
}

@end

