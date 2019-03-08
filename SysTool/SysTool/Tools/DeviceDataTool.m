//
//  DeviceDataTool.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/13.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "DeviceDataTool.h"

#import "sys/utsname.h"
#import <AdSupport/AdSupport.h>
#include <sys/sysctl.h>
#include <mach/mach.h> // 获取CPU信息所需要引入的头文件
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>



// 设备型号的枚举值
typedef NS_ENUM(NSUInteger, DiviceType) {
    iPhone_1G = 0,
    iPhone_3G,
    iPhone_3GS,
    iPhone_4,
    iPhone_4_Verizon,
    iPhone_4S,
    iPhone_5_GSM,
    iPhone_5_CDMA,
    iPhone_5C_GSM,
    iPhone_5C_GSM_CDMA,
    iPhone_5S_GSM,
    iPhone_5S_GSM_CDMA,
    iPhone_6,
    iPhone_6_Plus,
    iPhone_6S,
    iPhone_6S_Plus,
    iPhone_SE,
    Chinese_iPhone_7,
    Chinese_iPhone_7_Plus,
    American_iPhone_7,
    American_iPhone_7_Plus,
    Chinese_iPhone_8,
    Chinese_iPhone_8_Plus,
    Chinese_iPhone_X,
    Global_iPhone_8,
    Global_iPhone_8_Plus,
    Global_iPhone_X,
    iPhone_XS,
    iPhone_XS_Max,
    iPhone_XR,
    
    iPod_Touch_1G,
    iPod_Touch_2G,
    iPod_Touch_3G,
    iPod_Touch_4G,
    iPod_Touch_5Gen,
    iPod_Touch_6G,
    
    iPad_1,
    iPad_3G,
    iPad_2_WiFi,
    iPad_2_GSM,
    iPad_2_CDMA,
    iPad_3_WiFi,
    iPad_3_GSM,
    iPad_3_CDMA,
    iPad_3_GSM_CDMA,
    iPad_4_WiFi,
    iPad_4_GSM,
    iPad_4_CDMA,
    iPad_4_GSM_CDMA,
    iPad_Air,
    iPad_Air_Cellular,
    iPad_Air_2_WiFi,
    iPad_Air_2_Cellular,
    iPad_Pro_97inch_WiFi,
    iPad_Pro_97inch_Cellular,
    iPad_Pro_129inch_WiFi,
    iPad_Pro_129inch_Cellular,
    iPad_Mini,
    iPad_Mini_WiFi,
    iPad_Mini_GSM,
    iPad_Mini_CDMA,
    iPad_Mini_GSM_CDMA,
    iPad_Mini_2,
    iPad_Mini_2_Cellular,
    iPad_Mini_3_WiFi,
    iPad_Mini_3_Cellular,
    iPad_Mini_4_WiFi,
    iPad_Mini_4_Cellular,
    iPad_5_WiFi,
    iPad_5_Cellular,
    iPad_Pro_129inch_2nd_gen_WiFi,
    iPad_Pro_129inch_2nd_gen_Cellular,
    iPad_Pro_105inch_WiFi,
    iPad_Pro_105inch_Cellular,
    iPad_6,
    
    appleTV2,
    appleTV3,
    appleTV4,
    
    i386Simulator,
    x86_64Simulator,
    
    iUnknown,
};

static NSString * const kMachine = @"machine";
static NSString * const kNodeName = @"nodename";
static NSString * const kRelease = @"release";
static NSString * const kSysName = @"sysname";
static NSString * const kVersion = @"version";

@interface DeviceDataTool()

@property (nonatomic, assign) DiviceType iDevice;
@property (nonatomic,strong)NSDictionary *utsNameDic;
@property (nonatomic,strong)NSProcessInfo *processInfo;
@property (nonatomic,strong)UIScreen *screen;

@end

@implementation DeviceDataTool

+(instancetype)sharedManager {
    static DeviceDataTool *manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[DeviceDataTool alloc] init];
        manger.iDevice = [self transformMachineToIdevice];
    });
    return manger;
}

- (NSString *)getDiviceName {
    return iDeviceNameContainer[self.iDevice];
}

/// 获取iPhone名称
- (NSString *)getiPhoneName {
    return [UIDevice currentDevice].name;
}

- (NSString *)getDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceModel;
}

- (NSString *)getSystemUptime {
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
//    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
//    time = now - time;
//    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];//直接指定时区，这里是东8区
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
//    NSString *dateString = [dateFormatter stringFromDate:date];
    int d = time / (3600*24);
    time = time - d*3600*24;
    CGFloat h = time / 3600;
    NSString *dateString = [NSString stringWithFormat:@"%.0d天%.0f小时",d,h];
    return dateString;
}

- (NSUInteger)getBusFrequency {
    return [self _getSystemInfo:HW_BUS_FREQ];
}

- (NSUInteger)getRamSize {
    return [self _getSystemInfo:HW_MEMSIZE];
}

//- (float)getCPUUsage {
//    float cpu = 0;
//    NSArray *cpus = [self getPerCPUUsage];
//    if (cpus.count == 0) return -1;
//    for (NSNumber *n in cpus) {
//        cpu += n.floatValue;
//    }
//    return cpu;
//}

- (NSArray *)getPerCPUUsage {
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        NSMutableArray *cpus = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    } else {
        return @[];
    }
}


