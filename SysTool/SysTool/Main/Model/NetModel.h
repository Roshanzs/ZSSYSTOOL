//
//  NetModel.h
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/15.
//  Copyright © 2018年 stark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetModel : NSObject

//上行速度
@property(nonatomic,strong)NSString *upspace;
//下行速度
@property(nonatomic,strong)NSString *downspace;
//当天已用数据流量
@property(nonatomic,strong)NSString *Use4gDayData;
//当天已用wifi流量
@property(nonatomic,strong)NSString *UseWifiDayData;
//当月已用数据流量
@property(nonatomic,strong)NSString *Use4gData;
//当月已用wifi流量
@property(nonatomic,strong)NSString *UseWifiData;
//cpu频率
@property(nonatomic,strong)NSString *CPUHZ;
//已用内存
@property(nonatomic,strong)NSString *memoryUse;
//已用磁盘
@property(nonatomic,strong)NSString *diskUse;
//IP
@property(nonatomic,strong)NSString *IPSTR;

+(instancetype)share;

@end

NS_ASSUME_NONNULL_END
