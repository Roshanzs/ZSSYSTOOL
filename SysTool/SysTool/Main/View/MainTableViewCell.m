//
//  MainTableViewCell.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/14.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


@end