#pragma mark - Disk
- (NSString *)getApplicationSize {
    unsigned long long documentSize   =  [self _getSizeOfFolder:[self _getDocumentPath]];
    unsigned long long librarySize   =  [self _getSizeOfFolder:[self _getLibraryPath]];
    unsigned long long cacheSize =  [self _getSizeOfFolder:[self _getCachePath]];
    
    unsigned long long total = documentSize + librarySize + cacheSize;
    
    NSString *applicationSize = [NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleFile];
    return applicationSize;
}

- (int64_t)getTotalDiskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)getFreeDiskSpace {
    
    //    if (@available(iOS 11.0, *)) {
    //        NSError *error = nil;
    //        NSURL *testURL = [NSURL URLWithString:NSHomeDirectory()];
    //
    //        NSDictionary *dict = [testURL resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:&error];
    //
    //        return (int64_t)dict[NSURLVolumeAvailableCapacityForImportantUsageKey];
    //
    //
    //    } else {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
    //    }
    
}

- (int64_t)getUsedDiskSpace {
    int64_t totalDisk = [self getTotalDiskSpace];
    int64_t freeDisk = [self getFreeDiskSpace];
    if (totalDisk < 0 || freeDisk < 0) return -1;
    int64_t usedDisk = totalDisk - freeDisk;
    if (usedDisk < 0) usedDisk = -1;
    return usedDisk;
}

#pragma mark - Memory
- (int64_t)getTotalMemory {
    int64_t totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    if (totalMemory < -1) totalMemory = -1;
    return totalMemory;
}

- (int64_t)getActiveMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.active_count * page_size;
}

- (int64_t)getInActiveMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.inactive_count * page_size;
}

- (int64_t)getFreeMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}

- (int64_t)getUsedMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}

- (int64_t)getWiredMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.wire_count * page_size;
}

- (int64_t)getPurgableMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.purgeable_count * page_size;
}

- (NSInteger)getBatteryCapacity {
    return BatteryCapacityContainer[self.iDevice];
}

- (CGFloat)getBatterVolocity {
    return BatteryVoltageContainer[self.iDevice];
}

- (const NSString *)getCPUProcessor {
    return CPUNameContainer[self.iDevice];
}

-(NSInteger)getCpuMax{
    return CPUFrequencyContainer[self.iDevice];
}

