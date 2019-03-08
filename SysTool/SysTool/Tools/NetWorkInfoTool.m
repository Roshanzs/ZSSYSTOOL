//
//  NetWorkInfoTool.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/13.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "NetWorkInfoTool.h"
#import "NetModel.h"

// 下面是获取ip需要的头文件
#include <ifaddrs.h>
#include <sys/socket.h> // Per msqr
#import <sys/ioctl.h>
#include <net/if.h>
#import <arpa/inet.h>
#include <net/if_dl.h>
#import <SystemConfiguration/CaptiveNetwork.h>

typedef enum {
    FolwBytesNumWiFiSent    = 1, //WiFi状态下发送流量
    FolwBytesNumWiFiReceived    = 2, //WiFi状态下接收流量
    FolwBytesNumWiFiTotal   = 3, //WiFi状态下消耗总流量
    FolwBytesNumWWANSent    = 4, //移动网络下发送流量
    FolwBytesNumWWANReceived    = 5, //移动网络下接收流量
    FolwBytesNumWWANTotal   = 6, //移动网络下消耗总流量
}FolwBytesNum;

@implementation NetWorkInfoTool

+ (instancetype)sharedManager {
    static NetWorkInfoTool *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[NetWorkInfoTool alloc] init];
    });
    return _manager;
}

// 获取ip
-(void)getDeviceIPAddressesWithBlock:(void (^)(NSString * _Nonnull))ipBlock{
    if (![[NetModel share].IPSTR  isEqual: @"获取中..."] && [NetModel share].IPSTR != nil) {
        ipBlock([NetModel share].IPSTR);
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error;
        NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
        NSString *ip = nil;
        ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
        if (!ip) {
            ipBlock(@"获取中...");
            return ;
        }
        NSDictionary *dic = nil;
        NSData *data = [ip dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        //        NSLog(@"ipdic = %@",dic);
        NSString *ipstr = nil;
        if ([dic objectForKey:@"data"]) {
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSString class]]) {
                ipBlock(@"获取中");
                return;
            }
            NSDictionary *ipdic = dic[@"data"];
            if ([ipdic objectForKey:@"ip"]) {
                ipstr = ipdic[@"ip"];
            }else{
                ipBlock(@"获取中...");
            }
        }
        ipBlock(ipstr);
    });
}


-(NSString *)getIPAddresses
{
    NSString *address = @"未知";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

//iOS获取当前手机WIFI名称信息
-(NSString *)getWifiName
{
    NSString *currentSSID = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil){
        NSDictionary* myDict = (__bridge NSDictionary *) CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict!=nil){
            currentSSID=[myDict valueForKey:@"SSID"];
            /* myDict包含信息：
             {
             BSSID = "ac:29:3a:99:33:45";
             SSID = "三千";
             SSIDDATA = <e4b889e5 8d83>;
             }
             */
        } else {
            currentSSID=@"未链接";
        }
    } else {
        currentSSID=@"未链接";
    }
    CFRelease(myArray);
    return currentSSID;
}


- (NSString *)ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr) {
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                switch (family) {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    } break;
                        
                    case AF_INET6: { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        
                    default: break;
                }
                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address ? address : @"未知";
}

- (NSString *)getIpAddressWIFI {
    return [self ipAddressWithIfaName:@"en0"];
}

- (NSString *)getIpAddressCell {
    return [self ipAddressWithIfaName:@"pdp_ip0"];
}


+ (BOOL)ifConnectDelegate {
    CFDictionaryRef proxySettings = CFNetworkCopySystemProxySettings();
    NSDictionary *dictProxy = (__bridge_transfer id)proxySettings;
    //是否开启了http代理
    if ([[dictProxy objectForKey:@"HTTPEnable"] boolValue]) {
        return YES;
    }
    return  NO;
    
}
+ (NSDictionary *)getCurrentDelegateSettings {
    CFDictionaryRef proxySettings = CFNetworkCopySystemProxySettings();
    NSDictionary *dictProxy = (__bridge_transfer id)proxySettings;
    //是否开启了http代理
    if ([[dictProxy objectForKey:@"HTTPEnable"] boolValue]) {
        CFBridgingRelease(proxySettings);
        return dictProxy;
    }
    return @{@"已开启":@"无"};
}

