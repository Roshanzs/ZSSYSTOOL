//
//  OnlyLiuliangView.m
//  SysToolWidget
//
//  Created by 紫贝壳 on 2018/12/27.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "OnlyLiuliangView.h"

@interface OnlyLiuliangView()

@property(nonatomic,strong)UILabel *upNetlab;
@property(nonatomic,strong)UILabel *downNetlab;
@property(nonatomic,strong)UILabel *Netlab;
@property(nonatomic,strong)UILabel *wifiNetlab;
@property(nonatomic,strong)UIProgressView *progressView;
@property(nonatomic,strong)UILabel *wifiDayuselab;
@property(nonatomic,strong)UILabel *netDayUselab;

@end

@implementation OnlyLiuliangView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    NSString *dayCanUseData = @"未设置";
    NSString *dayCurrUseData = @"0";
    NSString *dayCurrUsewifiData = @"0";
    NSDictionary *currdict = [ShareTools getCurrDataLiuliang];
    if ([currdict objectForKey:@"netTotle"]) {
        NSString *str = [currdict objectForKey:@"netTotle"];
        dayCurrUseData = str;
    }
    if ([currdict objectForKey:@"wifiTotle"]) {
        NSString *str = [currdict objectForKey:@"wifiTotle"];
        dayCurrUsewifiData = [ShareTools getFileSizeString:[str longLongValue]];
    }
    id dic = [ShareTools ReadDicWithKey:CURRDAYCANUSE];
    if ([dic isKindOfClass:[NSString class]]) {
        dayCanUseData = dic;
    }
    
    UIView *marginv = [[UIView alloc]init];
    marginv.backgroundColor = [UIColor whiteColor];
    [self addSubview:marginv];
    [marginv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.bottom.mas_equalTo(self).offset(-40);
        make.width.mas_equalTo(1);
        make.left.mas_equalTo(120.0/375.0*WSCREEN);
    }];
    
    UIImageView *upNetImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"upnetimg"]];
    [self addSubview:upNetImgv];
    [upNetImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20.0/375.0*WSCREEN);
        make.top.mas_equalTo(self).offset(20);
        make.width.mas_equalTo(12.0/375.0*WSCREEN);
        make.height.mas_equalTo(upNetImgv.mas_width);
    }];
    
    UILabel *upNetlab = [self CreatLab];
    upNetlab.textAlignment = NSTextAlignmentRight;
    self.upNetlab = upNetlab;
    upNetlab.text = @"0B/s";
    [self addSubview:upNetlab];
    [upNetlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(upNetImgv);
        make.left.mas_equalTo(upNetImgv.mas_right).offset(10.0/375.0*WSCREEN);
        make.right.mas_equalTo(marginv).offset(-15.0/375.0*WSCREEN);
    }];
    
    UIImageView *downNetImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downnetimg"]];
    [self addSubview:downNetImgv];
    [downNetImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(upNetImgv);
        make.top.mas_equalTo(upNetImgv.mas_bottom).offset(20);
        make.size.mas_equalTo(upNetImgv);
    }];
    
    UILabel *downNetlab = [self CreatLab];
    self.downNetlab = downNetlab;
    downNetlab.textAlignment = NSTextAlignmentRight;
    downNetlab.text = @"0B/s";
    [self addSubview:downNetlab];
    [downNetlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(downNetImgv);
        make.leading.trailing.mas_equalTo(upNetlab);
    }];
    
    UIImageView *NetImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"4gnetimg"]];
    [self addSubview:NetImgv];
    [NetImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(marginv).offset(50.0/375.0*WSCREEN);
        make.top.mas_equalTo(self).offset(12);
        make.width.mas_equalTo(18.0/375.0*WSCREEN);
        make.height.mas_equalTo(NetImgv.mas_width);
    }];

    UILabel *Netlab = [self CreatLab];
    self.Netlab = Netlab;
    Netlab.text = [NSString stringWithFormat:@"%@/%@",[ShareTools checkNetLiuliang],[ShareTools checkTotleNetLiuliang]];
    [self addSubview:Netlab];
    [Netlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(NetImgv);
        make.top.mas_equalTo(NetImgv.mas_bottom).offset(8);
    }];
    
    UILabel *NetNoticelab = [[UILabel alloc]init];
    NetNoticelab.font = [UIFont systemFontOfSize:9.0/375.0*WSCREEN];
    NetNoticelab.textColor = ColorWithRGB(99, 99, 99);
    NetNoticelab.textAlignment = NSTextAlignmentCenter;
    NetNoticelab.text = @"(本月已用/本月可用)";
    [self addSubview:NetNoticelab];
    [NetNoticelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(NetImgv);
        make.top.mas_equalTo(Netlab.mas_bottom).offset(5);
        make.width.mas_equalTo(100.0/375.0*WSCREEN);
    }];

    UIImageView *wifiNetImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wifinameimg"]];
    [self addSubview:wifiNetImgv];
    [wifiNetImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(NetImgv);
        make.right.mas_equalTo(-60.0/375.0*WSCREEN);
        make.size.mas_equalTo(NetImgv);
    }];

    UILabel *wifiNetlab = [self CreatLab];
    self.wifiNetlab = wifiNetlab;
    wifiNetlab.text = [NSString stringWithFormat:@"%@/%@",dayCurrUsewifiData,[ShareTools checkWifiLiuliang]];
    [self addSubview:wifiNetlab];
    [wifiNetlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(wifiNetImgv);
        make.centerY.mas_equalTo(Netlab);
    }];
    
    UILabel *wifiNoticelab = [[UILabel alloc]init];
    wifiNoticelab.font = [UIFont systemFontOfSize:9.0/375.0*WSCREEN];
    wifiNoticelab.textColor = ColorWithRGB(99, 99, 99);
    wifiNoticelab.textAlignment = NSTextAlignmentCenter;
    wifiNoticelab.text = @"(今日已用/本月已用)";
    [self addSubview:wifiNoticelab];
    [wifiNoticelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(wifiNetImgv);
        make.centerY.width.mas_equalTo(NetNoticelab);
    }];

    UIProgressView *progressView = [[UIProgressView alloc]init];
    self.progressView = progressView;
    [ShareTools ZScorner:progressView WithFlote:8.0/375.0*WSCREEN];
    progressView.progress = 0.5;
    [self addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20.0/375.0*WSCREEN);
        make.right.mas_equalTo(self).offset(-20.0/375.0*WSCREEN);
        make.bottom.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(20);
    }];
    if (dayCanUseData.longLongValue > 0) {
        self.progressView.progress = 1.0*dayCurrUseData.longLongValue/dayCanUseData.longLongValue;
        if (self.progressView.progress > 0.8) {
            self.progressView.progressTintColor = [UIColor redColor];
        }else{
            self.progressView.progressTintColor = [UIColor blueColor];
        }
    }else{
        self.progressView.progress = 0;
    }

    UILabel *netDayUselab = [[UILabel alloc]init];;
    self.netDayUselab = netDayUselab;
    netDayUselab.textAlignment = NSTextAlignmentCenter;
    netDayUselab.font = [UIFont systemFontOfSize:13.0/375.0*WSCREEN];
    netDayUselab.textColor = [UIColor whiteColor];
    netDayUselab.text = [NSString stringWithFormat:@"今日已用数据流量: %@",[ShareTools getFileSizeString:[dayCurrUseData longLongValue]]];
    if (dayCanUseData.intValue>0) {
        netDayUselab.text = [NSString stringWithFormat:@"今日已用数据流量: %@/%@",[ShareTools getFileSizeString:[dayCurrUseData longLongValue]],[ShareTools getFileSizeString:[dayCanUseData longLongValue]]];
    }
    [self addSubview:netDayUselab];
    [netDayUselab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(progressView);
        make.trailing.leading.mas_equalTo(progressView);
    }];
    
}

