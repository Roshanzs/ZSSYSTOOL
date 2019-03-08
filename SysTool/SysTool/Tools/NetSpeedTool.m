//
//  NetSpeedTool.m
//  SysTool
//
//  Created by 紫贝壳 on 2019/1/9.
//  Copyright © 2019年 stark. All rights reserved.
//

#import "NetSpeedTool.h"

#define urlString @"http://www.qibaoyouwu.com/ios/forSYSNetSpeed"//3M

@interface NetSpeedTool()
{
    measureBlock   infoBlock;
    finishMeasureBlock   fmeasureBlock;
    int                           _second;
    NSMutableData*                _connectData;
    NSMutableData*                _oneMinData;
    NSURLConnection *             _connect;
    NSTimer*                      _timer;
}

@property (copy, nonatomic) void (^faildBlock) (NSError *error);

@end

@implementation NetSpeedTool

/**
 *  初始化测速方法
 *
 *  @param measureBlock       实时返回测速信息
 *  @param finishMeasureBlock 最后完成时候返回平均测速信息
 *
 *  @return MeasurNetTools对象
 */
- (instancetype)initWithblock:(measureBlock)measureBlock finishMeasureBlock:(finishMeasureBlock)finishMeasureBlock failedBlock:(void (^) (NSError *error))failedBlock
{
    self = [super init];
    if (self) {
        infoBlock = measureBlock;
        fmeasureBlock = finishMeasureBlock;
        _faildBlock = failedBlock;
        _connectData = [[NSMutableData alloc] init];
        _oneMinData = [[NSMutableData alloc] init];
    }
    return self;
}

/**
 *  开始测速
 */
-(void)startMeasur
{
    [self meausurNet];
}

/**
 *  停止测速，会通过block立即返回测试信息
 */
-(void)stopMeasur
{
    [self finishMeasure];
}

-(void)meausurNet
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    NSURL    *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _connect = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    [_timer fire];
    _second = 0;
    
}

-(void)countTime{
    ++_second;
    if (_second == 15) {
        [self finishMeasure];
        return;
    }
    float speed = _oneMinData.length;
    //    if(speed==0.0f){
    //        NSLog(@"acde");
    //    }
    infoBlock(speed);
    
    //清空数据
    [_oneMinData resetBytesInRange:NSMakeRange(0, _oneMinData.length)];
    [_oneMinData setLength:0];
}

/**
 * 测速完成
 */
-(void)finishMeasure{
    [_timer invalidate];
    _timer = nil;
    if(_second!=0){
        float finishSpeed = _connectData.length / _second;
        fmeasureBlock(finishSpeed);
    }
    
    [_connect cancel];
    _connectData = nil;
    _connect = nil;
    
    
}



#pragma mark - urlconnect delegate methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.faildBlock) {
        self.faildBlock(error);
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_connectData appendData:data];
    [_oneMinData appendData:data];
    //    NSLog(@"_oneMinData:%lu  data:%lu",(unsigned long)_oneMinData.length,(unsigned long)data.length);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"connectionDidFinishLoading");
    [self finishMeasure];
}


- (void)dealloc
{
    NSLog(@"netspeed dealloc");
}


@end