#pragma mark - Private Method
+ (DiviceType)transformMachineToIdevice{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    
    if ([machineString isEqualToString:@"iPhone1,1"])   return iPhone_1G;
    if ([machineString isEqualToString:@"iPhone1,2"])   return iPhone_3G;
    if ([machineString isEqualToString:@"iPhone2,1"])   return iPhone_3GS;
    if ([machineString isEqualToString:@"iPhone3,1"])   return iPhone_4;
    if ([machineString isEqualToString:@"iPhone3,3"])   return iPhone_4_Verizon;
    if ([machineString isEqualToString:@"iPhone4,1"])   return iPhone_4S;
    if ([machineString isEqualToString:@"iPhone5,1"])   return iPhone_5_GSM;
    if ([machineString isEqualToString:@"iPhone5,2"])   return iPhone_5_CDMA;
    if ([machineString isEqualToString:@"iPhone5,3"])   return iPhone_5C_GSM;
    if ([machineString isEqualToString:@"iPhone5,4"])   return iPhone_5C_GSM_CDMA;
    if ([machineString isEqualToString:@"iPhone6,1"])   return iPhone_5S_GSM;
    if ([machineString isEqualToString:@"iPhone6,2"])   return iPhone_5S_GSM_CDMA;
    if ([machineString isEqualToString:@"iPhone7,2"])   return iPhone_6;
    if ([machineString isEqualToString:@"iPhone7,1"])   return iPhone_6_Plus;
    if ([machineString isEqualToString:@"iPhone8,1"])   return iPhone_6S;
    if ([machineString isEqualToString:@"iPhone8,2"])   return iPhone_6S_Plus;
    if ([machineString isEqualToString:@"iPhone8,4"])   return iPhone_SE;
    
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([machineString isEqualToString:@"iPhone9,1"])   return Chinese_iPhone_7;
    if ([machineString isEqualToString:@"iPhone9,2"])   return Chinese_iPhone_7_Plus;
    if ([machineString isEqualToString:@"iPhone9,3"])   return American_iPhone_7;
    if ([machineString isEqualToString:@"iPhone9,4"])   return American_iPhone_7_Plus;
    if ([machineString isEqualToString:@"iPhone10,1"])  return Chinese_iPhone_8;
    if ([machineString isEqualToString:@"iPhone10,4"])  return Global_iPhone_8;
    if ([machineString isEqualToString:@"iPhone10,2"])  return Chinese_iPhone_8_Plus;
    if ([machineString isEqualToString:@"iPhone10,5"])  return Global_iPhone_8_Plus;
    if ([machineString isEqualToString:@"iPhone10,3"])  return Chinese_iPhone_X;
    if ([machineString isEqualToString:@"iPhone10,6"])  return Global_iPhone_X;
    if ([machineString isEqualToString:@"iPhone11,2"])  return iPhone_XS;
    if ([machineString isEqualToString:@"iPhone11,4"] || [machineString isEqualToString:@"iPhone11,6"])  return iPhone_XS_Max;
    if ([machineString isEqualToString:@"iPhone11,8"])  return iPhone_XR;
    
    if ([machineString isEqualToString:@"iPod1,1"])     return iPod_Touch_1G;
    if ([machineString isEqualToString:@"iPod2,1"])     return iPod_Touch_2G;
    if ([machineString isEqualToString:@"iPod3,1"])     return iPod_Touch_3G;
    if ([machineString isEqualToString:@"iPod4,1"])     return iPod_Touch_4G;
    if ([machineString isEqualToString:@"iPod5,1"])     return iPod_Touch_5Gen;
    if ([machineString isEqualToString:@"iPod7,1"])     return iPod_Touch_6G;
    
    if ([machineString isEqualToString:@"iPad1,1"])     return iPad_1;
    if ([machineString isEqualToString:@"iPad1,2"])     return iPad_3G;
    if ([machineString isEqualToString:@"iPad2,1"])     return iPad_2_WiFi;
    if ([machineString isEqualToString:@"iPad2,2"])     return iPad_2_GSM;
    if ([machineString isEqualToString:@"iPad2,3"])     return iPad_2_CDMA;
    if ([machineString isEqualToString:@"iPad2,4"])     return iPad_2_CDMA;
    if ([machineString isEqualToString:@"iPad2,5"])     return iPad_Mini_WiFi;
    if ([machineString isEqualToString:@"iPad2,6"])     return iPad_Mini_GSM;
    if ([machineString isEqualToString:@"iPad2,7"])     return iPad_Mini_CDMA;
    if ([machineString isEqualToString:@"iPad3,1"])     return iPad_3_WiFi;
    if ([machineString isEqualToString:@"iPad3,2"])     return iPad_3_GSM;
    if ([machineString isEqualToString:@"iPad3,3"])     return iPad_3_CDMA;
    if ([machineString isEqualToString:@"iPad3,4"])     return iPad_4_WiFi;
    if ([machineString isEqualToString:@"iPad3,5"])     return iPad_4_GSM;
    if ([machineString isEqualToString:@"iPad3,6"])     return iPad_4_CDMA;
    if ([machineString isEqualToString:@"iPad4,1"])     return iPad_Air;
    if ([machineString isEqualToString:@"iPad4,2"])     return iPad_Air_Cellular;
    if ([machineString isEqualToString:@"iPad4,4"])     return iPad_Mini_2;
    if ([machineString isEqualToString:@"iPad4,5"])     return iPad_Mini_2_Cellular;
    if ([machineString isEqualToString:@"iPad4,7"])     return iPad_Mini_3_WiFi;
    if ([machineString isEqualToString:@"iPad4,8"])     return iPad_Mini_3_Cellular;
    if ([machineString isEqualToString:@"iPad4,9"])     return iPad_Mini_3_Cellular;
    if ([machineString isEqualToString:@"iPad5,1"])     return iPad_Mini_4_WiFi;
    if ([machineString isEqualToString:@"iPad5,2"])     return iPad_Mini_4_Cellular;
    
    if ([machineString isEqualToString:@"iPad5,3"])     return iPad_Air_2_WiFi;
    if ([machineString isEqualToString:@"iPad5,4"])     return iPad_Air_2_Cellular;
    if ([machineString isEqualToString:@"iPad6,3"])     return iPad_Pro_97inch_WiFi;
    if ([machineString isEqualToString:@"iPad6,4"])     return iPad_Pro_97inch_Cellular;
    if ([machineString isEqualToString:@"iPad6,7"])     return iPad_Pro_129inch_WiFi;
    if ([machineString isEqualToString:@"iPad6,8"])     return iPad_Pro_129inch_Cellular;
    
    if ([machineString isEqualToString:@"iPad6,11"])    return iPad_5_WiFi;
    if ([machineString isEqualToString:@"iPad6,12"])    return iPad_5_Cellular;
    if ([machineString isEqualToString:@"iPad7,1"])     return iPad_Pro_129inch_2nd_gen_WiFi;
    if ([machineString isEqualToString:@"iPad7,2"])     return iPad_Pro_129inch_2nd_gen_Cellular;
    if ([machineString isEqualToString:@"iPad7,3"])     return iPad_Pro_105inch_WiFi;
    if ([machineString isEqualToString:@"iPad7,4"])     return iPad_Pro_105inch_Cellular;
    if ([machineString isEqualToString:@"iPad7,6"])     return iPad_6;
    
    if ([machineString isEqualToString:@"AppleTV2,1"])  return appleTV2;
    if ([machineString isEqualToString:@"AppleTV3,1"])  return appleTV3;
    if ([machineString isEqualToString:@"AppleTV3,2"])  return appleTV3;
    if ([machineString isEqualToString:@"AppleTV5,3"])  return appleTV4;
    
    if ([machineString isEqualToString:@"i386"])        return i386Simulator;
    if ([machineString isEqualToString:@"x86_64"])      return x86_64Simulator;
    
    return iUnknown;
}