-(UILabel *)CreatLab{
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:12.0/375.0*WSCREEN];
    return lab;
}

-(void)setModel:(NetModel *)model{
    _model = model;
    NSString *dayCanUseData = @"未设置";
    NSString *dayCurrUseData = @"0";
    NSString *dayCurrUsewifiData = @"0";
    NSDictionary *currdict = [ShareTools getCurrDataLiuliang];
    if ([currdict objectForKey:@"netTotle"]) {
        NSString *str = [currdict objectForKey:@"netTotle"];
        dayCurrUseData = str;
    }
    if ([currdict objectForKey:@"wifiTotle"]) {
        NSString *str = [currdict objectForKey:@"wifiTotle"];
        dayCurrUsewifiData = [ShareTools getFileSizeString:[str longLongValue]];
    }
    id dic = [ShareTools ReadDicWithKey:CURRDAYCANUSE];
    if ([dic isKindOfClass:[NSString class]]) {
        dayCanUseData = dic;
    }
    self.upNetlab.text = model.upspace;
    self.downNetlab.text = model.downspace;
    self.Netlab.text = [NSString stringWithFormat:@"%@/%@",[ShareTools checkNetLiuliang],[ShareTools checkTotleNetLiuliang]];
    self.wifiNetlab.text = [NSString stringWithFormat:@"%@/%@",dayCurrUsewifiData,[ShareTools checkWifiLiuliang]];
    self.netDayUselab.text = [NSString stringWithFormat:@"今日已用数据流量: %@",[ShareTools getFileSizeString:[dayCurrUseData longLongValue]]];
    if (dayCanUseData.longLongValue > 0) {
        self.progressView.progress = 1.0*dayCurrUseData.longLongValue/dayCanUseData.longLongValue;
        if (self.progressView.progress > 0.8) {
            self.progressView.progressTintColor = [UIColor redColor];
        }else{
            self.progressView.progressTintColor = [UIColor blueColor];
        }
        self.netDayUselab.text = [NSString stringWithFormat:@"今日已用数据流量: %@/%@",[ShareTools getFileSizeString:[dayCurrUseData longLongValue]],[ShareTools getFileSizeString:[dayCanUseData longLongValue]]];
    }else{
        self.progressView.progress = 0;
    }
}


@end