/*WiFi状态下发送流量*/
- (NSString *)getWiFiSentFolwBytes
{
    NSString *bytesStr;
    bytesStr = [self getFolwBytesWithTyep:FolwBytesNumWiFiSent];
    return bytesStr;
}

/*WiFi状态下接收流量 */
- (NSString *)getWiFiReceivedFolwBytes
{
    NSString *bytesStr;
    bytesStr = [self getFolwBytesWithTyep:FolwBytesNumWiFiReceived];
    return bytesStr;
}

/*WiFi状态下消耗总流量*/
- (NSString *)getWiFiTotalFolwBytes
{
    NSString *bytesStr;
    bytesStr = [self getFolwBytesWithTyep:FolwBytesNumWiFiTotal];
    return bytesStr;
}

/* WiFi状态下单个请求消耗流量*/
- (NSString *)getWiFiFolwDifferenceBytes

{
    NSString *bytesStr;
    bytesStr = [self getFolwBytesWithTyep:FolwBytesNumWiFiTotal];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *dBytes = [userDefault objectForKey:@"WiFiFolwDifferenceBytes"];
    [userDefault setObject:bytesStr forKey:@"WiFiFolwDifferenceBytes"];
    [userDefault synchronize];
    NSInteger nowBytes = [bytesStr integerValue];
    NSInteger oldBytes = [dBytes integerValue];
    NSInteger dIntBytes = nowBytes - oldBytes;
    bytesStr = [NSString stringWithFormat:@"%ld",dIntBytes];
    return bytesStr;
}

/*移动网络下发送流量*/
- (NSString *)getWWANSentFolwBytes
{
    NSString *bytesStr;
    bytesStr = [self getFolwBytesWithTyep:FolwBytesNumWWANSent];
    return bytesStr;
}

/*移动网络下接收流量*/
- (NSString *)getWWANReceivedFolwBytes
{
    NSString *bytesStr;
    bytesStr = [self getFolwBytesWithTyep:FolwBytesNumWWANReceived];
    return bytesStr;
}

/*移动网络下消耗总流量*/
- (NSString *)getWWANTotalFolwBytes

{
    NSString *bytesStr;
    bytesStr = [self getFolwBytesWithTyep:FolwBytesNumWWANTotal];
    return bytesStr;
}

/*移动网络下单个请求消耗流量*/
- (NSString *)getWWANFolwDifferenceBytes
{
    NSString *bytesStr;
    bytesStr = [self getFolwBytesWithTyep:FolwBytesNumWiFiTotal];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *dBytes = [userDefault objectForKey:@"WWANFolwDifferenceBytes"];
    [userDefault setObject:bytesStr forKey:@"WWANFolwDifferenceBytes"];
    [userDefault synchronize];
    NSInteger nowBytes = [bytesStr integerValue];
    NSInteger oldBytes = [dBytes integerValue];
    NSInteger dIntBytes = nowBytes - oldBytes;
    bytesStr = [NSString stringWithFormat:@"%ld",dIntBytes];
    return bytesStr;
}