#pragma Containers
static NSString *iDeviceNameContainer[] = {
    [iPhone_1G]                 = @"iPhone 1G",
    [iPhone_3G]                 = @"iPhone 3G",
    [iPhone_3GS]                = @"iPhone 3GS",
    [iPhone_4]                  = @"iPhone 4",
    [iPhone_4_Verizon]          = @"Verizon iPhone 4",
    [iPhone_4S]                 = @"iPhone 4S",
    [iPhone_5_GSM]              = @"iPhone 5 (GSM)",
    [iPhone_5_CDMA]             = @"iPhone 5 (CDMA)",
    [iPhone_5C_GSM]             = @"iPhone 5C (GSM)",
    [iPhone_5C_GSM_CDMA]        = @"iPhone 5C (GSM+CDMA)",
    [iPhone_5S_GSM]             = @"iPhone 5S (GSM)",
    [iPhone_5S_GSM_CDMA]        = @"iPhone 5S (GSM+CDMA)",
    [iPhone_6]                  = @"iPhone 6",
    [iPhone_6_Plus]             = @"iPhone 6 Plus",
    [iPhone_6S]                 = @"iPhone 6S",
    [iPhone_6S_Plus]            = @"iPhone 6S Plus",
    [iPhone_SE]                 = @"iPhone SE",
    [Chinese_iPhone_7]          = @"国行/日版/港行 iPhone 7",
    [Chinese_iPhone_7_Plus]     = @"港行/国行 iPhone 7 Plus",
    [American_iPhone_7]         = @"美版/台版 iPhone 7",
    [American_iPhone_7_Plus]    = @"美版/台版 iPhone 7 Plus",
    [Chinese_iPhone_8]          = @"国行/日版 iPhone 8",
    [Chinese_iPhone_8_Plus]     = @"国行/日版 iPhone 8 Plus",
    [Chinese_iPhone_X]          = @"国行/日版 iPhone X",
    [Global_iPhone_8]           = @"美版(Global) iPhone 8",
    [Global_iPhone_8_Plus]      = @"美版(Global) iPhone 8 Plus",
    [Global_iPhone_X]           = @"美版(Global) iPhone X",
    [iPhone_XS]                 = @"iPhone XS",
    [iPhone_XS_Max]             = @"iPhone XS Max",
    [iPhone_XR]                 = @"iPhone XR",
    
    [iPod_Touch_1G]             = @"iPod Touch 1G",
    [iPod_Touch_2G]             = @"iPod Touch 2G",
    [iPod_Touch_3G]             = @"iPod Touch 3G",
    [iPod_Touch_4G]             = @"iPod Touch 4G",
    [iPod_Touch_5Gen]           = @"iPod Touch 5(Gen)",
    [iPod_Touch_6G]             = @"iPod Touch 6G",
    [iPad_1]                    = @"iPad 1",
    [iPad_3G]                   = @"iPad 3G",
    [iPad_2_CDMA]               = @"iPad 2 (GSM)",
    [iPad_2_GSM]                = @"iPad 2 (CDMA)",
    [iPad_2_WiFi]               = @"iPad 2 (WiFi)",
    [iPad_3_WiFi]               = @"iPad 3 (WiFi)",
    [iPad_3_GSM]                = @"iPad 3 (GSM)",
    [iPad_3_CDMA]               = @"iPad 3 (CDMA)",
    [iPad_3_GSM_CDMA]           = @"iPad 3 (GSM+CDMA)",
    [iPad_4_WiFi]               = @"iPad 4 (WiFi)",
    [iPad_4_GSM]                = @"iPad 4 (GSM)",
    [iPad_4_CDMA]               = @"iPad 4 (CDMA)",
    [iPad_4_GSM_CDMA]           = @"iPad 4 (GSM+CDMA)",
    [iPad_Air]                  = @"iPad Air",
    [iPad_Air_Cellular]         = @"iPad Air (Cellular)",
    [iPad_Air_2_WiFi]           = @"iPad Air 2 (WiFi)",
    [iPad_Air_2_Cellular]       = @"iPad Air 2 (Cellular)",
    [iPad_Mini_WiFi]            = @"iPad Mini (WiFi)",
    [iPad_Mini_GSM]             = @"iPad Mini (GSM)",
    [iPad_Mini_CDMA]            = @"iPad Mini (CDMA)",
    [iPad_Mini_2]               = @"iPad Mini 2",
    [iPad_Mini_2_Cellular]      = @"iPad Mini 2 (Cellular)",
    [iPad_Mini_3_WiFi]          = @"iPad Mini 3 (WiFi)",
    [iPad_Mini_3_Cellular]      = @"iPad Mini 3 (Cellular)",
    [iPad_Mini_4_WiFi]          = @"iPad Mini 4 (WiFi)",
    [iPad_Mini_4_Cellular]      = @"iPad Mini 4 (Cellular)",
    
    [iPad_Pro_97inch_WiFi]      = @"iPad Pro 9.7 inch(WiFi)",
    [iPad_Pro_97inch_Cellular]  = @"iPad Pro 9.7 inch(Cellular)",
    [iPad_Pro_129inch_WiFi]     = @"iPad Pro 12.9 inch(WiFi)",
    [iPad_Pro_129inch_Cellular] = @"iPad Pro 12.9 inch(Cellular)",
    [iPad_5_WiFi]               = @"iPad 5(WiFi)",
    [iPad_5_Cellular]           = @"iPad 5(Cellular)",
    [iPad_Pro_129inch_2nd_gen_WiFi]     = @"iPad Pro 12.9 inch(2nd generation)(WiFi)",
    [iPad_Pro_129inch_2nd_gen_Cellular] = @"iPad Pro 12.9 inch(2nd generation)(Cellular)",
    [iPad_Pro_105inch_WiFi]             = @"iPad Pro 10.5 inch(WiFi)",
    [iPad_Pro_105inch_Cellular]         = @"iPad Pro 10.5 inch(Cellular)",
    [iPad_6]                            = @"iPad 6",
    
    [appleTV2]                  = @"appleTV2",
    [appleTV3]                  = @"appleTV3",
    [appleTV4]                  = @"appleTV4",
    
    [i386Simulator]             = @"i386Simulator",
    [x86_64Simulator]           = @"x86_64Simulator",
    
    [iUnknown]                  = @"Unknown"
};

