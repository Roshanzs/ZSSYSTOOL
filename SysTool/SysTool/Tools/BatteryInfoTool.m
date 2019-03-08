//
//  BatteryInfoTool.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/13.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "BatteryInfoTool.h"
#import "DeviceDataTool.h"

@interface BatteryInfoTool ()

@property (nonatomic, assign) BOOL batteryMonitoringEnabled;

@end

@implementation BatteryInfoTool

+ (instancetype)sharedManager {
    static BatteryInfoTool *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[BatteryInfoTool alloc] init];
    });
    return _manager;
}

- (void)startBatteryMonitoring {
    if (!self.batteryMonitoringEnabled) {
        self.batteryMonitoringEnabled = YES;
        UIDevice *device = [UIDevice currentDevice];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_batteryLevelUpdatedCB:)
                                                     name:UIDeviceBatteryLevelDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_batteryStatusUpdatedCB:)
                                                     name:UIDeviceBatteryStateDidChangeNotification
                                                   object:nil];
        
        [device setBatteryMonitoringEnabled:YES];
        // If by any chance battery value is available - update it immediately
        if ([device batteryState] != UIDeviceBatteryStateUnknown) {
            [self _doUpdateBatteryStatus];
        }
    }
}

- (void)stopBatteryMonitoring {
    if (self.batteryMonitoringEnabled) {
        self.batteryMonitoringEnabled = NO;
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark - Private Method

- (void)_batteryLevelUpdatedCB:(NSNotification*)notification {
    [self _doUpdateBatteryStatus];
}

- (void)_batteryStatusUpdatedCB:(NSNotification*)notification {
    [self _doUpdateBatteryStatus];
}

- (void)_doUpdateBatteryStatus {
    float batteryMultiplier = [[UIDevice currentDevice] batteryLevel];
    self.levelPercent = batteryMultiplier * 100;
    self.levelMAH =  self.capacity * batteryMultiplier;
    switch ([[UIDevice currentDevice] batteryState]) {
        case UIDeviceBatteryStateCharging:
            if (self.levelPercent == 100) {
                self.status = @"已充满";
            } else {
                self.status = @"充电中";
            }
            break;
        case UIDeviceBatteryStateFull:
            self.status = @"已充满";
            break;
        case UIDeviceBatteryStateUnplugged:
            self.status = @"没充电";
            break;
        case UIDeviceBatteryStateUnknown:
            self.status = @"未知";
            break;
    }
    
    [self.delegate batteryStatusUpdated];
}

- (BOOL)isAllowMonitorBattery {
    return [UIDevice currentDevice].isBatteryMonitoringEnabled;
}

#pragma mark - Setters && Getters
- (CGFloat)voltage {
    return [[DeviceDataTool sharedManager] getBatterVolocity];
}

- (NSUInteger)capacity {
    return [[DeviceDataTool sharedManager] getBatteryCapacity];
}


@end
