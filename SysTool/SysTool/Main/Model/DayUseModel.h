//
//  DayUseModel.h
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/16.
//  Copyright © 2018年 stark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DayUseModel : NSObject
//时间
@property(nonatomic,strong)NSString *daytime;
//流量组
@property(nonatomic,strong)NSDictionary *liuliangNum;
//wifi上行流量
@property(nonatomic,strong)NSString *wifiup;
//wifi下行流量
@property(nonatomic,strong)NSString *wifidown;
//wifi总流量
@property(nonatomic,strong)NSString *wifiTotle;
//数据上行流量
@property(nonatomic,strong)NSString *netup;
//数据下行流量
@property(nonatomic,strong)NSString *netdown;
//数据总流量
@property(nonatomic,strong)NSString *netTotle;

+(instancetype)modelWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
