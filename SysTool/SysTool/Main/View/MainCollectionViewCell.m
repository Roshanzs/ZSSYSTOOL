//
//  MainCollectionViewCell.m
//  SysTool
//
//  Created by 紫贝壳 on 2019/1/30.
//  Copyright © 2019年 stark. All rights reserved.
//

#import "MainCollectionViewCell.h"

@interface MainCollectionViewCell()
@property(nonatomic,strong)UILabel *lab;
@end

@implementation MainCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UILabel *lab = [[UILabel alloc]init];
    lab.textColor = ColorWithRGB(74, 77, 108);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:17.0/375.0*WSCREEN];
    self.lab = lab;
    [self.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.contentView);
        make.center.mas_equalTo(self.contentView);
    }];
}

-(void)setIndex:(NSIndexPath *)index{
    _index = index;
    switch (index.item) {
        case 0:
            self.lab.text = @"流量信息";
            break;
        case 1:
            self.lab.text = @"硬件信息";
            break;
        case 2:
            self.lab.text = @"CPU信息";
            break;
        case 3:
            self.lab.text = @"内存信息";
            break;
        case 4:
            self.lab.text = @"磁盘信息";
            break;
        case 5:
            self.lab.text = @"电池信息";
            break;
        case 6:
            self.lab.text = @"网络信息";
            break;
        case 7:
            self.lab.text = @"本地化信息";
            break;
        default:
            break;
    }
}

@end
