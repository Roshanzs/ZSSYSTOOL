//
//  ShareTools.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/14.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "ShareTools.h"

@interface ShareTools()
@end

@implementation ShareTools

+(instancetype)share{
    static ShareTools *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ShareTools alloc]init];
    });
    return share;
}

//切割圆角
+(void)ZScorner:(UIView *)obj WithFlote:(CGFloat)Radius{
    obj.layer.cornerRadius = Radius;
    obj.layer.masksToBounds = YES;
}

+ (NSString *)getVersionNum
{
    NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNum = [bundleDic objectForKey:@"CFBundleShortVersionString"];
    return versionNum;
}

// 时间戳转化为时间
+ (NSString *)creatTimeFromDate
{
    NSDate *date2=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];//直接指定时区，这里是东8区
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:date2];
    return dateString;
}

+(NSString *)getFileSizeString:(long long)size
{
    size = size<0?0:size;
    if (size >= 1024*1024*1024) {
        return [NSString stringWithFormat:@"%.2fG",size/1024/1024/1024.0];
    }else if (size >= 1024*1024) {
        return [NSString stringWithFormat:@"%.1fM",size/1024/1024.0];
    }else if (size >= 1024 && size<1024*1024){
        return [NSString stringWithFormat:@"%.1fK",size/1024.0];
    }else{
        return [NSString stringWithFormat:@"%1.1fB",size/1.0];
    }
}

+ (NSString *)formatBandWidth:(unsigned long long)size
{
    size *=8;
    NSString *formattedStr = nil;
    if (size == 0){
        formattedStr = NSLocalizedString(@"0",@"");
    }else if (size > 0 && size < 1024){
        formattedStr = [NSString stringWithFormat:@"%qu", size];
    }else if (size >= 1024 && size < pow(1024, 2)){
        int intsize = (int)(size / 1024);
        int model = size % 1024;
        if (model > 512) {
            intsize += 1;
        }
        formattedStr = [NSString stringWithFormat:@"%dK",intsize ];
    }else if (size >= pow(1024, 2) && size < pow(1024, 3)){
        unsigned long long l = pow(1024, 2);
        int intsize = size / pow(1024, 2);
        int  model = (int)(size % l);
        if (model > l/2) {
            intsize +=1;
        }
        formattedStr = [NSString stringWithFormat:@"%dM", intsize];
    }else if (size >= pow(1024, 3)){
        int intsize = size / pow(1024, 3);
        formattedStr = [NSString stringWithFormat:@"%dG", intsize];
    }
    return formattedStr;
}

//获取地址
+(NSURL *)getPlistPath{
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.stark.ForSYS"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/ZSShareData.plist"];
    return containerURL;
}

//获取fmdb地址
+(NSURL *)getFMDBPath{
    NSURL *containerpath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.stark.ForSYS"];
    containerpath = [containerpath URLByAppendingPathComponent:@"Library/Caches/ForDayUseInfo.db"];
    return containerpath;
}

//获取openurl地址
+(NSURL *)getOpenPath{
    NSURL *containerpath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.stark.ForSYS"];
    containerpath = [containerpath URLByAppendingPathComponent:@"Library/Caches/OpenUrlArr.plist"];
    return containerpath;
}

//获取观看广告次数
+(NSString *)ChackADWithid:(NSString *)typeid{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *path = [ZSPathDocument stringByAppendingPathComponent:@"ADData.plist"];
    if ([manger fileExistsAtPath:path]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        NSString *str = [dic objectForKey:typeid];
        return str;
    }
    return @"0";
}

//添加观看广告次数
+(void)AddADWithid:(NSString *)typeid WithNum:(NSString *)num{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *path = [ZSPathDocument stringByAppendingPathComponent:@"ADData.plist"];
    if ([manger fileExistsAtPath:path]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        [dic setObject:num forKey:typeid];
        [dic writeToFile:path atomically:YES];
    }else{
        NSDictionary *dic = @{typeid:num};
        [dic writeToFile:path atomically:YES];
    }
}

//获取plist
+(NSDictionary *)CreatPlist{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:[ShareTools getPlistPath]];
    return dict;
}

//储存
+(BOOL)SaveStateWithValue:(id)Value WithKey:(NSString *)key{
    NSMutableDictionary *Mdic = [NSMutableDictionary dictionaryWithDictionary:[ShareTools CreatPlist]];
    [Mdic setObject:Value forKey:key];
    return [Mdic writeToURL:[ShareTools getPlistPath] atomically:YES];
}

