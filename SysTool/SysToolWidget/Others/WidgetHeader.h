//
//  WidgetHeader.h
//  SysToolWidget
//
//  Created by 紫贝壳 on 2018/12/17.
//  Copyright © 2018年 stark. All rights reserved.
//

#ifndef WidgetHeader_h
#define WidgetHeader_h

#import "ShareTools.h"
#import "DeviceDataTool.h"
#import "NetWorkInfoTool.h"
#import "BatteryInfoTool.h"
#import "DeviceInfoTool.h"
#import "Masonry.h"

#define CURRDAYCANUSE @"CURRDAYCANUSE" //当天可使用移动数据流量设置
#define TOTLENETDATE @"TOTLENETDATE" //移动数据总流量
#define HADUSENETDATA @"HADUSENETDATA" //移动数据已使用流量
#define NETDATACLEAR @"NETDATACLEAR" //设置移动数据已使用量时网卡当前的移动数据使用量
#define WIFIDATACLEAR @"WIFIDATACLEAR" //设置已用wifi流量为零时当前网卡流量
#define SWITCHBTN @"SWITCHBTN" //switch开关状态
#define BEFORDAYUSEDATA @"BEFORDAYUSEDATA" //记录前一天的wifi和移动数据用量

#define WIFICURRDATA @"WIFICURRDATA" //当前wifi已用总量
#define WIFICURRUPDATA @"WIFICURRUPDATA" //当前wifi上行已用总量
#define WIFICURRDOWNDATA @"WIFICURRDOWNDATA" //当前wifi下行已用总量
#define NETCURRDATA @"NETCURRDATA" //当前移动数据已用总量
#define NETCURRUPDATA @"NETCURRUPDATA" //当前移动数据上行已用总量
#define ETCURRDOWNDATA @"ETCURRDOWNDATA" //当前移动数据下行已用总量

#define DAYMONTHCLEARBOOL @"DAYMONTHCLEARBOOL" //月初是否清零过
#define WIDGETTYPE @"WIDGETTYPE" //widget类型

//弱引用
#define WeakSelf(type)  __weak typeof(type) weakself = type;

//屏幕宽高
#define WSCREEN [UIScreen mainScreen].bounds.size.width
#define HSCREEN [UIScreen mainScreen].bounds.size.height
#define BSCREEN [UIScreen mainScreen].bounds

#define WSCREENWidget ([UIScreen mainScreen].bounds.size.width-20)

//全局颜色
#define ColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define ColorWithRGB(r,g,b) ColorWithRGBA(r,g,b,1.0f)
#define ColorWithHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
//随机颜色
#define ColorWithRandom [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

//获取temp
#define ZSPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define ZSPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define ZSPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#endif /* WidgetHeader_h */
