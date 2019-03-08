//
//  DeviceInfoTool.h
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/13.
//  Copyright © 2018年 stark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfoTool : NSObject
/** 能否打电话 */
@property (nonatomic, assign, readonly) BOOL canMakePhoneCall NS_EXTENSION_UNAVAILABLE_IOS("");

+ (instancetype)sharedManager;

- (NSString *)getDeviceModel;
/** 获取设备上次重启的时间 */
- (NSDate *)getSystemUptime;
- (NSUInteger)getCPUFrequency;
/** 获取总线程频率 */
- (NSUInteger)getBusFrequency;
/** 获取当前设备主存 */
- (NSUInteger)getRamSize;

- (NSString *)getCPUProcessor;
/** 获取CPU数量 */
- (NSUInteger)getCPUCount;
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
@end

NS_ASSUME_NONNULL_END