+(id)ReadDicWithKey:(NSString *)key{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:[ShareTools getPlistPath]];
    if ([dict objectForKey:key]) {
        return [dict objectForKey:key];
    }
    return nil;
}

+(NSArray *)DayUseEveryData{
   return [ShareTools checkData];
}

+(BOOL)DayUseDataUpdateWithDict:(NSDictionary *)dict{
    NSString *daytimeupdate = [dict objectForKey:@"daytime"];
    NSArray *dataarr = [ShareTools DayUseEveryData];
    NSDictionary *Firstdic = dataarr.firstObject;
    NSString *daytime = [Firstdic objectForKey:@"daytime"];
    if (dataarr.count >= 1){
        if (daytime.integerValue == daytimeupdate.integerValue) {
            NSDictionary *dict3 = [ShareTools NowWithLastDayWithLastDic:[ShareTools beforRecordData] WithNowDic:dict];
           return [ShareTools updateDataWithTime:dict3];
        }
       NSDictionary *dict4 = [ShareTools dayFirstdictWithdic:dict];
        [ShareTools updateRecordData];
        return [ShareTools CreatDataWithStr:dict4];
    }
    NSDictionary *dict5 = [ShareTools dayFirstdictWithdic:dict];
    [ShareTools updateRecordData];
    return [ShareTools CreatDataWithStr:dict5];
}

//今日l开始统计的初始值
+(NSDictionary *)dayFirstdictWithdic:(NSDictionary *)dic{
    NSString *nowtime = [dic objectForKey:@"daytime"];
    NSDictionary *dayUseDic = @{@"wifiup":@"0",@"wifidown":@"0",@"wifiTotle":@"0",@"netup":@"0",@"netdown":@"0",@"netTotle":@"0"};
    NSDictionary *dayDic = @{@"daytime":nowtime,@"liuliangNum":dayUseDic};
    return dayDic;
}

//今日统计
+(NSDictionary *)NowWithLastDayWithLastDic:(NSDictionary *)lastdic WithNowDic:(NSDictionary *)nowdic{
    NSDictionary *lastliuliangdic = [lastdic objectForKey:@"liuliangNum"];
    NSDictionary *nowliuliangdic = [nowdic objectForKey:@"liuliangNum"];
    NSString *nowtime = [nowdic objectForKey:@"daytime"];
    
    NSString *wifiup = [NSString stringWithFormat:@"%lld",[[nowliuliangdic objectForKey:@"wifiup"] longLongValue] - [[lastliuliangdic objectForKey:@"wifiup"] longLongValue]];
    NSString *wifidown = [NSString stringWithFormat:@"%lld",[[nowliuliangdic objectForKey:@"wifidown"] longLongValue] - [[lastliuliangdic objectForKey:@"wifidown"] longLongValue]];
    NSString *wifiTotle = [NSString stringWithFormat:@"%lld",[[nowliuliangdic objectForKey:@"wifiTotle"] longLongValue] - [[lastliuliangdic objectForKey:@"wifiTotle"] longLongValue]];
    NSString *netup = [NSString stringWithFormat:@"%lld",[[nowliuliangdic objectForKey:@"netup"] longLongValue] - [[lastliuliangdic objectForKey:@"netup"] longLongValue]];
    NSString *netdown = [NSString stringWithFormat:@"%lld",[[nowliuliangdic objectForKey:@"netdown"] longLongValue] - [[lastliuliangdic objectForKey:@"netdown"] longLongValue]];
    NSString *netTotle = [NSString stringWithFormat:@"%lld",[[nowliuliangdic objectForKey:@"netTotle"] longLongValue] - [[lastliuliangdic objectForKey:@"netTotle"] longLongValue]];
    NSDictionary *dayUseDic = @{@"wifiup":wifiup,@"wifidown":wifidown,@"wifiTotle":wifiTotle,@"netup":netup,@"netdown":netdown,@"netTotle":netTotle};
    NSDictionary *dayDic = @{@"daytime":nowtime,@"liuliangNum":dayUseDic};
    return dayDic;
}


