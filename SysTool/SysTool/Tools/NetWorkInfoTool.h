//
//  NetWorkInfoTool.h
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/13.
//  Copyright © 2018年 stark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWorkInfoTool : NSObject

+ (instancetype)sharedManager;

/** 获取外网ip */
-(void)getDeviceIPAddressesWithBlock:(void(^)(NSString *ipStr))ipBlock;
//获取局域网IP地址
- (NSString *)getIPAddresses;
//WIFI名称
- (NSString *)getWifiName;
//ipv6地址
- (NSString *)getIpAddressWIFI;

- (NSString *)getIpAddressCell;
/**是否连接了代理*/
+ (BOOL)ifConnectDelegate;
/*得到当前代理的配置 */
+ (NSDictionary *)getCurrentDelegateSettings;

/*WiFi状态下发送流量*/
- (NSString *)getWiFiSentFolwBytes;
/*WiFi状态下接收流量 */
- (NSString *)getWiFiReceivedFolwBytes;
/*WiFi状态下消耗总流量*/
- (NSString *)getWiFiTotalFolwBytes;
/*移动网络下发送流量*/
- (NSString *)getWWANSentFolwBytes;
/*移动网络下接收流量*/
- (NSString *)getWWANReceivedFolwBytes;
/*移动网络下消耗总流量*/
- (NSString *)getWWANTotalFolwBytes;
//每日消耗的流量
-(void)DayUseLiuliang;
//创建每日流量字典
+(NSDictionary *)DayUseDict;

@end

NS_ASSUME_NONNULL_END