// 电池容量，单位mA
static const NSUInteger BatteryCapacityContainer[] = {
    [iPhone_1G]                 = 1400,
    [iPhone_3G]                 = 1150,
    [iPhone_3GS]                = 1219,
    [iPhone_4]                  = 1420,
    [iPhone_4_Verizon]          = 1420,
    [iPhone_4S]                 = 1430,
    [iPhone_5_GSM]              = 1440,
    [iPhone_5_CDMA]             = 1440,
    [iPhone_5C_GSM]             = 1507,
    [iPhone_5S_GSM_CDMA]        = 1570,
    [iPhone_6]                  = 1810,
    [iPhone_6_Plus]             = 2915,
    [iPhone_6S]                 = 1715,
    [iPhone_6S_Plus]            = 2750,
    [iPhone_SE]                 = 1624,
    [Chinese_iPhone_7]          = 1960,
    [American_iPhone_7]         = 1960,
    [Chinese_iPhone_7_Plus]     = 2900,
    [American_iPhone_7_Plus]    = 2900,
    [Chinese_iPhone_8]          = 1821,
    [Global_iPhone_8]           = 1821,
    [Chinese_iPhone_8_Plus]     = 2691,
    [Global_iPhone_8_Plus]      = 2691,
    [Chinese_iPhone_X]          = 2716,
    [Global_iPhone_X]           = 2716,
    [iPhone_XS]                 = 2658,
    [iPhone_XS_Max]             = 3174,
    [iPhone_XR]                 = 2942,
    
    [iPod_Touch_1G]             = 789,
    [iPod_Touch_2G]             = 789,
    [iPod_Touch_3G]             = 930,
    [iPod_Touch_4G]             = 930,
    [iPod_Touch_5Gen]           = 1030,
    [iPod_Touch_6G]             = 1043,
    [iPad_1]                    = 6613,
    [iPad_2_CDMA]               = 6930,
    [iPad_2_GSM]                = 6930,
    [iPad_2_WiFi]               = 6930,
    [iPad_3_WiFi]               = 11560,
    [iPad_3_GSM]                = 11560,
    [iPad_3_CDMA]               = 11560,
    [iPad_4_WiFi]               = 11560,
    [iPad_4_GSM]                = 11560,
    [iPad_4_CDMA]               = 11560,
    [iPad_Air]                  = 8827,
    [iPad_Air_Cellular]         = 8827,
    [iPad_Air_2_WiFi]           = 7340,
    [iPad_Air_2_Cellular]       = 7340,
    [iPad_Mini_WiFi]            = 4440,
    [iPad_Mini_GSM]             = 4440,
    [iPad_Mini_CDMA]            = 4440,
    [iPad_Mini_2]               = 6471,
    [iPad_Mini_2_Cellular]      = 6471,
    [iPad_Mini_3_WiFi]          = 6471,
    [iPad_Mini_3_Cellular]      = 6471,
    [iPad_Mini_4_WiFi]          = 5124,
    [iPad_Mini_4_Cellular]      = 5124,
    
    [iPad_Pro_97inch_WiFi]      = 7306,
    [iPad_Pro_97inch_Cellular]  = 7306,
    [iPad_Pro_129inch_WiFi]     = 10307,
    [iPad_Pro_129inch_Cellular] = 10307,
    [iPad_5_WiFi]               = 8820,
    [iPad_5_Cellular]           = 8820,
    [iPad_Pro_105inch_WiFi]     = 8134,
    [iPad_Pro_105inch_Cellular] = 8134,
    [iPad_6]                    = 8820,
    
    [iUnknown]                  = 0
};