+(NSString *)checkNetLiuliang{
    NSString *useData = @"0";
    NSString *wangkaData = [[NetWorkInfoTool sharedManager] getWWANTotalFolwBytes];
    NSString *hadUse = [ShareTools ReadDicWithKey:HADUSENETDATA];
    NSString *ClearData = [ShareTools ReadDicWithKey:NETDATACLEAR];
    if (hadUse.longLongValue >= 0) {
        useData = [NSString stringWithFormat:@"%@",[ShareTools getFileSizeString:(wangkaData.longLongValue - ClearData.longLongValue + hadUse.longLongValue)]];
    }else{
        useData = [ShareTools getFileSizeString:[wangkaData longLongValue]];;
    }
    return useData;
}

+(NSString *)checkTotleNetLiuliang{
    NSString *TotleData = @"未设置";
    NSString *dicTotle = [ShareTools ReadDicWithKey:TOTLENETDATE];
    if (dicTotle.longLongValue > 0) {
        TotleData = [ShareTools getFileSizeString:[dicTotle longLongValue]];
    }
    return TotleData;
}

+(NSString *)checkWifiLiuliang{
    NSString *wifiuseData = @"0";
    NSString *wifiData = [[NetWorkInfoTool sharedManager] getWiFiTotalFolwBytes];
    id wifiUse = [ShareTools ReadDicWithKey:WIFIDATACLEAR];
    if ([wifiUse isKindOfClass:[NSString class]]) {
        wifiuseData = [ShareTools getFileSizeString:(wifiData.longLongValue - [wifiUse longLongValue])];
    }else{
        wifiuseData = [ShareTools getFileSizeString:wifiData.longLongValue];
    }
    return wifiuseData;
}


// 获取当前时间
+ (NSString *)getNowTimeFromDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];//直接指定时区，这里是东8区
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

//流量清零
+(BOOL)MonthClearLiuliangData{
    BOOL issave = [ShareTools SaveStateWithValue:@"0" WithKey:HADUSENETDATA];
    BOOL isCurrNetLiuliang = [ShareTools SaveStateWithValue:[NSString stringWithFormat:@"%@",[[NetWorkInfoTool sharedManager] getWWANTotalFolwBytes]] WithKey:NETDATACLEAR];
    BOOL isCurrWifiLiuliang = [ShareTools SaveStateWithValue:[NSString stringWithFormat:@"%@",[[NetWorkInfoTool sharedManager] getWiFiTotalFolwBytes]] WithKey:WIFIDATACLEAR];
    if (issave && isCurrNetLiuliang && isCurrWifiLiuliang) {
        [ShareTools deleteDBData];
        return YES;
    }
    return NO;
}

//实时获取当天数据
+(NSDictionary *)getCurrDataLiuliang{
    NSDictionary *dayDic = [NetWorkInfoTool DayUseDict];
    NSDictionary *dict = [ShareTools NowWithLastDayWithLastDic:[ShareTools beforRecordData] WithNowDic:dayDic];
    NSDictionary *useinfoDic = [dict objectForKey:@"liuliangNum"];
    return useinfoDic;
}

//更新统计时记录之前用的数据
+(BOOL)updateRecordData{
    NSDictionary *dict = [NetWorkInfoTool DayUseDict];
    BOOL succ = [ShareTools SaveStateWithValue:dict WithKey:BEFORDAYUSEDATA];
    return succ;
}

//统计时记录之前用的数据
+(NSDictionary *)beforRecordData{
    NSDictionary *dict = [ShareTools ReadDicWithKey:BEFORDAYUSEDATA];
    if (dict) {
        return dict;
    }
    return nil;
}

//数据库
+(FMDatabase *)dbpathWithDB{
    //1.创建database路径
    NSString *dbpath = [NSString stringWithFormat:@"%@",[ShareTools getFMDBPath]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    return db;
}

// 删除数据库
+ (void)deleteDBData{
    FMDatabase *db = [ShareTools dbpathWithDB];
    if ([db open]) {
        NSString *sql = @"delete from ForDayUseInfo";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to delete db data");
        } else {
            NSLog(@"success to delete db data");
        }
        [db close];
    }
}


