//
//  DayUseModel.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/16.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "DayUseModel.h"

@implementation DayUseModel

+(instancetype)modelWithDic:(NSDictionary *)dic{
    DayUseModel *model = [[DayUseModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    if ([dic objectForKey:@"liuliangNum"]) {
        NSDictionary *dict = [dic objectForKey:@"liuliangNum"];
        [model setValuesForKeysWithDictionary:dict];
    }
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}



@end