// 电池电压：单位V
static const CGFloat BatteryVoltageContainer[] = {
    [iPhone_1G]                 = 3.7,
    [iPhone_3G]                 = 3.7,
    [iPhone_3GS]                = 3.7,
    [iPhone_4]                  = 3.7,
    [iPhone_4_Verizon]          = 3.7,
    [iPhone_4S]                 = 3.7,
    [iPhone_5_GSM]              = 3.8,
    [iPhone_5_CDMA]             = 3.8,
    [iPhone_5C_GSM]             = 3.8,
    [iPhone_5C_GSM_CDMA]        = 3.8,
    [iPhone_5S_GSM]             = 3.8,
    [iPhone_5S_GSM_CDMA]        = 3.8,
    [iPhone_6]                  = 3.82,
    [iPhone_6_Plus]             = 3.82,
    [iPhone_6S]                 = 3.82,
    [iPhone_6S_Plus]            = 3.8,
    [iPhone_SE]                 = 3.82,
    [American_iPhone_7]         = 3.8,
    [Chinese_iPhone_7]          = 3.8,
    [American_iPhone_7_Plus]    = 3.82,
    [Chinese_iPhone_7_Plus]     = 3.82,
    [Chinese_iPhone_8]          = 3.82,
    [Global_iPhone_8]           = 3.82,
    [Chinese_iPhone_8_Plus]     = 3.82,
    [Global_iPhone_8_Plus]      = 3.82,
    [Chinese_iPhone_X]          = 3.81,
    [Global_iPhone_X]           = 3.81,
    [iPhone_XS]                 = 3.81,
    [iPhone_XS_Max]             = 3.80,
    
    [iPod_Touch_1G]             = 3.7,
    [iPod_Touch_2G]             = 3.7,
    [iPod_Touch_3G]             = 3.7,
    [iPod_Touch_4G]             = 3.7,
    [iPod_Touch_5Gen]           = 3.7,
    [iPod_Touch_6G]             = 3.83,
    [iPad_1]                    = 3.75,
    [iPad_2_CDMA]               = 3.8,
    [iPad_2_GSM]                = 3.8,
    [iPad_2_WiFi]               = 3.8,
    [iPad_3_WiFi]               = 3.7,
    [iPad_3_GSM]                = 3.7,
    [iPad_3_CDMA]               = 3.7,
    [iPad_4_WiFi]               = 3.7,
    [iPad_4_GSM]                = 3.7,
    [iPad_4_CDMA]               = 3.7,
    [iPad_Air]                  = 3.73,
    [iPad_Air_Cellular]         = 3.73,
    [iPad_Air_2_WiFi]           = 3.76,
    [iPad_Air_2_Cellular]       = 3.76,
    [iPad_Mini_WiFi]            = 3.72,
    [iPad_Mini_GSM]             = 3.72,
    [iPad_Mini_CDMA]            = 3.72,
    [iPad_Mini_2]               = 3.75,
    [iPad_Mini_2_Cellular]      = 3.75,
    [iPad_Mini_3_WiFi]          = 3.75,
    [iPad_Mini_3_Cellular]      = 3.75,
    [iPad_Mini_4_WiFi]          = 3.82,
    [iPad_Mini_4_Cellular]      = 3.82,
    [iPad_Pro_97inch_WiFi]      = 3.82,
    [iPad_Pro_97inch_Cellular]  = 3.82,
    [iPad_Pro_129inch_WiFi]     = 3.77,
    [iPad_Pro_129inch_Cellular] = 3.77,
    [iPad_5_WiFi]               = 3.73,
    [iPad_5_Cellular]           = 3.73,
    [iPad_Pro_105inch_WiFi]     = 3.77,
    [iPad_Pro_105inch_Cellular] = 3.77,
    [iPad_6]                    = 3.73,
    
    [iUnknown]                  = 0
};

/** CPU频率、速度 */
static const NSUInteger CPUFrequencyContainer[] = {
    [iPhone_1G]                 = 412,
    [iPhone_3G]                 = 620,
    [iPhone_3GS]                = 600,
    [iPhone_4]                  = 800,
    [iPhone_4_Verizon]          = 800,
    [iPhone_4S]                 = 800,
    [iPhone_5_GSM]              = 1300,
    [iPhone_5_CDMA]             = 1300,
    [iPhone_5C_GSM]             = 1000,
    [iPhone_5C_GSM_CDMA]        = 1000,
    [iPhone_5S_GSM]             = 1300,
    [iPhone_5S_GSM_CDMA]        = 1300,
    [iPhone_6]                  = 1400,
    [iPhone_6_Plus]             = 1400,
    [iPhone_6S]                 = 1850,
    [iPhone_6S_Plus]            = 1850,
    [iPhone_SE]                 = 1850,
    [Chinese_iPhone_7]          = 2340,
    [American_iPhone_7]         = 2340,
    [American_iPhone_7_Plus]    = 2240,
    [Chinese_iPhone_7_Plus]     = 2240,
    [Chinese_iPhone_8]          = 2390,
    [Chinese_iPhone_8_Plus]     = 2390,
    [Chinese_iPhone_X]          = 2390,
    [Global_iPhone_8]           = 2390,
    [Global_iPhone_8_Plus]      = 2390,
    [Global_iPhone_X]           = 2390,
    
    
    [iPod_Touch_1G]             = 400,
    [iPod_Touch_2G]             = 533,
    [iPod_Touch_3G]             = 600,
    [iPod_Touch_4G]             = 800,
    [iPod_Touch_5Gen]           = 1000,
    [iPod_Touch_6G]             = 1024,
    [iPad_1]                    = 1000,
    [iPad_2_CDMA]               = 1000,
    [iPad_2_GSM]                = 1000,
    [iPad_2_WiFi]               = 1000,
    [iPad_3_WiFi]               = 1000,
    [iPad_3_GSM]                = 1000,
    [iPad_3_CDMA]               = 1000,
    [iPad_4_WiFi]               = 1400,
    [iPad_4_GSM]                = 1400,
    [iPad_4_CDMA]               = 1400,
    [iPad_Air]                  = 1400,
    [iPad_Air_Cellular]         = 1400,
    [iPad_Air_2_WiFi]           = 1500,
    [iPad_Air_2_Cellular]       = 1500,
    
    [iPad_Mini_WiFi]            = 1000,
    [iPad_Mini_GSM]             = 1000,
    [iPad_Mini_CDMA]            = 1000,
    [iPad_Mini_2]               = 1300,
    [iPad_Mini_2_Cellular]      = 1300,
    [iPad_Mini_3_WiFi]          = 1300,
    [iPad_Mini_3_Cellular]      = 1300,
    [iPad_Mini_4_WiFi]          = 1490,
    [iPad_Mini_4_Cellular]      = 1490,
    [iPad_Pro_97inch_WiFi]      = 2160,
    [iPad_Pro_97inch_Cellular]  = 2160,
    [iPad_Pro_129inch_WiFi]     = 2240,
    [iPad_Pro_129inch_Cellular] = 2240,
    [iPad_5_WiFi]               = 1850,
    [iPad_5_Cellular]           = 1850,
    [iPad_Pro_129inch_2nd_gen_WiFi]     = 2380,
    [iPad_Pro_129inch_2nd_gen_Cellular] = 2380,
    [iPad_Pro_105inch_WiFi]             = 2380,
    [iPad_Pro_105inch_Cellular]         = 2380,
    [iPad_6]                            = 2310,
    
    [iUnknown]                  = 0
};