//创建
+(void)CreatDBdate{
    FMDatabase *db = [ShareTools dbpathWithDB];
    [db open];
    if (![db open]) {
        NSLog(@"db open fail chuangjian");
        return;
    }
    //4.数据库中创建表（可创建多张）
    NSString *sql = @"create table if not exists ForDayUseInfo ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,time text NOT NULL, wifitotle text DEFAULT '0', wifiup text DEFAULT '0', wifidown text DEFAULT '0', nettotle text DEFAULT '0', netup text DEFAULT '0', netdown text DEFAULT '0')";
    BOOL result = [db executeUpdate:sql];
    if (result) {
        NSLog(@"create table success");
    }
    [db close];
}

//增
+(BOOL)CreatDataWithStr:(NSDictionary *)dataDic{
    FMDatabase *db = [ShareTools dbpathWithDB];
    [db open];
    if (![db open]) {
        NSLog(@"db open fail zeng");
        return NO;
    }
    NSArray *dbarr = [ShareTools checkData];
    if (dbarr.count > 30) {
        NSDictionary *dic = dbarr.lastObject;
        [ShareTools deletaDataWithDic:dic];
    }
    if ([dataDic objectForKey:@"daytime"]) {
        NSString *timestr = [dataDic objectForKey:@"daytime"];
        NSDictionary *useinfoDic = [dataDic objectForKey:@"liuliangNum"];
        
        NSString *wifitotletr = [useinfoDic objectForKey:@"wifiTotle"];
        NSString *wifiupstr = [useinfoDic objectForKey:@"wifiup"];
        NSString *wifidownstr = [useinfoDic objectForKey:@"wifidown"];
        NSString *nettotlestr = [useinfoDic objectForKey:@"netTotle"];
        NSString *netupstr = [useinfoDic objectForKey:@"netup"];
        NSString *netdownstr = [useinfoDic objectForKey:@"netdown"];

        BOOL result = [db executeUpdate:@"insert into ForDayUseInfo (time,wifitotle,wifiup,wifidown,nettotle,netup,netdown) values(?,?,?,?,?,?,?)",timestr,wifitotletr,wifiupstr,wifidownstr,nettotlestr,netupstr,netdownstr];
        if (result) {
            NSLog(@"insert into 'ForDayUseInfo' success");
        }
        return [db close];
    }
    return NO;
}

//删
+(BOOL)deletaDataWithDic:(NSDictionary *)dic{
    FMDatabase *db = [ShareTools dbpathWithDB];
    [db open];
    if (![db open]) {
        NSLog(@"db open fail");
        return NO;
    }
    NSString *time = [dic objectForKey:@"time"];
    BOOL result = [db executeUpdate:@"delete from ForDayUseInfo where time = ?" withArgumentsInArray:@[time]];
    if (result) {
        NSLog(@"delete from ForDayUseInfo success");
    }
   return [db close];
}

//改
+(BOOL)updateDataWithTime:(NSDictionary *)updatedic{
    FMDatabase *db = [ShareTools dbpathWithDB];
    [db open];
    if (![db open]) {
        NSLog(@"db open fail gai");
        return NO;
    }
    if ([updatedic objectForKey:@"daytime"]) {
        NSString *timestr = [updatedic objectForKey:@"daytime"];
        NSDictionary *useinfoDic = [updatedic objectForKey:@"liuliangNum"];
        
        NSString *wifitotletr = [useinfoDic objectForKey:@"wifiTotle"];
        NSString *wifiupstr = [useinfoDic objectForKey:@"wifiup"];
        NSString *wifidownstr = [useinfoDic objectForKey:@"wifidown"];
        NSString *nettotlestr = [useinfoDic objectForKey:@"netTotle"];
        NSString *netupstr = [useinfoDic objectForKey:@"netup"];
        NSString *netdownstr = [useinfoDic objectForKey:@"netdown"];
    
    BOOL result = [db executeUpdate:@"update ForDayUseInfo set wifitotle = ? ,wifiup = ?,wifidown = ?,nettotle = ?,netup = ?,netdown = ? where time = ?",wifitotletr,wifiupstr,wifidownstr,nettotlestr,netupstr,netdownstr,timestr];
    if (result) {
//        NSLog(@"update ForDayUseInfo success");
    }
   return [db close];
    }
    return NO;
}

