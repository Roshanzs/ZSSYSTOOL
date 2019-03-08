//
//  DeviceDataTool.h
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/13.
//  Copyright © 2018年 stark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceDataTool : NSObject

+ (instancetype)sharedManager;
/** 获取设备型号 */
- (NSString *)getDiviceName;
/// 获取iPhone名称
-(NSString *)getiPhoneName;
/// 当前系统名称
- (NSString *)getSystemName;
/// 当前系统版本号
- (NSString *)getSystemVersion;
//获取手机型号
- (NSString *)getDeviceModel;
/** 获取设备上次重启的时间 */
- (NSString *)getSystemUptime;
/**得到当前手机所属运营商名称，如果没有则为nil */
+ (NSString *)getCurrentPhoneOperatorName;
/**得到当前手机号的国家代码,如果没有则为nil*/
+ (NSString *)getCurrentISOCountryCode;
/**得到移动国家码*/
+ (NSString *)getMobileCountryCode;
/**得到屏幕亮度*/
- (CGFloat)getScreenBrightness;
/**屏幕分辨率*/
- (NSString *)screenResolution;
/**得到当前屏幕dpi*/
- (CGFloat)getScreenDpi;
/// 获取当前语言
+ (NSString *)getDeviceLanguage;
//获取时区
-(NSString *)getCurrentTime;
//获取当前国家代码
-(NSString *)getCurrentCountyNum;
/** 获取当前设备主存 */
- (NSUInteger)getRamSize;
/** 获取设备电池容量，单位 mA 毫安 */
- (NSInteger)getBatteryCapacity;
/** 获取电池电压，单位 V 福特 */
- (CGFloat)getBatterVolocity;


/**得到当前设备的核数*/
- (NSInteger)getNuclearCount;
/**得到当前设备活跃的核数*/
- (NSInteger)getActiveNuclearCount;
//获取CPU频率
- (void)getCPUFrequencyWithBlock:(void(^)(NSInteger freIntgeer))FrequencyBlock;
/** 获取总线程频率 */
- (NSUInteger)getBusFrequency;
//cup最高频率
-(NSInteger)getCpuMax;
/** 获取CPU处理器名称 */
- (const NSString *)getCPUProcessor;
/**是否支持多任务*/
- (BOOL)multitaskingSupported;
/**获取当前设置XNU内核版本*/
- (NSString *)getKernelVersion;
/**得到构建描述*/
- (NSString *)getDarwinBuildDescription;
/**得到当前操作系统名称*/
- (NSString *)getOSName;
/** 获取CPU总的使用百分比 */
- (float)getCPUUsage;
/** 获取单个CPU使用百分比 */
- (NSArray *)getPerCPUUsage;


/** 获取本 App 所占磁盘空间 */
- (NSString *)getApplicationSize;
/** 获取磁盘总空间 */
- (int64_t)getTotalDiskSpace;
/** 获取未使用的磁盘空间 */
- (int64_t)getFreeDiskSpace;
/** 获取已使用的磁盘空间 */
- (int64_t)getUsedDiskSpace;


/** 获取总内存空间 */
- (int64_t)getTotalMemory;
/** 获取活跃的内存空间 */
- (int64_t)getActiveMemory;
/** 获取不活跃的内存空间 */
- (int64_t)getInActiveMemory;
/** 获取空闲的内存空间 */
- (int64_t)getFreeMemory;
/** 获取正在使用的内存空间 */
- (int64_t)getUsedMemory;
/** 获取存放内核的内存空间 */
- (int64_t)getWiredMemory;
/** 获取可释放的内存空间 */
- (int64_t)getPurgableMemory;

@end

NS_ASSUME_NONNULL_END