- (NSString *)getFolwBytesWithTyep:(FolwBytesNum)typeNum
{
    NSString *bytesStr;
    BOOL success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    long long WiFiSent = 0;
    long long WiFiReceived = 0;
    long long WWANSent = 0;
    long long WWANReceived = 0;
    NSString *name=[[NSString alloc]init];
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];                        if (cursor->ifa_addr->sa_family == AF_LINK) {
                //wifi消耗流量
                if ([name hasPrefix:@"en"]) {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                }
                //移动网络消耗流量
                if ([name hasPrefix:@"pdp_ip0"]) {
                    networkStatisc = (const struct if_data *) cursor->ifa_data; WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    if(typeNum == FolwBytesNumWiFiSent)
    {
        bytesStr = [NSString stringWithFormat:@"%lld",WiFiSent];
        bytesStr = [self checkUseDataWithdata:bytesStr WithType:WIFICURRUPDATA];
    }else if(typeNum == FolwBytesNumWiFiReceived)
    {
        bytesStr = [NSString stringWithFormat:@"%lld",WiFiReceived];
        bytesStr = [self checkUseDataWithdata:bytesStr WithType:WIFICURRDOWNDATA];
    }else if(typeNum == FolwBytesNumWiFiTotal)
    {
        bytesStr = [NSString stringWithFormat:@"%lld",WiFiSent + WiFiReceived];
        bytesStr = [self checkUseDataWithdata:bytesStr WithType:WIFICURRDATA];
    }else if(typeNum == FolwBytesNumWWANSent)
    {
        bytesStr = [NSString stringWithFormat:@"%lld",WWANSent];
        bytesStr = [self checkUseDataWithdata:bytesStr WithType:NETCURRUPDATA];
    }else if(typeNum == FolwBytesNumWWANReceived)
    {
        bytesStr = [NSString stringWithFormat:@"%lld",WWANReceived];
        bytesStr = [self checkUseDataWithdata:bytesStr WithType:ETCURRDOWNDATA];
    }else if(typeNum == FolwBytesNumWWANTotal)
    {
        bytesStr = [NSString stringWithFormat:@"%lld",WWANSent+WWANReceived];
        bytesStr = [self checkUseDataWithdata:bytesStr WithType:NETCURRDATA];
    }
    return bytesStr;
}


//每日消耗的流量
-(void)DayUseLiuliang{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dayDic = [NetWorkInfoTool DayUseDict];
        [ShareTools DayUseDataUpdateWithDict:dayDic];
    });
}

+(NSDictionary *)DayUseDict{
    NetWorkInfoTool *netTool = [NetWorkInfoTool sharedManager];
    NSString *nowtime = [ShareTools getNowTimeFromDate];
    NSString *wifiup = [netTool getWiFiSentFolwBytes];
    NSString *wifidown = [netTool getWiFiReceivedFolwBytes];
    NSString *wifiTotle = [netTool getWiFiTotalFolwBytes];
    NSString *netup = [netTool getWWANSentFolwBytes];
    NSString *netdown = [netTool getWWANReceivedFolwBytes];
    NSString *netTotle = [netTool getWWANTotalFolwBytes];
    NSDictionary *dayUseDic = @{@"wifiup":wifiup,@"wifidown":wifidown,@"wifiTotle":wifiTotle,@"netup":netup,@"netdown":netdown,@"netTotle":netTotle};
    NSDictionary *dayDic = @{@"daytime":nowtime,@"liuliangNum":dayUseDic};
    return dayDic;
}

//校正已用流量的不正确性
-(NSString *)checkUseDataWithdata:(NSString *)bytesStr WithType:(NSString *)type{
    NSString *OLDDATA = [NSString stringWithFormat:@"%@OLD",type];
    NSString *recordData = [ShareTools ReadDicWithKey:OLDDATA];
        if (recordData.longLongValue > 0) {
            if (recordData.longLongValue > bytesStr.longLongValue) {
                //如果记录的流量大于网卡统计的流量
                NSString *recorddifferent = [ShareTools ReadDicWithKey:type];
                if (recorddifferent.longLongValue > 0) {
                    if (recorddifferent.longLongValue > bytesStr.longLongValue) {
                        [ShareTools SaveStateWithValue:bytesStr WithKey:type];
                        return recordData;
                    }
                    NSString *changeData = [NSString stringWithFormat:@"%lld",bytesStr.longLongValue-recorddifferent.longLongValue+recordData.longLongValue];
                    [ShareTools SaveStateWithValue:bytesStr WithKey:type];
                    [ShareTools SaveStateWithValue:changeData WithKey:OLDDATA];
                    return changeData;
                }
                [ShareTools SaveStateWithValue:bytesStr WithKey:type];
                return recordData;
            }
            [ShareTools SaveStateWithValue:bytesStr WithKey:OLDDATA];
            return bytesStr;
        }
        [ShareTools SaveStateWithValue:bytesStr WithKey:OLDDATA];
        return bytesStr;
}

@end