static const NSString *CPUNameContainer[] = {
    [iPhone_1G]                 = @"ARM 1176JZ",
    [iPhone_3G]                 = @"ARM 1176JZ",
    [iPhone_3GS]                = @"ARM Cortex-A8",
    [iPhone_4]                  = @"Apple A4",
    [iPhone_4_Verizon]          = @"Apple A4",
    [iPhone_4S]                 = @"Apple A5",
    [iPhone_5_GSM]              = @"Apple A6",
    [iPhone_5_CDMA]             = @"Apple A6",
    [iPhone_5C_GSM]             = @"Apple A6",
    [iPhone_5C_GSM_CDMA]        = @"Apple A6",
    [iPhone_5S_GSM]             = @"Apple A7",
    [iPhone_5S_GSM_CDMA]        = @"Apple A7",
    [iPhone_6]                  = @"Apple A8",
    [iPhone_6_Plus]             = @"Apple A8",
    [iPhone_6S]                 = @"Apple A9",
    [iPhone_6S_Plus]            = @"Apple A9",
    [iPhone_SE]                 = @"Apple A9",
    [Chinese_iPhone_7]          = @"Apple A10",
    [American_iPhone_7]         = @"Apple A10",
    [American_iPhone_7_Plus]    = @"Apple A10",
    [Chinese_iPhone_7_Plus]     = @"Apple A10",
    [Chinese_iPhone_8]          = @"Apple A11",
    [Chinese_iPhone_8_Plus]     = @"Apple A11",
    [Chinese_iPhone_X]          = @"Apple A11",
    [Global_iPhone_8]           = @"Apple A11",
    [Global_iPhone_8_Plus]      = @"Apple A11",
    [Global_iPhone_X]           = @"Apple A11",
    [iPhone_XS]                 = @"A12 Bionic",
    [iPhone_XS_Max]             = @"A12 Bionic",
    [iPhone_XR]                 = @"A12 Bionic",
    
    [iPod_Touch_1G]             = @"ARM 1176JZ",
    [iPod_Touch_2G]             = @"ARM 1176JZ",
    [iPod_Touch_3G]             = @"ARM Cortex-A8",
    [iPod_Touch_4G]             = @"ARM Cortex-A8",
    [iPod_Touch_5Gen]           = @"Apple A5",
    [iPod_Touch_6G]             = @"Apple A8",
    [iPad_1]                    = @"ARM Cortex-A8",
    [iPad_2_CDMA]               = @"ARM Cortex-A9",
    [iPad_2_GSM]                = @"ARM Cortex-A9",
    [iPad_2_WiFi]               = @"ARM Cortex-A9",
    [iPad_3_WiFi]               = @"ARM Cortex-A9",
    [iPad_3_GSM]                = @"ARM Cortex-A9",
    [iPad_3_CDMA]               = @"ARM Cortex-A9",
    [iPad_4_WiFi]               = @"Apple A6X",
    [iPad_4_GSM]                = @"Apple A6X",
    [iPad_4_CDMA]               = @"Apple A6X",
    [iPad_Air]                  = @"Apple A7",
    [iPad_Air_Cellular]         = @"Apple A7",
    [iPad_Air_2_WiFi]           = @"Apple A8X",
    [iPad_Air_2_Cellular]       = @"Apple A8X",
    [iPad_Mini_WiFi]            = @"ARM Cortex-A9",
    [iPad_Mini_GSM]             = @"ARM Cortex-A9",
    [iPad_Mini_CDMA]            = @"ARM Cortex-A9",
    [iPad_Mini_2]               = @"Apple A7",
    [iPad_Mini_2_Cellular]      = @"Apple A7",
    [iPad_Mini_3_WiFi]          = @"Apple A7",
    [iPad_Mini_3_Cellular]      = @"Apple A7",
    [iPad_Mini_4_WiFi]          = @"Apple A8",
    [iPad_Mini_4_Cellular]      = @"Apple A8",
    
    [iPad_Pro_97inch_WiFi]      = @"Apple A9X",
    [iPad_Pro_97inch_Cellular]  = @"Apple A9X",
    [iPad_Pro_129inch_WiFi]     = @"Apple A9X",
    [iPad_Pro_129inch_Cellular] = @"Apple A9X",
    [iPad_Pro_129inch_2nd_gen_WiFi]     = @"Apple A10X",
    [iPad_Pro_129inch_2nd_gen_Cellular] = @"Apple A10X",
    [iPad_Pro_105inch_WiFi]             = @"Apple A10X",
    [iPad_Pro_105inch_Cellular]         = @"Apple A10X",
    [iPad_6]                            = @"Apple A10",
    
    [iUnknown]                          = @"Unknown"
};


- (BOOL)multitaskingSupported {
    return [UIDevice currentDevice].multitaskingSupported;
}

- (NSString *)getKernelVersion {
    return self.utsNameDic[kRelease];
}

