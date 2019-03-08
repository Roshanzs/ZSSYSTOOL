//
//  widgetView.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/19.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "widgetView.h"

@interface widgetView()

@property(nonatomic,strong)UILabel *upNetlab;
@property(nonatomic,strong)UILabel *downNetlab;
@property(nonatomic,strong)UILabel *Netlab;
@property(nonatomic,strong)UILabel *wifiNetlab;
@property(nonatomic,strong)UILabel *cpuhzlab;
@property(nonatomic,strong)UILabel *memorylab;
@property(nonatomic,strong)UILabel *disklab;
@property(nonatomic,strong)UILabel *wifinamelab;

@end

@implementation widgetView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIImageView *upNetImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"upnetimg"]];
    [self addSubview:upNetImgv];
    [upNetImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20.0/375.0*WSCREEN);
        make.top.mas_equalTo(self).offset(10);
        make.width.mas_equalTo(12.0/375.0*WSCREEN);
        make.height.mas_equalTo(upNetImgv.mas_width);
    }];
    
    UILabel *upNetlab = [self CreatLab];
    self.upNetlab = upNetlab;
    upNetlab.text = @"0B/s";
    [self addSubview:upNetlab];
    [upNetlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(upNetImgv);
        make.left.mas_equalTo(upNetImgv.mas_right).offset(10.0/375.0*WSCREEN);
    }];
    
    UIImageView *downNetImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downnetimg"]];
    [self addSubview:downNetImgv];
    [downNetImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(upNetImgv);
        make.centerY.mas_equalTo(self).offset(-12);
        make.size.mas_equalTo(upNetImgv);
    }];
    
    UILabel *downNetlab = [self CreatLab];
    self.downNetlab = downNetlab;
    downNetlab.text = @"0B/s";
    [self addSubview:downNetlab];
    [downNetlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(downNetImgv);
        make.leading.mas_equalTo(upNetlab);
    }];
    
    UIImageView *NetImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"4gnetimg"]];
    [self addSubview:NetImgv];
    [NetImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(upNetImgv);
        make.centerY.mas_equalTo(self).offset(12);
        make.size.mas_equalTo(upNetImgv);
    }];
    
    UILabel *Netlab = [self CreatLab];
    self.Netlab = Netlab;
    Netlab.text = [NSString stringWithFormat:@"%@/%@",[ShareTools checkNetLiuliang],[ShareTools checkTotleNetLiuliang]];
    [self addSubview:Netlab];
    [Netlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(NetImgv);
        make.leading.mas_equalTo(upNetlab);
    }];
    
    UIImageView *wifiNetImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wifinetimg"]];
    [self addSubview:wifiNetImgv];
    [wifiNetImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(upNetImgv);
        make.bottom.mas_equalTo(self).offset(-10);
        make.size.mas_equalTo(upNetImgv);
    }];
    
    UILabel *wifiNetlab = [self CreatLab];
    self.wifiNetlab = wifiNetlab;
    wifiNetlab.text = [ShareTools checkWifiLiuliang];
    [self addSubview:wifiNetlab];
    [wifiNetlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(wifiNetImgv);
        make.leading.mas_equalTo(upNetlab);
    }];
    
    
    UIView *marginv = [[UIView alloc]init];
    marginv.backgroundColor = ColorWithRGB(222, 222, 222);
    [self addSubview:marginv];
    [marginv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(20);
        make.bottom.mas_equalTo(self).offset(-20);
        make.width.mas_equalTo(1);
        make.centerX.mas_equalTo(self);
    }];
    
    
    UIImageView *wifinameImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wifinameimg"]];
    [self addSubview:wifinameImgv];
    [wifinameImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(marginv).offset(20.0/375.0*WSCREEN);
        make.centerY.mas_equalTo(upNetImgv);
        make.size.mas_equalTo(upNetImgv);
    }];
    
    UILabel *wifinamelab =  [self CreatLab];
    self.wifinamelab = wifinamelab;
    wifinamelab.text = [[NetWorkInfoTool sharedManager] getWifiName];
    [self addSubview:wifinamelab];
    [wifinamelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(wifinameImgv);
        make.left.mas_equalTo(wifinameImgv.mas_right).offset(10.0/375.0*WSCREEN);
        make.right.mas_equalTo(self).offset(-10.0/375.0*WSCREEN);
    }];
    
    UIImageView *cpuhzImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cpuimg"]];
    [self addSubview:cpuhzImgv];
    [cpuhzImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(wifinameImgv);
        make.centerY.mas_equalTo(downNetImgv);
        make.size.mas_equalTo(upNetImgv);
    }];
    
    UILabel *cpuhzlab =  [self CreatLab];
    self.cpuhzlab = cpuhzlab;
    cpuhzlab.text = [NSString stringWithFormat:@"%.1f%%/%ldMHz",[[DeviceDataTool sharedManager] getCPUUsage]*100,(long)[[DeviceDataTool sharedManager] getCpuMax]];
    [self addSubview:cpuhzlab];
    [cpuhzlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cpuhzImgv);
        make.trailing.leading.mas_equalTo(wifinamelab);
    }];
    
    UIImageView *memoryImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"memoryimg"]];
    [self addSubview:memoryImgv];
    [memoryImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(wifinameImgv);
        make.centerY.mas_equalTo(NetImgv);
        make.size.mas_equalTo(upNetImgv);
    }];
    
    UILabel *memorylab = [self CreatLab];
    self.memorylab = memorylab;
    memorylab.text = @"0M";
    [self addSubview:memorylab];
    [memorylab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(memoryImgv);
        make.trailing.leading.mas_equalTo(wifinamelab);
    }];
    
    UIImageView *diskImgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diskimg"]];
    [self addSubview:diskImgv];
    [diskImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(wifinameImgv);
        make.centerY.mas_equalTo(wifiNetImgv);
        make.size.mas_equalTo(upNetImgv);
    }];
    
    UILabel *disklab =  [self CreatLab];
    self.disklab = disklab;
    disklab.text = @"0M";
    [self addSubview:disklab];
    [disklab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(diskImgv);
        make.trailing.leading.mas_equalTo(wifinamelab);
    }];
    
}

-(UILabel *)CreatLab{
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:12.0/375.0*WSCREEN];
    return lab;
}

-(void)setModel:(NetModel *)model{
    _model = model;
    self.upNetlab.text = model.upspace;
    self.downNetlab.text = model.downspace;
    self.Netlab.text = [NSString stringWithFormat:@"%@/%@",[ShareTools checkNetLiuliang],[ShareTools checkTotleNetLiuliang]];
    self.wifiNetlab.text = [ShareTools checkWifiLiuliang];
    self.cpuhzlab.text = [NSString stringWithFormat:@"%.1f%%/%@",[[DeviceDataTool sharedManager] getCPUUsage]*100,model.CPUHZ];
    self.memorylab.text = model.memoryUse;
    self.disklab.text = model.diskUse;
    self.wifinamelab.text = [[NetWorkInfoTool sharedManager] getWifiName];
}

@end
