//
//  BatteryInfoTool.h
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/13.
//  Copyright © 2018年 stark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BatteryInfoDelegate
- (void)batteryStatusUpdated;
@end

@interface BatteryInfoTool : NSObject

@property (nonatomic, weak) id<BatteryInfoDelegate> delegate;

@property (nonatomic, assign) NSUInteger capacity;
@property (nonatomic, assign) CGFloat voltage;

@property (nonatomic, assign) NSUInteger levelPercent;
@property (nonatomic, assign) NSUInteger levelMAH;
@property (nonatomic, copy)   NSString *status; //电池状态

+ (instancetype)sharedManager;
/** 开始监测电池电量 */
- (void)startBatteryMonitoring;
/** 停止监测电池电量 */
- (void)stopBatteryMonitoring;
/**电池是否允许监控*/
- (BOOL)isAllowMonitorBattery;

@end

NS_ASSUME_NONNULL_END