- (NSString *)getDarwinBuildDescription {
    return self.utsNameDic[kVersion];
}

- (NSString *)getOSName {
    return self.utsNameDic[kSysName];
}

/// 当前系统名称
-(NSString *)getSystemName {
    return [UIDevice currentDevice].systemName;
}

/// 当前系统版本号
-(NSString *)getSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}

/// 获取当前语言
+ (NSString *)getDeviceLanguage {
    NSArray *languageArray = [NSLocale preferredLanguages];
    return [languageArray objectAtIndex:0];
}

-(NSString *)getCurrentTime{
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    // 获取指定时区的名称
    NSString *strZoneName = [zone name];
    return strZoneName;
}

-(NSString *)getCurrentCountyNum{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    return countryCode;
}

- (NSInteger)getNuclearCount {
    return self.processInfo.processorCount;
}
- (NSInteger)getActiveNuclearCount {
    return self.processInfo.activeProcessorCount;
}

- (NSUInteger)_getSystemInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

- (NSString *)_getDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

- (NSString *)_getLibraryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

- (NSString *)_getCachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

-(unsigned long long)_getSizeOfFolder:(NSString *)folderPath {
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    
    NSString *file;
    unsigned long long folderSize = 0;
    
    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
    }
    return folderSize;
}

+ (NSString *)getCurrentPhoneOperatorName {
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (!carrier.isoCountryCode) {
        return @"未知";
    }
    return [carrier carrierName];
}
+ (NSString *)getCurrentISOCountryCode {
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    if (!carrier.isoCountryCode) {
        return @"未知";
    }
    return [carrier isoCountryCode];
    
}
+ (NSString *)getMobileCountryCode {
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    if (!carrier.isoCountryCode) {
        return @"未知";
    }
    return [carrier mobileCountryCode];
    
}

- (CGFloat)getScreenBrightness {
    return self.screen.brightness;
}
- (NSString *)screenResolution {
    return [NSString stringWithFormat:@"%.0f X %.0f",self.screen.scale*self.screen.bounds.size.height,self.screen.scale*self.screen.bounds.size.width];
}
/**
 *  获取dpi
 *
 *  @return dpi的值,参考：http://stackoverflow.com/questions/3860305/get-ppi-of-iphone-ipad-ipod-touch-at-runtime
 */
- (CGFloat)getScreenDpi {
    float scale = 1;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 132*scale;
    }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 163*scale;
    }else {
        return 160*scale;
    }
    
}

- (NSDictionary *)utsNameDic {
    if (!_utsNameDic) {
        struct utsname systemInfo;
        uname(&systemInfo);
        _utsNameDic = @{kSysName:[NSString stringWithCString:systemInfo.sysname encoding:NSUTF8StringEncoding],kNodeName:[NSString stringWithCString:systemInfo.nodename encoding:NSUTF8StringEncoding],kRelease:[NSString stringWithCString:systemInfo.release encoding:NSUTF8StringEncoding],kVersion:[NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding],kMachine:[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]};
    }
    return _utsNameDic;
}

- (NSProcessInfo *)processInfo {
    if (!_processInfo) {
        _processInfo = [NSProcessInfo processInfo];
    }
    return _processInfo;
}

#pragma mark - Lazy Load
- (UIScreen *)screen {
    if (!_screen) {
        _screen = [UIScreen mainScreen];
    }
    return _screen;
}


//获取CPU频率
extern int freqTest(int cycles);

-(void)getCPUFrequencyWithBlock:(void (^)(NSInteger))FrequencyBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *timers = [NSMutableArray array];
        for (int i=0; i<500; i++) {
            NSTimeInterval time = 0;
            [timers addObject:@(time)];
        }
        int sum = 0;
        for (int i=0; i<500; i++) {
            NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
            [timers replaceObjectAtIndex:i withObject:@(time)];
            sum += freqTest(10000);
            NSTimeInterval time2 = [[NSProcessInfo processInfo] systemUptime];
            [timers replaceObjectAtIndex:i withObject:@(time2-time)];
        }
        NSTimeInterval time = [timers[0] doubleValue];
        for(int i = 1; i < 500; i++)
        {
            if(time > [timers[i] doubleValue])
                time = [timers[i] doubleValue];
        }

        double freq = 1300000.0 / time;
        freq = freq / 1000000.0 + 9.0;
        if (ceil(freq) == 1392) {
            freq = 1400;
        }
        FrequencyBlock(freq);
    });
}

- (float)getCPUUsage
{
    kern_return_t            kr = { 0 };
    task_info_data_t        tinfo = { 0 };
    mach_msg_type_number_t    task_info_count = TASK_INFO_MAX;
    kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    task_basic_info_t        basic_info = { 0 };
    thread_array_t            thread_list = { 0 };
    mach_msg_type_number_t    thread_count = { 0 };
    thread_info_data_t        thinfo = { 0 };
    thread_basic_info_t        basic_info_th = { 0 };
    basic_info = (task_basic_info_t)tinfo;
    // get threads in the task
    kr = task_threads( mach_task_self(), &thread_list, &thread_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    long    tot_sec = 0;
    long    tot_usec = 0;
    float    tot_cpu = 0;
    for ( int i = 0; i < thread_count; i++ )
    {
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
        if ( KERN_SUCCESS != kr )
            return 0.0f;
        basic_info_th = (thread_basic_info_t)thinfo;
        if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
        {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    return tot_cpu;
}

@end