//查当天使用的详情
+(NSDictionary *)checkDataCurrData{
    FMDatabase *db = [ShareTools dbpathWithDB];
    [db open];
    if (![db open]) {
        NSLog(@"db open fail chacurrdata");
        return @{};
    }
    NSString *currdata = [ShareTools getNowTimeFromDate];
    NSString *dbstr = [NSString stringWithFormat:@"select * from ForDayUseInfo where time = %@",currdata];
    FMResultSet *result = [db executeQuery:dbstr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    while ([result next]) {
        [dict setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"wifitotle"]] forKey:@"wifiTotle"];
        [dict setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"wifiup"]] forKey:@"wifiup"];
        [dict setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"wifidown"]] forKey:@"wifidown"];
        [dict setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"nettotle"]] forKey:@"netTotle"];
        [dict setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"netup"]] forKey:@"netup"];
        [dict setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"netdown"]] forKey:@"netdown"];
    }
    return dict.copy;
}

//查所有天数的详情
+(NSArray *)checkData{
    FMDatabase *db = [ShareTools dbpathWithDB];
    [db open];
    if (![db open]) {
        NSLog(@"db open fail cha");
        return @[];
    }
    //ORDER BY ID DESC --根据ID降序查找:ORDER BY ID ASC --根据ID升序序查找
    FMResultSet *result = [db executeQuery:@"select * from ForDayUseInfo ORDER BY time DESC"];
    NSMutableArray *Marr = [NSMutableArray array];
    while ([result next]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"time"]] forKey:@"daytime"];
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
        [dict2 setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"wifitotle"]] forKey:@"wifiTotle"];
        [dict2 setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"wifiup"]] forKey:@"wifiup"];
        [dict2 setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"wifidown"]] forKey:@"wifidown"];
        [dict2 setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"nettotle"]] forKey:@"netTotle"];
        [dict2 setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"netup"]] forKey:@"netup"];
        [dict2 setObject:[NSString stringWithFormat:@"%@",[result stringForColumn:@"netdown"]] forKey:@"netdown"];
        [dict setObject:dict2 forKey:@"liuliangNum"];
        [Marr addObject:dict];
    }
    return Marr.copy;
}



+(NSDictionary *)openUrlArrDic{
    NSDictionary *arrdic = [NSDictionary dictionaryWithContentsOfURL:[ShareTools getOpenPath]];
    if (arrdic) {
        return arrdic;
    }
    return @{@"state":@"0",@"urlarr":@[]};
}

+(NSArray *)openUrlNormalArrDic{
    NSString *bundlepath = [[NSBundle mainBundle] pathForResource:@"openUrlNormal.plist" ofType:nil];
    NSArray *arr = [NSArray arrayWithContentsOfFile:bundlepath];
    return arr;
}

+(void)addOpenUrlWithArr:(NSArray *)arr{
    NSDictionary *dict = [ShareTools openUrlArrDic];
    NSMutableArray *Marr = [NSMutableArray arrayWithArray:[dict objectForKey:@"urlarr"]];
    NSString *state = [dict objectForKey:@"state"];
    for (NSDictionary *dic in arr) {
        [Marr insertObject:dic atIndex:state.integerValue];
    }
    NSDictionary *dic = @{@"state":state,@"urlarr":Marr.copy};
    [dic writeToURL:[ShareTools getOpenPath] atomically:YES];
}


+(NSString *)openState{
    NSDictionary *arrdic = [NSDictionary dictionaryWithContentsOfURL:[ShareTools getOpenPath]];
    NSString *state = [arrdic objectForKey:@"state"];
    return state;
}

+(void)changeOpenUrlArrWithFrom:(NSInteger)Fint To:(NSInteger)Tint WithisAdd:(int)isadd{
    NSDictionary *dict = [ShareTools openUrlArrDic];
    NSMutableArray *Marr = [NSMutableArray arrayWithArray:[dict objectForKey:@"urlarr"]];
    NSDictionary *tempdic = [Marr objectAtIndex:Fint];
    [Marr removeObjectAtIndex:Fint];
    [Marr insertObject:tempdic atIndex:Tint];
    NSString *state = [dict objectForKey:@"state"];
    state = [NSString stringWithFormat:@"%d",state.intValue+isadd];
    NSDictionary *dic = @{@"state":state,@"urlarr":Marr.copy};
    [dic writeToURL:[ShareTools getOpenPath] atomically:YES];
}

+(void)limiteFive{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ShareTools openUrlArrDic]];
    [dic setObject:@"5" forKey:@"state"];
    [dic.copy writeToURL:[ShareTools getOpenPath] atomically:YES];
}

@end

