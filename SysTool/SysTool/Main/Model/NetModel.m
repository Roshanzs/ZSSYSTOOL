//
//  NetModel.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/15.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "NetModel.h"

@implementation NetModel

+(instancetype)share{
    static NetModel *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[NetModel alloc]init];
    });
    return share;
}

@end
