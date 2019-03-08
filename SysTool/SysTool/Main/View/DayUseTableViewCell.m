//
//  DayUseTableViewCell.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/16.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "DayUseTableViewCell.h"

@interface DayUseTableViewCell()
@property(nonatomic,strong)UILabel *timelab;
@property(nonatomic,strong)UILabel *wifiuplab;
@property(nonatomic,strong)UILabel *wifidownlab;
@property(nonatomic,strong)UILabel *wifilab;

@property(nonatomic,strong)UILabel *netuplab;
@property(nonatomic,strong)UILabel *netdownlab;
@property(nonatomic,strong)UILabel *netlab;

@end

@implementation DayUseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UILabel *timelab = [[UILabel alloc]init];
    timelab.textAlignment = NSTextAlignmentCenter;
    timelab.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
    timelab.textColor = ColorWithRGB(140, 140, 140);
    timelab.text = @"1993-04-08";
    self.timelab = timelab;
    [self.contentView addSubview:timelab];
    [timelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(WSCREEN/3.0);
    }];
    
    UILabel *wifilab = [[UILabel alloc]init];
    wifilab.textAlignment = NSTextAlignmentCenter;
    wifilab.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
    wifilab.text = @"0M";
    self.wifilab = wifilab;
    [self.contentView addSubview:wifilab];
    [wifilab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(timelab.mas_right);
        make.width.mas_equalTo(WSCREEN/6.0);
    }];
    
    UILabel *wifiuplab = [self Creatlab];
    wifiuplab.text = @"0M";
    self.wifiuplab = wifiuplab;
    [self.contentView addSubview:wifiuplab];
    [wifiuplab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView).offset(-10.0/667.0*HSCREEN);
        make.left.mas_equalTo(wifilab.mas_right);
        make.width.mas_equalTo(WSCREEN/6.0);
    }];
    
    UILabel *wifidownlab = [self Creatlab];
    wifidownlab.text = @"0M";
    self.wifidownlab = wifidownlab;
    [self.contentView addSubview:wifidownlab];
    [wifidownlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView).offset(10.0/667.0*HSCREEN);
        make.left.mas_equalTo(wifilab.mas_right);
        make.width.mas_equalTo(WSCREEN/6.0);
    }];
    
    UILabel *netlab = [[UILabel alloc]init];
    netlab.textAlignment = NSTextAlignmentCenter;
    netlab.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
    netlab.text = @"0M";
    self.netlab = netlab;
    [self.contentView addSubview:netlab];
    [netlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(WSCREEN/3.0*2.0);
        make.width.mas_equalTo(WSCREEN/6.0);
    }];
    
    UILabel *netuplab = [self Creatlab];
    netuplab.text = @"0M";
    self.netuplab = netuplab;
    [self.contentView addSubview:netuplab];
    [netuplab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView).offset(-10.0/667.0*HSCREEN);
        make.left.mas_equalTo(netlab.mas_right);
        make.width.mas_equalTo(WSCREEN/6.0);
    }];
    
    UILabel *netdownlab = [self Creatlab];
    netdownlab.text = @"0M";
    self.netdownlab = netdownlab;
    [self.contentView addSubview:netdownlab];
    [netdownlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView).offset(10.0/667.0*HSCREEN);
        make.left.mas_equalTo(netlab.mas_right);
        make.width.mas_equalTo(WSCREEN/6.0);
    }];
    
}

-(void)setModel:(DayUseModel *)model{
    _model = model;
    self.timelab.text = model.daytime;
    self.wifilab.text = [ShareTools getFileSizeString:model.wifiTotle.longLongValue];
    self.wifiuplab.text = [NSString stringWithFormat:@"↑ %@",[ShareTools getFileSizeString:model.wifiup.longLongValue]];
    self.wifidownlab.text = [NSString stringWithFormat:@"↓ %@",[ShareTools getFileSizeString:model.wifidown.longLongValue]];

    self.netlab.text = [ShareTools getFileSizeString:model.netTotle.longLongValue];
    self.netuplab.text = [NSString stringWithFormat:@"↑ %@",[ShareTools getFileSizeString:model.netup.longLongValue]];
    self.netdownlab.text = [NSString stringWithFormat:@"↓ %@",[ShareTools getFileSizeString:model.netdown.longLongValue]];

}

-(UILabel *)Creatlab{
    UILabel *lab = [[UILabel alloc]init];
    lab.textColor = ColorWithRGB(140, 140, 140);
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont systemFontOfSize:11.0/375.0*WSCREEN];
    return lab;
}

@end
