//
//  ShareTools.h
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/14.
//  Copyright © 2018年 stark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShareTools : NSObject

//上行速度
@property(nonatomic,strong)NSString *upspace;
//下行速度
@property(nonatomic,strong)NSString *downspace;
//网络状态
@property(nonatomic,strong)NSString *netType;
//wifi状态
@property(nonatomic,strong)NSString *wifiType;
//已用4g流量
@property(nonatomic,strong)NSString *Use4gData;
//已用wifi流量
@property(nonatomic,strong)NSString *UseWifiData;

+(instancetype)share;
//切割圆角
+(void)ZScorner:(UIView *)obj WithFlote:(CGFloat)Radius;
//app版本
+ (NSString *)getVersionNum;
// 时间戳转化为时间
+ (NSString *)creatTimeFromDate;
//内存转M
+(NSString *)getFileSizeString:(long long)size;
+(NSString *)formatBandWidth:(unsigned long long)size;
//状态储存
+(BOOL)SaveStateWithValue:(id)Value WithKey:(NSString *)key;
//读取状态
+(id)ReadDicWithKey:(NSString *)key;

//每日流量的读取
+(NSArray*)DayUseEveryData;
//更新当天流量
+(BOOL)DayUseDataUpdateWithDict:(NSDictionary *)dict;

//当天使用的流量详情
//+(NSDictionary *)checkDataCurrData;
//实时获取当天数据
+(NSDictionary *)getCurrDataLiuliang;

//校验后的移动数据已使用流量
+(NSString *)checkNetLiuliang;
//校验后的Wifi已使用流量
+(NSString *)checkWifiLiuliang;
//校验后的总移动数据流量
+(NSString *)checkTotleNetLiuliang;
// 获取当前时间
+ (NSString *)getNowTimeFromDate;

//流量清零
+(BOOL)MonthClearLiuliangData;

//创建数据库
+(void)CreatDBdate;

//快捷打开数组
+(NSDictionary *)openUrlArrDic;
//顶部的打开数组个数
+(NSString *)openState;
//限制显示的只有五个
+(void)limiteFive;
//移动了openurl
+(void)changeOpenUrlArrWithFrom:(NSInteger)Fint To:(NSInteger)Tint WithisAdd:(int)isadd;

//获取常用的openurl
+(NSArray *)openUrlNormalArrDic;

//添加openurl
+(void)addOpenUrlWithArr:(NSArray *)arr;

//添加观看广告次数
+(void)AddADWithid:(NSString *)typeid WithNum:(NSString *)num;
//获取观看广告次数
+(NSString *)ChackADWithid:(NSString *)typeid;

@end

NS_ASSUME_NONNULL_END
